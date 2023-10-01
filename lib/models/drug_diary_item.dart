import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class DrugDiaryItem implements Comparable<DrugDiaryItem> {
  final String id;
  final String name;
  final String amount;
  final DateTime date;
  final String? notes;

  DrugDiaryItem({
    String? id,
    required String name,
    required String amount,
    required this.date,
    String? notes,
  })  : assert(id == null || Uuid.isValidUUID(fromString: id)),
        name = name.trim(),
        amount = amount.trim(),
        notes = notes?.trim(),
        id = id ?? _uuid.v4();

  factory DrugDiaryItem.fromMap(Map<String, dynamic> map) {
    return DrugDiaryItem(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  /// Sorts by date, then by name, then by id.
  ///
  /// The id is included to ensure that the sort is stable.
  @override
  int compareTo(DrugDiaryItem other) {
    final dateComparison = date.compareTo(other.date);
    if (dateComparison != 0) return dateComparison;
    final nameComparison = name.compareTo(other.name);
    if (nameComparison != 0) return nameComparison;
    return id.compareTo(other.id);
  }
}

/// An object that controls a list of [DrugDiaryItem].
class DrugDiaryProvider extends StateNotifier<List<DrugDiaryItem>> {
  final Future<Database> _database;

  DrugDiaryProvider() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'drug_diary.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE drug_diary(id TEXT PRIMARY KEY, name TEXT NOT NULL, amount TEXT NOT NULL, date TEXT NOT NULL, notes TEXT NOT NULL)',
        );
      },
      onOpen: (db) async {
        final List<Map<String, Object?>> drugMaps =
            await db.query('drug_diary');
        state =
            drugMaps.map((drugMap) => DrugDiaryItem.fromMap(drugMap)).toList();
      },
      version: 1,
    );
  }

  void add(DrugDiaryItem drugDiaryItem) {
    state = [
      ...state,
      drugDiaryItem,
    ];

    _insertIntoDatabase(drugDiaryItem);
  }

  Future<int> _insertIntoDatabase(DrugDiaryItem drugDiaryItem) {
    final db = await _database;
    return _database.insert(
      'drug_diary',
      drugDiaryItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void remove(DrugDiaryItem target) {
    state = state.where((drug) => drug.id != target.id).toList();
    _deleteFromDatabase(target);
  }

  void _deleteFromDatabase(DrugDiaryItem target) {
    _database.delete(
      'drug_diary',
      where: 'id = ?',
      whereArgs: [target.id],
    );
  }

  void update(DrugDiaryItem drugDiaryItem) {
    state = [
      for (final drug in state)
        if (drug.id == drugDiaryItem.id) drugDiaryItem else drug,
    ];
    _insertIntoDatabase(drugDiaryItem);
  }
}

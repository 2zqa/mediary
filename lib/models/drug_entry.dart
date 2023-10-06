import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class DrugEntry implements Comparable<DrugEntry> {
  final String id;
  final String name;
  final String amount;
  final DateTime date;
  final String? notes;

  DrugEntry({
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

  factory DrugEntry.fromMap(Map<String, dynamic> map) {
    return DrugEntry(
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
  int compareTo(DrugEntry other) {
    final dateComparison = date.compareTo(other.date);
    if (dateComparison != 0) return dateComparison;
    final nameComparison = name.compareTo(other.name);
    if (nameComparison != 0) return nameComparison;
    return id.compareTo(other.id);
  }
}

/// An object that controls a list of [DrugEntry].
class DrugEntriesProvider extends StateNotifier<List<DrugEntry>> {
  static const _tableName = 'drug_entries';
  late final Future<Database> _database;

  DrugEntriesProvider() : super([]);

  Future<void> initialize() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'mediary.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, name TEXT NOT NULL, amount TEXT NOT NULL, date TEXT NOT NULL, notes TEXT NOT NULL)',
        );
      },
      onOpen: (db) async {
        final List<Map<String, Object?>> drugMaps =
            await db.query(_tableName);
        state =
            drugMaps.map((drugMap) => DrugEntry.fromMap(drugMap)).toList();
      },
      version: 1,
    );
  }

  void add(DrugEntry drug) {
    state = [
      ...state,
      drug,
    ];

    _insertIntoDatabase(drug);
  }

  Future<int> _insertIntoDatabase(DrugEntry drug) {
    final db = await _database;
    return _database.insert(
      'drug_diary',
      drug.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void remove(DrugEntry target) {
    state = state.where((drug) => drug.id != target.id).toList();
    _deleteFromDatabase(target);
  }

  void _deleteFromDatabase(DrugEntry drug) {
    _database.delete(
      'drug_diary',
      where: 'id = ?',
      whereArgs: [drug.id],
    );
  }

  void update(DrugEntry target) {
    state = [
      for (final drug in state)
        if (drug.id == target.id) target else drug,
    ];
    _insertIntoDatabase(target);
  }
}

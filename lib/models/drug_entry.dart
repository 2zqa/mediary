import 'dart:async';

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

class AsyncDrugEntriesNotifier extends AsyncNotifier<List<DrugEntry>> {
  late final Database _database;
  static const _tableName = 'drug_entries';

  Future<List<DrugEntry>> _getAll() async {
    List<Map<String, Object?>> drugMaps = await _database.query(_tableName);
    return drugMaps.map(DrugEntry.fromMap).toList();
  }

  @override
  FutureOr<List<DrugEntry>> build() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'mediary.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, name TEXT NOT NULL, amount TEXT NOT NULL, date TEXT NOT NULL, notes TEXT)',
        );
      },
    );
    return _getAll();
  }

  Future<void> add(DrugEntry drugEntry) async {
    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new drugEntry and reload the drugEntry list from the remote repository
    state = await AsyncValue.guard(() async {
      await _database.insert(
        _tableName,
        drugEntry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return _getAll();
    });
  }

  Future<void> delete(DrugEntry drugEntry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _database.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [drugEntry.id],
      );
      return _getAll();
    });
  }
}
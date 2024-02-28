import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../migrations/drug_entry_migrations.dart';

const _uuid = Uuid();

enum DrugColor { blue, orange, red, yellow, green, purple }

class DrugEntry implements Comparable<DrugEntry> {
  final String id;
  final String name;
  final String amount;
  final DateTime date;
  final String notes;
  final DrugColor color;

  DrugEntry({
    String? id,
    required String name,
    required String amount,
    required this.date,
    required String notes,
    required this.color,
  })  : assert(id == null || Uuid.isValidUUID(fromString: id)),
        name = name.trim(),
        amount = amount.trim(),
        notes = notes.trim(),
        id = id ?? _uuid.v4();

  DrugEntry.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        name = map['name'] as String,
        amount = map['amount'] as String,
        date = DateTime.parse(map['date'] as String),
        notes = map['notes'] as String,
        color = DrugColor.values[map['color_index'] as int];

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'amount': amount,
        'date': date.toIso8601String(),
        'color_index': color.index,
        'notes': notes,
      };

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

class DrugEntriesNotifier extends AsyncNotifier<List<DrugEntry>> {
  late final Database _database;
  static const _tableName = 'drug_entries';

  Future<List<DrugEntry>> _getAll() async {
    final List<Map<String, Object?>> drugMaps =
        await _database.query(_tableName);
    return drugMaps.map(DrugEntry.fromMap).toList();
  }

  Future<DrugEntry> get(String id) async {
    final List<Map<String, Object?>> drugMaps = await _database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return DrugEntry.fromMap(drugMaps.single);
  }

  Future<List<DrugEntry>> search(String query) async {
    final List<Map<String, Object?>> drugMaps = await _database.query(
      where: 'name LIKE ?',
      _tableName,
      whereArgs: ['%$query%'],
    );
    return drugMaps.map(DrugEntry.fromMap).toList();
  }

  @override
  FutureOr<List<DrugEntry>> build() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'mediary.db'),
      version: DrugEntriesDatabase.version,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion; i <= newVersion - 1; i++) {
          await db.execute(DrugEntriesDatabase.migrations[i]);
        }
      },
    );
    return _getAll();
  }

  /// If you want to update of a drug, use [replace] instead. This method is
  /// only for updating the state of the notifier.
  ///
  /// See [AsyncNotifier.update]
  @override
  Future<List<DrugEntry>> update(
    FutureOr<List<DrugEntry>> Function(List<DrugEntry>) cb, {
    FutureOr<List<DrugEntry>> Function(Object err, StackTrace stackTrace)?
        onError,
  }) async {
    return super.update(cb, onError: onError);
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

  Future<void> replace(DrugEntry drugEntry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _database.update(
        _tableName,
        drugEntry.toMap(),
        where: 'id = ?',
        whereArgs: [drugEntry.id],
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

  /// Wipes the database and inserts all [drugEntries] into the database.
  Future<void> import(List<DrugEntry> drugEntries) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _database.transaction((txn) async {
        await txn.delete(_tableName);
        for (final drugEntry in drugEntries) {
          await txn.insert(
            _tableName,
            drugEntry.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      return _getAll();
    });
  }
}

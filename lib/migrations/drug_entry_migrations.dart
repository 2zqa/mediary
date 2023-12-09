/// Provides version and sql migrations for the drug entries database.
class DrugEntriesDatabase {
  static const _tableName = 'drug_entries';

  static final List<String> migrations = [
    'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, name TEXT NOT NULL, amount TEXT NOT NULL, date TEXT NOT NULL, notes TEXT)',
    'ALTER TABLE $_tableName ADD COLUMN color_index INTEGER NOT NULL DEFAULT 0',
  ];

  static int get version => DrugEntriesDatabase.migrations.length;
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // Private access constructor
  DB._();
  // Create DB instance
  static final DB instance = DB._();
  // SQLite instance
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), "crypto.db"),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_account);
    await db.execute(_wallet);
    await db.execute(_history);
    await db.insert("account", {"balance": 0});
  }

  String get _account => '''
    CREATE TABLE account (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      balance REAL
    );
''';

  String get _wallet => '''
    CREATE TABLE wallet (
      acronym TEXT PRIMARY KEY,
      coin TEXT,
      quantity TEXT
    );
''';

  String get _history => '''
    CREATE TABLE history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      operation_date INT,
      operation_type TEXT,
      coin TEXT,
      acronym TEXT,
      value TEXT,
      quantity TEXT
    );
''';
}

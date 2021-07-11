import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static Future<Database> localDatabase(
    String dbName, [
    String tableName,
  ]) async {
    final databasePath = await getDatabasesPath();
    return openDatabase(
      join(databasePath, dbName),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $tableName(timestamp TEXT PRIMARY KEY, latitude REAL, longitude REAL, address TEXT, name TEXT)');
      },
    );
  }

  static Future<void> insert(
    String dbName,
    String tableName,
    Map<String, Object> data,
  ) async {
    final db = await LocalDatabase.localDatabase(dbName, tableName);
    db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> retrieve(
    String dbName,
    String tableName,
  ) async {
    final db = await LocalDatabase.localDatabase(dbName, tableName);
    final result = db.query(tableName);
    return result;
  }

  static Future<void> clear(String dbName, String tableName) async {
    final db = await LocalDatabase.localDatabase(dbName, tableName);
    await db.delete(tableName);
  }
}

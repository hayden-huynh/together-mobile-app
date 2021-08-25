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
        if (dbName == "location") {
          return db.execute(
            'CREATE TABLE $tableName(timestamp TEXT PRIMARY KEY, latitude REAL, longitude REAL)',
          );
        } else if (dbName == "questionnaire") {
          return db.execute(
            'CREATE TABLE $tableName(Q0 TEXT, Q1 TEXT, Q2 TEXT, Q3 TEXT, Q4 TEXT, Q5 TEXT, Q6 TEXT, Q7 TEXT, timestamp TEXT PRIMARY KEY)',
          );
        }
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

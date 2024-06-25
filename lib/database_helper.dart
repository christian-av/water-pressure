import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'water_pressure.db';
  static const String userTable = 'users'; // User table name
  static const String pressureLogTable = 'pressure_logs'; // Pressure log table name

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $pressureLogTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT,
        pressure TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert(userTable, user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await instance.database;
    return await db.query(userTable);
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(userTable, where: 'username = ?', whereArgs: [username]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getUserDetails(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(userTable, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(userTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePassword(int id, String newPassword) async {
    Database db = await instance.database;
    return await db.update(
      userTable,
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateUsername(int id, String newUsername) async {
    Database db = await instance.database;
    return await db.update(
      userTable,
      {'username': newUsername},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Additional methods for pressure log operations
  Future<int> insertPressureLog(Map<String, dynamic> log) async {
    Database db = await instance.database;
    return await db.insert(pressureLogTable, log);
  }

  Future<List<Map<String, dynamic>>> getPressureLogs() async {
    Database db = await instance.database;
    return await db.query(pressureLogTable);
  }

  Future<int> deletePressureLog(int id) async {
    Database db = await instance.database;
    return await db.delete(pressureLogTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearPressureLogs() async {
    Database db = await instance.database;
    return await db.delete(pressureLogTable);
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employees.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            position TEXT NOT NULL,
            startDate TEXT NOT NULL,
            endDate TEXT 
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchCurrentEmployees() async {
    final db = await database;
    return await db.query(
      'employees',
      where: 'endDate IS NULL',
    );
  }

  Future<List<Map<String, dynamic>>> fetchPreviousEmployees() async {
    final db = await database;
    return await db.query(
      'employees',
      where: 'endDate IS NOT NULL',
    );
  }

  Future<int> addEmployee(Map<String, dynamic> employee) async {
    final db = await database;
    return await db.insert('employees', employee);
  }

  Future<int> updateEmployee(int id, Map<String, dynamic> employee) async {
    final db = await database;
    return await db
        .update('employees', employee, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

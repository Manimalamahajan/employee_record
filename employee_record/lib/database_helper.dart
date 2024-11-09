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

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE employees (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,role TEXT,startDate DATE,endDate DATE)');
  }

  Future<int> createEmployee(Map<String, dynamic> employee) async {
    final db = await instance.database;
    return await db.insert('employees', employee);
  }

  Future<List<Map<String, dynamic>>> readAllEmployees() async {
    final db = await instance.database;
    return await db.query('employees');
  }

  Future<int> updateEmployee(Map<String, dynamic> employee) async {
    final db = await instance.database;
    return await db.update(
      'employees',
      employee,
      where: 'id = ?',
      whereArgs: [employee['id']],
    );
  }

  Future<int> deleteEmployee(int? id) async {
    final db = await instance.database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

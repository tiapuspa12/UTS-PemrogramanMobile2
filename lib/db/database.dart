import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Mendapatkan direktori penyimpanan aplikasi
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/user_database.db';

    // Membuka atau membuat database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            name TEXT,
            email TEXT,
            address TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.insert('users', user);
    } catch (e) {
      print("Error inserting user: $e");
      return -1; // Return -1 jika terjadi error
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final db = await database;
      return await db.query('users');
    } catch (e) {
      print("Error retrieving users: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      print("Error retrieving user: $e");
      return null;
    }
  }
}

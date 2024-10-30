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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/user_database.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            name TEXT,
            email TEXT,
            address TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }

  // Method for user registration
  Future<int> registerUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.insert('users', user);
    } catch (e) {
      print("Error inserting user: $e");
      return -1;
    }
  }

  // Method for user login
  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      print("Error retrieving user: $e");
      return null;
    }
  }

  // Function to get user by ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      print("Error retrieving user by id: $e");
      return null;
    }
  }

  // Method to update user data
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.update(
        'users',
        user,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating user: $e");
      return -1; // Return -1 if there's an error
    }
  }
}

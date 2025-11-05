import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'reflections.db');

    return await openDatabase(
      path,
      version: 2, // incremented version to include 'date'
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create table with 'date' column
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reflections(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        who TEXT NOT NULL,
        what TEXT NOT NULL,
        when_question TEXT NOT NULL,
        where_question TEXT NOT NULL,
        why_question TEXT NOT NULL,
        date TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    print('Database and table created!');
  }

  // Upgrade existing database to add 'date' column if missing
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE reflections ADD COLUMN date TEXT');
      print('Database upgraded: Added "date" column.');
    }
  }

  // Insert a reflection
  Future<int> insertReflection({
    required String who,
    required String what,
    required String when,
    required String where,
    required String why,
    required DateTime date,
  }) async {
    final db = await database;
    return await db.insert(
      'reflections',
      {
        'who': who,
        'what': what,
        'when_question': when,
        'where_question': where,
        'why_question': why,
        'date': date.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // optional
    );
  }

  // Get all reflections
  Future<List<Map<String, dynamic>>> getReflections() async {
    final db = await database;
    return await db.query('reflections', orderBy: 'createdAt DESC');
  }

  // Get reflections by specific date
  Future<List<Map<String, dynamic>>> getReflectionsByDate(DateTime date) async {
    final db = await database;
    String isoDate = date.toIso8601String().substring(0, 10); // keep only YYYY-MM-DD
    return await db.query(
      'reflections',
      where: 'date LIKE ?',
      whereArgs: ['$isoDate%'],
      orderBy: 'createdAt DESC',
    );
  }

  // Delete a reflection by Date
  Future<int> deleteReflectionsByDate(DateTime date) async {
    final db = await database;
    String isoDate = date.toIso8601String().substring(0, 10); // YYYY-MM-DD
    return await db.delete(
      'reflections',
      where: 'date LIKE ?',
      whereArgs: ['$isoDate%'],
    );
  }

  // Clear all reflections
  Future<int> clearReflections() async {
    final db = await database;
    return await db.delete('reflections');
  }

  // USER AUTHENTICATION LOGIC
  // Insert new user
  Future<int> insertUser(String email, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get user for login validation
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Check if email already exists 
  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }
}
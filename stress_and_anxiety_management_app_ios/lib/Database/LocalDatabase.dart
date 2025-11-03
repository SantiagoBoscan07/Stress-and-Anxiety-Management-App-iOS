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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reflections(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        who TEXT NOT NULL,
        what TEXT NOT NULL,
        when_question TEXT NOT NULL,
        where_question TEXT NOT NULL,
        why_question TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    print('Database and table created!');
  }

  // Insert a reflection
  Future<int> insertReflection({
    required String who,
    required String what,
    required String when,
    required String where,
    required String why,
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
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  // Get all reflections
  Future<List<Map<String, dynamic>>> getReflections() async {
    final db = await database;
    return await db.query('reflections', orderBy: 'createdAt DESC');
  }

  // Delete a reflection by id
  Future<int> deleteReflection(int id) async {
    final db = await database;
    return await db.delete('reflections', where: 'id = ?', whereArgs: [id]);
  }

  // Optional: clear all reflections
  Future<int> clearReflections() async {
    final db = await database;
    return await db.delete('reflections');
  }
}

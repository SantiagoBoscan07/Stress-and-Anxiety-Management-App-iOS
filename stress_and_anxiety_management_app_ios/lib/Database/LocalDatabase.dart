import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // --- ValueNotifier to notify username changes ---
  final ValueNotifier<String?> userNameNotifier = ValueNotifier(null);

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    await _loadUserNameNotifier(); // initialize the notifier
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'reflections.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        date TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE reflections ADD COLUMN date TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE user(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        )
      ''');
    }
  }

  // --- User methods ---
  Future<int> saveUserName(String name) async {
    final db = await database;
    await db.delete('user'); // keep only one user
    final id = await db.insert('user', {'name': name});
    userNameNotifier.value = name; // notify listeners immediately
    return id;
  }

  Future<String?> getUserName() async {
    final db = await database;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) return result.first['name'] as String?;
    return null;
  }

  Future<void> deleteUserName() async {
    final db = await database;
    await db.delete('user');
    userNameNotifier.value = null; // notify listeners immediately
  }

  Future<void> _loadUserNameNotifier() async {
    userNameNotifier.value = await getUserName();
  }

  // --- Keep your existing reflection methods as-is ---
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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> clearReflections() async {
    final db = await database;
    return await db.delete('reflections');
  }

  Future<void> deleteAllData() async {
    await clearReflections();
    await deleteUserName();
  }

  Future<List<Map<String, dynamic>>> getReflections() async {
    final db = await database;
    return await db.query('reflections', orderBy: 'createdAt DESC');
  }

  Future<List<Map<String, dynamic>>> getReflectionsByDate(DateTime date) async {
    final db = await database;
    String isoDate = date.toIso8601String().substring(0, 10);
    return await db.query(
      'reflections',
      where: 'date LIKE ?',
      whereArgs: ['$isoDate%'],
      orderBy: 'createdAt DESC',
    );
  }

  Future<int> deleteReflectionsByDate(DateTime date) async {
    final db = await database;
    String isoDate = date.toIso8601String().substring(0, 10);
    return await db.delete(
      'reflections',
      where: 'date LIKE ?',
      whereArgs: ['$isoDate%'],
    );
  }
}

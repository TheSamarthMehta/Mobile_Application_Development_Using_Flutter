import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/user.dart';

class MyDB {
  static Database? _db;

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'user.db');
    String createUserTable = '''
  CREATE TABLE USERS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userName TEXT NOT NULL,
    state TEXT NOT NULL,
    city TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    address  TEXT,
    mobileNumber TEXT NOT NULL,
    dateOfBirth TEXT NOT NULL,
    gender TEXT NOT NULL,
    age TEXT NOT NULL,
    password TEXT NOT NULL,
    confirmPassword TEXT NOT NULL,
    isFavorite INTEGER DEFAULT 0
  )
''';

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(createUserTable);
    });
  }

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDatabase();
      return _db!;
    }
  }

  /// *Insert User*
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('USERS', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// *Update User*
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
        'USERS',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
    );
  }

  /// *Delete User*
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('USERS', where: 'id = ?', whereArgs: [id]);
  }

  /// *Get User by ID*
  Future<User?> getUserById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result =
        await db.query('USERS', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  /// *Get All Users*
  Future<List<User>> getAllUsers() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('USERS');
    print(result);
    return result.map((map) => User.fromMap(map)).toList();
  }

  /// To close Database when not needed
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }

  /// *Get all users who are marked as favorites*
  Future<List<User>> getFavouriteUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('USERS', where: 'isFavorite = ?', whereArgs: [1]);

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  /// *Toggle the favorite status of a user*
  Future<void> toggleFavorite(int userId, int isFav) async {
    final db = await database;
    await db.update(
      'USERS',
      {'isFavorite': isFav},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}

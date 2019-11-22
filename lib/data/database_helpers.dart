import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/character.dart';

// singleton class to manage the database
class DatabaseHelper with ChangeNotifier {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "GloomhavenCompanion.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableCharacters (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnClassCode TEXT NOT NULL,
                $columnXp INTEGER NOT NULL,
                $columnGold INTEGER NOT NULL,
                $columnNotes TEXT NOT NULL,
                $columnCheckMarks INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Character character) async {
    Database db = await database;
    int id = await db.insert(tableCharacters, character.toMap());
    notifyListeners();
    return id;
  }

  Future<Character> queryRow(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCharacters,
        columns: [
          columnId,
          columnName,
          columnClassCode,
          columnXp,
          columnGold,
          columnNotes,
          columnCheckMarks
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Character.fromMap(maps.first);
    }
    return null;
  }

  Future<List> queryAllRows() async {
    Database db = await database;
    var result = await db.query(tableCharacters);
    return result.toList();
  }

// TODO: delete(int id)
// TODO: update(Word word)
}

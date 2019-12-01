import 'dart:io';

import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk_row.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/character.dart';

// singleton class to manage the database
class DatabaseHelper
// with ChangeNotifier
{
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
    await db.transaction((txn) async {
      await db.execute('''
              CREATE TABLE $tableCharacters (
                $columnCharacterId INTEGER PRIMARY KEY,
                $columnCharacterName TEXT NOT NULL,
                $columnCharacterClassCode TEXT NOT NULL,
                $columnCharacterClassColor TEXT NOT NULL,
                $columnCharacterClassIcon TEXT NOT NULL,
                $columnCharacterXp INTEGER NOT NULL,
                $columnCharacterGold INTEGER NOT NULL,
                $columnCharacterNotes TEXT NOT NULL,
                $columnCharacterCheckMarks INTEGER NOT NULL
              )''');
      await db.execute('''
              CREATE TABLE $tablePerks (
                $columnPerkId INTEGER PRIMARY KEY,
                $columnPerkClass TEXT NOT NULL,
                $columnPerkDetails TEXT NOT NULL
              )''').then((_) {
        for (PerkRow perkRow in perkRowList) {
          txn.rawInsert(
              'INSERT INTO $tablePerks($columnPerkClass, $columnPerkDetails) VALUES("${perkRow.perkClass}", "${perkRow.perkDetails}")');
        }
      }).then((_) {
        txn.execute('''
              CREATE TABLE $tableCharacterPerks (
                $columnAssociatedCharacterId INTEGER NOT NULL,
                $columnAssociatedPerkId INTEGER NOT NULL,
                $columnCharacterPerkIsSelected BOOLEAN
              )''');
      });
    });
    // PerkRow perk = PerkRow();
    // perk.perkClass = "BR";
    // perk.perkDetails = "TESTing Details";
    // insertPerk(perk);
    print("************ DATABASE INITIALIZED");
  }

  // Database helper methods:

  Future<int> insert(Character character) async {
    Database db = await database;
    int id = await db.insert(tableCharacters, character.toMap());
    await db.transaction((txn) async {
      for (PerkRow perk in perkRowList) {
        if (perk.perkClass == character.classCode) {
          txn.rawInsert(
              'INSERT INTO $tableCharacterPerks($columnAssociatedCharacterId, $columnAssociatedPerkId) VALUES(${character.characterId}, ${perk.perkId})');
        }
      }
    });
    print("****************** CHARACTER: " + character.toMap().toString());
    // notifyListeners();
    return id;
  }

  Future<PerkRow> queryPerkRow(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tablePerks,
        columns: [columnPerkId, columnPerkClass, columnPerkDetails],
        where: '$columnPerkId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      print(PerkRow.fromMap(maps.first).perkDetails);
      return PerkRow.fromMap(maps.first);
    }
    return null;
  }

  Future<Character> queryCharacterRow(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCharacters,
        columns: [
          columnCharacterId,
          columnCharacterName,
          columnCharacterClassCode,
          columnCharacterClassColor,
          columnCharacterClassIcon,
          columnCharacterXp,
          columnCharacterGold,
          columnCharacterNotes,
          columnCharacterCheckMarks
        ],
        where: '$columnCharacterId = ?',
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

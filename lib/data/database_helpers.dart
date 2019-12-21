import 'dart:io';

import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// singleton class to manage the database
class DatabaseHelper {
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
      await txn.execute('''
              CREATE TABLE $tableCharacters (
                $columnCharacterId INTEGER PRIMARY KEY,
                $columnCharacterName TEXT NOT NULL,
                $columnCharacterClassCode TEXT NOT NULL,
                $columnCharacterClassColor TEXT NOT NULL,
                $columnCharacterClassIcon TEXT NOT NULL,
                $columnCharacterXp INTEGER NOT NULL,
                $columnCharacterGold INTEGER NOT NULL,
                $columnCharacterNotes TEXT NOT NULL,
                $columnCharacterCheckMarks INTEGER NOT NULL,
                $columnIsRetired BOOL NOT NULL
              )''');
      await txn.execute('''
              CREATE TABLE $tablePerks (
                $columnPerkId INTEGER PRIMARY KEY,
                $columnPerkClass TEXT NOT NULL,
                $columnPerkDetails TEXT NOT NULL
              )''').then((_) async {
        for (Perk perk in perkList) {
          for (int i = 0; i < perk.numOfPerks; i++) {
            int id = await txn.insert(tablePerks, perk.toMap());
            print("ID: " +
                id.toString() +
                " : " +
                perk.perkClassCode +
                " : " +
                perk.perkDetails);
          }
        }
      }).then((_) {
        txn.execute('''
              CREATE TABLE $tableCharacterPerks (
                $columnAssociatedCharacterId INTEGER,
                $columnAssociatedPerkId INTEGER,
                $columnCharacterPerkIsSelected BOOLEAN
              )''');
      });
    });
    print("DB HELPER - DATABASE INITIALIZED");
  }

  Future<int> insertCharacter(
      Character _legacyCharacter, List<bool> _selectedPerks) async {
    Database db = await database;
    int id = await db.insert(tableCharacters, _legacyCharacter.toMap());
    _legacyCharacter.id = id;
    await queryPerks(_legacyCharacter.classCode).then((_perkList) {
      db.transaction((txn) async {
        _perkList.asMap().forEach((index, _perk) async {
          if (_perk[columnPerkClass] == _legacyCharacter.classCode) {
            await txn.rawInsert(
                'INSERT INTO $tableCharacterPerks ($columnAssociatedCharacterId, $columnAssociatedPerkId, $columnCharacterPerkIsSelected) VALUES (${_legacyCharacter.id}, ${_perk[columnPerkId]}, ${_selectedPerks[index] ? 1 : 0})');
          }
        });
      });
    });
    print("DB HELPER - INSERT LEGACY CHARACTER: " +
        _legacyCharacter.toMap().toString());
    return id;
  }

  Future<void> updateCharacter(Character _updatedCharacter) async {
    Database db = await database;
    var map = <String, dynamic>{
      columnCharacterId: _updatedCharacter.id,
      columnCharacterName: _updatedCharacter.name,
      columnCharacterClassCode: _updatedCharacter.classCode,
      columnCharacterClassColor: _updatedCharacter.classColor,
      columnCharacterClassIcon: _updatedCharacter.classIcon,
      columnCharacterXp: _updatedCharacter.xp,
      columnCharacterGold: _updatedCharacter.gold,
      columnCharacterNotes: _updatedCharacter.notes,
      columnCharacterCheckMarks: _updatedCharacter.checkMarks,
      columnIsRetired: _updatedCharacter.isRetired ? 1 : 0
    };
    await db.update(tableCharacters, map,
        where: '$columnCharacterId = ?', whereArgs: [_updatedCharacter.id]);
    print("DB HELPER - UPDATE CHARACTER: " + _updatedCharacter.toString());
  }

  Future<Perk> queryPerk(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tablePerks,
        columns: [columnPerkId, columnPerkClass, columnPerkDetails],
        where: '$columnPerkId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Perk.fromMap(maps.first);
    }
    print("DB HELPER - QUERY PERK: " + maps.toString());
    return null;
  }

  Future<void> updateCharacterPerk(CharacterPerk _perk) async {
    Database db = await database;
    Map<String, dynamic> row = {
      columnAssociatedCharacterId: _perk.associatedCharacterId,
      columnAssociatedPerkId: _perk.associatedPerkId,
      columnCharacterPerkIsSelected: _perk.characterPerkIsSelected ? 0 : 1
    };
    await db.update(tableCharacterPerks, row,
        where:
            '$columnAssociatedPerkId = ? AND $columnAssociatedCharacterId = ?',
        whereArgs: [_perk.associatedPerkId, _perk.associatedCharacterId]);
    print("DB HELPER - UPDATE CHARACTER PERK: " + row.toString());
  }

  Future<List<CharacterPerk>> queryCharacterPerks(int _characterId) async {
    Database db = await database;
    List<CharacterPerk> _list = [];
    List result = await db.query(tableCharacterPerks,
        where: '$columnAssociatedCharacterId = ?', whereArgs: [_characterId]);
    result.forEach((perk) => _list.add(CharacterPerk.fromMap(perk)));
    print("DB HELPER - QUERY CHARACTER PERKS: " + _list.toString());
    return _list;
  }

  Future<List> queryPerks(String _classCode) async {
    Database db = await database;
    var result = await db.query(tablePerks,
        where: '$columnPerkClass = ?', whereArgs: [_classCode]);
    print("DB HELPER - QUERY PERKS: " + result.toList().toString());
    return result.toList();
  }

  Future<Character> queryCharacter(int id) async {
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
          columnCharacterCheckMarks,
          columnIsRetired
        ],
        where: '$columnCharacterId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      print("DB HELPER - QUERY CHARACTER: " +
          Character.fromMap(maps.first).toString());
      return Character.fromMap(maps.first);
    }
    return null;
  }

  Future<List> queryAllCharacters() async {
    Database db = await database;
    List<Character> _list = [];
    var result = await db.query(tableCharacters);
    result.forEach((_character) => _list.add(Character.fromMap(_character)));
    print("DB HELPER - QUERY ALL CHARACTERS: " + _list.toString());
    return _list;
  }

  Future deleteCharacter(int _characterId) async {
    Database db = await database;
    return await db.transaction((txn) async {
      txn.delete(tableCharacters,
          where: '$columnCharacterId = ?', whereArgs: [_characterId]);
      txn.delete(tableCharacterPerks,
          where: '$columnAssociatedCharacterId = ?', whereArgs: [_characterId]);
    });
  }
}

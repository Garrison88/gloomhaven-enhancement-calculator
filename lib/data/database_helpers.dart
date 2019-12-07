import 'dart:io';

import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
        for (Perk perkRow in perkRowList) {
          for (int i = 0; i < perkRow.numOfPerks; i++) {
            int id = await txn.insert(tablePerks, perkRow.toMap());
            print("ID: " +
                id.toString() +
                " : " +
                perkRow.perkClassCode +
                " : " +
                perkRow.perkDetails);
            // 'INSERT INTO $tablePerks($columnPerkClass, $columnPerkDetails) VALUES("${perkRow.perkClassCode}", "${perkRow.perkDetails}")');
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
    // Perk perk = Perk();
    // perk.perkClass = "BR";
    // perk.perkDetails = "TESTing Details";
    // insertPerk(perk);
    print("************ DATABASE INITIALIZED");
  }

  // Database helper methods:

  Future<int> insertCharacter(Character _character) async {
    Database db = await database;
    int id = await db.insert(tableCharacters, _character.toMap());
    await db.transaction((txn) async {
      for (Perk perk in perkRowList) {
        if (perk.perkClassCode == _character.classCode) {
          for (int i = 0; i <= perk.numOfPerks; i++) {
            txn.rawInsert(
                'INSERT INTO $tableCharacterPerks ($columnAssociatedCharacterId, $columnAssociatedPerkId, $columnCharacterPerkIsSelected) VALUES (${_character.id}, ${perk.perkId}, 0)');
            print(perk.perkDetails.toString());
          }
        }
      }
    });
    print("****************** CHARACTER: " + _character.toMap().toString());
    // notifyListeners();
    return id;
  }

  Future<int> insertLegacyCharacter(
      Character _legacyCharacter, List<bool> _selectedPerks) async {
    Database db = await database;
    int id = await db.insert(tableCharacters, _legacyCharacter.toMap());
    _legacyCharacter.id = id;
    await queryPerks(_legacyCharacter.classCode).then((_perkList) {
      db.transaction((txn) async {
        // var _counter = 0;
        _perkList.asMap().forEach((index, perk) async {
          if (perk[columnPerkClass] == _legacyCharacter.classCode) {
            print("######*******%%%%%%%%: " + _selectedPerks[index].toString());
            await txn.rawInsert(
                'INSERT INTO $tableCharacterPerks ($columnAssociatedCharacterId, $columnAssociatedPerkId, $columnCharacterPerkIsSelected) VALUES (${_legacyCharacter.id}, ${perk[columnPerkId]}, ${_selectedPerks[index] ? 1 : 0})');

            print(
                "PERK ${perk[columnPerkDetails]} WITH ID ${perk[columnPerkId]} FOR CHARACTER ${_legacyCharacter.id} IS ${_selectedPerks[index] ? 'SELECTED' : '** NOT ** SELECTED'}");
            // _counter++;
          }
        });
      });
    });
    print(
        "****************** CHARACTER: " + _legacyCharacter.toMap().toString());
    return id;
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
    return null;
  }

  Future<CharacterPerk> queryCharacterPerk(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCharacterPerks,
        columns: [
          columnAssociatedCharacterId,
          columnAssociatedPerkId,
          columnCharacterPerkIsSelected
        ],
        where: '$columnAssociatedCharacterId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      print(CharacterPerk.fromMap(maps.first).associatedCharacterId);
      return CharacterPerk.fromMap(maps.first);
    }
    return null;
  }

  Future<List> queryCharacterPerks(int _characterId) async {
    Database db = await database;
    var result = await db.query(tableCharacterPerks,
        where: '$columnAssociatedCharacterId = ?', whereArgs: [_characterId]);
    print("QUERY ALL CHARACTER PERKS RESULTS: " + result.toList().toString());
    return result.toList();
  }

  Future<List> queryPerks(String _classCode) async {
    Database db = await database;
    // List<PerkRow> _perks;
    var result = await db.query(tablePerks,
        where: '$columnPerkClass = ?', whereArgs: [_classCode]);
    // print("QUERY ALL PERKS RESULTS: " + result.toList().toString());
    // maps.forEach((row)  {print("QERIED PERK ROW AND GOT: %%%%%%%%%%% " + row.toString()); _perks.add(row);});
    return result.toList();
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
          columnCharacterCheckMarks,
          columnIsRetired
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

  Future<int> deleteCharacter(int _characterId) async {
    Database db = await database;
    return await db.delete(tableCharacters,
        where: '$columnCharacterId = ?', whereArgs: [_characterId]);
  }
// TODO: update(Word word)
}

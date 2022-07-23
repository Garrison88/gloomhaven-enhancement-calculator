import 'dart:convert' as convert;
import 'dart:io';
import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';

import 'database_migrations.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/character.dart';
import '../models/character_perk.dart';
import '../models/perk.dart';
import 'character_data.dart';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static const _databaseName = "GloomhavenCompanion.db";

  // Increment this version when you need to change the schema.
  static const _databaseVersion = 7;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  String databasePath;
  List<String> tables = [
    tableCharacters,
    tableCharacterPerks,
  ];

  Future<Database> get database async => _database ??= await _initDatabase();

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    databasePath = join(
      documentsDirectory.path,
      _databaseName,
    );
    // Open the database. Can also add an onUpgrade callback parameter.
    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String boolType = 'BOOL NOT NULL';
  static const String integerType = 'INTEGER NOT NULL';
  static const String createTable = 'CREATE TABLE';

  // SQL string to create the database
  Future _onCreate(
    Database db,
    int version,
  ) async {
    await db.transaction((txn) async {
      await txn.execute('''
        $createTable $tableCharacters (
          $columnCharacterId $idType,
          $columnCharacterUuid $textType,
          $columnCharacterName $textType,
          $columnCharacterClassCode $textType,
          $columnPreviousRetirements $integerType,
          $columnCharacterXp $integerType,
          $columnCharacterGold $integerType,
          $columnCharacterNotes $textType,
          $columnCharacterCheckMarks $integerType,
          $columnIsRetired $boolType,
          $columnResourceHide $integerType,
          $columnResourceMetal $integerType,
          $columnResourceLumber $integerType,
          $columnResourceArrowVine $integerType,
          $columnResourceAxeNut $integerType,
          $columnResourceRockRoot $integerType,
          $columnResourceFlameFruit $integerType,
          $columnResourceCorpseCap $integerType,
          $columnResourceSnowThistle $integerType
        )''');
      await txn.execute('''
        $createTable $tablePerks (
          $columnPerkId $idType,
          $columnPerkClass $textType,
          $columnPerkDetails $textType,
          $columnPerkIsGrouped $boolType
        )''').then(
        (_) async {
          for (Perk perk in CharacterData.perks) {
            for (int i = 0; i < perk.numOfPerks; i++) {
              await txn.insert(tablePerks, perk.toMap());
            }
          }
        },
      );
      await txn.execute('''
        $createTable $tableCharacterPerks (
          $columnAssociatedCharacterUuid $textType,
          $columnAssociatedPerkId $integerType,
          $columnCharacterPerkIsSelected $boolType
        )''');

      await txn.execute('''
        $createTable $tableMasteries (
          $columnMasteryId $idType,
          $columnMasteryClass $textType,
          $columnMasteryDetails $textType
        )''').then(
        (_) async {
          for (Mastery mastery in CharacterData.masteries) {
            await txn.insert(tableMasteries, mastery.toMap());
          }
        },
      );
      await txn.execute('''
        $createTable $tableCharacterMasteries (
          $columnAssociatedCharacterUuid $textType,
          $columnAssociatedMasteryId $integerType,
          $columnCharacterMasteryAchieved $boolType
        )''');
    });
  }

  Future _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    await db.transaction(
      (txn) async {
        if (oldVersion <= 4) {
          // Add perks for Crimson Scales classes
          await DatabaseMigrations.regeneratePerksTable(txn);
          // Add Uuid column to CharactersTable and CharacterPerks table,
          // and change schema for both
          await DatabaseMigrations.migrateToUuids(txn);
        }
        if (oldVersion <= 5) {
          // Cleanup perks and add Ruinmaw
          await DatabaseMigrations.regeneratePerksTable(txn);
        }
        if (oldVersion <= 6) {
          // Include Frosthaven Resources
          await DatabaseMigrations.includeFrosthavenResources(txn);
        }
      },
    );
  }

  Future<String> generateBackup() async {
    Database dbs = await database;
    List data = [];
    List<Map<String, dynamic>> listMaps = [];

    for (final String table in tables) {
      listMaps = await dbs.query(table);
      data.add(listMaps);
    }

    List backups = [
      tables,
      data,
    ];

    return convert.jsonEncode(backups);
  }

  Future<void> restoreBackup(
    String backup,
  ) async {
    var dbs = await database;

    await clearAllTables();

    Batch batch = dbs.batch();

    List json = convert.jsonDecode(backup);

    for (var i = 0; i < json[0].length; i++) {
      for (var k = 0; k < json[1][i].length; k++) {
        batch.insert(
          json[0][i],
          json[1][i][k],
        );
      }
    }

    await batch.commit(
      continueOnError: false,
      noResult: true,
    );
  }

  Future clearAllTables() async {
    try {
      Database dbs = await database;
      for (String table in tables) {
        await dbs.delete(table);
        await dbs.rawQuery('DELETE FROM sqlite_sequence where name="$table"');
      }
    } catch (e) {}
  }

  Future<int> insertCharacter(
    Character character,
  ) async {
    Database db = await database;
    int id = await db.insert(
      tableCharacters,
      character.toMap(),
    );
    final perks = await queryPerks(character.playerClass.classCode);
    perks.asMap().forEach(
      (key, perk) async {
        await db.insert(
          tableCharacterPerks,
          {
            columnAssociatedCharacterUuid: character.uuid,
            columnAssociatedPerkId: perk[columnPerkId],
            columnCharacterPerkIsSelected: 0,
          },
        );
      },
    );
    final masteries = await queryMasteries(character.playerClass.classCode);
    masteries.asMap().forEach(
      (key, mastery) async {
        await db.insert(
          tableCharacterMasteries,
          {
            columnAssociatedCharacterUuid: character.uuid,
            columnAssociatedMasteryId: mastery[columnMasteryId],
            columnCharacterMasteryAchieved: 0,
          },
        );
      },
    );
    return id;
  }

  Future<void> updateCharacter(
    Character updatedCharacter,
  ) async {
    Database db = await database;
    await db.update(
      tableCharacters,
      updatedCharacter.toMap(),
      where: '$columnCharacterUuid = ?',
      whereArgs: [updatedCharacter.uuid],
    );
  }

  Future<void> updateCharacterPerk(
    CharacterPerk perk,
    bool value,
  ) async {
    Database db = await database;
    Map<String, dynamic> map = {
      columnAssociatedCharacterUuid: perk.associatedCharacterUuid,
      columnAssociatedPerkId: perk.associatedPerkId,
      columnCharacterPerkIsSelected: value ? 1 : 0
    };
    await db.update(
      tableCharacterPerks,
      map,
      where:
          '$columnAssociatedPerkId = ? AND $columnAssociatedCharacterUuid = ?',
      whereArgs: [perk.associatedPerkId, perk.associatedCharacterUuid],
    );
  }

  Future<void> updateCharacterMastery(
    CharacterMastery mastery,
    bool value,
  ) async {
    Database db = await database;
    Map<String, dynamic> map = {
      columnAssociatedCharacterUuid: mastery.associatedCharacterUuid,
      columnAssociatedMasteryId: mastery.associatedMasteryId,
      columnCharacterMasteryAchieved: value ? 1 : 0
    };
    await db.update(
      tableCharacterMasteries,
      map,
      where:
          '$columnAssociatedMasteryId = ? AND $columnAssociatedCharacterUuid = ?',
      whereArgs: [mastery.associatedMasteryId, mastery.associatedCharacterUuid],
    );
  }

  Future<List<CharacterPerk>> queryCharacterPerks(
    String characterUuid,
  ) async {
    Database db = await database;
    List<CharacterPerk> list = [];
    List result = await db.query(
      tableCharacterPerks,
      where: '$columnAssociatedCharacterUuid = ?',
      whereArgs: [characterUuid],
    );
    for (final perk in result) {
      list.add(
        CharacterPerk.fromMap(perk),
      );
    }
    return list;
  }

  Future<List<CharacterMastery>> queryCharacterMasteries(
    String characterUuid,
  ) async {
    Database db = await database;
    List<CharacterMastery> list = [];
    List result = await db.query(
      tableCharacterMasteries,
      where: '$columnAssociatedCharacterUuid = ?',
      whereArgs: [characterUuid],
    );
    for (final mastery in result) {
      list.add(
        CharacterMastery.fromMap(mastery),
      );
    }
    return list;
  }

  Future<List> queryPerks(
    String classCode,
  ) async {
    Database db = await database;
    var result = await db.query(
      tablePerks,
      where: '$columnPerkClass = ?',
      whereArgs: [classCode],
    );
    return result.toList();
  }

  Future<List> queryMasteries(
    String classCode,
  ) async {
    Database db = await database;
    var result = await db.query(
      tableMasteries,
      where: '$columnMasteryClass = ?',
      whereArgs: [classCode],
    );
    return result.toList();
  }

  Future<List> queryAllCharacters() async {
    Database db = await database;
    List<Character> list = [];
    await db.query(tableCharacters).then(
      (charactersMap) {
        for (final character in charactersMap) {
          list.add(
            Character.fromMap(character),
          );
        }
      },
    );
    return list;
  }

  Future<void> deleteCharacter(Character character) async {
    Database db = await database;
    return await db.transaction((txn) async {
      await txn.delete(
        tableCharacters,
        where: '$columnCharacterUuid = ?',
        whereArgs: [character.uuid],
      );
      await txn.delete(
        tableCharacterPerks,
        where: '$columnAssociatedCharacterUuid = ?',
        whereArgs: [character.uuid],
      );
    });
  }
}

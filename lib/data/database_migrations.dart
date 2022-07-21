import 'character_data.dart';
import 'database_helpers.dart';
import '../models/character.dart';
import '../models/character_perk.dart';
import '../models/perk.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseMigrations {
  static regeneratePerksTable(Transaction txn) async {
    await txn.execute('DROP TABLE IF EXISTS $tablePerks');
    await txn.execute('''
        ${DatabaseHelper.createTable} $tablePerks(
          $columnPerkId ${DatabaseHelper.idType},
          $columnPerkClass ${DatabaseHelper.textType},
          $columnPerkDetails ${DatabaseHelper.textType},
          $columnPerkIsGrouped ${DatabaseHelper.boolType}
        )''').then(
      (_) async {
        for (Perk perk in CharacterData.perks) {
          for (int i = 0; i < perk.numOfPerks; i++) {
            await txn.insert(
              tablePerks,
              perk.toMap(),
            );
          }
        }
      },
    );
  }

  static migrateToUuids(Transaction txn) async {
    await txn.execute('''
        ALTER TABLE $tableCharacterPerks RENAME TO cptmp
        ''');
    await txn.execute('''
        ${DatabaseHelper.createTable} $tableCharacterPerks(
          $columnAssociatedCharacterUuid ${DatabaseHelper.textType},
          $columnAssociatedPerkId ${DatabaseHelper.integerType},
          $columnCharacterPerkIsSelected ${DatabaseHelper.boolType}
        )''');
    await txn.execute('''
        INSERT INTO $tableCharacterPerks(
          $columnAssociatedCharacterUuid,
          $columnAssociatedPerkId,
          $columnCharacterPerkIsSelected
        ) SELECT CharacterID, 
        $columnAssociatedPerkId, 
        $columnCharacterPerkIsSelected FROM cptmp
        ''');
    await txn.execute('''
        DROP TABLE cptmp
        ''');
    await txn.execute('''
      ALTER TABLE $tableCharacters RENAME TO ctmp
      ''');
    await txn.execute('''
      ALTER TABLE ctmp ADD COLUMN $columnCharacterUuid
      ''');
    await txn.execute('''
      ${DatabaseHelper.createTable} $tableCharacters(
        $columnCharacterId ${DatabaseHelper.idType},
        $columnCharacterUuid ${DatabaseHelper.textType},
        $columnCharacterName ${DatabaseHelper.textType},
        $columnCharacterClassCode ${DatabaseHelper.textType},
        $columnPreviousRetirements ${DatabaseHelper.integerType},
        $columnCharacterXp ${DatabaseHelper.integerType},
        $columnCharacterGold ${DatabaseHelper.integerType},
        $columnCharacterNotes ${DatabaseHelper.textType},
        $columnCharacterCheckMarks ${DatabaseHelper.integerType},
        $columnIsRetired ${DatabaseHelper.boolType}
      )''');
    await txn.execute('''
      INSERT INTO $tableCharacters(
        $columnCharacterId,
        $columnCharacterUuid,
        $columnCharacterName,
        $columnCharacterClassCode,
        $columnPreviousRetirements,
        $columnCharacterXp,
        $columnCharacterGold,
        $columnCharacterNotes,
        $columnCharacterCheckMarks,
        $columnIsRetired
        )
        SELECT $columnCharacterId,
        $columnCharacterId,
        $columnCharacterName,
        $columnCharacterClassCode,
        $columnPreviousRetirements,
        $columnCharacterXp,
        $columnCharacterGold,
        $columnCharacterNotes,
        $columnCharacterCheckMarks,
        $columnIsRetired FROM ctmp;
      ''');
    await txn.execute('''
        DROP TABLE ctmp
        ''');
  }

  static includeFrosthavenResources(Transaction txn) async {
    await regeneratePerksTable(txn);
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceHide ${DatabaseHelper.integerType} DEFAULT 0');
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceMetal ${DatabaseHelper.integerType} DEFAULT 0');
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceLumber ${DatabaseHelper.integerType} DEFAULT 0');
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceArrowVine ${DatabaseHelper.integerType} DEFAULT 0');
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceAxeNut ${DatabaseHelper.integerType} DEFAULT 0');
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceRockRoot ${DatabaseHelper.integerType} DEFAULT 0');
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceFlameFruit ${DatabaseHelper.integerType} DEFAULT 0');
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceCorpseCap ${DatabaseHelper.integerType} DEFAULT 0');
    await txn.rawInsert(
        'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceSnowThistle ${DatabaseHelper.integerType} DEFAULT 0');
  }
}

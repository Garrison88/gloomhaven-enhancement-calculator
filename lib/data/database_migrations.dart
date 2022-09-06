import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';

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

  static includeClassMasteries(Transaction txn) async {
    await txn.execute('''
        ${DatabaseHelper.createTable} $tableMasteries (
          $columnMasteryId ${DatabaseHelper.idType},
          $columnMasteryClass ${DatabaseHelper.textType},
          $columnMasteryDetails ${DatabaseHelper.textType}
        )''').then(
      (_) async {
        for (Mastery mastery in CharacterData.masteries) {
          await txn.insert(tableMasteries, mastery.toMap());
        }
      },
    );
    await txn.execute('''
        ${DatabaseHelper.createTable} $tableCharacterMasteries (
          $columnAssociatedCharacterUuid ${DatabaseHelper.textType},
          $columnAssociatedMasteryId ${DatabaseHelper.integerType},
          $columnCharacterMasteryAchieved ${DatabaseHelper.boolType}
        )''');
  }

  static includeResources(Transaction txn) async {
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceHide ${DatabaseHelper.integerType} DEFAULT 0',
    );
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceMetal ${DatabaseHelper.integerType} DEFAULT 0',
    );
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceLumber ${DatabaseHelper.integerType} DEFAULT 0',
    );
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceArrowvine ${DatabaseHelper.integerType} DEFAULT 0',
    );
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceAxenut ${DatabaseHelper.integerType} DEFAULT 0',
    );
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceRockroot ${DatabaseHelper.integerType} DEFAULT 0',
    );
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceFlamefruit ${DatabaseHelper.integerType} DEFAULT 0',
    );
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceCorpsecap ${DatabaseHelper.integerType} DEFAULT 0',
    );
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnResourceSnowthistle ${DatabaseHelper.integerType} DEFAULT 0',
    );
  }
}

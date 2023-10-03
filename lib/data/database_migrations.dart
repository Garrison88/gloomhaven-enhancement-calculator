import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/legacy_perk.dart' as legacy;
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/legacy_mastery.dart'
    as legacy;
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class DatabaseMigrations {
  static regeneratePerksTable(Transaction txn) async {
    await txn.execute('DROP TABLE IF EXISTS ${legacy.tablePerks}');
    await txn.execute('''
        ${DatabaseHelper.createTable} ${legacy.tablePerks}(
          ${legacy.columnPerkId} ${DatabaseHelper.idType},
          ${legacy.columnPerkClass} ${DatabaseHelper.textType},
          ${legacy.columnPerkDetails} ${DatabaseHelper.textType},
          ${legacy.columnPerkIsGrouped} ${DatabaseHelper.boolType}
        )''').then(
      (_) async {
        for (legacy.Perk perk in CharacterData.legacyPerks) {
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
        for (legacy.Mastery mastery in CharacterData.masteries) {
          await txn.insert(
            tableMasteries,
            mastery.toMap(),
          );
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

  static addVariantColumnToCharacterTable(Transaction txn) async {
    await txn.rawInsert(
      'ALTER TABLE $tableCharacters ADD COLUMN $columnVariant ${DatabaseHelper.textType} DEFAULT \'${Variant.base.name}\'',
    );
  }

  static convertCharacterPerkIdColumnFromIntToText(Transaction txn) async {
    await txn.execute('''
  ALTER TABLE $tableCharacterPerks
  RENAME TO temp_$tableCharacterPerks
''');

    await txn.execute('''
  CREATE TABLE $tableCharacterPerks (
    $columnAssociatedCharacterUuid ${DatabaseHelper.textType},
    $columnAssociatedPerkId ${DatabaseHelper.textType},
    $columnCharacterPerkIsSelected ${DatabaseHelper.boolType}
  )
''');

    await txn.execute('''
  INSERT INTO $tableCharacterPerks
  SELECT
    $columnAssociatedCharacterUuid,
    CAST($columnAssociatedPerkId AS TEXT),
    $columnCharacterPerkIsSelected
  FROM temp_$tableCharacterPerks
''');

    await txn.execute('DROP TABLE temp_$tableCharacterPerks');
  }

  static convertCharacterMasteryIdColumnFromIntToText(Transaction txn) async {
    await txn.execute('''
  ALTER TABLE $tableCharacterMasteries
  RENAME TO temp_$tableCharacterMasteries
''');

    await txn.execute('''
  CREATE TABLE $tableCharacterMasteries (
    $columnAssociatedCharacterUuid ${DatabaseHelper.textType},
    $columnAssociatedMasteryId ${DatabaseHelper.textType},
    $columnCharacterMasteryAchieved ${DatabaseHelper.boolType}
  )
''');

    await txn.execute('''
  INSERT INTO $tableCharacterMasteries
  SELECT
    $columnAssociatedCharacterUuid,
    CAST($columnAssociatedMasteryId AS TEXT),
    $columnCharacterMasteryAchieved
  FROM temp_$tableCharacterMasteries
''');

    await txn.execute('DROP TABLE temp_$tableCharacterMasteries');
  }

  static Future<void> includeClassVariantsAndPerksAsMap(Transaction txn) async {
    const String tempTablePerks = 'temp_$tablePerks';
    await txn.execute('''
         ${DatabaseHelper.createTable} $tempTablePerks (
           $columnPerkId ${DatabaseHelper.idTextPrimaryType},
           $columnPerkClass ${DatabaseHelper.textType},
           $columnPerkDetails ${DatabaseHelper.textType},
           $columnPerkIsGrouped ${DatabaseHelper.boolType},
           $columnPerkVariant ${DatabaseHelper.textType}
         )''');
    // Handle existing Perks for Variant.base
    await _handleBaseVariantPerks(
      txn,
      tempTablePerks,
    );

    // Handle all other Perks
    await _handleRemainingVariantPerks(
      txn,
      tempTablePerks,
    );

    // Replace the old table with the temp table
    await _dropCharacterPerksTableAndRenameTemp(
      txn,
      tempTablePerks,
    );
  }

  static Future<void> _handleBaseVariantPerks(
    Transaction txn,
    String tempTablePerks,
  ) async {
    final List<Map<String, dynamic>> characterPerksMaps = await txn.query(
      tableCharacterPerks,
    );
    final List<CharacterPerk?> characterPerks =
        characterPerksMaps.map((e) => CharacterPerk.fromMap(e)).toList();
    final List<Map<String, dynamic>> charactersMaps = await txn.query(
      tableCharacters,
    );
    final List<Character?> characters =
        charactersMaps.map((e) => Character.fromMap(e)).toList();
    await Future.forEach(
      CharacterData.perksMap.entries,
      (entry) async {
        final classKey = entry.key;
        final perkLists =
            entry.value.where((element) => element.variant == Variant.base);

        for (Perks list in perkLists) {
          for (Perk perk in list.perks) {
            perk.classCode = classKey;
            String index =
                (list.perks.indexOf(perk) + 1).toString().padLeft(2, '0');
            for (int i = 0; i < perk.quantity; i++) {
              String suffix = '$index${indexToLetter(i)}';

              int id = await txn.insert(
                tempTablePerks,
                perk.toMap(suffix),
              );
              // This handles for a mistake when first defining the Infuser perks
              // One perk that has two checks was only given one
              // All perks after 726 (the last Infuser perk) should reference an
              // index one lower than the perk id
              if (id >= 726) {
                id--;
              }
              CharacterPerk? matchingCharacterPerk;

              matchingCharacterPerk = characterPerks.firstWhereOrNull(
                (element) => element?.associatedPerkId == id.toString(),
              );

              if (matchingCharacterPerk != null) {
                Character? character = characters.firstWhereOrNull(
                  (element) =>
                      element?.uuid ==
                      matchingCharacterPerk?.associatedCharacterUuid,
                );
                if (character != null) {
                  if (id == 725 && index == '11') {
                    await txn.insert(
                      tableCharacterPerks,
                      CharacterPerk(
                        character.uuid,
                        '${character.playerClass.classCode}_${Variant.base.name}_$suffix',
                        false,
                      ).toMap(),
                    );
                  }
                  debugPrint('MATCHING PERK FOUND');

                  await txn.update(
                    tableCharacterPerks,
                    {
                      columnAssociatedPerkId:
                          '${character.playerClass.classCode}_${Variant.base.name}_$suffix',
                    },
                    where: '$columnAssociatedPerkId = ?',
                    whereArgs: [id],
                  );
                }
                debugPrint('INSERTED PERK ID IS: $id');
              }
            }
          }
        }
      },
    );
  }

  static Future<void> _handleRemainingVariantPerks(
    Transaction txn,
    String tempTablePerks,
  ) async {
    await Future.forEach(CharacterData.perksMap.entries, (entry) async {
      final classCode = entry.key;
      final perkLists =
          entry.value.where((element) => element.variant != Variant.base);

      for (Perks list in perkLists) {
        for (Perk perk in list.perks) {
          perk.variant = list.variant;
          perk.classCode = classCode;
          for (int i = 0; i < perk.quantity; i++) {
            try {
              await txn.insert(
                tempTablePerks,
                perk.toMap('${list.perks.indexOf(perk)}${indexToLetter(i)}'),
              );
            } catch (e) {
              debugPrint('ERROR WITH PERKS2 TABLE: $e');
            }
          }
        }
      }
    });
  }

  static Future<void> _dropCharacterPerksTableAndRenameTemp(
    Transaction txn,
    String tempTablePerks,
  ) async {
    await txn.execute('''
       ${DatabaseHelper.dropTable} $tablePerks
        ''');
    await txn.rawUpdate(
      'ALTER TABLE $tempTablePerks RENAME TO $tablePerks',
    );
  }

  static Future<void> includeClassVariantsAndMasteriesAsMap(
      Transaction txn) async {
    const String tempTableMasteries = 'temp_$tableMasteries';
    await txn.execute('''
        ${DatabaseHelper.createTable} $tempTableMasteries (
          $columnMasteryId ${DatabaseHelper.idTextPrimaryType},
          $columnMasteryClass ${DatabaseHelper.textType},
          $columnMasteryDetails ${DatabaseHelper.textType},
          $columnMasteryVariant ${DatabaseHelper.textType}
        )''');
    // Handle existing Masteries for Variant.base
    await _handleVariantMasteries(
      txn,
      tempTableMasteries,
    );

    // Handle all other Perks
    // await _handleRemainingVariantMasteries(
    //   txn,
    //   tempTableMasteries,
    // );

    // Replace the old table with the temp table
    await _dropCharacterMasteriesTableAndRenameTemp(
      txn,
      tempTableMasteries,
    );
  }

  // TODO: Masteries can be handled the same regardless of Variant because no new ones have been added
  // (or have they? considering JotL FHCO character sheets...)
  static Future<void> _handleVariantMasteries(
    Transaction txn,
    String tempTableMasteries,
  ) async {
    final List<Map<String, dynamic>> characterMasteriesMaps =
        await txn.query(tableCharacterMasteries);
    final List<CharacterMastery?> characterMasteries =
        characterMasteriesMaps.map((e) => CharacterMastery.fromMap(e)).toList();
    await Future.forEach(CharacterData.masteriesMap.entries, (entry) async {
      final classKey = entry.key;
      final masteryLists = entry.value;

      for (Masteries list in masteryLists) {
        for (Mastery mastery in list.masteries) {
          mastery.classCode = classKey;
          mastery.variant = list.variant;

          int id = await txn.insert(
            tempTableMasteries,
            mastery.toMap(list.masteries.indexOf(mastery).toString()),
          );
          CharacterMastery? matchingCharacterMastery;

          matchingCharacterMastery = characterMasteries.firstWhereOrNull(
            (element) => element?.associatedMasteryId == id.toString(),
          );

          if (matchingCharacterMastery != null) {
            debugPrint('MATCHING MASTERY FOUND');
            final List<Map<String, dynamic>> characters = await txn.query(
              tableCharacters,
              where: '$columnCharacterUuid = ?',
              whereArgs: [matchingCharacterMastery.associatedCharacterUuid],
            );

            Character character = Character.fromMap(characters.first);

            await txn.update(
              tableCharacterMasteries,
              {
                columnAssociatedMasteryId:
                    '${character.playerClass.classCode}_${Variant.base.name}_${list.masteries.indexOf(mastery)}',
              },
              where: '$columnAssociatedMasteryId = ?',
              whereArgs: [id],
            );
          }
          debugPrint('INSERTED MASTERY ID IS: $id');
        }
      }
    });
  }

  // static Future<void> _handleRemainingVariantMasteries(
  //   Transaction txn,
  //   String tempTableMasteries,
  // ) async {
  //   await Future.forEach(CharacterData.masteriesMap.entries, (entry) async {
  //     final classCode = entry.key;
  //     final masteryLists =
  //         entry.value.where((element) => element.variant != Variant.base);

  //     for (Masteries list in masteryLists) {
  //       for (Mastery mastery in list.masteries) {
  //         mastery.variant = list.variant;
  //         mastery.classCode = classCode;
  //         try {
  //           await txn.insert(
  //             tempTableMasteries,
  //             mastery.toMap('${list.masteries.indexOf(mastery)}'),
  //           );
  //         } catch (e) {
  //           debugPrint('ERROR WITH MASTERIES TABLE: $e');
  //         }
  //       }
  //     }
  //   });
  // }

  static Future<void> _dropCharacterMasteriesTableAndRenameTemp(
    Transaction txn,
    String tempTableMasteries,
  ) async {
    await txn.execute('''
       ${DatabaseHelper.dropTable} $tableMasteries
        ''');
    await txn.rawUpdate(
      'ALTER TABLE $tempTableMasteries RENAME TO $tableMasteries',
    );
  }
}

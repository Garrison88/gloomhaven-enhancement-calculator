import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/event.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/global_achievement.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/party_achievement.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';

import 'package:sqflite/sqflite.dart';

class CampaignMigrations {
  // Add this to database version 13
  static Future<void> addCampaignTables(Transaction txn) async {
    // Create Campaigns table
    await txn.execute('''
      ${DatabaseHelper.createTable} $tableCampaigns (
        $columnCampaignId ${DatabaseHelper.idType},
        $columnCampaignUuid ${DatabaseHelper.textType},
        $columnPartyName ${DatabaseHelper.textType},
        $columnReputation ${DatabaseHelper.integerType} DEFAULT 0,
        $columnProsperity ${DatabaseHelper.integerType} DEFAULT 1,
        $columnProsperityCheckmarks ${DatabaseHelper.integerType} DEFAULT 0,
        $columnSanctuaryDonations ${DatabaseHelper.integerType} DEFAULT 0,
        $columnCurrentLocation ${DatabaseHelper.textType} DEFAULT 'Gloomhaven',
        $columnNotes TEXT DEFAULT '',
        $columnCreatedAt ${DatabaseHelper.dateTimeType},
        $columnGameVariant ${DatabaseHelper.textType} DEFAULT 'base',
        $columnIsActive ${DatabaseHelper.boolType} DEFAULT 1
      )
    ''');

    await txn.execute('''
      ${DatabaseHelper.createTable} $tableGlobalAchievements (
        $columnAchievementId ${DatabaseHelper.idType},
        $columnAchievementName ${DatabaseHelper.textType},
        $columnAchievementType TEXT,
        $columnAchievementDetails TEXT DEFAULT '',
        $columnIsActive ${DatabaseHelper.boolType} DEFAULT 1,
        $columnUnlockedAt ${DatabaseHelper.dateTimeType},
        $columnAssociatedCampaignUuid ${DatabaseHelper.textType},
        FOREIGN KEY ($columnAssociatedCampaignUuid) REFERENCES $tableCampaigns($columnCampaignUuid)
      )
    ''');

    // Create unique index for singleton types
    await txn.execute('''
      CREATE UNIQUE INDEX idx_singleton_achievements 
      ON $tableGlobalAchievements($columnAchievementType) 
      WHERE $columnAchievementType IN ('City Rule', 'The Drake Aided', 'End of the Invasion', 'End of Corruption')
    ''');

    // Create Party Achievements table
    await txn.execute('''
      ${DatabaseHelper.createTable} $tablePartyAchievements (
        $columnPartyAchievementId ${DatabaseHelper.idType},
        $columnPartyAchievementName ${DatabaseHelper.textType},
        $columnPartyAchievementDetails TEXT DEFAULT '',
        $columnPartyAchievementUnlockedAt ${DatabaseHelper.dateTimeType},
        $columnPartyAchievementCampaignUuid ${DatabaseHelper.textType},
        FOREIGN KEY ($columnPartyAchievementCampaignUuid) REFERENCES $tableCampaigns($columnCampaignUuid)
      )
    ''');

    // Create Campaign Unlocks table
    await txn.execute('''
      ${DatabaseHelper.createTable} $tableCampaignUnlocks (
        $columnUnlockId ${DatabaseHelper.idType},
        $columnUnlockType ${DatabaseHelper.textType},
        $columnUnlockName ${DatabaseHelper.textType},
        $columnUnlockCondition ${DatabaseHelper.textType},
        $columnUnlockProgress ${DatabaseHelper.integerType} DEFAULT 0,
        $columnUnlockTarget ${DatabaseHelper.integerType},
        $columnIsUnlocked ${DatabaseHelper.boolType} DEFAULT 0,
        $columnUnlockCampaignUuid ${DatabaseHelper.textType},
        FOREIGN KEY ($columnUnlockCampaignUuid) REFERENCES $tableCampaigns($columnCampaignUuid)
      )
    ''');

    // Create Campaign Events table
    await txn.execute('''
      ${DatabaseHelper.createTable} $tableCampaignEvents (
        $columnEventId ${DatabaseHelper.idType},
        $columnEventNumber ${DatabaseHelper.integerType},
        $columnEventType ${DatabaseHelper.textType},
        $columnEventStatus ${DatabaseHelper.textType} DEFAULT 'available',
        $columnEventNotes TEXT DEFAULT '',
        $columnEventCampaignUuid ${DatabaseHelper.textType},
        FOREIGN KEY ($columnEventCampaignUuid) REFERENCES $tableCampaigns($columnCampaignUuid)
      )
    ''');

    // Create indexes for better query performance
    await txn.execute('''
      CREATE INDEX idx_campaign_uuid ON $tableCampaigns($columnCampaignUuid)
    ''');

    await txn.execute('''
      CREATE INDEX idx_global_achievements_campaign 
      ON $tableGlobalAchievements($columnAssociatedCampaignUuid)
    ''');

    await txn.execute('''
      CREATE INDEX idx_party_achievements_campaign 
      ON $tablePartyAchievements($columnPartyAchievementCampaignUuid)
    ''');

    await txn.execute('''
      CREATE INDEX idx_campaign_unlocks_campaign 
      ON $tableCampaignUnlocks($columnUnlockCampaignUuid)
    ''');

    await txn.execute('''
      CREATE INDEX idx_campaign_events_campaign 
      ON $tableCampaignEvents($columnEventCampaignUuid)
    ''');

    await txn.execute('''
      CREATE INDEX idx_campaign_events_type_status 
      ON $tableCampaignEvents($columnEventType, $columnEventStatus)
    ''');
  }

  // Optional: Link existing characters to campaigns
  static Future<void> linkCharactersToCampaigns(Transaction txn) async {
    // Add CampaignUUID column to Characters table
    await txn.execute('''
      ALTER TABLE $tableCharacters 
      ADD COLUMN $columnCampaignUuid TEXT
    ''');

    // Create index for character campaign relationship
    await txn.execute('''
      CREATE INDEX idx_characters_campaign 
      ON $tableCharacters($columnCampaignUuid)
    ''');
  }
}

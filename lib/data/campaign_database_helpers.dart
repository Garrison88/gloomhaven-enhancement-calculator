import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/event.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/global_achievement.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/party_achievement.dart';
import 'package:gloomhaven_enhancement_calc/models/world/world.dart';
import 'package:sqflite/sqflite.dart';

// Extension to DatabaseHelper for campaign-related operations
class CampaignDatabaseHelper {
  // Campaign CRUD operations
  static Future<int> insertCampaign(Database db, Campaign campaign) async {
    // Verify world exists
    final worldExists = await db.query(
      tableWorlds,
      where: '$columnWorldUuid = ?',
      whereArgs: [campaign.worldUuid],
      limit: 1,
    );

    if (worldExists.isEmpty) {
      throw Exception('Cannot create party without a world');
    }

    return await db.insert(tableCampaigns, campaign.toMap());
  }

  static Future<void> updateCampaign(Database db, Campaign campaign) async {
    await db.update(
      tableCampaigns,
      campaign.toMap(),
      where: '$columnCampaignUuid = ?',
      whereArgs: [campaign.uuid],
    );
  }

  static Future<void> deleteCampaign(Database db, String campaignUuid) async {
    await db.transaction((txn) async {
      // Delete campaign and all associated data
      await txn.delete(
        tableCampaigns,
        where: '$columnCampaignUuid = ?',
        whereArgs: [campaignUuid],
      );
      await txn.delete(
        tableGlobalAchievements,
        where: '$columnAssociatedCampaignUuid = ?',
        whereArgs: [campaignUuid],
      );
      await txn.delete(
        tablePartyAchievements,
        where: '$columnPartyAchievementCampaignUuid = ?',
        whereArgs: [campaignUuid],
      );
      await txn.delete(
        tableCampaignUnlocks,
        where: '$columnUnlockCampaignUuid = ?',
        whereArgs: [campaignUuid],
      );
      await txn.delete(
        tableCampaignEvents,
        where: '$columnEventCampaignUuid = ?',
        whereArgs: [campaignUuid],
      );
    });
  }

  static Future<List<Campaign>> queryAllCampaigns(Database db) async {
    List<Campaign> campaigns = [];
    List<Map<String, dynamic>> maps = await db.query(tableCampaigns);
    for (final map in maps) {
      campaigns.add(Campaign.fromMap(map));
    }
    return campaigns;
  }

  static Future<Campaign?> queryActiveCampaignInWorld(
    Database db,
    String worldUuid,
  ) async {
    List<Map<String, dynamic>> maps = await db.query(
      tableCampaigns,
      where: '$columnCampaignWorldUuid = ? AND $columnIsActive = ?',
      whereArgs: [worldUuid, 1],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Campaign.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> insertGlobalAchievement(
    Database db,
    GlobalAchievement achievement,
  ) async {
    // For singleton types (like City Rule), check if one exists FOR THIS CAMPAIGN
    if (achievement.type != null &&
        AchievementTypes.singletonTypes.contains(achievement.type)) {
      List<Map<String, dynamic>> existing = await db.query(
        tableGlobalAchievements,
        where:
            '$columnAchievementType = ? AND $columnAssociatedCampaignUuid = ?',
        whereArgs: [achievement.type, achievement.associatedCampaignUuid],
      );

      if (existing.isNotEmpty) {
        // Overwrite the existing singleton
        await db.update(
          tableGlobalAchievements,
          achievement.toMap(),
          where:
              '$columnAchievementType = ? AND $columnAssociatedCampaignUuid = ?',
          whereArgs: [achievement.type, achievement.associatedCampaignUuid],
        );
        return existing.first[columnAchievementId];
      }
    }
    // For cumulative types (like Ancient Technology), check for exact duplicates
    else if (achievement.type == AchievementTypes.ancientTechnology) {
      List<Map<String, dynamic>> existing = await db.query(
        tableGlobalAchievements,
        where:
            '$columnAchievementName = ? AND $columnAchievementType = ? AND $columnAssociatedCampaignUuid = ?',
        whereArgs: [
          achievement.name,
          achievement.type,
          achievement.associatedCampaignUuid
        ],
      );

      // Don't insert exact duplicates
      if (existing.isNotEmpty) {
        return existing.first[columnAchievementId];
      }
    }

    return await db.insert(tableGlobalAchievements, achievement.toMap());
  }

  static Future<void> deleteGlobalAchievement(Database db, int id) async {
    await db.delete(
      tableGlobalAchievements,
      where: '$columnAchievementId = ?',
      whereArgs: [id],
    );
  }

  // Query ALL global achievements (not filtered by campaign)
  static Future<List<GlobalAchievement>> queryAllGlobalAchievements(
    Database db,
    String campaignUuid,
  ) async {
    List<GlobalAchievement> achievements = [];
    List<Map<String, dynamic>> maps = await db.query(
      tableGlobalAchievements,
      where: '$columnAssociatedCampaignUuid = ? AND $columnIsActive = ?',
      whereArgs: [campaignUuid, 1],
    );
    for (final map in maps) {
      achievements.add(GlobalAchievement.fromMap(map));
    }
    return achievements;
  }

  // Count specific achievement types
  static Future<int> countAchievementsByType(
    Database db,
    String type,
  ) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableGlobalAchievements WHERE $columnAchievementType = ? AND $columnIsActive = 1',
      [type],
    );
    return result.first['count'] as int;
  }

  // Party Achievement operations
  static Future<int> insertPartyAchievement(
    Database db,
    PartyAchievement achievement,
  ) async {
    return await db.insert(tablePartyAchievements, achievement.toMap());
  }

  static Future<void> deletePartyAchievement(Database db, int id) async {
    await db.delete(
      tablePartyAchievements,
      where: '$columnPartyAchievementId = ?',
      whereArgs: [id],
    );
  }

  static Future<List<PartyAchievement>> queryPartyAchievements(
    Database db,
    String campaignUuid,
  ) async {
    List<PartyAchievement> achievements = [];
    List<Map<String, dynamic>> maps = await db.query(
      tablePartyAchievements,
      where: '$columnPartyAchievementCampaignUuid = ?',
      whereArgs: [campaignUuid],
    );
    for (final map in maps) {
      achievements.add(PartyAchievement.fromMap(map));
    }
    return achievements;
  }

  // Campaign Unlock operations
  static Future<int> insertCampaignUnlock(
    Database db,
    CampaignUnlock unlock,
  ) async {
    return await db.insert(tableCampaignUnlocks, unlock.toMap());
  }

  static Future<void> updateCampaignUnlock(
    Database db,
    CampaignUnlock unlock,
  ) async {
    await db.update(
      tableCampaignUnlocks,
      unlock.toMap(),
      where: '$columnUnlockId = ?',
      whereArgs: [unlock.id],
    );
  }

  static Future<List<CampaignUnlock>> queryCampaignUnlocks(
    Database db,
    String campaignUuid,
  ) async {
    List<CampaignUnlock> unlocks = [];
    List<Map<String, dynamic>> maps = await db.query(
      tableCampaignUnlocks,
      where: '$columnUnlockCampaignUuid = ?',
      whereArgs: [campaignUuid],
    );
    for (final map in maps) {
      unlocks.add(CampaignUnlock.fromMap(map));
    }
    return unlocks;
  }

  // Event operations
  static Future<int> insertCampaignEvent(
    Database db,
    CampaignEvent event,
  ) async {
    return await db.insert(tableCampaignEvents, event.toMap());
  }

  static Future<void> updateCampaignEvent(
    Database db,
    CampaignEvent event,
  ) async {
    await db.update(
      tableCampaignEvents,
      event.toMap(),
      where: '$columnEventId = ?',
      whereArgs: [event.id],
    );
  }

  static Future<List<CampaignEvent>> queryCampaignEvents(
      Database db, String campaignUuid,
      {EventType? type, EventStatus? status}) async {
    List<CampaignEvent> events = [];
    String whereClause = '$columnEventCampaignUuid = ?';
    List<dynamic> whereArgs = [campaignUuid];

    if (type != null) {
      whereClause += ' AND $columnEventType = ?';
      whereArgs.add(type.name);
    }

    if (status != null) {
      whereClause += ' AND $columnEventStatus = ?';
      whereArgs.add(status.name);
    }

    List<Map<String, dynamic>> maps = await db.query(
      tableCampaignEvents,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: '$columnEventNumber ASC',
    );

    for (final map in maps) {
      events.add(CampaignEvent.fromMap(map));
    }
    return events;
  }

  // Initialize predefined unlocks for a new campaign
  static Future<void> initializeCampaignUnlocks(
    Database db,
    String campaignUuid,
  ) async {
    final unlocks = PredefinedUnlocks.getGloomhavenUnlocks();
    for (final unlockData in unlocks) {
      final unlock = CampaignUnlock(
        type: unlockData['type'],
        name: unlockData['name'],
        condition: unlockData['condition'],
        target: unlockData['target'],
        associatedCampaignUuid: campaignUuid,
      );
      await insertCampaignUnlock(db, unlock);
    }
  }

  // Initialize starting events for a new campaign
  static Future<void> initializeCampaignEvents(
    Database db,
    String campaignUuid,
  ) async {
    // Add city events 1-30
    for (int i in EventDeckManager.getStartingCityEvents()) {
      final event = CampaignEvent(
        eventNumber: i,
        type: EventType.city,
        associatedCampaignUuid: campaignUuid,
      );
      await insertCampaignEvent(db, event);
    }

    // Add road events 1-30
    for (int i in EventDeckManager.getStartingRoadEvents()) {
      final event = CampaignEvent(
        eventNumber: i,
        type: EventType.road,
        associatedCampaignUuid: campaignUuid,
      );
      await insertCampaignEvent(db, event);
    }
  }
}

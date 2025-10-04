import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/campaign_database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/global_achievement.dart';
import 'package:gloomhaven_enhancement_calc/models/world/world.dart';
import 'package:sqflite/sqflite.dart';

class WorldDatabaseHelper {
  // World CRUD operations
  static Future<int> insertWorld(Database db, World world) async {
    return await db.insert(tableWorlds, world.toMap());
  }

  static Future<void> updateWorld(Database db, World world) async {
    await db.update(
      tableWorlds,
      world.toMap(),
      where: '$columnWorldUuid = ?',
      whereArgs: [world.uuid],
    );
  }

  static Future<void> deleteWorld(Database db, String worldUuid) async {
    await db.transaction((txn) async {
      // Delete world and all associated data (cascading delete)
      await txn.delete(
        tableWorlds,
        where: '$columnWorldUuid = ?',
        whereArgs: [worldUuid],
      );

      // Delete all campaigns in this world
      await txn.delete(
        tableCampaigns,
        where: '$columnCampaignWorldUuid = ?',
        whereArgs: [worldUuid],
      );

      // Delete global achievements for this world
      await txn.delete(
        tableGlobalAchievements,
        where: '$columnAchievementWorldUuid = ?',
        whereArgs: [worldUuid],
      );

      // Party achievements and other campaign-specific data will be deleted
      // through cascade from campaigns
    });
  }

  static Future<List<World>> queryAllWorlds(Database db) async {
    List<World> worlds = [];
    List<Map<String, dynamic>> maps = await db.query(
      tableWorlds,
      orderBy: '$columnWorldCreatedAt DESC',
    );
    for (final map in maps) {
      worlds.add(World.fromMap(map));
    }
    return worlds;
  }

  static Future<World?> queryActiveWorld(Database db) async {
    List<Map<String, dynamic>> maps = await db.query(
      tableWorlds,
      where: '$columnWorldIsActive = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return World.fromMap(maps.first);
    }
    return null;
  }

  // Get all campaigns (parties) in a world
  static Future<List<Campaign>> queryCampaignsInWorld(
    Database db,
    String worldUuid,
  ) async {
    List<Campaign> campaigns = [];
    List<Map<String, dynamic>> maps = await db.query(
      tableCampaigns,
      where: '$columnCampaignWorldUuid = ?',
      whereArgs: [worldUuid],
      orderBy: '$columnCreatedAt DESC',
    );
    for (final map in maps) {
      campaigns.add(Campaign.fromMap(map));
    }
    return campaigns;
  }

  // Global Achievement operations (now scoped to worlds)
  static Future<int> insertGlobalAchievement(
    Database db,
    GlobalAchievement achievement,
  ) async {
    // For singleton types (like City Rule), check if one exists in this world
    if (achievement.type != null &&
        AchievementTypes.singletonTypes.contains(achievement.type)) {
      List<Map<String, dynamic>> existing = await db.query(
        tableGlobalAchievements,
        where: '$columnAchievementType = ? AND $columnAchievementWorldUuid = ?',
        whereArgs: [achievement.type, achievement.worldUuid],
      );

      if (existing.isNotEmpty) {
        // Overwrite the existing singleton
        await db.update(
          tableGlobalAchievements,
          achievement.toMap(),
          where:
              '$columnAchievementType = ? AND $columnAchievementWorldUuid = ?',
          whereArgs: [achievement.type, achievement.worldUuid],
        );
        return existing.first[columnAchievementId];
      }
    }
    // For cumulative types (like Ancient Technology), check for exact duplicates
    else if (achievement.type == AchievementTypes.ancientTechnology) {
      List<Map<String, dynamic>> existing = await db.query(
        tableGlobalAchievements,
        where:
            '$columnAchievementName = ? AND $columnAchievementType = ? AND $columnAchievementWorldUuid = ?',
        whereArgs: [
          achievement.name,
          achievement.type,
          achievement.worldUuid,
        ],
      );

      // Don't insert exact duplicates
      if (existing.isNotEmpty) {
        return existing.first[columnAchievementId];
      }
    }

    return await db.insert(tableGlobalAchievements, achievement.toMap());
  }

  static Future<List<GlobalAchievement>> queryGlobalAchievements(
    Database db,
    String worldUuid,
  ) async {
    List<GlobalAchievement> achievements = [];
    List<Map<String, dynamic>> maps = await db.query(
      tableGlobalAchievements,
      where: '$columnAchievementWorldUuid = ?',
      whereArgs: [worldUuid],
    );
    for (final map in maps) {
      achievements.add(GlobalAchievement.fromMap(map));
    }
    return achievements;
  }

  static Future<int> countAchievementsByType(
    Database db,
    String worldUuid,
    String type,
  ) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableGlobalAchievements WHERE $columnAchievementWorldUuid = ? AND $columnAchievementType = ? AND $columnIsActive = 1',
      [worldUuid, type],
    );
    return result.first['count'] as int;
  }
}

// Updated CampaignDatabaseHelper methods
extension UpdatedCampaignDatabaseHelper on CampaignDatabaseHelper {
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
}

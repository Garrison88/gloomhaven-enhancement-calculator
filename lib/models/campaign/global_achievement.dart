// Database table and column names
import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';

const String tableGlobalAchievements = 'GlobalAchievements';
const String columnAchievementId = 'AchievementID';
const String columnAchievementName = 'AchievementName';
const String columnAchievementType = 'AchievementType';
const String columnAchievementDetails = 'AchievementDetails';
const String columnUnlockedAt = 'UnlockedAt';
const String columnAssociatedCampaignUuid = 'CampaignUUID';

// Global Achievement model class
class GlobalAchievement {
  int? id;
  String name;
  String? type; // e.g., "City Rule", "Ancient Technology", etc.
  String details;
  bool isActive;
  DateTime? unlockedAt;
  String associatedCampaignUuid;

  GlobalAchievement({
    this.id,
    required this.name,
    this.type,
    this.details = '',
    this.isActive = true,
    this.unlockedAt,
    required this.associatedCampaignUuid,
  });

  // Constructor to create from database map
  GlobalAchievement.fromMap(Map<String, dynamic> map)
      : id = map[columnAchievementId],
        name = map[columnAchievementName],
        type = map[columnAchievementType],
        details = map[columnAchievementDetails] ?? '',
        isActive = map[columnIsActive] == 1,
        unlockedAt = map[columnUnlockedAt] != null
            ? DateTime.parse(map[columnUnlockedAt])
            : null,
        associatedCampaignUuid = map[columnAssociatedCampaignUuid];

  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAchievementName: name,
      columnAchievementType: type,
      columnAchievementDetails: details,
      columnIsActive: isActive ? 1 : 0,
      columnUnlockedAt: unlockedAt?.toIso8601String(),
      columnAssociatedCampaignUuid: associatedCampaignUuid,
    };
    if (id != null) {
      map[columnAchievementId] = id;
    }
    return map;
  }

  // Check if this achievement has the same type as another
  bool hasSameType(GlobalAchievement other) {
    return type != null && other.type != null && type == other.type;
  }
}

// Common achievement types in Gloomhaven
class AchievementTypes {
  static const String cityRule = 'City Rule';
  static const String ancientTechnology = 'Ancient Technology';
  static const String drakeAided = 'The Drake Aided';
  static const String artifactRecovered = 'Artifact Recovered';
  static const String endOfInvasion = 'End of the Invasion';
  static const String endOfCorruption = 'End of Corruption';
}

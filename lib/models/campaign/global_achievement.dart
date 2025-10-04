// Database table and column names
import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';

const String tableGlobalAchievements = 'GlobalAchievements';
const String columnAchievementId = 'AchievementID';
const String columnAchievementWorldUuid =
    'WorldUUID'; // Links to world, not campaign
const String columnAchievementName = 'AchievementName';
const String columnAchievementType = 'AchievementType';
const String columnAchievementDetails = 'AchievementDetails';
// const String columnIsActive = 'IsActive';
const String columnUnlockedAt = 'UnlockedAt';

// Global Achievement model class
class GlobalAchievement {
  int? id;
  String worldUuid; // Links to world, shared by all parties in that world
  String associatedCampaignUuid; // Links to the campaign that unlocked it
  String name;
  String? type; // e.g., "City Rule", "Ancient Technology", etc.
  String details;
  bool isActive;
  DateTime? unlockedAt;

  GlobalAchievement({
    this.id,
    required this.worldUuid,
    required this.associatedCampaignUuid,
    required this.name,
    this.type,
    this.details = '',
    this.isActive = true,
    this.unlockedAt,
  });

  // Constructor to create from database map
  GlobalAchievement.fromMap(Map<String, dynamic> map)
      : id = map[columnAchievementId],
        worldUuid = map[columnAchievementWorldUuid],
        associatedCampaignUuid = map[columnAssociatedCampaignUuid],
        name = map[columnAchievementName],
        type = map[columnAchievementType],
        details = map[columnAchievementDetails] ?? '',
        isActive = map[columnIsActive] == 1,
        unlockedAt = map[columnUnlockedAt] != null
            ? DateTime.parse(map[columnUnlockedAt])
            : null;

  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAchievementWorldUuid: worldUuid,
      columnAssociatedCampaignUuid: associatedCampaignUuid,
      columnAchievementName: name,
      columnAchievementType: type,
      columnAchievementDetails: details,
      columnIsActive: isActive ? 1 : 0,
      columnUnlockedAt: unlockedAt?.toIso8601String(),
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

// Achievement types that can have multiple instances
class AchievementTypes {
  static const String cityRule = 'City Rule'; // Only one can be active
  static const String ancientTechnology =
      'Ancient Technology'; // Can have multiple
  static const String drakeAided = 'The Drake Aided'; // Unique
  static const String artifactRecovered =
      'Artifact Recovered'; // Can have multiple
  static const String endOfInvasion = 'End of the Invasion'; // Unique
  static const String endOfCorruption = 'End of Corruption'; // Unique

  // Types that can only have one active instance
  static const List<String> singletonTypes = [
    cityRule,
    drakeAided,
    endOfInvasion,
    endOfCorruption,
  ];

  // Types that can have multiple instances
  static const List<String> cumulativeTypes = [
    ancientTechnology,
    artifactRecovered,
  ];
}

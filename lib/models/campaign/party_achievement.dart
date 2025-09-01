// Database table and column names for Party Achievements
const String tablePartyAchievements = 'PartyAchievements';
const String columnPartyAchievementId = 'PartyAchievementID';
const String columnPartyAchievementName = 'PartyAchievementName';
const String columnPartyAchievementDetails = 'PartyAchievementDetails';
const String columnPartyAchievementUnlockedAt = 'UnlockedAt';
const String columnPartyAchievementCampaignUuid = 'CampaignUUID';

// Party Achievement model class
class PartyAchievement {
  int? id;
  String name;
  String details;
  DateTime? unlockedAt;
  String associatedCampaignUuid;

  PartyAchievement({
    this.id,
    required this.name,
    this.details = '',
    this.unlockedAt,
    required this.associatedCampaignUuid,
  });

  // Constructor to create from database map
  PartyAchievement.fromMap(Map<String, dynamic> map)
      : id = map[columnPartyAchievementId],
        name = map[columnPartyAchievementName],
        details = map[columnPartyAchievementDetails] ?? '',
        unlockedAt = map[columnPartyAchievementUnlockedAt] != null
            ? DateTime.parse(map[columnPartyAchievementUnlockedAt])
            : null,
        associatedCampaignUuid = map[columnPartyAchievementCampaignUuid];

  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnPartyAchievementName: name,
      columnPartyAchievementDetails: details,
      columnPartyAchievementUnlockedAt: unlockedAt?.toIso8601String(),
      columnPartyAchievementCampaignUuid: associatedCampaignUuid,
    };
    if (id != null) {
      map[columnPartyAchievementId] = id;
    }
    return map;
  }
}

// Database table and column names for Campaign Unlocks
const String tableCampaignUnlocks = 'CampaignUnlocks';
const String columnUnlockId = 'UnlockID';
const String columnUnlockType = 'UnlockType';
const String columnUnlockName = 'UnlockName';
const String columnUnlockCondition = 'UnlockCondition';
const String columnUnlockProgress = 'UnlockProgress';
const String columnUnlockTarget = 'UnlockTarget';
const String columnIsUnlocked = 'IsUnlocked';
const String columnUnlockCampaignUuid = 'CampaignUUID';

// Campaign Unlock model class
class CampaignUnlock {
  int? id;
  UnlockType type;
  String name;
  String condition;
  int progress;
  int target;
  bool isUnlocked;
  String associatedCampaignUuid;

  CampaignUnlock({
    this.id,
    required this.type,
    required this.name,
    required this.condition,
    this.progress = 0,
    required this.target,
    this.isUnlocked = false,
    required this.associatedCampaignUuid,
  });

  // Constructor to create from database map
  CampaignUnlock.fromMap(Map<String, dynamic> map)
      : id = map[columnUnlockId],
        type = UnlockType.values.firstWhere(
          (t) => t.name == map[columnUnlockType],
          orElse: () => UnlockType.other,
        ),
        name = map[columnUnlockName],
        condition = map[columnUnlockCondition],
        progress = map[columnUnlockProgress],
        target = map[columnUnlockTarget],
        isUnlocked = map[columnIsUnlocked] == 1,
        associatedCampaignUuid = map[columnUnlockCampaignUuid];

  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUnlockType: type.name,
      columnUnlockName: name,
      columnUnlockCondition: condition,
      columnUnlockProgress: progress,
      columnUnlockTarget: target,
      columnIsUnlocked: isUnlocked ? 1 : 0,
      columnUnlockCampaignUuid: associatedCampaignUuid,
    };
    if (id != null) {
      map[columnUnlockId] = id;
    }
    return map;
  }

  // Calculate progress percentage
  double get progressPercentage => target > 0 ? progress / target : 0.0;

  // Check if unlock condition is met
  bool get conditionMet => progress >= target;
}

// Enum for unlock types
enum UnlockType {
  envelope,
  characterClass,
  scenario,
  item,
  achievement,
  other,
}

// Predefined unlocks from Gloomhaven
class PredefinedUnlocks {
  static List<Map<String, dynamic>> getGloomhavenUnlocks() {
    return [
      {
        'type': UnlockType.envelope,
        'name': 'Envelope A',
        'condition': 'Gain 5 "Ancient Technology" global achievements',
        'target': 5,
      },
      {
        'type': UnlockType.envelope,
        'name': 'Envelope B',
        'condition':
            'Donate a total of 100 gold to the Sanctuary of the Great Oak',
        'target': 100,
      },
      {
        'type': UnlockType.characterClass,
        'name': 'Sun Class',
        'condition': 'Have a party reputation of 10 or higher',
        'target': 10,
      },
      {
        'type': UnlockType.characterClass,
        'name': 'Eclipse Class',
        'condition': 'Have a party reputation of -10 or lower',
        'target': -10,
      },
      {
        'type': UnlockType.achievement,
        'name': 'The Drake Aided',
        'condition':
            'Have a party gain both "The Drake\'s Command" and "The Drake\'s Treasure" party achievements',
        'target': 2,
      },
      {
        'type': UnlockType.other,
        'name': 'City Event 76 & Road Event 67',
        'condition': 'Have a party reputation of 20',
        'target': 20,
      },
      {
        'type': UnlockType.other,
        'name': 'City Event 77 & Road Event 68',
        'condition': 'Have a party reputation of -20',
        'target': -20,
      },
    ];
  }
}

import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

// Database table and column names
const String tableCampaigns = 'Campaigns';
const String columnCampaignId = 'CampaignID';
const String columnCampaignUuid = 'CampaignUUID';
const String columnPartyName = 'PartyName';
const String columnReputation = 'Reputation';
const String columnProsperity = 'Prosperity';
const String columnProsperityCheckmarks = 'ProsperityCheckmarks';
const String columnSanctuaryDonations = 'SanctuaryDonations';
const String columnCurrentLocation = 'CurrentLocation';
const String columnNotes = 'Notes';
const String columnCreatedAt = 'CreatedAt';
const String columnGameVariant = 'GameVariant';
const String columnIsActive = 'IsActive';

// Campaign model class
class Campaign {
  int? id;
  String uuid;
  String partyName;
  int reputation;
  int prosperity;
  int prosperityCheckmarks;
  int sanctuaryDonations;
  String currentLocation;
  String notes;
  DateTime createdAt;
  Variant gameVariant;
  bool isActive;

  // Calculated properties
  int get prosperityLevel {
    // Prosperity thresholds: 4, 9, 15, 22, 30, 39, 50, 64 checkmarks
    if (prosperityCheckmarks >= 64) return 9;
    if (prosperityCheckmarks >= 50) return 8;
    if (prosperityCheckmarks >= 39) return 7;
    if (prosperityCheckmarks >= 30) return 6;
    if (prosperityCheckmarks >= 22) return 5;
    if (prosperityCheckmarks >= 15) return 4;
    if (prosperityCheckmarks >= 9) return 3;
    if (prosperityCheckmarks >= 4) return 2;
    return 1;
  }

  int get shopPriceModifier {
    // Shop price modifiers based on reputation
    if (reputation >= 19) return -5;
    if (reputation >= 15) return -4;
    if (reputation >= 11) return -3;
    if (reputation >= 7) return -2;
    if (reputation >= 3) return -1;
    if (reputation >= -2) return 0;
    if (reputation >= -6) return 1;
    if (reputation >= -10) return 2;
    if (reputation >= -14) return 3;
    if (reputation >= -18) return 4;
    return 5; // reputation <= -19
  }

  Campaign({
    this.id,
    required this.uuid,
    required this.partyName,
    this.reputation = 0,
    this.prosperity = 1,
    this.prosperityCheckmarks = 0,
    this.sanctuaryDonations = 0,
    this.currentLocation = 'Gloomhaven',
    this.notes = '',
    DateTime? createdAt,
    this.gameVariant = Variant.base,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  // Constructor to create from database map
  Campaign.fromMap(Map<String, dynamic> map)
      : id = map[columnCampaignId],
        uuid = map[columnCampaignUuid],
        partyName = map[columnPartyName],
        reputation = map[columnReputation],
        prosperity = map[columnProsperity],
        prosperityCheckmarks = map[columnProsperityCheckmarks],
        sanctuaryDonations = map[columnSanctuaryDonations],
        currentLocation = map[columnCurrentLocation],
        notes = map[columnNotes],
        createdAt = DateTime.parse(map[columnCreatedAt]),
        gameVariant = Variant.values.firstWhere(
          (v) => v.name == map[columnGameVariant],
          orElse: () => Variant.base,
        ),
        isActive = map[columnIsActive] == 1;

  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCampaignUuid: uuid,
      columnPartyName: partyName,
      columnReputation: reputation,
      columnProsperity: prosperity,
      columnProsperityCheckmarks: prosperityCheckmarks,
      columnSanctuaryDonations: sanctuaryDonations,
      columnCurrentLocation: currentLocation,
      columnNotes: notes,
      columnCreatedAt: createdAt.toIso8601String(),
      columnGameVariant: gameVariant.name,
      columnIsActive: isActive ? 1 : 0,
    };
    if (id != null) {
      map[columnCampaignId] = id;
    }
    return map;
  }

  // Create a copy with modifications
  Campaign copyWith({
    int? id,
    String? uuid,
    String? partyName,
    int? reputation,
    int? prosperity,
    int? prosperityCheckmarks,
    int? sanctuaryDonations,
    String? currentLocation,
    String? notes,
    DateTime? createdAt,
    Variant? gameVariant,
    bool? isActive,
  }) {
    return Campaign(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      partyName: partyName ?? this.partyName,
      reputation: reputation ?? this.reputation,
      prosperity: prosperity ?? this.prosperity,
      prosperityCheckmarks: prosperityCheckmarks ?? this.prosperityCheckmarks,
      sanctuaryDonations: sanctuaryDonations ?? this.sanctuaryDonations,
      currentLocation: currentLocation ?? this.currentLocation,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      gameVariant: gameVariant ?? this.gameVariant,
      isActive: isActive ?? this.isActive,
    );
  }
}

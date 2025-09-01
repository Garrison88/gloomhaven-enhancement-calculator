// Database table and column names for Events
const String tableCampaignEvents = 'CampaignEvents';
const String columnEventId = 'EventID';
const String columnEventNumber = 'EventNumber';
const String columnEventType = 'EventType';
const String columnEventStatus = 'EventStatus';
const String columnEventNotes = 'EventNotes';
const String columnEventCampaignUuid = 'CampaignUUID';

// Event model class
class CampaignEvent {
  int? id;
  int eventNumber;
  EventType type;
  EventStatus status;
  String notes;
  String associatedCampaignUuid;

  CampaignEvent({
    this.id,
    required this.eventNumber,
    required this.type,
    this.status = EventStatus.available,
    this.notes = '',
    required this.associatedCampaignUuid,
  });

  // Constructor to create from database map
  CampaignEvent.fromMap(Map<String, dynamic> map)
      : id = map[columnEventId],
        eventNumber = map[columnEventNumber],
        type = EventType.values.firstWhere(
          (t) => t.name == map[columnEventType],
          orElse: () => EventType.city,
        ),
        status = EventStatus.values.firstWhere(
          (s) => s.name == map[columnEventStatus],
          orElse: () => EventStatus.available,
        ),
        notes = map[columnEventNotes] ?? '',
        associatedCampaignUuid = map[columnEventCampaignUuid];

  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnEventNumber: eventNumber,
      columnEventType: type.name,
      columnEventStatus: status.name,
      columnEventNotes: notes,
      columnEventCampaignUuid: associatedCampaignUuid,
    };
    if (id != null) {
      map[columnEventId] = id;
    }
    return map;
  }

  // Get display name for the event
  String get displayName =>
      '${type == EventType.city ? 'City' : 'Road'} Event $eventNumber';
}

// Enum for event types
enum EventType {
  city,
  road,
}

// Enum for event status
enum EventStatus {
  available, // In the deck
  completed, // Has been played
  removed, // Removed from the game
  bottomOfDeck, // Returned to bottom of deck
}

// Helper class for managing event decks
class EventDeckManager {
  // Starting events for Gloomhaven
  static List<int> getStartingCityEvents() {
    return List.generate(30, (index) => index + 1); // Events 1-30
  }

  static List<int> getStartingRoadEvents() {
    return List.generate(30, (index) => index + 1); // Events 1-30
  }

  // Events added by character unlocks/retirements
  static Map<String, List<int>> characterCityEvents = {
    'Sun': [75],
    'Eclipse': [77],
    // Add more as needed based on character unlocks
  };

  static Map<String, List<int>> characterRoadEvents = {
    'Sun': [67],
    'Eclipse': [68],
    // Add more as needed based on character unlocks
  };

  // Events added by reputation milestones
  static Map<int, List<int>> reputationCityEvents = {
    20: [76],
    -20: [77],
  };

  static Map<int, List<int>> reputationRoadEvents = {
    20: [67],
    -20: [68],
  };
}

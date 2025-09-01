import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/data/campaign_database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/event.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/global_achievement.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/party_achievement.dart';

import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:uuid/uuid.dart';

class CampaignModel with ChangeNotifier {
  CampaignModel({
    required this.databaseHelper,
  });

  DatabaseHelper databaseHelper;

  Campaign? _currentCampaign;
  List<Campaign> _campaigns = [];
  List<GlobalAchievement> _globalAchievements = [];
  List<PartyAchievement> _partyAchievements = [];
  List<CampaignUnlock> _campaignUnlocks = [];
  List<CampaignEvent> _cityEvents = [];
  List<CampaignEvent> _roadEvents = [];

  // Controllers for editing
  final partyNameController = TextEditingController();
  final sanctuaryDonationController = TextEditingController();
  final notesController = TextEditingController();
  final locationController = TextEditingController();

  // Getters
  Campaign? get currentCampaign => _currentCampaign;
  List<Campaign> get campaigns => _campaigns;
  List<GlobalAchievement> get globalAchievements => _globalAchievements;
  List<PartyAchievement> get partyAchievements => _partyAchievements;
  List<CampaignUnlock> get campaignUnlocks => _campaignUnlocks;
  List<CampaignEvent> get cityEvents => _cityEvents;
  List<CampaignEvent> get roadEvents => _roadEvents;

  // Computed getters
  List<CampaignEvent> get availableCityEvents =>
      _cityEvents.where((e) => e.status == EventStatus.available).toList();

  List<CampaignEvent> get availableRoadEvents =>
      _roadEvents.where((e) => e.status == EventStatus.available).toList();

  int get ancientTechnologyCount => _globalAchievements
      .where((a) => a.type == AchievementTypes.ancientTechnology && a.isActive)
      .length;

  @override
  void dispose() {
    partyNameController.dispose();
    sanctuaryDonationController.dispose();
    notesController.dispose();
    locationController.dispose();
    super.dispose();
  }

  // Initialize and load data
  Future<void> initialize() async {
    await loadCampaigns();
    await loadActiveCampaign();
  }

  Future<void> loadCampaigns() async {
    final db = await databaseHelper.database;
    _campaigns = await CampaignDatabaseHelper.queryAllCampaigns(db);
    notifyListeners();
  }

  Future<void> loadActiveCampaign() async {
    final db = await databaseHelper.database;
    _currentCampaign = await CampaignDatabaseHelper.queryActiveCampaign(db);

    if (_currentCampaign != null) {
      await loadCampaignData(_currentCampaign!.uuid);
      _updateControllers();
    }
    notifyListeners();
  }

  Future<void> loadCampaignData(String campaignUuid) async {
    final db = await databaseHelper.database;

    _globalAchievements =
        await CampaignDatabaseHelper.queryGlobalAchievements(db, campaignUuid);
    _partyAchievements =
        await CampaignDatabaseHelper.queryPartyAchievements(db, campaignUuid);
    _campaignUnlocks =
        await CampaignDatabaseHelper.queryCampaignUnlocks(db, campaignUuid);
    _cityEvents = await CampaignDatabaseHelper.queryCampaignEvents(
      db,
      campaignUuid,
      type: EventType.city,
    );
    _roadEvents = await CampaignDatabaseHelper.queryCampaignEvents(
      db,
      campaignUuid,
      type: EventType.road,
    );

    notifyListeners();
  }

  // Campaign CRUD operations
  Future<void> createCampaign({
    required String partyName,
    Variant gameVariant = Variant.base,
  }) async {
    final campaign = Campaign(
      uuid: const Uuid().v1(),
      partyName: partyName,
      gameVariant: gameVariant,
    );

    final db = await databaseHelper.database;

    // Deactivate current campaign if exists
    if (_currentCampaign != null) {
      _currentCampaign!.isActive = false;
      await CampaignDatabaseHelper.updateCampaign(db, _currentCampaign!);
    }

    // Insert new campaign
    campaign.id = await CampaignDatabaseHelper.insertCampaign(db, campaign);

    // Initialize unlocks and events
    await CampaignDatabaseHelper.initializeCampaignUnlocks(db, campaign.uuid);
    await CampaignDatabaseHelper.initializeCampaignEvents(db, campaign.uuid);

    _campaigns.add(campaign);
    _currentCampaign = campaign;
    await loadCampaignData(campaign.uuid);
    _updateControllers();

    notifyListeners();
  }

  Future<void> switchCampaign(Campaign campaign) async {
    if (_currentCampaign?.uuid == campaign.uuid) return;

    final db = await databaseHelper.database;

    // Deactivate current campaign
    if (_currentCampaign != null) {
      _currentCampaign!.isActive = false;
      await CampaignDatabaseHelper.updateCampaign(db, _currentCampaign!);
    }

    // Activate selected campaign
    campaign.isActive = true;
    await CampaignDatabaseHelper.updateCampaign(db, campaign);

    _currentCampaign = campaign;
    await loadCampaignData(campaign.uuid);
    _updateControllers();

    notifyListeners();
  }

  Future<void> deleteCampaign(Campaign campaign) async {
    final db = await databaseHelper.database;
    await CampaignDatabaseHelper.deleteCampaign(db, campaign.uuid);

    _campaigns.remove(campaign);

    if (_currentCampaign?.uuid == campaign.uuid) {
      _currentCampaign = null;
      _globalAchievements.clear();
      _partyAchievements.clear();
      _campaignUnlocks.clear();
      _cityEvents.clear();
      _roadEvents.clear();

      // Load first available campaign if any
      if (_campaigns.isNotEmpty) {
        await switchCampaign(_campaigns.first);
      }
    }

    notifyListeners();
  }

  // Update campaign properties
  Future<void> updateCampaign(Campaign updatedCampaign) async {
    final db = await databaseHelper.database;
    await CampaignDatabaseHelper.updateCampaign(db, updatedCampaign);

    if (_currentCampaign?.uuid == updatedCampaign.uuid) {
      _currentCampaign = updatedCampaign;
      await _checkUnlockProgress();
    }

    notifyListeners();
  }

  // Reputation management
  Future<void> adjustReputation(int change) async {
    if (_currentCampaign == null) return;

    int newRep = (_currentCampaign!.reputation + change).clamp(-20, 20);
    _currentCampaign!.reputation = newRep;

    await updateCampaign(_currentCampaign!);
  }

  // Prosperity management
  Future<void> addProsperityCheckmarks(int count) async {
    if (_currentCampaign == null) return;

    _currentCampaign!.prosperityCheckmarks += count;
    int newLevel = _currentCampaign!.prosperityLevel;

    if (newLevel > _currentCampaign!.prosperity) {
      _currentCampaign!.prosperity = newLevel;
      // Prosperity increased!
    }

    await updateCampaign(_currentCampaign!);
  }

  // Sanctuary donations
  Future<void> donatToSanctuary(int amount) async {
    if (_currentCampaign == null) return;

    _currentCampaign!.sanctuaryDonations += amount;
    await updateCampaign(_currentCampaign!);
  }

  // Achievement management
  Future<void> addGlobalAchievement({
    required String name,
    String? type,
    String details = '',
  }) async {
    if (_currentCampaign == null) return;

    final achievement = GlobalAchievement(
      name: name,
      type: type,
      details: details,
      unlockedAt: DateTime.now(),
      associatedCampaignUuid: _currentCampaign!.uuid,
    );

    final db = await databaseHelper.database;
    achievement.id =
        await CampaignDatabaseHelper.insertGlobalAchievement(db, achievement);

    // Reload achievements (in case one was overwritten)
    _globalAchievements = await CampaignDatabaseHelper.queryGlobalAchievements(
      db,
      _currentCampaign!.uuid,
    );

    await _checkUnlockProgress();
    notifyListeners();
  }

  Future<void> removeGlobalAchievement(GlobalAchievement achievement) async {
    if (achievement.id == null) return;

    final db = await databaseHelper.database;
    await CampaignDatabaseHelper.deleteGlobalAchievement(db, achievement.id!);

    _globalAchievements.remove(achievement);
    await _checkUnlockProgress();
    notifyListeners();
  }

  Future<void> addPartyAchievement({
    required String name,
    String details = '',
  }) async {
    if (_currentCampaign == null) return;

    final achievement = PartyAchievement(
      name: name,
      details: details,
      unlockedAt: DateTime.now(),
      associatedCampaignUuid: _currentCampaign!.uuid,
    );

    final db = await databaseHelper.database;
    achievement.id =
        await CampaignDatabaseHelper.insertPartyAchievement(db, achievement);

    _partyAchievements.add(achievement);
    await _checkUnlockProgress();
    notifyListeners();
  }

  Future<void> removePartyAchievement(PartyAchievement achievement) async {
    if (achievement.id == null) return;

    final db = await databaseHelper.database;
    await CampaignDatabaseHelper.deletePartyAchievement(db, achievement.id!);

    _partyAchievements.remove(achievement);
    await _checkUnlockProgress();
    notifyListeners();
  }

  // Event management
  Future<void> completeEvent(CampaignEvent event,
      {bool returnToBottom = false}) async {
    event.status =
        returnToBottom ? EventStatus.bottomOfDeck : EventStatus.completed;

    final db = await databaseHelper.database;
    await CampaignDatabaseHelper.updateCampaignEvent(db, event);

    notifyListeners();
  }

  Future<void> addEvent(int eventNumber, EventType type) async {
    if (_currentCampaign == null) return;

    final event = CampaignEvent(
      eventNumber: eventNumber,
      type: type,
      associatedCampaignUuid: _currentCampaign!.uuid,
    );

    final db = await databaseHelper.database;
    event.id = await CampaignDatabaseHelper.insertCampaignEvent(db, event);

    if (type == EventType.city) {
      _cityEvents.add(event);
    } else {
      _roadEvents.add(event);
    }

    notifyListeners();
  }

  Future<void> removeEvent(CampaignEvent event) async {
    event.status = EventStatus.removed;

    final db = await databaseHelper.database;
    await CampaignDatabaseHelper.updateCampaignEvent(db, event);

    notifyListeners();
  }

  // Check and update unlock progress
  Future<void> _checkUnlockProgress() async {
    if (_currentCampaign == null) return;

    final db = await databaseHelper.database;
    bool hasChanges = false;

    for (final unlock in _campaignUnlocks) {
      int oldProgress = unlock.progress;

      // Update progress based on unlock type
      switch (unlock.type) {
        case UnlockType.envelope:
          if (unlock.name == 'Envelope A') {
            unlock.progress = ancientTechnologyCount;
          } else if (unlock.name == 'Envelope B') {
            unlock.progress = _currentCampaign!.sanctuaryDonations;
          }
          break;

        case UnlockType.characterClass:
          if (unlock.name == 'Sun Class') {
            unlock.progress = _currentCampaign!.reputation;
          } else if (unlock.name == 'Eclipse Class') {
            unlock.progress = _currentCampaign!.reputation;
          }
          break;

        case UnlockType.achievement:
          if (unlock.name == 'The Drake Aided') {
            int count = 0;
            if (_partyAchievements.any((a) => a.name == "The Drake's Command"))
              count++;
            if (_partyAchievements.any((a) => a.name == "The Drake's Treasure"))
              count++;
            unlock.progress = count;
          }
          break;

        case UnlockType.other:
          if (unlock.name.contains('reputation')) {
            unlock.progress = _currentCampaign!.reputation;
          }
          break;

        default:
          break;
      }

      // Check if newly unlocked
      if (oldProgress != unlock.progress) {
        hasChanges = true;

        if (!unlock.isUnlocked && unlock.conditionMet) {
          unlock.isUnlocked = true;
          // Could trigger notification here
        }

        await CampaignDatabaseHelper.updateCampaignUnlock(db, unlock);
      }
    }

    if (hasChanges) {
      notifyListeners();
    }
  }

  // Helper methods
  void _updateControllers() {
    if (_currentCampaign != null) {
      partyNameController.text = _currentCampaign!.partyName;
      sanctuaryDonationController.text =
          _currentCampaign!.sanctuaryDonations.toString();
      notesController.text = _currentCampaign!.notes;
      locationController.text = _currentCampaign!.currentLocation;
    }
  }
}

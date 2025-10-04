import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/data/campaign_database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/data/world_database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/event.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/global_achievement.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/party_achievement.dart';

import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/models/world/world.dart';
import 'package:uuid/uuid.dart';

class CampaignModel with ChangeNotifier {
  CampaignModel({
    required this.databaseHelper,
  });

  DatabaseHelper databaseHelper;

  // World management
  World? _currentWorld;
  List<World> _worlds = [];

  // Campaign/Party management
  Campaign? _currentCampaign;
  List<Campaign> _campaignsInWorld = [];

  // Shared world data
  List<GlobalAchievement> _globalAchievements = [];

  // Campaign-specific data
  List<PartyAchievement> _partyAchievements = [];
  List<CampaignUnlock> _campaignUnlocks = [];
  List<CampaignEvent> _cityEvents = [];
  List<CampaignEvent> _roadEvents = [];

  // Controllers for editing
  final worldNameController = TextEditingController();
  final partyNameController = TextEditingController();
  final sanctuaryDonationController = TextEditingController();
  final notesController = TextEditingController();
  final locationController = TextEditingController();

  // Getters
  World? get currentWorld => _currentWorld;
  List<World> get worlds => _worlds;
  Campaign? get currentCampaign => _currentCampaign;
  List<Campaign> get campaignsInWorld => _campaignsInWorld;
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
    worldNameController.dispose();
    partyNameController.dispose();
    sanctuaryDonationController.dispose();
    notesController.dispose();
    locationController.dispose();
    super.dispose();
  }

  // Initialize and load data
  Future<void> initialize() async {
    await loadWorlds();
    if (_worlds.isNotEmpty) {
      await loadActiveWorld();
    }
  }

  // World operations
  Future<void> loadWorlds() async {
    final db = await databaseHelper.database;
    _worlds = await WorldDatabaseHelper.queryAllWorlds(db);
    notifyListeners();
  }

  Future<void> loadActiveWorld() async {
    final db = await databaseHelper.database;
    _currentWorld = await WorldDatabaseHelper.queryActiveWorld(db);

    if (_currentWorld != null) {
      await loadWorldData(_currentWorld!);
    }
    notifyListeners();
  }

  Future<void> loadWorldData(World world) async {
    final db = await databaseHelper.database;

    // Load campaigns in this world
    _campaignsInWorld =
        await WorldDatabaseHelper.queryCampaignsInWorld(db, world.uuid);

    // Load global achievements for this world
    _globalAchievements =
        await WorldDatabaseHelper.queryGlobalAchievements(db, world.uuid);

    // Try to load active campaign in this world
    _currentCampaign =
        await UpdatedCampaignDatabaseHelper.queryActiveCampaignInWorld(
            db, world.uuid);

    if (_currentCampaign != null) {
      await loadCampaignData(_currentCampaign!);
    }

    notifyListeners();
  }

  Future<void> createWorld({
    required String name,
    Variant gameVariant = Variant.base,
  }) async {
    final world = World(
      uuid: const Uuid().v1(),
      name: name,
      gameVariant: gameVariant,
    );

    final db = await databaseHelper.database;

    // Deactivate current world if exists
    if (_currentWorld != null) {
      _currentWorld!.isActive = false;
      await WorldDatabaseHelper.updateWorld(db, _currentWorld!);
    }

    // Insert new world
    world.id = await WorldDatabaseHelper.insertWorld(db, world);

    _worlds.add(world);
    _currentWorld = world;
    _campaignsInWorld.clear();
    _currentCampaign = null;
    _globalAchievements.clear();

    notifyListeners();
  }

  Future<void> switchWorld(World world) async {
    if (_currentWorld?.uuid == world.uuid) return;

    final db = await databaseHelper.database;

    // Deactivate current world
    if (_currentWorld != null) {
      _currentWorld!.isActive = false;
      await WorldDatabaseHelper.updateWorld(db, _currentWorld!);
    }

    // Activate selected world
    world.isActive = true;
    await WorldDatabaseHelper.updateWorld(db, world);

    _currentWorld = world;
    await loadWorldData(world);

    notifyListeners();
  }

  Future<void> deleteWorld(World world) async {
    final db = await databaseHelper.database;
    await WorldDatabaseHelper.deleteWorld(db, world.uuid);

    _worlds.remove(world);

    if (_currentWorld?.uuid == world.uuid) {
      _currentWorld = null;
      _currentCampaign = null;
      _clearAllData();

      // Load first available world if any
      if (_worlds.isNotEmpty) {
        await switchWorld(_worlds.first);
      }
    }

    notifyListeners();
  }

  // Campaign operations
  Future<void> loadCampaignData(Campaign campaign) async {
    final db = await databaseHelper.database;

    // Party achievements are campaign-specific
    _partyAchievements =
        await CampaignDatabaseHelper.queryPartyAchievements(db, campaign.uuid);
    _campaignUnlocks =
        await CampaignDatabaseHelper.queryCampaignUnlocks(db, campaign.uuid);
    _cityEvents = await CampaignDatabaseHelper.queryCampaignEvents(
      db,
      campaign.uuid,
      type: EventType.city,
    );
    _roadEvents = await CampaignDatabaseHelper.queryCampaignEvents(
      db,
      campaign.uuid,
      type: EventType.road,
    );

    _updateControllers();
    notifyListeners();
  }

  Future<void> createCampaign({
    required String partyName,
    String? worldUuid,
  }) async {
    // Use provided world UUID or current world
    final targetWorldUuid = worldUuid ?? _currentWorld?.uuid;

    if (targetWorldUuid == null) {
      throw Exception('Cannot create party without selecting a world');
    }

    final campaign = Campaign(
      uuid: const Uuid().v1(),
      worldUuid: targetWorldUuid,
      partyName: partyName,
    );

    final db = await databaseHelper.database;

    // Deactivate other campaigns in this world
    if (_currentCampaign != null &&
        _currentCampaign!.worldUuid == targetWorldUuid) {
      _currentCampaign!.isActive = false;
      await CampaignDatabaseHelper.updateCampaign(db, _currentCampaign!);
    }

    // Insert new campaign
    campaign.id =
        await UpdatedCampaignDatabaseHelper.insertCampaign(db, campaign);

    // Initialize unlocks and events for the new campaign
    await CampaignDatabaseHelper.initializeCampaignUnlocks(db, campaign.uuid);
    await CampaignDatabaseHelper.initializeCampaignEvents(db, campaign.uuid);

    _campaignsInWorld.add(campaign);
    _currentCampaign = campaign;
    await loadCampaignData(campaign);

    notifyListeners();
  }

  Future<void> switchCampaign(Campaign campaign) async {
    if (_currentCampaign?.uuid == campaign.uuid) return;

    final db = await databaseHelper.database;

    // Deactivate current campaign in this world
    if (_currentCampaign != null &&
        _currentCampaign!.worldUuid == campaign.worldUuid) {
      _currentCampaign!.isActive = false;
      await CampaignDatabaseHelper.updateCampaign(db, _currentCampaign!);
    }

    // Activate selected campaign
    campaign.isActive = true;
    await CampaignDatabaseHelper.updateCampaign(db, campaign);

    _currentCampaign = campaign;
    await loadCampaignData(campaign);

    notifyListeners();
  }

  Future<void> deleteCampaign(Campaign campaign) async {
    final db = await databaseHelper.database;
    await CampaignDatabaseHelper.deleteCampaign(db, campaign.uuid);

    _campaignsInWorld.remove(campaign);

    if (_currentCampaign?.uuid == campaign.uuid) {
      _currentCampaign = null;
      _partyAchievements.clear();
      _campaignUnlocks.clear();
      _cityEvents.clear();
      _roadEvents.clear();

      // Load first available campaign in world if any
      if (_campaignsInWorld.isNotEmpty) {
        await switchCampaign(_campaignsInWorld.first);
      }
    }

    notifyListeners();
  }

  // Global Achievement management (now world-scoped)
  Future<void> addGlobalAchievement({
    required String name,
    required String associatedCampaignUuid,
    String? type,
    String details = '',
  }) async {
    if (_currentWorld == null) return;

    final achievement = GlobalAchievement(
      worldUuid: _currentWorld!.uuid,
      associatedCampaignUuid: associatedCampaignUuid,
      name: name,
      type: type,
      details: details,
      unlockedAt: DateTime.now(),
    );

    final db = await databaseHelper.database;
    achievement.id =
        await WorldDatabaseHelper.insertGlobalAchievement(db, achievement);

    // Reload achievements (in case one was overwritten)
    _globalAchievements = await WorldDatabaseHelper.queryGlobalAchievements(
      db,
      _currentWorld!.uuid,
    );

    await _checkUnlockProgress();
    notifyListeners();
  }

  // Helper methods
  void _clearAllData() {
    _globalAchievements.clear();
    _partyAchievements.clear();
    _campaignUnlocks.clear();
    _cityEvents.clear();
    _roadEvents.clear();
  }

  void _updateControllers() {
    if (_currentWorld != null) {
      worldNameController.text = _currentWorld!.name;
    }
    if (_currentCampaign != null) {
      partyNameController.text = _currentCampaign!.partyName;
      sanctuaryDonationController.text =
          _currentCampaign!.sanctuaryDonations.toString();
      notesController.text = _currentCampaign!.notes;
      locationController.text = _currentCampaign!.currentLocation;
    }
  }

  Future<void> _checkUnlockProgress() async {
    if (_currentCampaign == null || _currentWorld == null) return;

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
        }

        await CampaignDatabaseHelper.updateCampaignUnlock(db, unlock);
      }
    }

    if (hasChanges) {
      notifyListeners();
    }
  }

  // All other existing methods remain the same but properly check for world/campaign context
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
    }

    await updateCampaign(_currentCampaign!);
  }

  // Sanctuary donations
  Future<void> donatToSanctuary(int amount) async {
    if (_currentCampaign == null) return;

    _currentCampaign!.sanctuaryDonations += amount;
    await updateCampaign(_currentCampaign!);
  }

  // Remove global achievement
  Future<void> removeGlobalAchievement(GlobalAchievement achievement) async {
    if (achievement.id == null) return;

    final db = await databaseHelper.database;
    await CampaignDatabaseHelper.deleteGlobalAchievement(db, achievement.id!);

    _globalAchievements.remove(achievement);
    await _checkUnlockProgress();
    notifyListeners();
  }

  // Party Achievement management
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

  // Helper method to check if a world has any parties
  bool worldHasParties(String worldUuid) {
    return _campaignsInWorld.any((c) => c.worldUuid == worldUuid);
  }

  // Helper method to get active world's variant
  Variant? get currentWorldVariant => _currentWorld?.gameVariant;

  // Helper method to check for specific global achievements
  bool hasGlobalAchievement(String name) {
    return _globalAchievements.any((a) => a.name == name && a.isActive);
  }

  // Helper method to get active City Rule
  String? getActiveCityRule() {
    final cityRule = _globalAchievements.firstWhere(
      (a) => a.type == AchievementTypes.cityRule && a.isActive,
      orElse: () => GlobalAchievement(
          worldUuid: '', associatedCampaignUuid: '', name: ''),
    );
    return cityRule.name.isNotEmpty ? cityRule.name : null;
  }

  // Helper method to count achievements by type
  int countAchievementsByType(String type) {
    return _globalAchievements
        .where((a) => a.type == type && a.isActive)
        .length;
  }
}

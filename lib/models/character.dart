import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';

import '../data/character_data.dart';
import 'player_class.dart';

const String tableCharacters = 'Characters';

const String columnCharacterId = '_id';
const String columnCharacterUuid = 'Uuid';
const String columnCharacterName = 'Name';
const String columnCharacterClassCode = 'ClassCode';
const String columnPreviousRetirements = 'PreviousRetirements';
const String columnCharacterXp = 'XP';
const String columnCharacterGold = 'Gold';
const String columnCharacterNotes = 'Notes';
const String columnCharacterCheckMarks = 'CheckMarks';
const String columnResourceHide = 'ResourceHide';
const String columnResourceMetal = 'ResourceMetal';
const String columnResourceLumber = 'ResourceWood';
const String columnResourceArrowvine = 'ResourceArrowVine';
const String columnResourceAxenut = 'ResourceAxeNut';
const String columnResourceRockroot = 'ResourceRockRoot';
const String columnResourceFlamefruit = 'ResourceFlameFruit';
const String columnResourceCorpsecap = 'ResourceCorpseCap';
const String columnResourceSnowthistle = 'ResourceSnowThistle';
const String columnIsRetired = 'IsRetired';

class Character {
  int id;
  String uuid;
  String name;
  PlayerClass playerClass;
  int previousRetirements;
  int xp;
  int gold;
  String notes;
  int checkMarks;
  // TODO: uncomment this when including Resources
  int resourceHide;
  int resourceMetal;
  int resourceLumber;
  int resourceArrowvine;
  int resourceAxenut;
  int resourceRockroot;
  int resourceFlamefruit;
  int resourceCorpsecap;
  int resourceSnowthistle;
  bool isRetired;
  Character({
    this.id,
    this.uuid,
    this.name,
    this.playerClass,
    this.previousRetirements = 0,
    this.xp = 0,
    this.gold = 0,
    this.notes = 'Items, reminders, wishlist...',
    this.checkMarks = 0,
    // TODO: uncomment this when including Resources
    this.resourceHide = 0,
    this.resourceMetal = 0,
    this.resourceLumber = 0,
    this.resourceArrowvine = 0,
    this.resourceAxenut = 0,
    this.resourceRockroot = 0,
    this.resourceFlamefruit = 0,
    this.resourceCorpsecap = 0,
    this.resourceSnowthistle = 0,
    this.isRetired = false,
  });

  // List<Map<String, Object>> perks = [];
  List<Perk> perks = [];
  List<CharacterPerk> characterPerks = [];
  List<Mastery> masteries = [];
  List<CharacterMastery> characterMasteries = [];

  Character.fromMap(Map<String, dynamic> map) {
    id = map[columnCharacterId];
    uuid = map[columnCharacterUuid] ?? map[columnCharacterId].toString();
    name = map[columnCharacterName];
    playerClass = CharacterData.playerClassByClassCode(
      map[columnCharacterClassCode].toLowerCase(),
    );
    previousRetirements = map[columnPreviousRetirements];
    xp = map[columnCharacterXp];
    gold = map[columnCharacterGold];
    notes = map[columnCharacterNotes];
    checkMarks = map[columnCharacterCheckMarks];
    // TODO: uncomment this when including Resources
    resourceHide = map[columnResourceHide];
    resourceMetal = map[columnResourceMetal];
    resourceLumber = map[columnResourceLumber];
    resourceArrowvine = map[columnResourceArrowvine];
    resourceAxenut = map[columnResourceAxenut];
    resourceRockroot = map[columnResourceRockroot];
    resourceFlamefruit = map[columnResourceFlamefruit];
    resourceCorpsecap = map[columnResourceCorpsecap];
    resourceSnowthistle = map[columnResourceSnowthistle];
    isRetired = map[columnIsRetired] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() => {
        columnCharacterId: id,
        columnCharacterUuid: uuid ?? id,
        columnCharacterName: name,
        columnCharacterClassCode: playerClass.classCode.toLowerCase(),
        columnPreviousRetirements: previousRetirements,
        columnCharacterXp: xp,
        columnCharacterGold: gold,
        columnCharacterNotes: notes,
        columnCharacterCheckMarks: checkMarks,
        // TODO: uncomment this when including Resources
        columnResourceHide: resourceHide,
        columnResourceMetal: resourceMetal,
        columnResourceLumber: resourceLumber,
        columnResourceArrowvine: resourceArrowvine,
        columnResourceAxenut: resourceAxenut,
        columnResourceRockroot: resourceRockroot,
        columnResourceFlamefruit: resourceFlamefruit,
        columnResourceCorpsecap: resourceCorpsecap,
        columnResourceSnowthistle: resourceSnowthistle,
        columnIsRetired: isRetired ? 1 : 0,
      };

  int level() => CharacterData.levelXp.entries
      .lastWhere(
        (entry) => entry.value <= xp,
      )
      .key;

  int nextLevelXp() => CharacterData.levelXp.entries
      .firstWhere(
        (entry) => entry.key > level(),
        orElse: () => CharacterData.levelXp.entries.last,
      )
      .value;

  int maximumPerks() =>
      level() - 1 + ((checkMarks - 1) / 3).round() + previousRetirements;

  int checkMarkProgress() => checkMarks != 0
      ? checkMarks % 3 == 0
          ? 3
          : checkMarks % 3
      : 0;

  int numOfSelectedPerks() {
    int sum = 0;
    for (CharacterPerk perk in characterPerks) {
      if (perk.characterPerkIsSelected) {
        sum++;
      }
    }
    return sum;
  }
}

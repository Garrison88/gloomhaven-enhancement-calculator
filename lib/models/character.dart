import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

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
// const String columnResourceMetal = 'ResourceMetal';
// const String columnResourceWood = 'ResourceWood';
// const String columnResourceHide = 'ResourceHide';
// const String columnResourceArrowVine = 'ResourceArrowVine';
// const String columnResourceAxeNut = 'ResourceAxeNut';
// const String columnResourceRockRoot = 'ResourceRockRoot';
// const String columnResourceFlameFruit = 'ResourceFlameFruit';
// const String columnResourceCorpseCap = 'ResourceCorpseCap';
// const String columnResourceSnowThistle = 'ResourceSnowThistle';
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
  // int resourceHide;
  // int resourceMetal;
  // int resourceWood;
  // int resourceArrowVine;
  // int resourceAxeNut;
  // int resourceRockRoot;
  // int resourceFlameFruit;
  // int resourceCorpseCap;
  // int resourceSnowThistle;
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
    // this.resourceHide = 0,
    // this.resourceMetal = 0,
    // this.resourceWood = 0,
    // this.resourceArrowVine = 0,
    // this.resourceAxeNut = 0,
    // this.resourceRockRoot = 0,
    // this.resourceFlameFruit = 0,
    // this.resourceCorpseCap = 0,
    // this.resourceSnowThistle = 0,
    this.isRetired = false,
  });

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
    // resourceMetal = map[columnResourceMetal];
    // resourceHide = map[columnResourceHide];
    // resourceWood = map[columnResourceWood];
    // resourceArrowVine = map[columnResourceArrowVine];
    // resourceAxeNut = map[columnResourceAxeNut];
    // resourceRockRoot = map[columnResourceRockRoot];
    // resourceFlameFruit = map[columnResourceFlameFruit];
    // resourceCorpseCap = map[columnResourceCorpseCap];
    // resourceSnowThistle = map[columnResourceSnowThistle];
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
        // columnResourceHide: resourceHide,
        // columnResourceMetal: resourceMetal,
        // columnResourceWood: resourceWood,
        // columnResourceArrowVine: resourceArrowVine,
        // columnResourceAxeNut: resourceAxeNut,
        // columnResourceRockRoot: resourceRockRoot,
        // columnResourceFlameFruit: resourceFlameFruit,
        // columnResourceCorpseCap: resourceCorpseCap,
        // columnResourceSnowThistle: resourceSnowThistle,
        columnIsRetired: isRetired ? 1 : 0,
      };
}

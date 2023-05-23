import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';

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

  List<Perk> perks = [];
  List<CharacterPerk> characterPerks = [];
  List<Mastery> masteries = [];
  List<CharacterMastery> characterMasteries = [];
  List<PerkRow> perkRows = [];
  List<Perk> perkRowPerks = [];
  bool includeMasteries = true;

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
    resourceHide = map[columnResourceHide] ?? 0;
    resourceMetal = map[columnResourceMetal] ?? 0;
    resourceLumber = map[columnResourceLumber] ?? 0;
    resourceArrowvine = map[columnResourceArrowvine] ?? 0;
    resourceAxenut = map[columnResourceAxenut] ?? 0;
    resourceRockroot = map[columnResourceRockroot] ?? 0;
    resourceFlamefruit = map[columnResourceFlamefruit] ?? 0;
    resourceCorpsecap = map[columnResourceCorpsecap] ?? 0;
    resourceSnowthistle = map[columnResourceSnowthistle] ?? 0;
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

  Color primaryClassColor(
    Brightness brightness,
  ) =>
      isRetired
          ? brightness == Brightness.dark
              ? Colors.white
              : Colors.black
          : Color(
              playerClass.primaryColor,
            );

  Color secondaryClassColor(
    Brightness brightness,
  ) =>
      Color(
        playerClass.secondaryColor ?? playerClass.primaryColor,
      );

  static int level(int xp) => CharacterData.levelByXp(xp);

  static int xpForNextLevel(int level) => CharacterData.nextXpByLevel(level);

  static int maximumPerks(Character character) {
    int sum = 0;
    sum += level(character.xp) - 1;
    sum += ((character.checkMarks - 1) / 3).round();
    sum += character.previousRetirements;
    sum += character.characterMasteries.fold(
      0,
      (previousValue, mastery) =>
          previousValue + (mastery.characterMasteryAchieved ? 1 : 0),
    );
    return sum;
  }

  int checkMarkProgress() => checkMarks != 0
      ? checkMarks % 3 == 0
          ? 3
          : checkMarks % 3
      : 0;

  int numOfSelectedPerks() => characterPerks.fold(
        0,
        (previousValue, perk) =>
            previousValue + (perk.characterPerkIsSelected ? 1 : 0),
      );
}

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';

class CharacterModel with ChangeNotifier {
  bool _isEditable = false;
  Character character;
  List<CharacterPerk> characterPerks = [];
  int numOfSelectedPerks = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController xpController = TextEditingController();
  TextEditingController goldController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  CharacterModel({
    this.character,
  });
  DatabaseHelper db = DatabaseHelper.instance;
  // PlayerClass playerClass;

  // PlayerClass get playerClass => playerClass;

  // Future<bool> setPlayerClass() {
  //   return db
  //       .queryPlayerClass(character.classCode)
  //       .then((_class) => playerClass = _class)
  //       .then((_) => true);
  //   // return true;
  // }

  // Future<bool> setCharacter() async {
  //   character = await db.queryCharacter(_characterId);
  //   // _playerClass = await db.queryPlayerClass(character.classCode);
  //   return true;
  // }

  int getMaximumPerks() =>
      currentLevel -
      1 +
      ((character.checkMarks - 1) / 3).round() +
      character.previousRetirements;

  bool get isEditable {
    // print('get isEditable');
    return _isEditable;
  }

  set isEditable(bool value) {
    // print('edit changed');
    _isEditable = value;
    notifyListeners();
  }

  int get numOfPocketItems => (currentLevel / 2).round();

  int get currentLevel => character.xp < levelXpList.last
      ? levelXpList.indexWhere((_xp) => _xp > character.xp) + 1
      : 9;

  int get nextLevelXp => character.xp < levelXpList.last
      ? levelXpList.firstWhere((_threshold) => _threshold > character.xp)
      : levelXpList.last;

  Future<void> updateCharacter(Character _updatedCharacter) async {
    character = _updatedCharacter;
    await db.updateCharacter(_updatedCharacter);
    notifyListeners();
  }

  int get checkMarkProgress => character.checkMarks != 0
      ? character.checkMarks % 3 == 0
          ? 3
          : character.checkMarks % 3
      : 0;

  increaseCheckmark() {
    if (character.checkMarks < 18) {
      updateCharacter(character..checkMarks = character.checkMarks + 1);
      notifyListeners();
    }
  }

  decreaseCheckmark() {
    if (character.checkMarks > 0) {
      updateCharacter(character..checkMarks = character.checkMarks - 1);
      notifyListeners();
    }
  }

  Future<List<CharacterPerk>> loadCharacterPerks(int id) async {
    print('LOAD CHARACTER PERKS');
    List<CharacterPerk> perks = [];
    numOfSelectedPerks = 0;
    perks = await DatabaseHelper.instance.queryCharacterPerks(id);
    for (CharacterPerk perk in perks) {
      if (perk.characterPerkIsSelected) {
        numOfSelectedPerks++;
      }
    }
    characterPerks = perks;
    notifyListeners();
    return perks;
  }

  Future<bool> togglePerk(
    CharacterPerk perk,
    bool value,
  ) async {
    characterPerks.forEach((element) {
      if (element.associatedPerkId == perk.associatedPerkId) {
        element.characterPerkIsSelected = value;
      }
    });
    await db.updateCharacterPerk(perk, value);
    notifyListeners();
    return value;
  }

  Future<String> getPerkDetails(int perkId) async {
    Perk perk = await db.queryPerk(perkId);
    return perk.perkDetails;
  }
}

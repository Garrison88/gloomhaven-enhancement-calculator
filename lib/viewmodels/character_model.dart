import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';

class CharacterModel with ChangeNotifier {
  bool _isEditable = false;
  Character character;
  List<CharacterPerk> _characterPerks = [];
  int numOfSelectedPerks = 0;
  CharacterModel({this.character});
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

  bool get isEditable => _isEditable;

  set isEditable(bool _value) {
    _isEditable = _value;
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
      ? character.checkMarks % 3 == 0 ? 3 : character.checkMarks % 3
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

  Future<bool> setCharacterPerks() async {
    _characterPerks = await db.queryCharacterPerks(character.id);
    numOfSelectedPerks = 0;
    _characterPerks.forEach((_perk) {
      if (_perk.characterPerkIsSelected) {
        numOfSelectedPerks++;
      }
    });
    return true;
  }

  List<CharacterPerk> get characterPerks => _characterPerks;

  Future<void> togglePerk(_perk, _value) async {
    await db.updateCharacterPerk(_perk, _value);
    notifyListeners();
  }

  Future<String> getPerkDetails(int _perkId) async {
    Perk _perk = await db.queryPerk(_perkId);
    return _perk.perkDetails;
  }
}

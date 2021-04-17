import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';

class CharacterModel with ChangeNotifier {
  bool _isEditable = false;
  Character character;
  List<CharacterPerk> characterPerks = [];
  int numOfSelectedPerks = 0;
  TextEditingController previousRetirementsController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController xpController = TextEditingController();
  TextEditingController goldController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  // CharacterModel({
  //   this.character,
  // });
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
  //
  // int get numOfSelectedPerks => _numOfSelectedPerks;

  // set numOfSelectedPerks(int num) {
  //   _numOfSelectedPerks = num;
  // }

  // setNumOfSelectedPerks() {
  //   int tempNum = 0;
  //   characterPerks.forEach((element) {
  //     if (element.characterPerkIsSelected) {
  //       tempNum++;
  //     } else {
  //       tempNum--;
  //     }
  //   });
  //   // notifyListeners();
  // }
  //
  //

// int get numOfSelected

  // Character get character => _character;

  // set character(Character character) {
  //   _character = character;
  //   // loadCharacterPerks();
  //   // notifyListeners();
  // }

  int get maximumPerks {
    return currentLevel -
        1 +
        ((character.checkMarks - 1) / 3).round() +
        character.previousRetirements;
  }

  bool get isEditable {
    return _isEditable;
  }

  set isEditable(bool value) {
    _isEditable = value;
    notifyListeners();
  }

  int get numOfPocketItems => (currentLevel / 2).round();

  int get currentLevel => character.xp < CharacterData.levelXp.last
      ? CharacterData.levelXp.indexWhere((_xp) => _xp > character.xp) + 1
      : 9;

  int get nextLevelXp => character.xp < CharacterData.levelXp.last
      ? CharacterData.levelXp
          .firstWhere((threshold) => threshold > character.xp)
      : CharacterData.levelXp.last;

  Future<void> updateCharacter(Character updatedCharacter) async {
    character = updatedCharacter;
    await db.updateCharacter(updatedCharacter);
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
    characterPerks =
        await DatabaseHelper.instance.queryCharacterPerks(character.id);
    notifyListeners();
    return characterPerks;
  }

  Future<bool> togglePerk(
    CharacterPerk perk,
    bool value,
  ) async {
    value ? numOfSelectedPerks++ : numOfSelectedPerks--;
    for (CharacterPerk characterPerk in characterPerks) {
      if (characterPerk.associatedPerkId == perk.associatedPerkId) {
        characterPerk.characterPerkIsSelected = value;
      }
    }
    await db.updateCharacterPerk(perk, value);
    notifyListeners();
    return value;
  }

  Future<Perk> loadPerk(int perkId) async {
    Perk perk = await db.queryPerk(perkId);
    return perk;
  }
}

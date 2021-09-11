import 'package:flutter/material.dart';
import '../data/character_data.dart';
import '../data/database_helpers.dart';
import '../models/character.dart';
import '../models/character_perk.dart';
import '../shared_prefs.dart';

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
  DatabaseHelper db = DatabaseHelper.instance;

  int get maximumPerks =>
      currentLevel -
      1 +
      ((character.checkMarks - 1) / 3).round() +
      character.previousRetirements;

  bool get isEditable => _isEditable;

  set isEditable(bool value) {
    previousRetirementsController.text = character.previousRetirements != 0
        ? character.previousRetirements.toString()
        : '';
    nameController.text = character.name;
    xpController.text = character.xp != 0 ? character.xp.toString() : '';
    goldController.text = character.gold != 0 ? character.gold.toString() : '';
    notesController.text = character.notes;
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

  Color get numOfSelectedPerksColor {
    return maximumPerks >= numOfSelectedPerks
        ? SharedPrefs().darkTheme
            ? Colors.white
            : Colors.black87
        : Colors.red;
  }

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

  Future<List<CharacterPerk>> loadCharacterPerks(String id) async {
    characterPerks =
        await DatabaseHelper.instance.queryCharacterPerks(character.uuid);
    return characterPerks;
  }

  Future<void> togglePerk(
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

  Future<List> loadPerks(String characterCode) async =>
      await db.queryPerks(characterCode);
}

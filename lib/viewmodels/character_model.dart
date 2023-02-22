// import 'package:flutter/material.dart';
// import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
// import '../data/character_data.dart';
// import '../data/database_helpers.dart';
// import '../models/character.dart';
// import '../models/character_perk.dart';
// import '../shared_prefs.dart';

// class CharacterModel with ChangeNotifier {
//   CharacterModel({
//     @required this.character,
//   });
//   bool _isEditable = false;
//   Character character;
//   List<CharacterPerk> characterPerks = [];
//   List<CharacterMastery> characterMasteries = [];
//   int numOfSelectedPerks = 0;
//   TextEditingController previousRetirementsController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController xpController = TextEditingController();
//   TextEditingController goldController = TextEditingController();
//   TextEditingController notesController = TextEditingController();
//   // ScrollController scrollController = ScrollController();
//   // int _nextLevelXp = 499;

//   // int get nextLevelXp => _nextLevelXp;

//   // set nextLevelXp(int value) {
//   //   _nextLevelXp = CharacterData.levelXp[currentLevel];
//   //   //  < CharacterData.levelXp.last
//   //   //     ? CharacterData.levelXp.firstWhere((threshold) => threshold > value)
//   //   //     : CharacterData.levelXp.last;
//   //   notifyListeners();
//   // }

//   DatabaseHelper db = DatabaseHelper.instance;

//   int get maximumPerks =>
//       currentLevel -
//       1 +
//       ((character.checkMarks - 1) / 3).round() +
//       character.previousRetirements;

//   bool get isEditable => _isEditable && !character.isRetired;

//   set isEditable(bool value) {
//     previousRetirementsController
//       ..text = character.previousRetirements != 0
//           ? character.previousRetirements.toString()
//           : ''
//       ..selection = TextSelection.fromPosition(
//         TextPosition(
//           offset: previousRetirementsController.text.length,
//         ),
//       );
//     nameController.text = character.name;
//     xpController
//       ..text = character.xp != 0 ? character.xp.toString() : ''
//       ..selection = TextSelection.fromPosition(
//         TextPosition(
//           offset: xpController.text.length,
//         ),
//       );

//     goldController
//       ..text = character.gold != 0 ? character.gold.toString() : ''
//       ..selection = TextSelection.fromPosition(
//         TextPosition(
//           offset: goldController.text.length,
//         ),
//       );
//     notesController.text = character.notes;
//     _isEditable = value;
//     // notifyListeners();
//   }

//   int get numOfPocketItems => (currentLevel / 2).round();

//   // int get currentLevel =>
//   //     CharacterData.levelXp.keys.firstWhere((element) => element > nextLevelXp);

//   int get currentLevel {
//     return CharacterData.levelXp.entries
//         .where((entry) => entry.value <= character.xp)
//         .last
//         .key;
//   }

//   int get nextLevelXp {
//     return CharacterData.levelXp.entries
//         .firstWhere((element) => element.key > currentLevel,
//             orElse: () => CharacterData.levelXp.entries.last)
//         .value;
//   }

//   Future<void> updateCharacter(Character updatedCharacter) async {
//     character = updatedCharacter;
//     await db.updateCharacter(updatedCharacter);
//     // nextLevelXp = updatedCharacter.xp;
//     notifyListeners();
//   }

//   int get checkMarkProgress => character.checkMarks != 0
//       ? character.checkMarks % 3 == 0
//           ? 3
//           : character.checkMarks % 3
//       : 0;

//   Color get numOfSelectedPerksColor {
//     return maximumPerks >= numOfSelectedPerks
//         ? SharedPrefs().darkTheme
//             ? Colors.white
//             : Colors.black87
//         : Colors.red;
//   }

//   increaseCheckmark() {
//     if (character.checkMarks < 18) {
//       updateCharacter(character..checkMarks = character.checkMarks + 1);
//       notifyListeners();
//     }
//   }

//   decreaseCheckmark() {
//     if (character.checkMarks > 0) {
//       updateCharacter(character..checkMarks = character.checkMarks - 1);
//       notifyListeners();
//     }
//   }

//   Future<List<CharacterPerk>> loadCharacterPerks() async {
//     characterPerks =
//         await DatabaseHelper.instance.queryCharacterPerks(character.uuid);
//     return characterPerks;
//   }

//   Future<List<CharacterMastery>> loadCharacterMasteries() async {
//     characterMasteries =
//         await DatabaseHelper.instance.queryCharacterMasteries(character.uuid);
//     return characterMasteries;
//   }

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import '../data/character_data.dart';
import '../data/database_helpers.dart';
import '../models/character.dart';
import '../models/character_perk.dart';

class CharacterModel with ChangeNotifier {
  final DatabaseHelper db;
  Character character;

  CharacterModel({
    @required this.db,
    @required this.character,
  });

  bool _isEditable = false;
  int numOfSelectedPerks = 0;
  List<CharacterPerk> characterPerks = [];
  List<CharacterMastery> characterMasteries = [];

  final previousRetirementsController = TextEditingController();
  final nameController = TextEditingController();
  final xpController = TextEditingController();
  final goldController = TextEditingController();
  final notesController = TextEditingController();

  bool get isEditable => _isEditable && !character.isRetired;

  set isEditable(bool value) {
    final previousRetirementsText = character.previousRetirements != 0
        ? character.previousRetirements.toString()
        : '';

    final xpText = character.xp != 0 ? character.xp.toString() : '';

    final goldText = character.gold != 0 ? character.gold.toString() : '';

    previousRetirementsController
      ..text = previousRetirementsText
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: previousRetirementsText.length),
      );
    nameController.text = character.name;
    xpController
      ..text = xpText
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: xpText.length),
      );
    goldController
      ..text = goldText
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: goldText.length),
      );
    notesController.text = character.notes;
    _isEditable = value;
  }

  // int get maximumPerks =>
  //     currentLevel -
  //     1 +
  //     ((character.checkMarks - 1) ~/ 3) +
  //     character.previousRetirements;

  int get maximumPerks =>
      currentLevel -
      1 +
      ((character.checkMarks - 1) / 3).round() +
      character.previousRetirements;

  // int get numOfPocketItems => (currentLevel ~/ 2);

  int get numOfPocketItems => (currentLevel / 2).round();

  int get currentLevel => CharacterData.levelXp.entries
      .lastWhere((entry) => entry.value <= character.xp)
      .key;

  int get nextLevelXp => CharacterData.levelXp.entries
      .firstWhere((entry) => entry.key > currentLevel,
          orElse: () => CharacterData.levelXp.entries.last)
      .value;

  // int get checkMarkProgress => character.checkMarks % 3;

  int get checkMarkProgress => character.checkMarks != 0
      ? character.checkMarks % 3 == 0
          ? 3
          : character.checkMarks % 3
      : 0;

  Color get numOfSelectedPerksColor =>
      maximumPerks >= numOfSelectedPerks ? Colors.black87 : Colors.red;

  Future<void> updateCharacter(Character updatedCharacter) async {
    print('UPDATE CHARACTER CALLED');
    character = updatedCharacter;
    await db.updateCharacter(updatedCharacter);
    notifyListeners();
  }

  void increaseCheckmark() {
    if (character.checkMarks < 18) {
      updateCharacter(
        character..checkMarks = character.checkMarks + 1,
      );
    }
  }

  void decreaseCheckmark() {
    if (character.checkMarks > 0) {
      updateCharacter(
        character..checkMarks = character.checkMarks - 1,
      );
    }
  }

  Future<List<CharacterPerk>> loadCharacterPerks() async {
    characterPerks = await db.queryCharacterPerks(character.uuid);
    return characterPerks;
  }

  Future<List<CharacterMastery>> loadCharacterMasteries() async {
    characterMasteries = await db.queryCharacterMasteries(character.uuid);
    return characterMasteries;
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

  Future<void> toggleMastery(
    CharacterMastery mastery,
    bool value,
  ) async {
    for (CharacterMastery characterMastery in characterMasteries) {
      if (characterMastery.associatedMasteryId == mastery.associatedMasteryId) {
        characterMastery.characterMasteryAchieved = value;
      }
    }
    await db.updateCharacterMastery(mastery, value);
    notifyListeners();
    return value;
  }

  Future<List> loadPerks() async => await db.queryPerks(
        character.playerClass.classCode.toLowerCase(),
      );

  Future<List> loadMasteries() async => await db.queryMasteries(
        character.playerClass.classCode.toLowerCase(),
      );
}

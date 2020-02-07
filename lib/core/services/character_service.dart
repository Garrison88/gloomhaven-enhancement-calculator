// import 'package:gloomhaven_enhancement_calc/core/models/character.dart';
// import 'package:gloomhaven_enhancement_calc/core/services/database_helper.dart';
// import 'package:gloomhaven_enhancement_calc/locator.dart';

// class CharacterService {

// DatabaseHelper _databaseHelper = locator<DatabaseHelper>();

//   bool _isEditable = false;
//   Character character;
//   List<CharacterPerk> _characterPerks = [];
//   int numOfSelectedPerks = 0;
//   CharacterModel({this.character});
//   DatabaseHelper _databaseHelper = locator<DatabaseHelper>();
//   // PlayerClass playerClass;

//   // PlayerClass get playerClass => playerClass;

//   // Future<bool> setPlayerClass() {
//   //   return _databaseHelper
//   //       .queryPlayerClass(character.classCode)
//   //       .then((_class) => playerClass = _class)
//   //       .then((_) => true);
//   //   // return true;
//   // }

//   // Future<bool> setCharacter() async {
//   //   character = await _databaseHelper.queryCharacter(_characterId);
//   //   // _playerClass = await _databaseHelper.queryPlayerClass(character.classCode);
//   //   return true;
//   // }

//   int getMaximumPerks() =>
//       currentLevel -
//       1 +
//       ((character.checkMarks - 1) / 3).round() +
//       character.previousRetirements;

//   bool get isEditable => _isEditable;

//   set isEditable(bool _value) {
//     _isEditable = _value;
//     notifyListeners();
//   }

//   int get numOfPocketItems => (currentLevel / 2).round();

//   int get currentLevel => character.xp < levelXpList.last
//       ? levelXpList.indexWhere((_xp) => _xp > character.xp) + 1
//       : 9;

//   int get nextLevelXp => character.xp < levelXpList.last
//       ? levelXpList.firstWhere((_threshold) => _threshold > character.xp)
//       : levelXpList.last;

//   Future updateCharacter(Character _updatedCharacter) async {
//     character = _updatedCharacter;
//     await _databaseHelper.updateCharacter(_updatedCharacter);
//     notifyListeners();
//   }

//   int get checkMarkProgress => character.checkMarks != 0
//       ? character.checkMarks % 3 == 0 ? 3 : character.checkMarks % 3
//       : 0;

//   increaseCheckmark() {
//     if (character.checkMarks < 18) {
//       // character.checkMarks++;
//       updateCharacter(character..checkMarks = character.checkMarks + 1);
//       notifyListeners();
//     }
//   }

//   decreaseCheckmark() {
//     if (character.checkMarks > 0) {
//       // character.checkMarks++;
//       updateCharacter(character..checkMarks = character.checkMarks - 1);
//       notifyListeners();
//     }
//   }

//   Future<bool> setCharacterPerks() async {
//     setState(ViewState.Busy);
//     _characterPerks = await _databaseHelper.queryCharacterPerks(character.id);
//     numOfSelectedPerks = 0;
//     _characterPerks.forEach((_perk) {
//       if (_perk.characterPerkIsSelected) {
//         numOfSelectedPerks++;
//       }
//     });
//     setState(ViewState.Idle);
//     return true;
//   }

//   List<CharacterPerk> get characterPerks => _characterPerks;

//   Future togglePerk(_perk, _value) async {
//     await _databaseHelper.updateCharacterPerk(_perk, _value);
//     notifyListeners();
//   }

//   Future<String> getPerkDetails(int _perkId) async {
//     Perk _perk = await _databaseHelper.queryPerk(_perkId);
//     return _perk.perkDetails;
//   }

// }
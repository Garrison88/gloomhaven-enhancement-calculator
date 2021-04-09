import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class CharactersModel with ChangeNotifier {
  List<Character> _characters = [];
  // List<bool> _legacyPerks = [];
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  List<Character> get characters => _characters;

  Future<List<Character>> loadCharacters() async {
    print('LOAD CHARACTERS IN CHARACTERS MODEL');
    _characters = await databaseHelper.queryAllCharacters();
    return _characters;
  }

  Future<void> createCharacter(
    String name,
    PlayerClass playerClass,
    int initialLevel,
    int previousRetirements,
  ) async {
    Character character = Character();
    List<bool> perks = [];
    perkList.forEach((perk) {
      for (var x = 0; x < perk.numOfPerks; x++) {
        perks.add(false);
      }
    });
    character
      ..name = name
      ..classCode = playerClass.classCode
      ..classColor = playerClass.classColor
      ..classIcon = playerClass.classIconUrl
      ..classRace = playerClass.race
      ..className = playerClass.className
      ..previousRetirements = previousRetirements
      ..xp = initialLevel > 1 ? levelXpList[initialLevel - 2] : 0
      ..gold = 0
      ..notes = 'Add notes here'
      ..checkMarks = 0
      ..isRetired = false
      ..id = await databaseHelper.insertCharacter(character, perks);
    // print('inserted row: $id');
    print(character.name);
    print(character.classCode);
    characters.add(character);
    notifyListeners();
    // return character;
  }

  Future<void> deleteCharacter(int characterId) async {
    print('DELETE IN MODEL');
    await databaseHelper.deleteCharacter(characterId);
    characters.removeWhere((element) => element.id == characterId);
    notifyListeners();
  }

  // Future<Character> compileLegacyCharacterDetails() async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   Character _character = Character();
  //   int _checkMarks = 0;
  //   PlayerClass _playerClass =
  //       _prefs.getInt('selectedClass') != null && playerClassList != null
  //           ? playerClassList[_prefs.getInt('selectedClass')]
  //           : playerClassList[0];
  //   _character
  //     ..name = _prefs.getString('characterName') ?? '[UNKNOWN]'
  //     ..classCode = _playerClass.classCode
  //     ..classColor = _playerClass.classColor
  //     ..classIcon = _playerClass.classIconUrl
  //     ..classRace = _playerClass.race
  //     ..className = _playerClass.className
  //     ..xp = int.parse(_prefs.getString('characterXP') ?? 0)
  //     ..gold = int.parse(_prefs.getString('characterGold') ?? 0)
  //     ..notes = _prefs.getString('notes') ?? 'Add notes here'
  //     ..isRetired = false
  //     ..previousRetirements =
  //         int.parse(_prefs.getString('previousRetirements'));
  //   if (_prefs.getBool('firstCheck')) _checkMarks++;
  //   if (_prefs.getBool('secondCheck')) _checkMarks++;
  //   if (_prefs.getBool('thirdCheck')) _checkMarks++;
  //   if (_prefs.getBool('2FirstCheck')) _checkMarks++;
  //   if (_prefs.getBool('2SecondCheck')) _checkMarks++;
  //   if (_prefs.getBool('2ThirdCheck')) _checkMarks++;
  //   if (_prefs.getBool('3FirstCheck')) _checkMarks++;
  //   if (_prefs.getBool('3SecondCheck')) _checkMarks++;
  //   if (_prefs.getBool('3ThirdCheck')) _checkMarks++;
  //   if (_prefs.getBool('4FirstCheck')) _checkMarks++;
  //   if (_prefs.getBool('4SecondCheck')) _checkMarks++;
  //   if (_prefs.getBool('4ThirdCheck')) _checkMarks++;
  //   if (_prefs.getBool('5FirstCheck')) _checkMarks++;
  //   if (_prefs.getBool('5SecondCheck')) _checkMarks++;
  //   if (_prefs.getBool('5ThirdCheck')) _checkMarks++;
  //   if (_prefs.getBool('6FirstCheck')) _checkMarks++;
  //   if (_prefs.getBool('6SecondCheck')) _checkMarks++;
  //   if (_prefs.getBool('6ThirdCheck')) _checkMarks++;
  //   _character.checkMarks = _checkMarks;
  //   _playerClass.perks.forEach((perk) {
  //     for (var i = 0; i < perk.numOfChecks; i++) {
  //       _legacyPerks.add(_prefs.getBool(
  //               '${_playerClass.classCode}${perk.details}${i.toString()}') ??
  //           false);
  //     }
  //   });
  //   return _character;
  // }

  // Future addLegacyCharacter() async {
  //   await compileLegacyCharacterDetails().then((_character) => databaseHelper
  //       .insertCharacter(_character, _legacyPerks)
  //       .then((_id) => _character.id = _id)
  //       .then((_) => notifyListeners()));
  // }
}

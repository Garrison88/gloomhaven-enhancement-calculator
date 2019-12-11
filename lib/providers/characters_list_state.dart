import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class CharactersListState with ChangeNotifier {
  List<Character> _charactersList = [];
  List<bool> _legacyPerks = [];
  // CharactersListState(this._charactersList);
  DatabaseHelper db = DatabaseHelper.instance;

  List<Character> getCharactersList() => _charactersList;

  Future<bool> setCharactersList() async {
    await db.queryAllCharacterRows().then((_list) {
      _charactersList = _list;
    });
    notifyListeners();
    return true;
  }

  void addCharacter(String _name, PlayerClass _playerClass) async {
    Character character = Character();
    character.name = _name;
    character.playerClass = _playerClass;
    character.classCode = _playerClass.classCode;
    character.classColor = _playerClass.classColor;
    character.classIcon = _playerClass.classIconUrl;
    character.xp = 0;
    character.gold = 0;
    character.notes = 'Add notes here';
    character.checkMarks = 0;
    character.isRetired = false;
    int id = await db.insertCharacter(character);
    character.id = id;
    print('inserted row: $id');
    print(character.name);
    print(character.classCode);
    _charactersList.add(character);
    notifyListeners();
  }

  // void deleteCharacter(Character _character) async {
  //   await db.deleteCharacter(_character);
  //   // charactersList.indexOf(_character);
  //   notifyListeners();
  // }

  Future<Character> compileLegacyCharacterDetails() async {
    Character _legacyCharacter = Character();
    _legacyPerks.clear();
    int _checkMarks = 0;
    PlayerClass _playerClass =
        sp.getInt('selectedClass') != null && classList != null
            ? classList[sp.getInt('selectedClass')]
            : classList[0];
    _legacyCharacter.name = sp.getString('characterName') ?? '[UNKNOWN]';
    _legacyCharacter.playerClass = _playerClass;
    _legacyCharacter.classCode = _playerClass.classCode;
    _legacyCharacter.classColor = _playerClass.classColor;
    _legacyCharacter.classIcon = _playerClass.classIconUrl;
    _legacyCharacter.xp = int.parse(sp.getString('characterXP') ?? '0');
    _legacyCharacter.gold = int.parse(sp.getString('characterGold') ?? '0');
    _legacyCharacter.notes = sp.getString('notes') ?? 'Add notes here';
    if (sp.getBool('firstCheck')) _checkMarks++;
    if (sp.getBool('secondCheck')) _checkMarks++;
    if (sp.getBool('thirdCheck')) _checkMarks++;
    if (sp.getBool('2FirstCheck')) _checkMarks++;
    if (sp.getBool('2SecondCheck')) _checkMarks++;
    if (sp.getBool('2ThirdCheck')) _checkMarks++;
    if (sp.getBool('3FirstCheck')) _checkMarks++;
    if (sp.getBool('3SecondCheck')) _checkMarks++;
    if (sp.getBool('3ThirdCheck')) _checkMarks++;
    if (sp.getBool('4FirstCheck')) _checkMarks++;
    if (sp.getBool('4SecondCheck')) _checkMarks++;
    if (sp.getBool('4ThirdCheck')) _checkMarks++;
    if (sp.getBool('5FirstCheck')) _checkMarks++;
    if (sp.getBool('5SecondCheck')) _checkMarks++;
    if (sp.getBool('5ThirdCheck')) _checkMarks++;
    if (sp.getBool('6FirstCheck')) _checkMarks++;
    if (sp.getBool('6SecondCheck')) _checkMarks++;
    if (sp.getBool('6ThirdCheck')) _checkMarks++;
    _legacyCharacter.checkMarks = _checkMarks;
    _legacyCharacter.isRetired = false;
    _playerClass.perks.forEach((perk) {
      for (var i = 0; i < perk.numOfChecks; i++) {
        _legacyPerks.add(sp.getBool(
                '${_playerClass.classCode}${perk.details}${i.toString()}') ??
            false);
      }
    });
    // print(_legacyPerks.toString());
    return _legacyCharacter;
  }

  Future<void> addLegacyCharacter() async {
    await compileLegacyCharacterDetails().then((_legacyCharacter) =>
        db.insertLegacyCharacter(_legacyCharacter, _legacyPerks).then((_id) {
          _legacyCharacter.id = _id;
          _charactersList.add(_legacyCharacter);
          // notifyListeners();
        }).then((_) => notifyListeners()));
  }
}

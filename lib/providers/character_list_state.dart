import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterListState with ChangeNotifier {
  List<Character> _characterList = [];
  List<bool> _legacyPerks = [];
  DatabaseHelper db = DatabaseHelper.instance;

  List<Character> get characterList => _characterList;

  Future<bool> setCharacterList() async {
    _characterList = await db.queryAllCharacters();
    // notifyListeners();
    // _list.forEach((_result) => _result.))
    // await db.queryPlayerClass(_classCode)
    return true;
  }

  Future addCharacter(
      String _name, PlayerClass _playerClass, int _initialLevel) async {
    Character _character = Character();
    List<bool> _perks = [];
    perkList.forEach((_perk) {
      for (var x = 0; x < _perk.numOfPerks; x++) {
        _perks.add(false);
      }
    });
    _character.name = _name;
    _character.classCode = _playerClass.classCode;
    _character.classColor = _playerClass.classColor;
    _character.classIcon = _playerClass.classIconUrl;
    _character.classRace = _playerClass.race;
    _character.className = _playerClass.className;
    _character.xp = _initialLevel > 1 ? levelXpList[_initialLevel - 2] : 0;
    _character.gold = 0;
    _character.notes = 'Add notes here';
    _character.checkMarks = 0;
    _character.isRetired = false;
    int id = await db.insertCharacter(_character, _perks);
    _character.id = id;
    print('inserted row: $id');
    print(_character.name);
    print(_character.classCode);
    notifyListeners();
  }

  Future deleteCharacter(int _characterId) async {
    await db.deleteCharacter(_characterId).then((_) {
      notifyListeners();
    });
  }

  Future<Character> compileLegacyCharacterDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Character _character = Character();
    int _checkMarks = 0;
    PlayerClass _playerClass =
        _prefs.getInt('selectedClass') != null && classList != null
            ? classList[_prefs.getInt('selectedClass')]
            : classList[0];
    _character.name = _prefs.getString('characterName') ?? '[UNKNOWN]';
    // _character.playerClass = _playerClass;
    _character.classCode = _playerClass.classCode;
    _character.classColor = _playerClass.classColor;
    _character.classIcon = _playerClass.classIconUrl;
    _character.classRace = _playerClass.race;
    _character.className = _playerClass.className;
    _character.xp = int.parse(_prefs.getString('characterXP') ?? 0);
    _character.gold = int.parse(_prefs.getString('characterGold') ?? 0);
    _character.notes = _prefs.getString('notes') ?? 'Add notes here';
    if (_prefs.getBool('firstCheck')) _checkMarks++;
    if (_prefs.getBool('secondCheck')) _checkMarks++;
    if (_prefs.getBool('thirdCheck')) _checkMarks++;
    if (_prefs.getBool('2FirstCheck')) _checkMarks++;
    if (_prefs.getBool('2SecondCheck')) _checkMarks++;
    if (_prefs.getBool('2ThirdCheck')) _checkMarks++;
    if (_prefs.getBool('3FirstCheck')) _checkMarks++;
    if (_prefs.getBool('3SecondCheck')) _checkMarks++;
    if (_prefs.getBool('3ThirdCheck')) _checkMarks++;
    if (_prefs.getBool('4FirstCheck')) _checkMarks++;
    if (_prefs.getBool('4SecondCheck')) _checkMarks++;
    if (_prefs.getBool('4ThirdCheck')) _checkMarks++;
    if (_prefs.getBool('5FirstCheck')) _checkMarks++;
    if (_prefs.getBool('5SecondCheck')) _checkMarks++;
    if (_prefs.getBool('5ThirdCheck')) _checkMarks++;
    if (_prefs.getBool('6FirstCheck')) _checkMarks++;
    if (_prefs.getBool('6SecondCheck')) _checkMarks++;
    if (_prefs.getBool('6ThirdCheck')) _checkMarks++;
    _character.checkMarks = _checkMarks;
    _character.isRetired = false;
    _playerClass.perks.forEach((perk) {
      for (var i = 0; i < perk.numOfChecks; i++) {
        _legacyPerks.add(_prefs.getBool(
                '${_playerClass.classCode}${perk.details}${i.toString()}') ??
            false);
      }
    });
    return _character;
  }

  Future addLegacyCharacter() async {
    await compileLegacyCharacterDetails().then((_character) => db
        .insertCharacter(_character, _legacyPerks)
        .then((_id) => _character.id = _id)
        .then((_) => notifyListeners()));
  }
}

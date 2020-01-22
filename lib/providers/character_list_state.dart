import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
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

  Future addCharacter(String _name, PlayerClass _playerClass, int _initialLevel,
      int _previousRetirements) async {
    Character _character = Character();
    List<bool> _perks = [];
    perkList.forEach((_perk) {
      for (var x = 0; x < _perk.numOfPerks; x++) {
        _perks.add(false);
      }
    });
    _character
      ..name = _name
      ..classCode = _playerClass.classCode
      ..classColor = _playerClass.classColor
      ..classIcon = _playerClass.classIconUrl
      ..classRace = _playerClass.race
      ..className = _playerClass.className
      ..previousRetirements = _previousRetirements
      ..xp = _initialLevel > 1 ? levelXpList[_initialLevel - 2] : 0
      ..gold = 0
      ..notes = 'Add notes here'
      ..checkMarks = 0
      ..isRetired = false
      ..id = await db.insertCharacter(_character, _perks);
    // print('inserted row: $id');
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
    _character
      ..name = _prefs.getString('characterName') ?? '[UNKNOWN]'
      ..classCode = _playerClass.classCode
      ..classColor = _playerClass.classColor
      ..classIcon = _playerClass.classIconUrl
      ..classRace = _playerClass.race
      ..className = _playerClass.className
      ..xp = int.parse(_prefs.getString('characterXP') ?? 0)
      ..gold = int.parse(_prefs.getString('characterGold') ?? 0)
      ..notes = _prefs.getString('notes') ?? 'Add notes here'
      ..isRetired = false
      ..previousRetirements =
          int.parse(_prefs.getString('previousRetirements'));
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

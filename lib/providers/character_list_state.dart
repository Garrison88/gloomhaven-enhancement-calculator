import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class CharacterListState with ChangeNotifier {
  List<Character> _characterList = [];
  List<bool> _legacyPerks = [];
  DatabaseHelper db = DatabaseHelper.instance;

  List<Character> get characterList => _characterList;

  Future<bool> setCharacterList() async {
    await db.queryAllCharacters().then((_list) {
      _characterList = _list;
    });
    return true;
  }

  Future addCharacter(String _name, PlayerClass _playerClass) async {
    Character _character = Character();
    List<bool> _perks = [];
    perkList.forEach((_perk) {
      for (var x = 0; x < _perk.numOfPerks; x++) {
        _perks.add(false);
      }
    });
    _character.name = _name;
    _character.playerClass = _playerClass;
    _character.classCode = _playerClass.classCode;
    _character.classColor = _playerClass.classColor;
    _character.classIcon = _playerClass.classIconUrl;
    _character.xp = 0;
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

  Future<Character> compileLegacyCharacterDetails() async {
    Character _legacyCharacter = Character();
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
    _legacyCharacter.xp = int.parse(sp.getString('characterXP') ?? 0);
    _legacyCharacter.gold = int.parse(sp.getString('characterGold') ?? 0);
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
    return _legacyCharacter;
  }

  Future addLegacyCharacter() async {
    await compileLegacyCharacterDetails().then((_legacyCharacter) => db
        .insertCharacter(_legacyCharacter, _legacyPerks)
        .then((_id) => _legacyCharacter.id = _id)
        .then((_) => notifyListeners()));
  }
}

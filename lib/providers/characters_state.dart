import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/perk_row.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk.dart';

class CharactersState with ChangeNotifier {
  List<Character> charactersList = [];
  CharactersState({this.charactersList});
  DatabaseHelper db = DatabaseHelper.instance;

  void setCharactersList() async {
    List<Character> _charactersList = [];
    await db.queryAllRows().then((characters) {
      characters.forEach((character) {
        _charactersList.add(Character.fromMap(character));
        print(character.toString());
      });
    });
    charactersList = _charactersList;
    notifyListeners();
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
    int id = await db.insert(character);
    print('inserted row: $id');
    print(character.name);
    print(character.classCode);
    charactersList.add(character);
    PerkRow perk = PerkRow(_playerClass.classCode, "TeStiNG PeRkK AddD");
    // perk.perkClass = _playerClass.classCode;
    // perk.perkDetails = ;
    await db.insertPerk(perk);
    notifyListeners();
  }

  Future<void> addLegacyCharacter() async {
    List<Perk> _perkList;
    int _checkMarks = 0;
    Character legacyCharacter = Character();
    PlayerClass _playerClass =
        sp.getInt('selectedClass') != null && classList != null
            ? classList[sp.getInt('selectedClass')]
            : classList[0];
    legacyCharacter.name = sp.getString('characterName') ?? 'CHOOSE NAME';
    legacyCharacter.playerClass = _playerClass;
    legacyCharacter.classCode = _playerClass.classCode;
    legacyCharacter.classColor = _playerClass.classColor;
    legacyCharacter.classIcon = _playerClass.classIconUrl;
    legacyCharacter.xp = int.parse(sp.getString('characterXP') ?? '0');
    legacyCharacter.gold = int.parse(sp.getString('characterGold') ?? '0');
    legacyCharacter.notes = sp.getString('notes') ?? 'Add notes here';
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
    legacyCharacter.checkMarks = _checkMarks;
    int id = await db.insert(legacyCharacter);
    _playerClass.perks.forEach((f) =>
        sp.getBool('${_playerClass.classCode}${f.details}}${f.numOfChecks}'));
    print('inserted row: $id');
    print('legacy character name: ${legacyCharacter.name}');
    print('legacy character class code: ${legacyCharacter.classCode}');
    print('check marks: $_checkMarks');
    print('perks: ${_playerClass.perks}');
    charactersList.add(legacyCharacter);
    notifyListeners();
  }

  getCharactersList() => charactersList;
}

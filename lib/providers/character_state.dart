import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';

class CharacterState with ChangeNotifier {
  final int characterId;
  Character character;
  List<CharacterPerk> characterPerks;
  CharacterState({this.characterId, this.characterPerks});
  DatabaseHelper db = DatabaseHelper.instance;

  Future<Character> getCharacter(int _characterId) async => db
      .queryCharacterRow(_characterId)
      .then((_character) => character = _character);

  Future<List> getCharacterPerks(int _characterId) async =>
      characterPerks = await db.queryCharacterPerks(_characterId);

  void setCharacterPerks(_characterId) async {
    characterPerks = await db.queryCharacterPerks(_characterId);
    notifyListeners();
  }

  void setCharacter(_characterId) async {
    character = await db.queryCharacterRow(_characterId);
    notifyListeners();
  }

  void deleteCharacter(int _characterId) async {
    await db.deleteCharacter(_characterId);
    character = null;
    notifyListeners();
  }

  // UPDATE CHARACTER

}

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';

class CharacterState with ChangeNotifier {
  final int _characterId;
  bool _isEditable = false;
  Character _character;
  List<CharacterPerk> _characterPerks = [];
  CharacterState(this._characterId);
  DatabaseHelper db = DatabaseHelper.instance;

  Character get character => _character;

  bool get isEditable => _isEditable;

  Future<bool> setCharacter() async {
    _character = await db.queryCharacter(_characterId);
    return true;
  }

  // bool get characterIsLoading => _characterIsLoading;

  // bool get perksAreLoading => _perksAreLoading;

  // List<CharacterPerk> getCharacterPerks() => _characterPerks;

  int getPerk(CharacterPerk _perk) => _characterPerks.indexOf(_perk);

  void deleteCharacter(int _characterId) async {
    await db.deleteCharacter(_characterId);
    notifyListeners();
  }

//   bool togglePerk(CharacterPerk _perk) {
// db.selectPerk(_perk);
// characterPerks.indexOf(_perk);
// return !_perk.characterPerkIsSelected;
//   }

  // UPDATE CHARACTER

}

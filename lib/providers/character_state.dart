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

  List<int> _levelXpList = [45, 95, 150, 210, 275, 345, 420, 500];

  Character get character => _character;

  bool get isEditable => _isEditable;

  set isEditable(bool _value) {
    _isEditable = _value;
    notifyListeners();
  }

  int get level => _character.xp < _levelXpList.last
      ? _levelXpList.indexWhere((_xp) => _xp > _character.xp) + 1
      : 9;

  int get nextLevelXp => _character.xp < _levelXpList.last
      ? _levelXpList.firstWhere((_threshold) => _threshold > _character.xp)
      : _levelXpList.last;

  Future<bool> setCharacter() async {
    _character = await db.queryCharacter(_characterId);
    return true;
  }

  int getPerk(CharacterPerk _perk) => _characterPerks.indexOf(_perk);

  Future updateCharacter(Character _updatedCharacter) async {
    _character = _updatedCharacter;
    await db.updateCharacter(_updatedCharacter);
  }

  deleteCharacter(int _characterId) async {
    await db.deleteCharacter(_characterId);
    notifyListeners();
  }

}

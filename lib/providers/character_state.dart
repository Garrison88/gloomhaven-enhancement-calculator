import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class CharacterState with ChangeNotifier {
  final int _characterId;
  bool _isEditable = false;
  Character _character;
  // PlayerClass _playerClass;
  List<CharacterPerk> _characterPerks = [];
  List<bool> _checkMarkList = [];
  CharacterState(this._characterId);
  DatabaseHelper db = DatabaseHelper.instance;

  List<int> _levelXpList = [45, 95, 150, 210, 275, 345, 420, 500];

  // PlayerClass get playerClass => _playerClass;

  // Future<bool> setPlayerClass() async {
  //   _playerClass = await db.queryPlayerClass(_character.classCode);
  //   return true;
  // }

  Future<bool> setCharacter() async {
    _character = await db.queryCharacter(_characterId);
    // _playerClass = await db.queryPlayerClass(_character.classCode);
    return true;
  }

  Character get character => _character;

  bool get isEditable => _isEditable;

  set isEditable(bool _value) {
    _isEditable = _value;
    notifyListeners();
  }

  int get currentLevel => _character.xp < _levelXpList.last
      ? _levelXpList.indexWhere((_xp) => _xp > _character.xp) + 1
      : 9;

  int get nextLevelXp => _character.xp < _levelXpList.last
      ? _levelXpList.firstWhere((_threshold) => _threshold > _character.xp)
      : _levelXpList.last;

  int getPerk(CharacterPerk _perk) => _characterPerks.indexOf(_perk);

  Future updateCharacter(Character _updatedCharacter) async {
    _character = _updatedCharacter;
    await db.updateCharacter(_updatedCharacter);
  }

  // deleteCharacter(int _characterId) async {
  //   await db.deleteCharacter(_characterId);
  //   notifyListeners();
  // }
}

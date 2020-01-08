import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/view_model/base_model.dart';

class CharacterModel extends BaseModel {
  // final int _characterId;
  bool _isEditable = false;
  Character _character;
  // PlayerClass _playerClass;
  List<CharacterPerk> _characterPerks = [];
  List<bool> _checkMarkList = [];
  // CharacterModel(this.character);
  DatabaseHelper db = DatabaseHelper.instance;

  List<int> _levelXpList = [45, 95, 150, 210, 275, 345, 420, 500];

  // PlayerClass get playerClass => _playerClass;

  // Future<bool> setPlayerClass() async {
  //   _playerClass = await db.queryPlayerClass(character.classCode);
  //   return true;
  // }

  // Future<bool> setCharacter() async {
  //   character = await db.queryCharacter(_characterId);
  //   // _playerClass = await db.queryPlayerClass(character.classCode);
  //   return true;
  // }

  Character get character {
    print(character.name);
    return character;
  }

  set character(Character character) {
    if (_character != character) {
      _character = character;
      notifyChange();
      // do some extra work, that may call `notifyListeners()`
    }
  }

  bool get isEditable => _isEditable;

  set isEditable(bool _value) {
    _isEditable = _value;
    notifyChange();
  }

  int get currentLevel => _character.xp < _levelXpList.last
      ? _levelXpList.indexWhere((_xp) => _xp > _character.xp) + 1
      : 9;

  int get nextLevelXp => _character.xp < _levelXpList.last
      ? _levelXpList.firstWhere((_threshold) => _threshold > _character.xp)
      : _levelXpList.last;

  int getPerk(CharacterPerk _perk) => _characterPerks.indexOf(_perk);

  Future updateCharacter(Character _updatedCharacter) async {
    character = _updatedCharacter;
    await db.updateCharacter(_updatedCharacter);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // deleteCharacter(int _characterId) async {
  //   await db.deleteCharacter(_characterId);
  //   notifyChange();
  // }
}

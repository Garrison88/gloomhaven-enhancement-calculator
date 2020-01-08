import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/view_model/base_model.dart';

class CharacterPerksModel extends BaseModel {
  int characterId;
  List<CharacterPerk> _characterPerks = [];
  // CharacterPerksModel(this._characterId);
  DatabaseHelper db = DatabaseHelper.instance;

  // set characterId(int _id) {
  //   _characterId = _id;
  // }

  // int get characterId => _characterId;

  Future<bool> setCharacterPerks(_characterId) async {
    _characterPerks = await db.queryCharacterPerks(_characterId);
    return true;
  }

  List<CharacterPerk> get characterPerks => _characterPerks;

  Future togglePerk(_perk, _value) async {
    await db.updateCharacterPerk(_perk, _value);
    notifyChange();
  }

  Future<String> getPerkDetails(int _perkId) async {
    Perk _perk = await db.queryPerk(_perkId);
    return _perk.perkDetails;
  }
}

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';

class CharacterPerksState with ChangeNotifier {
  int _characterId;
  List<CharacterPerk> _characterPerks = [];
  CharacterPerksState(this._characterId);
  DatabaseHelper db = DatabaseHelper.instance;

  // setCharacterId(_charId) => _characterId = _charId;

  get characterId => _characterId;

  Future<bool> setCharacterPerks(_characterId) async {
    _characterPerks = await db.queryCharacterPerks(_characterId);
    return true;
  }

  List<CharacterPerk> get characterPerks => _characterPerks;

  Future<void> togglePerk(CharacterPerk _perk) async {
    await db.updateCharacterPerk(_perk);
    notifyListeners();
  }

  Future<String> getPerkDetails(int _perkId) async {
    Perk _perk = await db.queryPerk(_perkId);
    return _perk.perkDetails;
  }
}

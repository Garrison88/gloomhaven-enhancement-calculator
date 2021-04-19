import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class CharactersModel with ChangeNotifier {
  List<Character> _characters = [];
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  List<Character> get characters => _characters;

  Future<List<Character>> loadCharacters() async {
    _characters = await databaseHelper.queryAllCharacters();
    return _characters;
  }

  Future<void> createCharacter(
    String name,
    PlayerClass playerClass,
    int initialLevel,
    int previousRetirements,
  ) async {
    Character character = Character();
    List<bool> perks = [];
    CharacterData.perks.forEach((perk) {
      for (var x = 0; x < perk.numOfPerks; x++) {
        perks.add(false);
      }
    });
    character
      ..name = name
      ..classCode = playerClass.classCode
      ..classColor = playerClass.classColor
      ..classIcon = playerClass.classIconUrl
      ..classRace = playerClass.race
      ..className = playerClass.className
      ..previousRetirements = previousRetirements
      ..xp = initialLevel > 1 ? CharacterData.levelXp[initialLevel - 2] : 0
      ..gold = 0
      ..notes = 'Items, reminders, wishlist...'
      ..checkMarks = 0
      ..isRetired = false
      ..id = await databaseHelper.insertCharacter(character, perks);
    print(character.name);
    print(character.classCode);
    characters.add(character);
    notifyListeners();
  }

  Future<void> deleteCharacter(int characterId) async {
    await databaseHelper.deleteCharacter(characterId);
    characters.removeWhere((element) => element.id == characterId);
  }
}

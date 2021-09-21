import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/character_data.dart';
import '../data/database_helpers.dart';
import '../models/character.dart';
import '../models/player_class.dart';
import '../shared_prefs.dart';

class CharactersModel with ChangeNotifier {
  List<Character> _characters = [];
  Character currentCharacter;
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  PageController pageController;
  AnimationController animationController;
  bool _isEditMode = false;

  List<Character> get characters => _characters;

  Future<List<Character>> loadCharacters() async {
    _characters = await databaseHelper.queryAllCharacters();
    return _characters;
  }

  bool get isEditMode => _isEditMode;

  set isEditMode(bool value) {
    _isEditMode = value;
    notifyListeners();
  }

  Future<void> createCharacter(
    BuildContext context,
    String name,
    PlayerClass selectedClass, {
    int initialLevel = 1,
    int previousRetirements = 0,
  }) async {
    Character character = Character(
      uuid: Uuid().v1(),
      name: name,
      playerClass: selectedClass,
      previousRetirements: previousRetirements,
      xp: initialLevel > 1 ? CharacterData.levelXp[initialLevel - 2] : 0,
      gold: 15 * (initialLevel + 1),
    );
    character.id = await databaseHelper.insertCharacter(
      character,
    );
    characters.add(character);
    if (characters.length > 1) {
      pageController.animateToPage(
        characters.indexOf(character),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
    updateCurrentCharacter(
      context,
      index: characters.indexOf(character),
    );
    notifyListeners();
  }

  Future<void> deleteCharacter(
    BuildContext context,
    String uuid,
  ) async {
    int position = characters.indexOf(
      characters.firstWhere((element) => element.uuid == uuid),
    );
    await databaseHelper.deleteCharacter(uuid);
    characters.removeWhere((element) => element.uuid == uuid);
    updateCurrentCharacter(
      context,
      index: position,
    );
    notifyListeners();
  }

  void updateCurrentCharacter(
    BuildContext context, {
    int index,
  }) {
    isEditMode = false;
    if (characters.isEmpty) {
      currentCharacter = null;
      SharedPrefs().themeColor = '0xff4e7ec1';
      SharedPrefs().initialPage = 0;
    } else {
      try {
        currentCharacter = characters[index];
      } on RangeError {
        currentCharacter = characters.last;
      }
      SharedPrefs().themeColor = currentCharacter.playerClass.classColor;
      SharedPrefs().initialPage = characters.indexOf(currentCharacter);
    }
    EasyDynamicTheme.of(context).changeTheme(dynamic: true);
  }
}

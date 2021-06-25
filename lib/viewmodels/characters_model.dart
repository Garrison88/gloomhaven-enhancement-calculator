import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
// import 'package:gloomhaven_enhancement_calc/models/personal_goal.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class CharactersModel with ChangeNotifier {
  List<Character> _characters = [];
  Character currentCharacter;
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  PageController pageController;
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

  // Character get currentCharacter => _currentCharacter;

  // setCurrentCharacter(int index) {

  // }

  Future<void> createCharacter(
    BuildContext context,
    String name,
    PlayerClass selectedClass,
    int initialLevel,
    int previousRetirements,
    // PersonalGoal personalGoal,
  ) async {
    Character character = Character();
    List<bool> perks = [];
    CharacterData.perks.forEach((perk) {
      if (perk.perkClassCode == selectedClass.classCode) {
        for (var x = 0; x < perk.numOfPerks; x++) {
          perks.add(false);
        }
      }
    });
    character
      ..name = name
      ..classCode = selectedClass.classCode
      ..classColor = selectedClass.classColor
      ..classIcon = selectedClass.classIconUrl
      ..classRace = selectedClass.race
      ..className = selectedClass.className
      ..previousRetirements = previousRetirements
      ..xp = initialLevel > 1 ? CharacterData.levelXp[initialLevel - 2] : 0
      ..gold = 15 * (initialLevel + 1)
      ..notes = 'Items, reminders, wishlist...'
      ..checkMarks = 0
      ..isRetired = false
      ..id = await databaseHelper.insertCharacter(
        character,
        perks,
        // personalGoal,
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
    int id,
  ) async {
    int position = characters.indexOf(
      characters.firstWhere((element) => element.id == id),
    );
    await databaseHelper.deleteCharacter(id);
    characters.removeWhere((element) => element.id == id);
    // print('POSITION IN DELETE IS::::: $position');
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
      SharedPrefs().themeColor = currentCharacter.classColor;
      SharedPrefs().initialPage = characters.indexOf(currentCharacter);
    }
    EasyDynamicTheme.of(context).changeTheme(dynamic: true);
  }
}

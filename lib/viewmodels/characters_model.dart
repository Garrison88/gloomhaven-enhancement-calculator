import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/character_data.dart';
import '../data/database_helpers.dart';
import '../models/character.dart';
import '../models/player_class.dart';
import '../shared_prefs.dart';

class CharactersModel with ChangeNotifier {
  CharactersModel(this.context);

  BuildContext context;
  List<Character> _characters = [];
  Character currentCharacter;
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  PageController pageController;
  AnimationController animationController;
  bool showRetired = SharedPrefs().showRetiredCharacters;
  bool _isEditMode = false;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  List<Character> get characters => showRetired
      ? _characters
      : _characters.where((character) => !character.isRetired).toList();

  set characters(List<Character> characters) {
    _characters = characters;
    notifyListeners();
  }

  Future<List<Character>> loadCharacters() async {
    _characters = await databaseHelper.queryAllCharacters();
    setCurrentCharacter(
      index: SharedPrefs().initialPage,
    );
  }

  bool get isEditMode => _isEditMode;

  set isEditMode(bool value) {
    _isEditMode = value;
    notifyListeners();
  }

  void onPageChanged(
    int index,
  ) {
    isDialOpen.value = false;
    setCurrentCharacter(
      index: index,
    );
    isEditMode = false;
  }

  Future<void> createCharacter(
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
    _characters.add(character);
    if (characters.length > 1) {
      animateToIndex(
        characters.indexOf(character),
      );
    }
    setCurrentCharacter(
      index: characters.indexOf(character),
    );
    notifyListeners();
  }

  Future<void> deleteCurrentCharacter() async {
    isEditMode = false;
    int index = characters.indexOf(currentCharacter);
    await databaseHelper.deleteCharacter(currentCharacter);
    _characters.remove(currentCharacter);
    setCurrentCharacter(
      index: index,
    );
    notifyListeners();
  }

  void setCurrentCharacter({
    int index,
  }) {
    // isDialOpen.value = false;
    if (characters.isEmpty) {
      currentCharacter = null;
      SharedPrefs().initialPage = 0;
    } else if (index > characters.length - 1 || index == -1) {
      currentCharacter = characters.last;
      SharedPrefs().initialPage = characters.indexOf(characters.last);
    } else {
      currentCharacter = characters[index];

      SharedPrefs().initialPage = index;
    }
    _updateTheme();
  }

  void _updateTheme() {
    if (characters.isEmpty) {
      SharedPrefs().themeColor = '0xff4e7ec1';
      SharedPrefs().initialPage = 0;
    } else {
      SharedPrefs().themeColor = currentCharacter.isRetired
          ? '0xff111111'
          : currentCharacter.playerClass.classColor;
    }
    EasyDynamicTheme.of(context).changeTheme(dynamic: true);
  }

  void animateToIndex(
    int index,
  ) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> retireCurrentCharacter() async {
    if (!showRetired) {
      await Future.delayed(const Duration(milliseconds: 100));
      isDialOpen.value = false;
    }
    isEditMode = false;
    int index = characters.indexOf(currentCharacter);
    currentCharacter.isRetired = !currentCharacter.isRetired;
    await DatabaseHelper.instance.updateCharacter(currentCharacter);
    if (!showRetired) {
      characters.remove(currentCharacter);
    }
    setCurrentCharacter(
      index: index,
    );
    notifyListeners();
  }
}

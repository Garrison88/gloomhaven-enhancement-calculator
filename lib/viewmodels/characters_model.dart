import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/character_data.dart';
import '../data/database_helpers.dart';
import '../models/character.dart';
import '../models/player_class.dart';
import '../shared_prefs.dart';

class CharactersModel with ChangeNotifier {
  CharactersModel(
    this.context, {
    this.pageController,
    this.showRetired,
  });

  BuildContext context;
  List<Character> _characters = [];
  Character currentCharacter;
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  PageController pageController = PageController();
  AnimationController hideRetireCharacterAnimationController;
  bool showRetired;
  bool isEditMode = false;
  // int _trueIndex;

  // int get trueIndex => _characters.indexOf(currentCharacter);

  // set trueIndex(int trueIndex) {
  //   _trueIndex = trueIndex;
  // }

  void toggleShowRetired({
    int index,
  }) {
    int theIndex = index ??= showRetired
        ? _characters
            .where((character) => !character.isRetired)
            .toList()
            .indexOf(currentCharacter)
        : _characters.indexOf(currentCharacter);
    showRetired = !showRetired;
    SharedPrefs().showRetiredCharacters = showRetired;
    jumpToPage(theIndex == -1 ? 0 : theIndex);
    setCurrentCharacter(index: theIndex == -1 ? 0 : theIndex);
    notifyListeners();
  }

  bool get retiredCharactersAreHidden {
    return !showRetired && _characters.isNotEmpty;
  }

  List<Character> get characters => showRetired
      ? _characters
      : _characters.where((character) => !character.isRetired).toList();

  set characters(List<Character> characters) {
    _characters = characters;
    notifyListeners();
  }

  double currentPage() => pageController.page;

  Future<List<Character>> loadCharacters() async {
    characters = await databaseHelper.queryAllCharacters();
    setCurrentCharacter(
      index: SharedPrefs().initialPage,
    );
    notifyListeners();
    return characters;
  }

  void toggleEditMode() {
    isEditMode
        ? hideRetireCharacterAnimationController.reverse()
        : hideRetireCharacterAnimationController.forward();
    isEditMode = !isEditMode;
    notifyListeners();
  }

  void onPageChanged(
    int index,
  ) {
    SharedPrefs().initialPage = index;
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
      animateToPage(
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
    print('SET CHARACTER INDEX:: $index');
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

  void animateToPage(
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

  void jumpToPage(
    int index,
  ) {
    if (pageController.hasClients) {
      pageController.jumpToPage(
        index,
      );
    }
  }

  Future<int> retireCurrentCharacter() async {
    isEditMode = false;
    int trueIndex = _characters.indexOf(currentCharacter);
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
    return trueIndex;
  }
}

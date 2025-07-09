import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/data/player_classes/player_class_constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery/mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/perk/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk/perk.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:uuid/uuid.dart';

class CharactersModel with ChangeNotifier {
  CharactersModel({
    required this.databaseHelper,
    required this.showRetired,
  });

  List<Character> _characters = [];
  Character? currentCharacter;
  DatabaseHelper databaseHelper;
  PageController pageController = PageController(
    initialPage: SharedPrefs().initialPage,
  );
  bool isScrolledToTop = true;
  ScrollController charScreenScrollController = ScrollController();
  ScrollController enhancementCalcScrollController = ScrollController();
  final previousRetirementsController = TextEditingController();
  final nameController = TextEditingController();
  final xpController = TextEditingController();
  final goldController = TextEditingController();
  final notesController = TextEditingController();

  bool showRetired;
  bool isEditMode = false;

  @override
  void dispose() {
    pageController.dispose();
    charScreenScrollController.dispose();
    enhancementCalcScrollController.dispose();
    previousRetirementsController.dispose();
    nameController.dispose();
    xpController.dispose();
    goldController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void toggleShowRetired({
    Character? character,
  }) {
    // 🐉🐲 HERE THERE BE DRAGONS 🐲🐉
    if (_characters.isEmpty) {
      showRetired = !showRetired;
      notifyListeners();
      return;
    }
    int index = 0;
    if (character != null) {
      index = _characters.indexOf(character);
    } else if (retiredCharactersAreHidden && currentCharacter == null) {
      index = 0;
    } else if (currentCharacter != null && currentCharacter!.isRetired) {
      List<Character> tempList = characters;
      int tempIndex = tempList.indexOf(currentCharacter!);
      do {
        tempIndex++;
      } while (tempIndex < tempList.length &&
          tempList.elementAt(tempIndex).isRetired);
      try {
        index = characters
            .where((character) => !character.isRetired)
            .toList()
            .indexOf(tempList.elementAt(tempIndex));
      } on RangeError catch (_) {
        index = characters
                .where((character) => !character.isRetired)
                .toList()
                .length -
            1;
      }
    } else if (currentCharacter != null &&
        !currentCharacter!.isRetired &&
        showRetired) {
      index = characters
          .where((character) => !character.isRetired)
          .toList()
          .indexOf(currentCharacter!);
    } else {
      if (currentCharacter != null) {
        index = _characters.indexOf(currentCharacter!);
      }
    }
    showRetired = !showRetired;
    SharedPrefs().showRetiredCharacters = showRetired;
    if (!index.isNegative) {
      jumpToPage(
        index,
      );
    }
    _setCurrentCharacter(
      index: index,
    );
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

  Future<List<Character>> loadCharacters() async {
    // if (kDebugMode) {
    //   await createAllCharactersTest();
    // }
    List<Character> loadedCharacters =
        await databaseHelper.queryAllCharacters();
    for (Character character in loadedCharacters) {
      character.characterPerks = await _loadPerks(
        character,
      );
      character.characterMasteries = await _loadMasteries(
        character,
      );
      characters = loadedCharacters;
    }

    _setCurrentCharacter(
      index: SharedPrefs().initialPage,
    );
    notifyListeners();
    return characters;
  }

  Future<void> createCharactersTest({
    ClassCategory? classCategory,
  }) async {
    var random = Random();
    if (classCategory == null) {
      for (PlayerClass playerClass in PlayerClasses.playerClasses) {
        await createCharacter(
          playerClass.name,
          playerClass,
          initialLevel: random.nextInt(9) + 1,
          previousRetirements: random.nextInt(4),
          gloomhavenMode: random.nextBool(),
          prosperityLevel: random.nextInt(5),
        );
        debugPrint('Created ${playerClass.name}');
      }
    } else {
      for (PlayerClass playerClass in PlayerClasses.playerClasses.where(
        (element) => element.category == classCategory,
      )) {
        await createCharacter(
          playerClass.name,
          playerClass,
          initialLevel: random.nextInt(9) + 1,
          previousRetirements: random.nextInt(4),
          gloomhavenMode: random.nextBool(),
          prosperityLevel: random.nextInt(5),
        );
        debugPrint('Created ${playerClass.name}');
      }
    }

    await loadCharacters();
  }

  void toggleEditMode() {
    // isEditMode
    //     ? hideRetireCharacterAnimationController.reverse()
    //     : hideRetireCharacterAnimationController.forward();
    isEditMode = !isEditMode;
    notifyListeners();
  }

  void onPageChanged(
    int index,
  ) {
    SharedPrefs().initialPage = index;
    isScrolledToTop = true;
    _setCurrentCharacter(
      index: index,
    );
    isEditMode = false;
  }

  Future<void> createCharacter(
    String name,
    PlayerClass selectedClass, {
    int initialLevel = 1,
    int previousRetirements = 0,
    bool gloomhavenMode = true,
    int prosperityLevel = 0,
    Variant variant = Variant.base,
  }) async {
    Character character = Character(
      uuid: const Uuid().v1(),
      name: name,
      playerClass: selectedClass,
      previousRetirements: previousRetirements,
      xp: PlayerClasses.xpByLevel(initialLevel),
      gold:
          gloomhavenMode ? 15 * (initialLevel + 1) : 10 * prosperityLevel + 20,
      variant: variant,
    );
    try {
      character.id = await databaseHelper.insertCharacter(
        character,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    character.characterPerks = await _loadPerks(
      character,
    );

    character.characterMasteries = await _loadMasteries(
      character,
    );

    _characters.add(character);
    if (characters.length > 1) {
      _animateToPage(
        characters.indexOf(character),
      );
    }
    _setCurrentCharacter(
      index: characters.indexOf(character),
    );
    notifyListeners();
  }

  Future<void> deleteCurrentCharacter() async {
    isEditMode = false;
    int index = characters.indexOf(currentCharacter!);
    await databaseHelper.deleteCharacter(currentCharacter!);
    _characters.remove(currentCharacter);
    _setCurrentCharacter(
      index: index,
    );
    notifyListeners();
  }

  void _setCurrentCharacter({
    required int index,
  }) {
    if (characters.isEmpty) {
      currentCharacter = null;
      SharedPrefs().initialPage = 0;
    } else {
      if (index > characters.length - 1 || index == -1) {
        currentCharacter = characters.last;
        SharedPrefs().initialPage = characters.indexOf(characters.last);
      } else {
        currentCharacter = characters[index];
        SharedPrefs().initialPage = index;
      }
      if (currentCharacter != null) {
        previousRetirementsController.text =
            currentCharacter!.previousRetirements.toString();
        nameController.text = currentCharacter!.name;
        xpController.text =
            currentCharacter!.xp != 0 ? '${currentCharacter!.xp}' : '';
        goldController.text =
            currentCharacter!.gold != 0 ? '${currentCharacter!.gold}' : '';
        notesController.text = currentCharacter!.notes;
      }
    }
    updateTheme();
  }

  void updateTheme() {
    if (characters.isEmpty) {
      SharedPrefs().primaryClassColor = 0xff4e7ec1;
    } else if (currentCharacter != null) {
      if (currentCharacter != null && currentCharacter!.isRetired) {
        SharedPrefs().primaryClassColor =
            SharedPrefs().darkTheme ? 0xffffffff : 0xff000000;
      } else {
        SharedPrefs().primaryClassColor =
            currentCharacter!.playerClass.primaryColor;
      }
    }
  }

  void _animateToPage(
    int index,
  ) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
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
      _setCurrentCharacter(
        index: index,
      );
    }
  }

  Future<void> retireCurrentCharacter() async {
    if (currentCharacter != null) {
      isEditMode = false;
      int index = characters.indexOf(currentCharacter!);
      currentCharacter!.isRetired = !currentCharacter!.isRetired;
      await databaseHelper.updateCharacter(currentCharacter!);
      _setCurrentCharacter(
        index: index,
      );
      notifyListeners();
    }
  }

  Future<void> updateCharacter(Character character) async {
    await databaseHelper.updateCharacter(character);
    notifyListeners();
  }

  void increaseCheckmark(Character character) {
    if (character.checkMarks < 18) {
      updateCharacter(
        character..checkMarks += 1,
      );
    }
  }

  void decreaseCheckmark(Character character) {
    if (character.checkMarks > 0) {
      updateCharacter(
        character..checkMarks -= 1,
      );
    }
  }

  Future<List<CharacterPerk>> _loadPerks(Character character) async {
    // Load perks from database
    await _loadCharacterPerks(character);

    // Return character-specific perk selections
    return await databaseHelper.queryCharacterPerks(character.uuid);
  }

  Future<void> _loadCharacterPerks(Character character) async {
    final List<Map<String, Object?>> perks =
        await databaseHelper.queryPerks(character);

    for (var perkMap in perks) {
      character.perks.add(Perk.fromMap(perkMap));
    }
  }

  Future<List<CharacterMastery>> _loadMasteries(
    Character character,
  ) async {
    if (!character.includeMasteries()) {
      return [];
    }
    List<Map<String, Object?>> masteries = await databaseHelper.queryMasteries(
      character.playerClass.classCode,
    );
    for (var masteryMap in masteries) {
      character.masteries.add(
        Mastery.fromMap(masteryMap),
      );
    }
    return await databaseHelper.queryCharacterMasteries(
      character.uuid,
    );
  }

  Future<void> togglePerk({
    required List<CharacterPerk> characterPerks,
    required CharacterPerk perk,
    required bool value,
  }) async {
    for (CharacterPerk characterPerk in characterPerks) {
      if (characterPerk.associatedPerkId == perk.associatedPerkId) {
        characterPerk.characterPerkIsSelected = value;
      }
    }
    await databaseHelper.updateCharacterPerk(
      perk,
      value,
    );
    notifyListeners();
  }

  Future<void> toggleMastery({
    required List<CharacterMastery> characterMasteries,
    required CharacterMastery mastery,
    required bool value,
  }) async {
    for (CharacterMastery characterMastery in characterMasteries) {
      if (characterMastery.associatedMasteryId == mastery.associatedMasteryId) {
        characterMastery.characterMasteryAchieved = value;
      }
    }
    await databaseHelper.updateCharacterMastery(
      mastery,
      value,
    );
    notifyListeners();
  }
}

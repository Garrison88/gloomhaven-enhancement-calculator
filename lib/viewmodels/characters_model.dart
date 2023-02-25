import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:uuid/uuid.dart';
import '../data/character_data.dart';
import '../data/database_helpers.dart';
import '../models/character.dart';
import '../models/player_class.dart';
import '../shared_prefs.dart';

class CharactersModel with ChangeNotifier {
  CharactersModel({
    this.databaseHelper,
    this.showRetired,
  });

  List<Character> _characters = [];
  Character currentCharacter;
  DatabaseHelper databaseHelper;
  PageController pageController = PageController(
    initialPage: SharedPrefs().initialPage,
  );
  AnimationController hideRetireCharacterAnimationController;
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
    if (theIndex >= 1) {
      jumpToPage(
        theIndex,
      );
    }
    _setCurrentCharacter(
      index: theIndex == -1 ? 0 : theIndex,
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
    characters = await databaseHelper.queryAllCharacters();
    for (Character character in characters) {
      character.characterPerks = await _loadPerks(
        character,
      );
      character.characterMasteries = await _loadMasteries(
        character.uuid,
      );
      List<Map<String, Object>> masteries = await databaseHelper.queryMasteries(
        character.playerClass.classCode,
      );
      for (var masteryMap in masteries) {
        character.masteries.add(
          Mastery.fromMap(masteryMap),
        );
      }
    }

    _setCurrentCharacter(
      index: SharedPrefs().initialPage,
    );
    notifyListeners();
    return characters;
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
  }) async {
    Character character = Character(
      uuid: const Uuid().v1(),
      name: name,
      playerClass: selectedClass,
      previousRetirements: previousRetirements,
      xp: CharacterData.levelXp.entries
          .lastWhere((entry) => entry.key == initialLevel)
          .value,
      gold: 15 * (initialLevel + 1),
    );
    character.id = await databaseHelper.insertCharacter(
      character,
    );
    character.characterPerks = await _loadPerks(
      character,
    );

    character.characterMasteries = await _loadMasteries(
      character.uuid,
    );
    List<Map<String, Object>> masteries =
        await databaseHelper.queryMasteries(character.playerClass.classCode);
    for (var masteryMap in masteries) {
      character.masteries.add(
        Mastery.fromMap(masteryMap),
      );
    }
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
    int index = characters.indexOf(currentCharacter);
    await databaseHelper.deleteCharacter(currentCharacter);
    _characters.remove(currentCharacter);
    _setCurrentCharacter(
      index: index,
    );
    notifyListeners();
  }

  void _setCurrentCharacter({
    int index,
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
      currentCharacter = index > characters.length - 1 || index == -1
          ? characters.last
          : characters[index];
      previousRetirementsController.text =
          currentCharacter.previousRetirements != 0
              ? '${currentCharacter.previousRetirements}'
              : '';
      nameController.text = currentCharacter.name;
      xpController.text =
          currentCharacter.xp != 0 ? '${currentCharacter.xp}' : '';
      goldController.text =
          currentCharacter.gold != 0 ? '${currentCharacter.gold}' : '';
      notesController.text = currentCharacter.notes;
    }
    updateTheme();
  }

  void updateTheme() {
    if (characters.isEmpty) {
      SharedPrefs().themeColor = '0xff4e7ec1';
      SharedPrefs().initialPage = 0;
    } else {
      SharedPrefs().themeColor = currentCharacter.isRetired
          ? SharedPrefs().darkTheme
              ? '0xffffffff'
              : '0xff111111'
          : currentCharacter.playerClass.classColor;
    }
  }

  void _animateToPage(
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

  Future<void> retireCurrentCharacter() async {
    isEditMode = false;
    // int trueIndex = _characters.indexOf(character);
    int index = characters.indexOf(currentCharacter);
    currentCharacter.isRetired = !currentCharacter.isRetired;
    await databaseHelper.updateCharacter(currentCharacter);
    // if (!showRetired) {
    //   characters.remove(character,);
    // }
    _setCurrentCharacter(
      index: index,
    );
    notifyListeners();
    // return trueIndex;
  }

  Future<void> updateCharacter(Character character) async {
    await databaseHelper.updateCharacter(character);
    notifyListeners();
  }

  void increaseCheckmark(Character character) {
    if (character.checkMarks < 18) {
      updateCharacter(
        character..checkMarks = character.checkMarks + 1,
      );
    }
  }

  void decreaseCheckmark(Character character) {
    if (character.checkMarks > 0) {
      updateCharacter(
        character..checkMarks = character.checkMarks - 1,
      );
    }
  }

  Future<List<CharacterPerk>> _loadPerks(
    Character character,
  ) async {
    List<Map<String, Object>> perks = await databaseHelper.queryPerks(
      character.playerClass.classCode,
    );
    for (var perkMap in perks) {
      character.perks.add(
        Perk.fromMap(perkMap),
      );
    }
    return await databaseHelper.queryCharacterPerks(
      character.uuid,
    );
  }

  Future<List<CharacterMastery>> _loadMasteries(String uuid) async =>
      await databaseHelper.queryCharacterMasteries(uuid);

  Future<void> togglePerk({
    List<CharacterPerk> characterPerks,
    CharacterPerk perk,
    bool value,
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
    List<CharacterMastery> characterMasteries,
    CharacterMastery mastery,
    bool value,
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

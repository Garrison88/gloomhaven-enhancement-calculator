import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
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
    keepPage: false,
  );
  AnimationController hideRetireCharacterAnimationController;
  bool isScrolledToTop = true;
  ScrollController charScreenScrollController = ScrollController();
  ScrollController enhancementCalcScrollController = ScrollController();

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
    jumpToPage(
      theIndex == -1 ? 0 : theIndex,
    );
    setCurrentCharacter(
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
    isScrolledToTop = true;
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
      uuid: const Uuid().v1(),
      name: name,
      playerClass: selectedClass,
      previousRetirements: previousRetirements,
      xp: CharacterData.levelXp.entries
          .lastWhere((entry) => entry.key == initialLevel)
          .value,
      gold: 15 * (initialLevel + 1),
      // TODO: uncomment this when including Resources
      // resourceHide: 0,
      // resourceMetal: 0,
      // resourceLumber: 0,
      // resourceArrowvine: 0,
      // resourceAxenut: 0,
      // resourceCorpsecap: 0,
      // resourceFlamefruit: 0,
      // resourceRockroot: 0,
      // resourceSnowthistle: 0,
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
    // EasyDynamicTheme.of(context).changeTheme(dynamic: true);
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

  int numOfSelectedPerks = 0;
  List<CharacterPerk> characterPerks = [];
  List<CharacterMastery> characterMasteries = [];

  final previousRetirementsController = TextEditingController();
  final nameController = TextEditingController();
  final xpController = TextEditingController();
  final goldController = TextEditingController();
  final notesController = TextEditingController();

  int get checkMarkProgress => currentCharacter.checkMarks != 0
      ? currentCharacter.checkMarks % 3 == 0
          ? 3
          : currentCharacter.checkMarks % 3
      : 0;

  Future<void> updateCharacter(Character updatedCharacter) async {
    currentCharacter = updatedCharacter;
    await databaseHelper.updateCharacter(updatedCharacter);
    notifyListeners();
  }

  void increaseCheckmark() {
    if (currentCharacter.checkMarks < 18) {
      updateCharacter(
        currentCharacter..checkMarks = currentCharacter.checkMarks + 1,
      );
    }
  }

  void decreaseCheckmark() {
    if (currentCharacter.checkMarks > 0) {
      updateCharacter(
        currentCharacter..checkMarks = currentCharacter.checkMarks - 1,
      );
    }
  }

  Future<List<CharacterPerk>> loadCharacterPerks(String uuid) async {
    characterPerks = await databaseHelper.queryCharacterPerks(uuid);
    int temp = 0;
    for (final CharacterPerk perk in characterPerks) {
      if (perk.characterPerkIsSelected) {
        temp++;
      }
    }
    numOfSelectedPerks = temp;
    return characterPerks;
  }

  Future<List<CharacterMastery>> loadCharacterMasteries() async {
    characterMasteries =
        await databaseHelper.queryCharacterMasteries(currentCharacter.uuid);
    return characterMasteries;
  }

  Future<void> togglePerk(
    CharacterPerk perk,
    bool value,
  ) async {
    value ? numOfSelectedPerks++ : numOfSelectedPerks--;
    for (CharacterPerk characterPerk in characterPerks) {
      if (characterPerk.associatedPerkId == perk.associatedPerkId) {
        characterPerk.characterPerkIsSelected = value;
      }
    }
    await databaseHelper.updateCharacterPerk(perk, value);
    notifyListeners();
    return value;
  }

  Future<void> toggleMastery(
    CharacterMastery mastery,
    bool value,
  ) async {
    for (CharacterMastery characterMastery in characterMasteries) {
      if (characterMastery.associatedMasteryId == mastery.associatedMasteryId) {
        characterMastery.characterMasteryAchieved = value;
      }
    }
    await databaseHelper.updateCharacterMastery(mastery, value);
    notifyListeners();
    return value;
  }

  Future<List> loadPerks(String uuid) async {
    List list = await databaseHelper.queryPerks(
      characters
          .firstWhere((element) => element.uuid == uuid)
          .playerClass
          .classCode
          .toLowerCase(),
    );

    List<PerkRow> perkRows = [];
    List<Perk> perkRowPerks = [];
    List<Perk> perks = [];
    for (var perkMap in list) {
      perks.add(
        Perk.fromMap(perkMap),
      );
    }
    String details = '';
    for (Perk perk in perks) {
      if (details.isEmpty) {
        details = perk.perkDetails;
        perkRowPerks.add(perk);
        continue;
      }
      if (details == perk.perkDetails) {
        perkRowPerks.add(perk);
        continue;
      }
      if (details != perk.perkDetails) {
        perkRows.add(
          PerkRow(
            perks: perkRowPerks,
          ),
        );
        perkRowPerks = [perk];
        details = perk.perkDetails;
      }
    }
    perkRows.add(
      PerkRow(
        perks: perkRowPerks,
      ),
    );
    return perkRows;
  }

  Future<List> loadMasteries() async => await databaseHelper.queryMasteries(
        currentCharacter.playerClass.classCode.toLowerCase(),
      );
}

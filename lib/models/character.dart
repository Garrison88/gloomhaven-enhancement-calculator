// database table and column names
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk.dart';

import 'player_class.dart';

final String tableCharacters = 'CharactersTable';
final String columnCharacterId = '_id';
final String columnCharacterName = 'CharacterName';
final String columnCharacterClassCode = 'CharacterClassCode';
final String columnCharacterClassColor = 'CharacterClassColor';
final String columnCharacterClassIcon = 'CharacterClassIcon';
final String columnCharacterXp = 'CharacterXp';
final String columnCharacterGold = 'CharacterGold';
final String columnCharacterNotes = 'CharacterNotes';
final String columnCharacterCheckMarks = 'CharacterCheckMarks';
final String perksID = 'PerksForeignKey';

// data model class
class Character {
  int characterId;
  String name;
  PlayerClass playerClass;
  String classCode;
  String classColor;
  String classIcon;
  int xp;
  int gold;
  String notes;
  int checkMarks;
  List<Perk> perksList;

  Character(
      // this.id,
      // this.name,
      // this.playerClass,
      // this.classCode,
      // this.classColor,
      // this.classIcon,
      // this.xp,
      // this.gold,
      // this.notes,
      // this.checkMarks
      );

  // convenience constructor to create a Character object
  Character.fromMap(Map<String, dynamic> map) {
    characterId = map[columnCharacterId];
    name = map[columnCharacterName];
    classCode = map[columnCharacterClassCode];
    classColor = map[columnCharacterClassColor];
    classIcon = map[columnCharacterClassIcon];
    xp = map[columnCharacterXp];
    gold = map[columnCharacterGold];
    notes = map[columnCharacterNotes];
    checkMarks = map[columnCharacterCheckMarks];
  }

  // convenience method to create a Map from this Character object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCharacterId: characterId,
      columnCharacterName: name,
      columnCharacterClassCode: playerClass.classCode,
      columnCharacterClassColor: playerClass.classColor,
      columnCharacterClassIcon: playerClass.classIconUrl,
      columnCharacterXp: xp,
      columnCharacterGold: gold,
      columnCharacterNotes: notes,
      columnCharacterCheckMarks: checkMarks
    };
    if (characterId != null) {
      map[columnCharacterId] = characterId;
    }
    return map;
  }
}

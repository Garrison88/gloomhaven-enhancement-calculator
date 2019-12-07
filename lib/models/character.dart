// database table and column names
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk.dart';

import 'player_class.dart';

final String tableCharacters = 'CharactersTable';
final String columnCharacterId = '_id';
final String columnCharacterName = 'Name';
final String columnCharacterClassCode = 'ClassCode';
final String columnCharacterClassColor = 'ClassColor';
final String columnCharacterClassIcon = 'ClassIcon';
final String columnCharacterXp = 'XP';
final String columnCharacterGold = 'Gold';
final String columnCharacterNotes = 'Notes';
final String columnCharacterCheckMarks = 'CheckMarks';
final String columnIsRetired = 'IsRetired';
// final String perksID = 'PerksForeignKey';

// data model class
class Character {
  int id;
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
  bool isRetired;

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
    id = map[columnCharacterId];
    name = map[columnCharacterName];
    classCode = map[columnCharacterClassCode];
    classColor = map[columnCharacterClassColor];
    classIcon = map[columnCharacterClassIcon];
    xp = map[columnCharacterXp];
    gold = map[columnCharacterGold];
    notes = map[columnCharacterNotes];
    checkMarks = map[columnCharacterCheckMarks];
    isRetired = map[columnIsRetired] == 1 ? true : false;
  }

  // convenience method to create a Map from this Character object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCharacterId: id,
      columnCharacterName: name,
      columnCharacterClassCode: playerClass.classCode,
      columnCharacterClassColor: playerClass.classColor,
      columnCharacterClassIcon: playerClass.classIconUrl,
      columnCharacterXp: xp,
      columnCharacterGold: gold,
      columnCharacterNotes: notes,
      columnCharacterCheckMarks: checkMarks,
      columnIsRetired: isRetired ? 1 : 0
    };
    //TODO: why was this here?
    // if (characterId != null) {
    //   map[columnCharacterId] = characterId;
    // }
    return map;
  }
}

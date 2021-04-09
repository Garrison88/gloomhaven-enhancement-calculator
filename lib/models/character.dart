// database table and column names
// import 'package:gloomhaven_enhancement_calc/ui/widgets/perk.dart';

final String tableCharacters = 'Characters';
final String columnCharacterId = '_id';
final String columnCharacterName = 'Name';
final String columnCharacterClassCode = 'ClassCode';
final String columnCharacterClassColor = 'ClassColor';
final String columnCharacterClassIcon = 'ClassIcon';
final String columnCharacterClassRace = 'ClassRace';
final String columnCharacterClassName = 'ClassName';
final String columnPreviousRetirements = 'PreviousRetirements';
final String columnCharacterXp = 'XP';
final String columnCharacterGold = 'Gold';
final String columnCharacterNotes = 'Notes';
final String columnCharacterCheckMarks = 'CheckMarks';
final String columnIsRetired = 'IsRetired';

// data model class
class Character {
  int id;
  String name;
  // PlayerClass playerClass;
  String classCode;
  String classColor;
  String classIcon;
  String classRace;
  String className;
  int previousRetirements;
  int xp;
  int gold;
  String notes;
  int checkMarks;
  // List<Perk> perksList;
  bool isRetired;
  // PlayerClass playerClass;

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
    classRace = map[columnCharacterClassRace];
    className = map[columnCharacterClassName];
    previousRetirements = map[columnPreviousRetirements];
    xp = map[columnCharacterXp];
    gold = map[columnCharacterGold];
    notes = map[columnCharacterNotes];
    checkMarks = map[columnCharacterCheckMarks];
    isRetired = map[columnIsRetired] == 1 ? true : false;
    // playerClass = map[PlayerClass.fromMap(map)];
  }

  // convenience method to create a Map from this Character object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCharacterId: id,
      columnCharacterName: name,
      columnCharacterClassCode: classCode,
      columnCharacterClassColor: classColor,
      columnCharacterClassIcon: classIcon,
      columnCharacterClassRace: classRace,
      columnCharacterClassName: className,
      columnPreviousRetirements: previousRetirements,
      columnCharacterXp: xp,
      columnCharacterGold: gold,
      columnCharacterNotes: notes,
      columnCharacterCheckMarks: checkMarks,
      columnIsRetired: isRetired ? 1 : 0
    };
    return map;
  }
}

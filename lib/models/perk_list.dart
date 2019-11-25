// database table and column names
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk.dart';

import 'player_class.dart';

final String tableCharacterPerks = 'CharacterPerks';
final String characterID = 'CharacterID';
final String perkDetails = 'Details';
// final String columnId = '_id';
// final String columnName = 'name';
// final String columnClassCode = 'classCode';
// final String columnClassColor = 'classColor';
// final String columnClassIcon = 'classIcon';
// final String columnXp = 'xp';
// final String columnGold = 'gold';
// final String columnNotes = 'notes';
// final String columnCheckMarks = 'checkMarks';

// data model class
class PerkList {
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

  PerkList(
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
    name = map[columnName];
    classCode = map[columnClassCode];
    classColor = map[columnClassColor];
    classIcon = map[columnClassIcon];
    xp = map[columnXp];
    gold = map[columnGold];
    notes = map[columnNotes];
    checkMarks = map[columnCheckMarks];
  }

  // convenience method to create a Map from this Character object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnClassCode: playerClass.classCode,
      columnClassColor: playerClass.classColor,
      columnClassIcon: playerClass.classIconUrl,
      columnXp: xp,
      columnGold: gold,
      columnNotes: notes,
      columnCheckMarks: checkMarks
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

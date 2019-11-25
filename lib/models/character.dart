// database table and column names
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk.dart';

import 'player_class.dart';

final String characters = 'Characters';
final String characterId = '_id';
final String characterName = 'CharacterName';
final String characterClassCode = 'CharacterClassCode';
final String characterClassColor = 'CharacterClassColor';
final String characterClassIcon = 'CharacterClassIcon';
final String characterXp = 'CharacterXp';
final String characterGold = 'CharacterGold';
final String characterNotes = 'CharacterNotes';
final String characterCheckMarks = 'CharacterCheckMarks';
final String perksID = 'PerksForeignKey';
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
    name = map[characterName];
    classCode = map[characterClassCode];
    classColor = map[characterClassColor];
    classIcon = map[characterClassIcon];
    xp = map[characterXp];
    gold = map[characterGold];
    notes = map[characterNotes];
    checkMarks = map[characterCheckMarks];
  }

  // convenience method to create a Map from this Character object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      characterName: name,
      characterClassCode: playerClass.classCode,
      characterClassColor: playerClass.classColor,
      characterClassIcon: playerClass.classIconUrl,
      characterXp: xp,
      characterGold: gold,
      characterNotes: notes,
      characterCheckMarks: checkMarks
    };
    if (id != null) {
      map[characterId] = id;
    }
    return map;
  }
}

import '../ui/widgets/perk.dart';

final String tablePlayerClass = 'PlayerClassTable';
final String columnClassCode = '_Code';
final String columnClassRace = 'Race';
final String columnClassName = 'Name';
final String columnClassIconUrl = 'IconUrl';
final String columnClassIsLocked = 'IsLocked';
final String columnClassColor = 'Color';

class PlayerClass {
  String race;
  String className;
  String classCode;
  String classIconUrl;
  bool locked;
  String classColor;
  List<Perk> perks;

  PlayerClass(this.race, this.className, this.classCode, this.classIconUrl,
      this.locked, this.classColor, this.perks);

  // convenience constructor to create a Character object
  PlayerClass.fromMap(Map<String, dynamic> map) {
    classCode = map[columnClassCode];
    race = map[columnClassRace];
    className = map[columnClassName];
    classIconUrl = map[columnClassIconUrl];
    locked = map[locked] == 1 ? true : false;
    classColor = map[columnClassColor];
  }

  // convenience method to create a Map from this Character object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnClassCode: classCode,
      columnClassRace: race,
      columnClassName: className,
      columnClassIconUrl: classIconUrl,
      columnClassIsLocked: locked ? 1 : 0,
      columnClassColor: classColor
    };
    return map;
  }
}

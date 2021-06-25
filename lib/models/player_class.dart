import 'package:gloomhaven_enhancement_calc/data/character_data.dart';

const String tablePlayerClass = 'PlayerClassTable';
const String columnClassCode = '_Code';
const String columnClassRace = 'Race';
const String columnClassName = 'Name';
const String columnClassIconUrl = 'IconUrl';
const String columnClassIsLocked = 'IsLocked';
const String columnClassColor = 'Color';

class PlayerClass {
  String race;
  String className;
  String classCode;
  String classIconUrl;
  ClassCategory classCategory;
  bool locked;
  String classColor;

  PlayerClass(
    this.race,
    this.className,
    this.classCode,
    this.classIconUrl,
    this.classCategory,
    this.locked,
    this.classColor,
  );

  // convenience constructor to create a PlayerClass object
  PlayerClass.fromMap(Map<String, dynamic> map) {
    classCode = map[columnClassCode];
    race = map[columnClassRace];
    className = map[columnClassName];
    classIconUrl = map[columnClassIconUrl];
    locked = map[locked] == 1 ? true : false;
    classColor = map[columnClassColor];
  }

  // convenience method to create a Map from this PlayerClass object
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

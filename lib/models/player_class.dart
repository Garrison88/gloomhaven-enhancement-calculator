enum ClassCategory {
  gloomhaven,
  jawsOfTheLion,
  frosthaven,
  crimsonScales,
  custom,
}

enum ClassVersion {
  original,
  frosthavenCrossover,
  v2,
  v3,
  v4,
}

class PlayerClass {
  String race;
  String name;
  String classCode;
  String icon;
  ClassCategory category;
  int primaryColor;
  int? secondaryColor;
  bool locked;
  List<String> traits;
  ClassVersion classVersion;

  PlayerClass({
    required this.race,
    required this.name,
    required this.classCode,
    required this.icon,
    required this.category,
    required this.primaryColor,
    this.secondaryColor = 0xff4e7ec1,
    this.locked = true,
    this.traits = const [],
    this.classVersion = ClassVersion.original,
  });
}

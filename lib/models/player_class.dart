import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';

enum ClassCategory {
  gloomhaven,
  jawsOfTheLion,
  frosthaven,
  crimsonScales,
  custom,
}

enum Variant {
  base,
  frosthavenCrossover,
  v2,
  v3,
  v4,
}

class PlayerClass {
  final String race;
  final String name;
  String classCode;
  final String icon;
  final ClassCategory category;
  final int primaryColor;
  final int? secondaryColor;
  final bool locked;
  final List<String> traits;

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
  });

  static List<Perks>? perkListByClassCode(String classCode) =>
      CharacterData.perksMap[classCode];
}

import 'package:flutter/material.dart';

enum ClassCategory {
  gloomhaven,
  jawsOfTheLion,
  frosthaven,
  crimsonScales,
  custom,
}

class PlayerClass {
  String race;
  String name;
  String classCode;
  String icon;
  ClassCategory category;
  int primaryColor;
  int secondaryColor;
  bool locked;
  List<String> traits;

  PlayerClass({
    @required this.race,
    @required this.name,
    @required this.classCode,
    @required this.icon,
    @required this.category,
    @required this.primaryColor,
    this.secondaryColor = 0xff4e7ec1,
    this.locked = true,
    this.traits = const [],
  });
}

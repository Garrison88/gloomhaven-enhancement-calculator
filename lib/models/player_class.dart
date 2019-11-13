import 'dart:ui';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk.dart';

import 'package:gloomhaven_companion/ui/perk.dart';

class PlayerClass {
  final String race;
  final String className;
  String classCode;
  final String icon;
  final bool locked;
  final Color color;
  final List<Perk> perks;

  PlayerClass(this.race, this.className, this.classCode, this.icon, this.locked,
      this.color, this.perks);
}

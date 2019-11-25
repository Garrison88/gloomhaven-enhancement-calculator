import '../ui/widgets/perk.dart';

class PlayerClass {
  final String race;
  final String className;
  String classCode;
  final String classIconUrl;
  final bool locked;
  final String classColor;
  final List<Perk> perks;

  PlayerClass(this.race, this.className, this.classCode, this.classIconUrl, this.locked,
      this.classColor, this.perks);
}

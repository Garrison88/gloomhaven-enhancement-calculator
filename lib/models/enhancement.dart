import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';

class Enhancement {
  final EnhancementCategory category;
  final String name;
  final int ghCost;
  final int? fhCost;
  final String? iconPath;
  final bool invertIconColor;

  Enhancement(
    this.category,
    this.name, {
    this.iconPath,
    this.ghCost = 0,
    this.fhCost,
    this.invertIconColor = false,
  });

  int cost({required bool gloomhavenMode}) =>
      gloomhavenMode ? ghCost : fhCost ?? ghCost;
}

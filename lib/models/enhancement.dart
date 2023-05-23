import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';

class Enhancement {
  final EnhancementCategory category;
  final String name;
  final int ghCost;
  final int fhCost;
  final String iconPath;
  final bool invertIconColor;

  Enhancement(
    this.category,
    this.name, {
    this.ghCost,
    this.iconPath,
    this.fhCost,
    this.invertIconColor = false,
  });

  int cost({
    bool gloomhavenMode,
  }) =>
      gloomhavenMode ? ghCost : fhCost ?? ghCost;
}

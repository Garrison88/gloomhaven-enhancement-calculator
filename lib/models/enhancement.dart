import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';

class Enhancement {
  final EnhancementCategory category;
  final int baseCost;
  final String icon;
  final bool invertColor;
  final String name;

  Enhancement(
    this.category,
    this.baseCost,
    this.icon,
    this.invertColor,
    this.name,
  );
}

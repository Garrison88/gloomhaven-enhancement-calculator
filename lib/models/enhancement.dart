import '../data/enhancement_data.dart';

class Enhancement {
  final EnhancementCategory category;
  final int ghCost;
  final int fhCost;
  final String icon;
  final bool invertColor;
  final String name;

  Enhancement(
    this.category,
    this.ghCost,
    this.icon,
    this.invertColor,
    this.name, {
    this.fhCost,
  });
}

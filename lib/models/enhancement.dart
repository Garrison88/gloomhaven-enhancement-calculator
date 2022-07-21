import '../data/enhancement_data.dart';

class Enhancement {
  final EnhancementCategory category;
  final int ghCost;
  final int fhCost;
  final String icon;
  final String name;
  final bool invertIconColor;

  Enhancement(
    this.category,
    this.ghCost,
    this.icon,
    this.name, {
    this.fhCost,
    this.invertIconColor = false,
  });
}

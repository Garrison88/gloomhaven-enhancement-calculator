import 'package:gloomhaven_enhancement_calc/enums/enhancement_category.dart';

class Enhancement {
  final EnhancementCategory category;
  final int baseCost;
  final String icon;
  final String name;

  Enhancement(this.category, this.baseCost, this.icon, this.name);
}

import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/models/game_edition.dart';

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

  int cost({required GameEdition edition}) {
    switch (edition) {
      case GameEdition.gloomhaven:
        return ghCost;
      case GameEdition.gloomhaven2e:
        // GH2E costs mostly match FH, fall back to GH if neither specified
        return fhCost ?? ghCost;
      case GameEdition.frosthaven:
        return fhCost ?? ghCost;
    }
  }
}

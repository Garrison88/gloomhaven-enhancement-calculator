import 'package:gloomhaven_enhancement_calc/data/perks/perks_repository.dart';
import 'package:gloomhaven_enhancement_calc/models/perk/perk.dart';

enum ClassCategory {
  gloomhaven,
  jawsOfTheLion,
  frosthaven,
  crimsonScales,
  custom,
}

enum Variant {
  base,
  frosthavenCrossover,
  gloomhaven2E,
  v2,
  v3,
  v4,
}

class PlayerClass {
  final String race;
  final String name;
  String classCode;
  final String icon;
  final ClassCategory category;
  final int primaryColor;
  final Map<Variant, String>? variantNames;
  final int? secondaryColor;
  final bool locked;
  final List<String> traits;

  PlayerClass({
    required this.race,
    required this.name,
    required this.classCode,
    required this.icon,
    required this.category,
    required this.primaryColor,
    this.variantNames,
    this.secondaryColor = 0xff4e7ec1,
    this.locked = true,
    this.traits = const [],
  });

  static List<Perks>? perkListByClassCode(String classCode) =>
      PerksRepository.perksMap[classCode];

  /// Get the display name for a specific variant
  String getDisplayName(Variant variant) {
    // Check if there's an override for this variant
    if (variantNames != null && variantNames!.containsKey(variant)) {
      return variantNames![variant]!;
    }
    // Fall back to base name
    return name;
  }

  /// Get the full display name including race
  String getFullDisplayName(Variant variant) {
    return '$race ${getDisplayName(variant)}';
  }

  /// Check if this class has a custom name for the given variant
  bool hasVariantName(Variant variant) {
    return variantNames?.containsKey(variant) ?? false;
  }

  /// Get a combined display name for search/selection (e.g., "Brute/Bruiser")
  /// Shows all unique variant names separated by "/"
  String getCombinedDisplayNames({String? delimeter}) {
    if (variantNames == null || variantNames!.isEmpty) {
      return name;
    }

    // Get all unique names (base + variants)
    final Set<String> allNames = <String>{name};
    allNames.addAll(variantNames!.values);

    return allNames.join(delimeter ?? ' / ');
  }
}

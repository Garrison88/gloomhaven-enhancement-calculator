// ============================================================================
// SVG THEME MODE
// ============================================================================

/// Defines how an SVG asset's colors should adapt to the app theme.
///
/// Uses a sealed class hierarchy to make invalid states unrepresentable.
/// Previously this was two mutually-exclusive booleans.
sealed class SvgThemeMode {
  const SvgThemeMode();
}

/// No theming - renders SVG exactly as defined in the file.
///
/// Use this for:
/// - Icons that look good on both light and dark backgrounds as-is
/// - Colorful icons that don't need theme adaptation
class NoTheme extends SvgThemeMode {
  const NoTheme();
}

/// Modern approach: only `currentColor` parts change with theme.
///
/// Parts of the SVG that use `fill="currentColor"` or `stroke="currentColor"`
/// will change based on the theme:
/// - In dark mode: `currentColor` parts become white
/// - In light mode: `currentColor` parts become black
///
/// Other colors in the SVG are preserved.
///
/// This works for both **monochrome icons** (where the entire icon uses
/// `currentColor`) and **multi-color icons** (where only specific parts like
/// borders use `currentColor` while other colors stay fixed).
///
/// Examples:
/// - Move icon, Attack icon - entire icon uses `fill="currentColor"`
/// - Wild element icon - colorful pie chart stays the same, but the border
///   uses `currentColor` and adapts to the theme
class CurrentColorTheme extends SvgThemeMode {
  const CurrentColorTheme();
}

/// Legacy/deprecated: tints entire SVG white in dark mode.
///
/// Applies a color filter to tint the entire SVG white in dark mode.
/// This is deprecated in favor of [CurrentColorTheme] with properly configured
/// SVG assets that use `currentColor` for theme-aware parts.
///
/// Only use this for SVGs that cannot be converted to use `currentColor`
/// (e.g., embedded raster images).
@Deprecated('Migrate SVGs to use currentColor instead')
class ForegroundColorTheme extends SvgThemeMode {
  const ForegroundColorTheme();
}

// ============================================================================
// ASSET CONFIG
// ============================================================================

/// Configuration for how an SVG asset should be rendered and themed.
class AssetConfig {
  /// The file path to the SVG asset (relative to images/ directory).
  final String? path;

  /// How the SVG's colors should adapt to the app theme.
  final SvgThemeMode themeMode;

  /// Width multiplier for non-square icons.
  /// Default is 1.0 (square). Use 1.5, 2.0, 3.0 for wider icons.
  final double widthMultiplier;

  const AssetConfig(
    this.path, {
    this.themeMode = const NoTheme(),
    this.widthMultiplier = 1.0,
  });

  /// Convenience getters for backward compatibility during migration.
  /// These can be removed once all code uses [themeMode] directly.
  bool get usesCurrentColor => themeMode is CurrentColorTheme;

  // ignore: deprecated_member_use_from_same_package
  bool get usesForegroundColor => themeMode is ForegroundColorTheme;
}

// ============================================================================
// ASSET MAPS
// ============================================================================

/// Assets that require different files for light/dark themes.
/// These cannot be converted to use currentColor because they need
/// fundamentally different graphics per theme.
final themeSpecificAssets = {
  'REFRESH': (bool darkTheme) =>
      AssetConfig(darkTheme ? 'refresh.svg' : 'refresh_light.svg'),
  'SPENT': (bool darkTheme) =>
      AssetConfig(darkTheme ? 'spent.svg' : 'spent_light.svg'),
  'PERSISTENT': (bool darkTheme) =>
      AssetConfig(darkTheme ? 'persistent.svg' : 'persistent_light.svg'),
  'DAMAGE': (bool darkTheme) =>
      AssetConfig(darkTheme ? 'damage.svg' : 'damage_light.svg'),
  'item_minus_one': (bool darkTheme) => AssetConfig(
    darkTheme ? 'item_minus_one_light.svg' : 'item_minus_one.svg',
    widthMultiplier: 1.5,
  ),
};

/// Standard assets that use the same file regardless of theme.
/// Theme adaptation is handled via [SvgThemeMode].
const standardAssets = {
  // Attack modifiers
  'NULL': AssetConfig('attack_modifiers/null.svg'),
  '-2': AssetConfig('attack_modifiers/minus_2.svg'),
  '-1': AssetConfig('attack_modifiers/minus_1.svg'),
  '+0': AssetConfig('attack_modifiers/plus_0.svg'),
  '+X': AssetConfig('attack_modifiers/plus_x.svg'),
  '2x': AssetConfig('attack_modifiers/2_x.svg'),
  '+1': AssetConfig('attack_modifiers/plus_1.svg'),
  '+2': AssetConfig('attack_modifiers/plus_2.svg'),
  '+3': AssetConfig('attack_modifiers/plus_3.svg'),
  '+4': AssetConfig('attack_modifiers/plus_4.svg'),

  // Pips
  'pip_square': AssetConfig('pips/square.svg'),
  'pip_circle': AssetConfig('pips/circle.svg'),
  'pip_diamond_plus': AssetConfig('pips/diamond_plus.svg'),
  'pip_diamond': AssetConfig('pips/diamond.svg'),
  'pip_hex': AssetConfig('pips/hex.svg'),
  'pip_plus_one': AssetConfig('pips/pip_plus_one.svg'),

  // Equipment slots
  'One_Hand': AssetConfig(
    'equipment_slots/one_handed.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Two_Hand': AssetConfig(
    'equipment_slots/two_handed.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Head': AssetConfig(
    'equipment_slots/head.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Body': AssetConfig(
    'equipment_slots/body.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Pocket': AssetConfig(
    'equipment_slots/pocket.svg',
    themeMode: CurrentColorTheme(),
  ),

  // Movement and actions
  'MOVE': AssetConfig('move.svg', themeMode: CurrentColorTheme()),
  'FLYING': AssetConfig('flying.svg', themeMode: CurrentColorTheme()),
  'JUMP': AssetConfig('jump.svg', themeMode: CurrentColorTheme()),
  'SHIELD': AssetConfig('shield.svg', themeMode: CurrentColorTheme()),
  'TELEPORT': AssetConfig('teleport.svg', themeMode: CurrentColorTheme()),
  'PUSH': AssetConfig('push.svg'),
  'PULL': AssetConfig('pull.svg'),
  'RECOVER': AssetConfig('recover_card.svg', themeMode: CurrentColorTheme()),
  'LOSS': AssetConfig('loss.svg', themeMode: CurrentColorTheme()),
  'TARGET_CIRCLE': AssetConfig(
    'target_circle.svg',
    themeMode: CurrentColorTheme(),
  ),
  'HEAL': AssetConfig('heal.svg', themeMode: CurrentColorTheme()),
  'SHUFFLE': AssetConfig('shuffle.svg', themeMode: CurrentColorTheme()),

  // Status effects
  'STUN': AssetConfig('stun.svg'),
  'WOUND': AssetConfig('wound.svg'),
  'CURSE': AssetConfig('curse.svg'),
  'PIERCE': AssetConfig('pierce.svg'),
  'REGENERATE': AssetConfig('regenerate.svg'),
  'DISARM': AssetConfig('disarm.svg'),
  'BLESS': AssetConfig('bless.svg'),
  'SAFEGUARD': AssetConfig('safeguard.svg'),
  'IMMOBILIZE': AssetConfig('immobilize.svg'),
  'POISON': AssetConfig('poison.svg'),
  'MUDDLE': AssetConfig('muddle.svg'),
  'INVISIBLE': AssetConfig('invisible.svg'),
  'STRENGTHEN': AssetConfig('strengthen.svg'),
  'CHILL': AssetConfig('chill.svg'),
  'PROVOKE': AssetConfig('provoke.svg'),
  'BRITTLE': AssetConfig('brittle.svg'),
  'WARD': AssetConfig('ward.svg'),
  'RUPTURE': AssetConfig('rupture.svg'),
  'EMPOWER': AssetConfig('empower.svg'),
  'ENFEEBLE': AssetConfig('enfeeble.svg'),
  'INFECT': AssetConfig('infect.svg'),
  'DODGE': AssetConfig('dodge.svg'),
  'IMPAIR': AssetConfig('impair.svg'),
  'BANE': AssetConfig('bane.svg'),

  // Combat related
  'TARGET_DIAMOND': AssetConfig('target.svg'),
  'RANGE': AssetConfig('range.svg', themeMode: CurrentColorTheme()),
  'LOOT': AssetConfig('loot.svg', themeMode: CurrentColorTheme()),
  'RETALIATE': AssetConfig('retaliate.svg', themeMode: CurrentColorTheme()),
  'ATTACK': AssetConfig('attack.svg', themeMode: CurrentColorTheme()),
  'Rolling': AssetConfig('rolling.svg'),

  // Other
  'xp': AssetConfig('xp.svg', themeMode: CurrentColorTheme()),
  'SECTION': AssetConfig('section.svg', themeMode: CurrentColorTheme()),
  'plus_one': AssetConfig('plus_one.svg'),
  'hp': AssetConfig('hp.svg', themeMode: CurrentColorTheme()),
  'hex': AssetConfig('hex.svg'), // Multi-color icon, no theming needed
  // Class-specific abilities and icons
  'Shackle': AssetConfig(
    'class_icons/chainguard.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Shackled': AssetConfig(
    'class_icons/chainguard.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Cultivate': AssetConfig('cultivate.svg', themeMode: CurrentColorTheme()),
  'Chieftain': AssetConfig(
    'class_icons/chieftain.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Boneshaper': AssetConfig(
    'class_icons/boneshaper.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Berserker': AssetConfig(
    'class_icons/berserker.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Doomstalker': AssetConfig(
    'class_icons/doomstalker.svg',
    themeMode: CurrentColorTheme(),
  ),
  'Bladeswarm': AssetConfig(
    'class_icons/bladeswarm.svg',
    themeMode: CurrentColorTheme(),
  ),
  'HAIL': AssetConfig('class_icons/hail.svg', themeMode: CurrentColorTheme()),
  'Glow': AssetConfig('glow.svg'),
  'Spirit': AssetConfig(
    'class_icons/spirit_caller.svg',
    themeMode: CurrentColorTheme(),
  ),
  'SWING': AssetConfig('swing.svg'),
  'SATED': AssetConfig('sated.svg'),
  'Ladder': AssetConfig('ladder.svg', themeMode: CurrentColorTheme()),
  'Shrug_Off': AssetConfig('shrug_off.svg', themeMode: CurrentColorTheme()),
  'Projectile': AssetConfig(
    'class_icons/bombard.svg',
    themeMode: CurrentColorTheme(),
  ),
  'VOID': AssetConfig('void.svg'),
  'VOIDSIGHT': AssetConfig('voidsight.svg', themeMode: CurrentColorTheme()),
  'CONQUEROR': AssetConfig('conqueror.svg'),
  'REAVER': AssetConfig('reaver.svg'),
  'RITUALIST': AssetConfig('ritualist.svg'),
  'ALL_STANCES': AssetConfig('incarnate_all_stances.svg', widthMultiplier: 3.0),
  // TODO: Replace crystallize.svg with vector version, then switch to CurrentColorTheme
  // ignore: deprecated_member_use_from_same_package
  'CRYSTALLIZE': AssetConfig(
    'crystallize.svg',
    themeMode: ForegroundColorTheme(),
  ),
  // TODO: Replace spark.svg with vector version, then switch to CurrentColorTheme
  // ignore: deprecated_member_use_from_same_package
  'SPARK': AssetConfig('spark.svg', themeMode: ForegroundColorTheme()),
  // ignore: deprecated_member_use_from_same_package
  'consume_SPARK': AssetConfig('spark.svg', themeMode: ForegroundColorTheme()),
  'RAGE': AssetConfig(
    'class_icons/vanquisher.svg',
    themeMode: CurrentColorTheme(),
  ),
  'PROJECT': AssetConfig('project.svg', themeMode: CurrentColorTheme()),
  'BARRIER_PLUS': AssetConfig(
    'barrier_plus.svg',
    themeMode: CurrentColorTheme(),
  ),
  'CRITTERS': AssetConfig('critters.svg', themeMode: CurrentColorTheme()),
  'LUMINARY_HEXES': AssetConfig('luminary_hexes.svg', widthMultiplier: 1.5),
  'SHADOW': AssetConfig('shadow.svg'),
  'TIME_TOKEN': AssetConfig('time_token.svg'),
  'PERSIST': AssetConfig('persist.svg', themeMode: CurrentColorTheme()),
  'RESONANCE': AssetConfig('resonance.svg'),
  'INFUSION': AssetConfig('infusion.svg'),
  'TRANSFER': AssetConfig('transfer.svg', widthMultiplier: 2.0),
  'TIDE': AssetConfig('tide.svg'),
  'TROPHY': AssetConfig('trophy.svg'),
  'PRESSURE_LOSE': AssetConfig('pressure_lose.svg'),
  'PRESSURE_GAIN': AssetConfig('pressure_gain.svg'),
  'PRESSURE_LOW': AssetConfig('pressure_low.svg'),
  'PRESSURE_HIGH': AssetConfig('pressure_high.svg'),
  'EXPERIMENT': AssetConfig('experiment.svg'),
  'RESOLVE': AssetConfig('resolve.svg', themeMode: CurrentColorTheme()),

  // Elements and their combinations
  'EARTH': AssetConfig('elem_earth.svg', themeMode: CurrentColorTheme()),
  'consume_EARTH': AssetConfig(
    'elem_earth.svg',
    themeMode: CurrentColorTheme(),
  ),
  'AIR': AssetConfig('elem_air.svg', themeMode: CurrentColorTheme()),
  'consume_AIR': AssetConfig('elem_air.svg', themeMode: CurrentColorTheme()),
  'DARK': AssetConfig('elem_dark.svg', themeMode: CurrentColorTheme()),
  'consume_DARK': AssetConfig('elem_dark.svg', themeMode: CurrentColorTheme()),
  'LIGHT': AssetConfig('elem_light.svg', themeMode: CurrentColorTheme()),
  'consume_LIGHT': AssetConfig(
    'elem_light.svg',
    themeMode: CurrentColorTheme(),
  ),
  'ICE': AssetConfig('elem_ice.svg', themeMode: CurrentColorTheme()),
  'consume_ICE': AssetConfig('elem_ice.svg', themeMode: CurrentColorTheme()),
  'FIRE': AssetConfig('elem_fire.svg', themeMode: CurrentColorTheme()),
  'consume_FIRE': AssetConfig('elem_fire.svg', themeMode: CurrentColorTheme()),
  'Wild_Element': AssetConfig('elem_wild.svg', themeMode: CurrentColorTheme()),
  'consume_Wild_Element': AssetConfig(
    'elem_wild.svg',
    themeMode: CurrentColorTheme(),
  ),
  'AIR/DARK': AssetConfig('elem_air_or_dark.svg', widthMultiplier: 2.0),
  'consume_AIR/DARK': AssetConfig('elem_air_or_dark.svg', widthMultiplier: 2.0),
  'AIR/EARTH': AssetConfig('elem_air_or_earth.svg', widthMultiplier: 2.0),
  'consume_AIR/EARTH': AssetConfig(
    'elem_air_or_earth.svg',
    widthMultiplier: 2.0,
  ),
  'AIR/LIGHT': AssetConfig('elem_air_or_light.svg', widthMultiplier: 2.0),
  'consume_AIR/LIGHT': AssetConfig(
    'elem_air_or_light.svg',
    widthMultiplier: 2.0,
  ),
  'EARTH/DARK': AssetConfig('elem_earth_or_dark.svg', widthMultiplier: 2.0),
  'consume_EARTH/DARK': AssetConfig(
    'elem_earth_or_dark.svg',
    widthMultiplier: 2.0,
  ),
  'EARTH/LIGHT': AssetConfig('elem_earth_or_light.svg', widthMultiplier: 2.0),
  'consume_EARTH/LIGHT': AssetConfig(
    'elem_earth_or_light.svg',
    widthMultiplier: 2.0,
  ),
  'FIRE/AIR': AssetConfig('elem_fire_or_air.svg', widthMultiplier: 2.0),
  'consume_FIRE/AIR': AssetConfig('elem_fire_or_air.svg', widthMultiplier: 2.0),
  'FIRE/DARK': AssetConfig('elem_fire_or_dark.svg', widthMultiplier: 2.0),
  'consume_FIRE/DARK': AssetConfig(
    'elem_fire_or_dark.svg',
    widthMultiplier: 2.0,
  ),
  'FIRE/EARTH': AssetConfig('elem_fire_or_earth.svg', widthMultiplier: 2.0),
  'consume_FIRE/EARTH': AssetConfig(
    'elem_fire_or_earth.svg',
    widthMultiplier: 2.0,
  ),
  'FIRE/ICE': AssetConfig('elem_fire_or_ice.svg', widthMultiplier: 2.0),
  'consume_FIRE/ICE': AssetConfig('elem_fire_or_ice.svg', widthMultiplier: 2.0),
  'FIRE/LIGHT': AssetConfig('elem_fire_or_light.svg', widthMultiplier: 2.0),
  'consume_FIRE/LIGHT': AssetConfig(
    'elem_fire_or_light.svg',
    widthMultiplier: 2.0,
  ),
  'ICE/AIR': AssetConfig('elem_ice_or_air.svg', widthMultiplier: 2.0),
  'consume_ICE/AIR': AssetConfig('elem_ice_or_air.svg', widthMultiplier: 2.0),
  'ICE/DARK': AssetConfig('elem_ice_or_dark.svg', widthMultiplier: 2.0),
  'consume_ICE/DARK': AssetConfig('elem_ice_or_dark.svg', widthMultiplier: 2.0),
  'ICE/EARTH': AssetConfig('elem_ice_or_earth.svg', widthMultiplier: 2.0),
  'consume_ICE/EARTH': AssetConfig(
    'elem_ice_or_earth.svg',
    widthMultiplier: 2.0,
  ),
  'ICE/LIGHT': AssetConfig('elem_ice_or_light.svg', widthMultiplier: 2.0),
  'consume_ICE/LIGHT': AssetConfig(
    'elem_ice_or_light.svg',
    widthMultiplier: 2.0,
  ),
  'LIGHT/DARK': AssetConfig('elem_light_or_dark.svg', widthMultiplier: 2.0),
  'consume_LIGHT/DARK': AssetConfig(
    'elem_light_or_dark.svg',
    widthMultiplier: 2.0,
  ),
  'FIRE/ICE/EARTH': AssetConfig(
    'elem_fire_ice_earth.svg',
    themeMode: CurrentColorTheme(),
    widthMultiplier: 3.0,
  ),
  'Vial_Wild': AssetConfig('vial_wild.svg', themeMode: CurrentColorTheme()),
};

/// Get asset configuration for a given element
///
/// This function cleans the input string and returns the appropriate
/// asset path and color inversion settings.
///
/// Special handling for:
/// - XP values (xp8 -> xp.svg)
/// - Theme-dependent assets (different icons for light/dark themes)
/// - Standard game assets
/// - File path lookups (e.g., 'move.svg' finds config for 'MOVE')
AssetConfig getAssetConfig(String element, bool darkTheme) {
  // Clean the input string - remove punctuation
  String cleanElement = element.replaceAll(
    RegExp(
      r"[,.:()"
      "'"
      '"'
      "]",
    ),
    '',
  );

  // Handle XP pattern (xp8, xp10, etc.)
  if (RegExp(r'^xp\d+$').hasMatch(cleanElement)) {
    return const AssetConfig('xp.svg', themeMode: CurrentColorTheme());
  }

  // Check theme-specific assets first (by key)
  final themeAsset = themeSpecificAssets[cleanElement];
  if (themeAsset != null) {
    return themeAsset(darkTheme);
  }

  // Check standard assets (by key)
  final standardAsset = standardAssets[cleanElement];
  if (standardAsset != null) {
    return standardAsset;
  }

  // Fallback: search by file path (e.g., 'move.svg' -> find 'MOVE' config)
  // This handles cases where Enhancement.iconPath is used as the key
  for (final entry in themeSpecificAssets.entries) {
    final config = entry.value(darkTheme);
    if (config.path == cleanElement) {
      return config;
    }
  }
  for (final entry in standardAssets.entries) {
    if (entry.value.path == cleanElement) {
      return entry.value;
    }
  }

  // No configuration found - return default with the element as path
  return const AssetConfig(null);
}

/// Configuration for how an SVG asset should be colored based on the app theme.
///
/// ## [usesCurrentColor] (preferred)
/// When `true`, parts of the SVG that use `currentColor` in their fill or stroke
/// will change based on the theme. Other colors remain unchanged.
/// - In dark mode: `currentColor` parts become white
/// - In light mode: `currentColor` parts become black
///
/// This works for both **monochrome icons** (where the entire icon uses
/// `currentColor`) and **multi-color icons** (where only specific parts like
/// borders use `currentColor` while other colors stay fixed).
///
/// Examples:
/// - Move icon, Attack icon - entire icon uses `fill="currentColor"`
/// - Wild element icon - colorful pie chart stays the same, but the border
///   uses `currentColor` and adapts to the theme
///
/// ## [usesForegroundColor] (deprecated)
/// Legacy approach that applies a color filter to tint the entire SVG white
/// in dark mode. This is deprecated in favor of [usesCurrentColor] with
/// properly configured SVG assets that use `currentColor` for theme-aware parts.
///
/// Only use this for SVGs that cannot be converted to use `currentColor`
/// (e.g., embedded raster images).
///
/// ## Neither flag set
/// The SVG renders exactly as defined in the file with no color modifications.
/// Use this for icons that look good on both light and dark backgrounds as-is,
/// or for colorful icons that don't need theme adaptation.
class AssetConfig {
  final String? path;

  /// @deprecated Use [usesCurrentColor] with SVGs that have `currentColor` fills.
  ///
  /// When true, tints the entire SVG white in dark mode using a color filter.
  /// Only use for legacy SVGs that cannot be converted (e.g., embedded images).
  final bool usesForegroundColor;

  /// When true, sets the SVG's `currentColor` value based on theme.
  /// Only affects parts of the SVG that explicitly use `currentColor`.
  /// This is the preferred approach for theme-aware icons.
  final bool usesCurrentColor;

  /// Width multiplier for non-square icons.
  /// Default is 1.0 (square). Use 1.5, 2.0, 3.0 for wider icons.
  final double widthMultiplier;

  /// When true, overlays a +1 badge on the icon.
  /// Used for ATTACK+1, MOVE+1, HEAL+1, TARGET_CIRCLE+1 variants.
  final bool hasPlusOneOverlay;

  const AssetConfig(
    this.path, {
    @Deprecated('Prefer useCurrentColor with corrected SVG assets')
    this.usesForegroundColor = false,
    this.usesCurrentColor = false,
    this.widthMultiplier = 1.0,
    this.hasPlusOneOverlay = false,
  });
}

// Create a map for theme-dependent assets
final themeSpecificAssets = {
  // Must remain two separate assets
  'REFRESH': (bool darkTheme) =>
      AssetConfig(darkTheme ? 'refresh.svg' : 'refresh_light.svg'),
  // Must remain two separate assets
  'SPENT': (bool darkTheme) =>
      AssetConfig(darkTheme ? 'spent.svg' : 'spent_light.svg'),
  // Must remain two separate assets
  'PERSISTENT': (bool darkTheme) =>
      AssetConfig(darkTheme ? 'persistent.svg' : 'persistent_light.svg'),
  // Must remain two separate assets
  'DAMAGE': (bool darkTheme) =>
      AssetConfig(darkTheme ? 'damage.svg' : 'damage_light.svg'),
  'item_minus_one': (bool darkTheme) => AssetConfig(
    darkTheme ? 'item_minus_one_light.svg' : 'item_minus_one.svg',
    widthMultiplier: 1.5,
  ),
};

// Create a map for standard assets
const standardAssets = {
  // Attack modifiers
  'NULL': AssetConfig('attack_modifiers/null.svg'),
  'SHUFFLE': AssetConfig('shuffle.svg', usesCurrentColor: true),
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
    usesCurrentColor: true,
  ),
  'Two_Hand': AssetConfig(
    'equipment_slots/two_handed.svg',
    usesCurrentColor: true,
  ),
  'Head': AssetConfig('equipment_slots/head.svg', usesCurrentColor: true),
  'Body': AssetConfig('equipment_slots/body.svg', usesCurrentColor: true),
  'Pocket': AssetConfig('equipment_slots/pocket.svg', usesCurrentColor: true),

  // Movement and actions
  'MOVE': AssetConfig('move.svg', usesCurrentColor: true),
  'MOVE+1': AssetConfig(
    'move.svg',
    usesCurrentColor: true,
    hasPlusOneOverlay: true,
  ),
  'FLYING': AssetConfig('flying.svg', usesCurrentColor: true),
  'JUMP': AssetConfig('jump.svg', usesCurrentColor: true),
  'SHIELD': AssetConfig('shield.svg', usesCurrentColor: true),
  'TELEPORT': AssetConfig('teleport.svg', usesCurrentColor: true),
  'PUSH': AssetConfig('push.svg'),
  'PULL': AssetConfig('pull.svg'),
  'RECOVER': AssetConfig('recover_card.svg', usesCurrentColor: true),
  'LOSS': AssetConfig('loss.svg', usesCurrentColor: true),
  'TARGET_CIRCLE': AssetConfig('target_circle.svg', usesCurrentColor: true),
  'TARGET_CIRCLE+1': AssetConfig(
    'target_circle.svg',
    usesCurrentColor: true,
    hasPlusOneOverlay: true,
  ),
  'HEAL': AssetConfig('heal.svg', usesCurrentColor: true),
  'HEAL+1': AssetConfig(
    'heal.svg',
    usesCurrentColor: true,
    hasPlusOneOverlay: true,
  ),

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
  'RANGE': AssetConfig('range.svg', usesCurrentColor: true),
  'LOOT': AssetConfig('loot.svg', usesCurrentColor: true),
  'RETALIATE': AssetConfig('retaliate.svg', usesCurrentColor: true),
  'ATTACK': AssetConfig('attack.svg', usesCurrentColor: true),
  'ATTACK+1': AssetConfig(
    'attack.svg',
    usesCurrentColor: true,
    hasPlusOneOverlay: true,
  ),
  'Rolling': AssetConfig('rolling.svg'),

  // Other
  'xp': AssetConfig('xp.svg', usesCurrentColor: true),
  'SECTION': AssetConfig('section.svg', usesCurrentColor: true),
  'plus_one': AssetConfig('plus_one.svg'),
  'hp': AssetConfig('hp.svg', usesCurrentColor: true),
  'hex': AssetConfig('hex.svg'), // Multi-color icon, no theming needed
  // Class-specific abilities and icons
  'Shackle': AssetConfig('class_icons/chainguard.svg', usesCurrentColor: true),
  'Shackled': AssetConfig('class_icons/chainguard.svg', usesCurrentColor: true),
  'Cultivate': AssetConfig('cultivate.svg', usesCurrentColor: true),
  'Chieftain': AssetConfig('class_icons/chieftain.svg', usesCurrentColor: true),
  'Boneshaper': AssetConfig(
    'class_icons/boneshaper.svg',
    usesCurrentColor: true,
  ),
  'Berserker': AssetConfig('class_icons/berserker.svg', usesCurrentColor: true),
  'Doomstalker': AssetConfig(
    'class_icons/doomstalker.svg',
    usesCurrentColor: true,
  ),
  'Bladeswarm': AssetConfig(
    'class_icons/bladeswarm.svg',
    usesCurrentColor: true,
  ),
  'HAIL': AssetConfig('class_icons/hail.svg', usesCurrentColor: true),
  'Glow': AssetConfig('glow.svg'),
  'Spirit': AssetConfig(
    'class_icons/spirit_caller.svg',
    usesCurrentColor: true,
  ),
  'SWING': AssetConfig('swing.svg'),
  'SATED': AssetConfig('sated.svg'),
  'Ladder': AssetConfig('ladder.svg', usesCurrentColor: true),
  'Shrug_Off': AssetConfig('shrug_off.svg', usesCurrentColor: true),
  'Projectile': AssetConfig('class_icons/bombard.svg', usesCurrentColor: true),
  'VOID': AssetConfig('void.svg'),
  'VOIDSIGHT': AssetConfig('voidsight.svg', usesCurrentColor: true),
  'CONQUEROR': AssetConfig('conqueror.svg'),
  'REAVER': AssetConfig('reaver.svg'),
  'RITUALIST': AssetConfig('ritualist.svg'),
  'ALL_STANCES': AssetConfig('incarnate_all_stances.svg', widthMultiplier: 3.0),
  // TODO: Replace crystallize.svg with vector version, then switch to usesCurrentColor
  'CRYSTALLIZE': AssetConfig('crystallize.svg', usesForegroundColor: true),
  // TODO: Replace spark.svg with vector version, then switch to usesCurrentColor
  'SPARK': AssetConfig('spark.svg', usesForegroundColor: true),
  'consume_SPARK': AssetConfig('spark.svg', usesForegroundColor: true),
  'RAGE': AssetConfig('class_icons/vanquisher.svg', usesCurrentColor: true),
  'PROJECT': AssetConfig('project.svg', usesCurrentColor: true),
  'BARRIER_PLUS': AssetConfig('barrier_plus.svg', usesCurrentColor: true),
  'CRITTERS': AssetConfig('critters.svg', usesCurrentColor: true),
  'LUMINARY_HEXES': AssetConfig('luminary_hexes.svg', widthMultiplier: 1.5),
  'SHADOW': AssetConfig('shadow.svg'),
  'TIME_TOKEN': AssetConfig('time_token.svg'),
  'PERSIST': AssetConfig('persist.svg', usesCurrentColor: true),
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
  'RESOLVE': AssetConfig('resolve.svg', usesCurrentColor: true),

  // Elements and their combinations
  'EARTH': AssetConfig('elem_earth.svg', usesCurrentColor: true),
  'consume_EARTH': AssetConfig('elem_earth.svg', usesCurrentColor: true),
  'AIR': AssetConfig('elem_air.svg', usesCurrentColor: true),
  'consume_AIR': AssetConfig('elem_air.svg', usesCurrentColor: true),
  'DARK': AssetConfig('elem_dark.svg', usesCurrentColor: true),
  'consume_DARK': AssetConfig('elem_dark.svg', usesCurrentColor: true),
  'LIGHT': AssetConfig('elem_light.svg', usesCurrentColor: true),
  'consume_LIGHT': AssetConfig('elem_light.svg', usesCurrentColor: true),
  'ICE': AssetConfig('elem_ice.svg', usesCurrentColor: true),
  'consume_ICE': AssetConfig('elem_ice.svg', usesCurrentColor: true),
  'FIRE': AssetConfig('elem_fire.svg', usesCurrentColor: true),
  'consume_FIRE': AssetConfig('elem_fire.svg', usesCurrentColor: true),
  'Wild_Element': AssetConfig('elem_wild.svg', usesCurrentColor: true),
  'consume_Wild_Element': AssetConfig('elem_wild.svg', usesCurrentColor: true),
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
    usesCurrentColor: true,
    widthMultiplier: 3.0,
  ),
  'Vial_Wild': AssetConfig('vial_wild.svg', usesCurrentColor: true),
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
    return const AssetConfig('xp.svg', usesCurrentColor: true);
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

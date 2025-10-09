// Define a class to hold both the asset path and invert color flag
class AssetConfig {
  final String? path;
  final bool invertColor;

  const AssetConfig(this.path, {this.invertColor = false});
}

// Create a map for theme-dependent assets
final themeSpecificAssets = {
  'HEAL': (bool darkTheme) => AssetConfig(
        darkTheme ? 'heal.svg' : 'heal_light.svg',
      ),
  'HEAL+1': (bool darkTheme) => AssetConfig(
        darkTheme ? 'heal.svg' : 'heal_light.svg',
      ),
  'Target': (bool darkTheme) => AssetConfig(
        darkTheme ? 'target_alt.svg' : 'target_alt_light.svg',
      ),
  'Target+1': (bool darkTheme) => AssetConfig(
        darkTheme ? 'target_alt.svg' : 'target_alt_light.svg',
      ),
  'RECOVER': (bool darkTheme) => AssetConfig(
        darkTheme ? 'recover_card.svg' : 'recover_card_light.svg',
      ),
  'REFRESH': (bool darkTheme) => AssetConfig(
        darkTheme ? 'refresh_item.svg' : 'refresh_item_light.svg',
      ),
  'SPENT': (bool darkTheme) => AssetConfig(
        darkTheme ? 'spent.svg' : 'spent_light.svg',
      ),
  'LOSS': (bool darkTheme) => AssetConfig(
        darkTheme ? 'loss.svg' : 'loss_light.svg',
      ),
  'DAMAGE': (bool darkTheme) => AssetConfig(
        darkTheme ? 'damage.svg' : 'damage_light.svg',
      ),
  'item_minus_one': (bool darkTheme) => AssetConfig(
        darkTheme ? 'item_minus_one_light.svg' : 'item_minus_one.svg',
      ),
};

// Create a map for standard assets
const standardAssets = {
  // Attack modifiers
  'NULL': AssetConfig('attack_modifiers/null.svg'),
  'SHUFFLE': AssetConfig('shuffle.svg', invertColor: true),
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
  'One_Hand': AssetConfig('equipment_slots/one_handed.svg', invertColor: true),
  'Two_Hand': AssetConfig('equipment_slots/two_handed.svg', invertColor: true),
  'Head': AssetConfig('equipment_slots/head.svg', invertColor: true),
  'Body': AssetConfig('equipment_slots/body.svg', invertColor: true),
  'Pocket': AssetConfig('equipment_slots/pocket.svg', invertColor: true),

  // Movement and actions
  'MOVE': AssetConfig('move.svg', invertColor: true),
  'MOVE+1': AssetConfig('move.svg', invertColor: true),
  'JUMP': AssetConfig('jump.svg', invertColor: true),
  'SHIELD': AssetConfig('shield.svg', invertColor: true),
  'TELEPORT': AssetConfig('teleport.svg', invertColor: true),
  'PUSH': AssetConfig('push.svg'),
  'PULL': AssetConfig('pull.svg'),

  // Status effects
  'STUN': AssetConfig('stun.svg'),
  'WOUND': AssetConfig('wound.svg'),
  'CURSE': AssetConfig('curse.svg'),
  'PIERCE': AssetConfig('pierce.svg'),
  'REGENERATE': AssetConfig('regenerate.svg'),
  'DISARM': AssetConfig('disarm.svg'),
  'BLESS': AssetConfig('bless.svg'),
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
  'TARGET': AssetConfig('target.svg'),
  'RANGE': AssetConfig('range.svg', invertColor: true),
  'RANGE+1': AssetConfig('range.svg', invertColor: true),
  'LOOT': AssetConfig('loot.svg', invertColor: true),
  'RETALIATE': AssetConfig('retaliate.svg', invertColor: true),
  'ATTACK': AssetConfig('attack.svg', invertColor: true),
  'ATTACK+1': AssetConfig('attack.svg', invertColor: true),
  'Rolling': AssetConfig('rolling.svg'),

  // Other
  'xp': AssetConfig('xp.svg', invertColor: true),

  // Class-specific abilities and icons
  'Shackle': AssetConfig('class_icons/chainguard.svg', invertColor: true),
  'Shackled': AssetConfig('class_icons/chainguard.svg', invertColor: true),
  'Cultivate': AssetConfig('cultivate.svg', invertColor: true),
  'Chieftain': AssetConfig('class_icons/chieftain.svg', invertColor: true),
  'Boneshaper': AssetConfig('class_icons/boneshaper.svg', invertColor: true),
  'Berserker': AssetConfig('berserker.svg', invertColor: true),
  'Glow': AssetConfig('glow.svg'),
  'Spirit': AssetConfig('class_icons/spirit_caller.svg', invertColor: true),
  'SWING': AssetConfig('swing.svg'),
  'SATED': AssetConfig('sated.svg'),
  'Ladder': AssetConfig('ladder.svg', invertColor: true),
  'Shrug_Off': AssetConfig('shrug_off.svg', invertColor: true),
  'Projectile': AssetConfig('class_icons/bombard.svg', invertColor: true),
  'VOID': AssetConfig('void.svg'),
  'VOIDSIGHT': AssetConfig('voidsight.svg', invertColor: true),
  'CONQUEROR': AssetConfig('conqueror.svg'),
  'REAVER': AssetConfig('reaver.svg'),
  'RITUALIST': AssetConfig('ritualist.svg'),
  'ALL_STANCES': AssetConfig('incarnate_all_stances.svg'),
  'CRYSTALLIZE': AssetConfig('crystallize.svg', invertColor: true),
  'SPARK': AssetConfig('spark.svg', invertColor: true),
  'consume_SPARK': AssetConfig('spark.svg', invertColor: true),
  'RAGE': AssetConfig('class_icons/vanquisher.svg', invertColor: true),
  'PROJECT': AssetConfig('project.svg', invertColor: true),
  'BARRIER_PLUS': AssetConfig('barrier_plus.svg', invertColor: true),
  'CRITTERS': AssetConfig('critters.svg', invertColor: true),
  'LUMINARY_HEXES': AssetConfig('luminary_hexes.svg'),
  'SHADOW': AssetConfig('shadow.svg'),
  'TIME_TOKEN': AssetConfig('time_token.svg'),
  'PERSIST': AssetConfig('persist.svg', invertColor: true),
  'RESONANCE': AssetConfig('resonance.svg'),
  'INFUSION': AssetConfig('infusion.svg'),
  'TRANSFER': AssetConfig('transfer.svg'),
  'TIDE': AssetConfig('tide.svg'),
  'TROPHY': AssetConfig('trophy.svg'),
  'PRESSURE_LOSE': AssetConfig('pressure_lose.svg'),
  'PRESSURE_GAIN': AssetConfig('pressure_gain.svg'),
  'PRESSURE_LOW': AssetConfig('pressure_low.svg'),
  'PRESSURE_HIGH': AssetConfig('pressure_high.svg'),

  // Elements and their combinations
  'EARTH': AssetConfig('elem_earth.svg'),
  'consume_EARTH': AssetConfig('elem_earth.svg'),
  'AIR': AssetConfig('elem_air.svg'),
  'consume_AIR': AssetConfig('elem_air.svg'),
  'DARK': AssetConfig('elem_dark.svg'),
  'consume_DARK': AssetConfig('elem_dark.svg'),
  'LIGHT': AssetConfig('elem_light.svg'),
  'consume_LIGHT': AssetConfig('elem_light.svg'),
  'ICE': AssetConfig('elem_ice.svg'),
  'consume_ICE': AssetConfig('elem_ice.svg'),
  'FIRE': AssetConfig('elem_fire.svg'),
  'consume_FIRE': AssetConfig('elem_fire.svg'),
  'Any_Element': AssetConfig('elem_any.svg'),
  'Consume_Any_Element': AssetConfig('elem_any.svg'),
  'AIR/DARK': AssetConfig('elem_air_or_dark.svg'),
  'consume_AIR/DARK': AssetConfig('elem_air_or_dark.svg'),
  'AIR/EARTH': AssetConfig('elem_air_or_earth.svg'),
  'consume_AIR/EARTH': AssetConfig('elem_air_or_earth.svg'),
  'AIR/LIGHT': AssetConfig('elem_air_or_light.svg'),
  'consume_AIR/LIGHT': AssetConfig('elem_air_or_light.svg'),
  'EARTH/DARK': AssetConfig('elem_earth_or_dark.svg'),
  'consume_EARTH/DARK': AssetConfig('elem_earth_or_dark.svg'),
  'EARTH/LIGHT': AssetConfig('elem_earth_or_light.svg'),
  'consume_EARTH/LIGHT': AssetConfig('elem_earth_or_light.svg'),
  'FIRE/AIR': AssetConfig('elem_fire_or_air.svg'),
  'consume_FIRE/AIR': AssetConfig('elem_fire_or_air.svg'),
  'FIRE/DARK': AssetConfig('elem_fire_or_dark.svg'),
  'consume_FIRE/DARK': AssetConfig('elem_fire_or_dark.svg'),
  'FIRE/EARTH': AssetConfig('elem_fire_or_earth.svg'),
  'consume_FIRE/EARTH': AssetConfig('elem_fire_or_earth.svg'),
  'FIRE/ICE': AssetConfig('elem_fire_or_ice.svg'),
  'consume_FIRE/ICE': AssetConfig('elem_fire_or_ice.svg'),
  'FIRE/LIGHT': AssetConfig('elem_fire_or_light.svg'),
  'consume_FIRE/LIGHT': AssetConfig('elem_fire_or_light.svg'),
  'ICE/AIR': AssetConfig('elem_ice_or_air.svg'),
  'consume_ICE/AIR': AssetConfig('elem_ice_or_air.svg'),
  'ICE/DARK': AssetConfig('elem_ice_or_dark.svg'),
  'consume_ICE/DARK': AssetConfig('elem_ice_or_dark.svg'),
  'ICE/EARTH': AssetConfig('elem_ice_or_earth.svg'),
  'consume_ICE/EARTH': AssetConfig('elem_ice_or_earth.svg'),
  'ICE/LIGHT': AssetConfig('elem_ice_or_light.svg'),
  'consume_ICE/LIGHT': AssetConfig('elem_ice_or_light.svg'),
  'LIGHT/DARK': AssetConfig('elem_light_or_dark.svg'),
  'consume_LIGHT/DARK': AssetConfig('elem_light_or_dark.svg'),
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
AssetConfig getAssetConfig(
  String element,
  bool darkTheme,
) {
  // Clean the input string - remove punctuation
  String cleanElement = element.replaceAll(RegExp(r"[,.:()" "'" '"' "]"), '');

  // Handle XP pattern (xp8, xp10, etc.)
  if (RegExp(r'^xp\d+$').hasMatch(cleanElement)) {
    return const AssetConfig('xp.svg', invertColor: true);
  }

  // Check theme-specific assets first
  final themeAsset = themeSpecificAssets[cleanElement];
  if (themeAsset != null) {
    return themeAsset(darkTheme);
  }

  // Return standard asset or default configuration
  return standardAssets[cleanElement] ?? const AssetConfig(null);
}

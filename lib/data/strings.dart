class Strings {
  // general info
  static String generalInfoTitle = "Enhancements";
  static String generalInfoBody = "Once your team has earned 'The Power of "
      "Enhancement' global achievement, enhancements may be purchased "
      "to permanently augment their cards. This is done by paying the associated "
      "cost and adding a sticker to the card. You may only enhance a number of cards "
      "less than or equal to the Prosperity level of the town. Only abilities with a "
      "small translucent circle beside them can be enhanced, and only one "
      "enhancement may be added per circle.";

//  // prosperity level information
//  static String prosperityLevelInfoTitle = "";
//  static String prosperityLevelInfoBody = "You may enhance a number of cards "
//      "less than or equal to your Prosperity level";

  // card level information
  static String cardLevelInfoTitle = "Card Level Fee";
  static String cardLevelInfoBody =
      "25g is added to the cost of an enhancement "
      "for each card level beyond 1 or x.";

  // existing enhancements information
  static String existingEnhancementsInfoTitle = "Existing Enhancement Fee";
  static String existingEnhancementsInfoBody = "75g is added to the cost of an "
      "enhancement for each previous enhancement on the same action (the top or "
      "bottom of the card).";

  // plus one
  static String plusOneInfoBody =
      "Can be placed on any ability line (Move, Attack, Target, or Range) "
      "or summon base stat line (such as Move, Attack, Range, or HP) with a "
      "numerical value. That value is increased by 1. Increasing a Target by 1 "
      "is always subject to the multiple target fee.";
  static List<String> plusOneIcons = ['plus_one.png'];

  // negative effects
  static String negEffectInfoBody =
      "Can be placed on any main ability line that targets enemies, such as "
      "Attack or an existing negative effect ability. The specified condition is "
      "applied to all targets of the ability. Curse may be added multiple times "
      "to the same target. Summons cannot be enhanced with effects.";
  static List<String> negEffectIcons = [
    'poison.png',
    'wound.png',
    'muddle.png',
    'immobilize.png',
    'disarm.png',
    'curse.png'
  ];

  // positive effects
  static String posEffectInfoBody =
      "Can be placed on any main ability line that "
      "targets allies or yourself, such as Heal or Retaliate, or an existing "
      "positive effect action. The specified condition is applied to all targets "
      "of the ability. Bless may be added multiple times to the same target. "
      "Summons cannot be enhanced with effects.";
  static List<String> posEffectIcons = ['strengthen.png', 'bless.png'];

  // move
  static String moveInfoBody = "Can be placed on any Move ability line. "
      "The movement is now considered a Jump. Summons' moves cannot be enhanced"
      " with Jump.";
  static List<String> moveIcons = ['jump.png'];

  // elements
  static String elementsInfoBody = "Can be placed on any main ability line, such "
      "as Attack, Move, Strengthen, Push, or Poison. "
      "The element is created when the ability is used. In the case of "
      "'Any Element', the player chooses the element as normal.";
  static List<String> elementsIcons = [
    'elem_fire.png',
    'elem_frost.png',
    'elem_leaf.png',
    'elem_wind.png',
    'elem_sun.png',
    'elem_dark.png',
    'elements.png'
  ];

  // hex
  static String hexInfoBody = "Can be placed to increase the graphical "
      "depiction of an area attack. The new hex becomes an additional target of "
      "the attack. Adding a hex is not subject to the multiple target fee.";
  static List<String> hexIcons = ['hex_target.png'];

  // multiple targets
  static String multipleTargetsInfoTitle = "Multiple targets multiplier";
  static String multipleTargetsInfoBody = "If an ability targets multiple enemies or allies, "
      "the enhancement base cost is doubled. This includes abilities that target "
      "'All adjacent enemies' or 'All allies within range 3', for example. +1 Target "
      "will always be double base cost.";
}

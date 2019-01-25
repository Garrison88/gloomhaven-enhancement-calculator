class Strings {
  // menu items
  static List<String> choices = ['Developer Website'];

  // developer website url
  static String devWebsiteUrl = 'https://garrisonsiberry.com/';

  // general info
  static String generalInfoTitle = "Enhancements";
  static String generalInfoBody =
      "Congratulations! Now that your company has earned 'The Power of "
      "Enhancement' global achievement, its members may purchase enhancements "
      "to permanently augment their class' cards. This is done by paying the associated "
      "cost (determined by card level, previous enhancements, type of enhancement, and number of targets) "
      "and adding a sticker to the card. Players can only enhance a number of cards "
      "less than or equal to the Prosperity level of Gloomhaven. Only abilities with a "
      "small translucent circle beside them can be enhanced, and only one "
      "enhancement per circle can be added. Once an enhancement is placed, it "
      "persists through subsequent playthroughs with that class. A MAIN ability line is an ability "
      "that is written in larger font, whereas a NON-MAIN ability is written in a smaller font "
      "below a MAIN ability. A summon's stats can only be augmented with +1 enhancements.";

  // card level information
  static String cardLevelInfoTitle = "Card Level Fee";
  static String cardLevelInfoBody =
      "25g is added to the cost of an enhancement "
      "for each card level beyond 1 or x.";

  // existing enhancements information
  static String previousEnhancementsInfoTitle = "Previous Enhancements Fee";
  static String previousEnhancementsInfoBody = "75g is added to the cost of an "
      "enhancement for each previous enhancement on the same action. An action is"
      " defined as the top or bottom half of a card. This fee DOES NOT apply "
      "to an enhancement on a top action where a bottom action enhancement already"
      " exists, or vice versa.";

  // plus one for character
  static String plusOneCharacterInfoBody =
      "This enhancement can be placed on any ability line with a numerical value. "
      "That value is increased by 1. Increasing a Target by 1 is always subject "
      "to the multiple target fee.";
  static List<String> plusOneIcon = ['plus_one.png'];
  static List<String> plusOneCharacterEligibleIcons = [
    'move.png',
    'attack.png',
    'target.png',
    'range.png',
    'pierce.png',
    'shield.png',
    'heal.png',
    'retaliate.png',
    'push.png',
    'pull.png'
  ];

  // plus one for summon
  static String plusOneSummonInfoBody =
      "This enhancement can be placed on any summon ability"
      " with a numerical value. That value is increased by 1.";
  static List<String> plusOneSummonEligibleIcons = [
    'move.png',
    'attack.png',
    'range.png',
    'heal.png'
  ];

  // negative effects
  static String negEffectInfoBody =
      "These enhancements can be placed on any MAIN ability line that targets enemies. The specified condition is "
      "applied to all targets of that ability unless they are immune. Curse can be added multiple times "
      "to the same ability line. Summons cannot be enhanced with effects.";
  static List<String> negEffectIcons = [
    'poison.png',
    'wound.png',
    'muddle.png',
    'immobilize.png',
    'disarm.png',
    'curse.png'
  ];
  static List<String> negEffectEligibleIcons = [
    'attack.png',
    'poison.png',
    'wound.png',
    'muddle.png',
    'immobilize.png',
    'disarm.png',
    'curse.png',
    'push.png',
    'pull.png'
  ];

  // positive effects
  static String posEffectInfoBody =
      "These enhancements can be placed on any MAIN ability line that targets allies or yourself. "
      "The specified condition is applied to all targets of that ability. "
      "Bless can be added multiple times to the same ability line. Summons cannot be "
      "enhanced with effects.";
  static List<String> posEffectIcons = ['strengthen.png', 'bless.png'];
  static List<String> posEffectEligibleIcons = [
    'heal.png',
    'retaliate.png',
    'shield.png',
    'strengthen.png',
    'bless.png',
    'invisible.png'
  ];

  // move
  static String jumpInfoBody =
      "This enhancement can be placed on any Move ability line. "
      "The movement is now considered a Jump. A summon's Move cannot be enhanced"
      " with Jump.";
  static List<String> jumpIcon = ['jump.png'];
  static List<String> jumpEligibleIcons = ['move.png'];

  // specific element
  static String specificElementInfoBody =
      "These enhancements can be placed on any MAIN ability line. "
      "The specific element is created when the ability is used.";
  static List<String> specificElementIcons = [
    'elem_fire.png',
    'elem_frost.png',
    'elem_leaf.png',
    'elem_wind.png',
    'elem_sun.png',
    'elem_dark.png'
  ];
  static List<String> elementEligibleIcons = [
    'move.png',
    'attack.png',
    'shield.png',
    'heal.png',
    'retaliate.png',
    'push.png',
    'pull.png',
    'poison.png',
    'wound.png',
    'muddle.png',
    'immobilize.png',
    'disarm.png',
    'curse.png',
    'strengthen.png',
    'bless.png',
    'invisible.png'
  ];

  // any element
  static String anyElementInfoBody =
      "This enhancement can be placed on any MAIN ability line. The player chooses the element "
      "that is created when the ability is used.";
  static List<String> anyElementIcon = ['elem_any.png'];

  // hex
  static String hexInfoBody =
      "This enhancement can be placed to increase the graphical "
      "depiction of an area attack. The new Hex becomes an additional target of "
      "the attack. Adding a Hex is not subject to the multiple target fee.";
  static List<String> hexIcon = ['hex.png'];
  static List<String> hexEligibleIcons = ['hex.png'];

  // multiple targets
  static String multipleTargetsInfoTitle = "Multiple Targets Multiplier";
  static String multipleTargetsInfoBody =
      "If an ability targets multiple enemies or allies, the enhancement base cost "
      "is doubled. This includes abilities that target 'All adjacent enemies' or "
      "'All allies within range 3', for example. Adding +1 to Target will always be double "
      "base cost, while adding a Hex will never be.";
}

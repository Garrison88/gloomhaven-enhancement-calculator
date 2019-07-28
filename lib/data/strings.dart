import 'package:flutter/material.dart';
import 'package:gloomhaven_companion/data/custom_text_styles.dart';

class Strings {
  // menu items
  static List<String> choices = ['Developer Website'];

  // developer website url
  static String devWebsiteUrl = 'https://garrisonsiberry.com/';

  // general info
  static String generalInfoTitle = "Enhancements";

//  static String generalInfoBody =
  static RichText generalInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(text: "Congratulations! Now that your company has earned"),
      TextSpan(
        text: " 'The Power of Enhancement' ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
          text: "global achievement, its members can purchase enhancements "
              "to permanently augment their class's cards. This is done by paying the associated "
              "cost (determined by card level, previous enhancements, type of enhancement, and number of targets) "
              "and adding a sticker to the card. Players can only enhance a number of cards"),
      TextSpan(
        text: " less than or equal to ",
        style: CustomTextStyle.dialogTextBold(),
      ),
      TextSpan(
          text: "the Prosperity level of Gloomhaven. Only abilities with a "
              "small translucent circle beside them can be enhanced, and only one "
              "enhancement per circle can be added. Once an enhancement is placed,"),
      TextSpan(
        text: " it persists through subsequent playthroughs ",
        style: CustomTextStyle.dialogTextBold(),
      ),
      TextSpan(text: "with that class. A "),
      TextSpan(text: "main ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "ability is an ability that is written in larger font, "
              "whereas a"),
      TextSpan(text: " non-main ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "ability is written in a smaller font below a"),
      TextSpan(text: " main ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "ability. A summon's stats can"),
      TextSpan(text: " only ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "be augmented with +1 enhancements.")
    ]),
  );

//  RealRichText([
//    RealRichText[

//    ImageSpan(AssetImage('images/plus_one.png'),
//        imageHeight: plusOneHeight, imageWidth: plusOneWidth),
//    TextSpan(text: " enhancements.", style: CustomTextStyle.dialogText())
//  ]);

  // card level information
  static String cardLevelInfoTitle = "Card Level Fee";
  static RichText cardLevelInfoBody = RichText(
      text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
    TextSpan(
        text: "25g is added to the cost of an enhancement "
            "for each card level beyond 1 or x.")
  ]));

  // existing enhancements information
  static String previousEnhancementsInfoTitle = "Previous Enhancements Fee";
  static RichText previousEnhancementsInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(
          text: "75g is added to the cost of an enhancement for each previous "
              "enhancement on the"),
      TextSpan(text: " same action. ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "An action is defined as the top "
              "or bottom half of a card. This fee"),
      TextSpan(text: " does not ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "apply to an enhancement on a top action where a bottom "
              "action enhancement already exists, or vice versa.")
    ]),
  );

  // plus one for character
  static RichText plusOneCharacterInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(
          text: "This enhancement can be placed on any ability line with a"),
      TextSpan(
          text: " numerical value. ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "That value is increased by 1. Increasing a Target by 1 is"),
      TextSpan(text: " always ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "subject to the multiple target fee.")
    ]),
  );

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
  static RichText plusOneSummonInfoBody = RichText(
      text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
    TextSpan(
        text: "This enhancement can be placed on any summon ability"
            " with a"),
    TextSpan(
        text: " numerical value. ", style: CustomTextStyle.dialogTextBold()),
    TextSpan(text: "That value is increased by 1.")
  ]));

  static List<String> plusOneSummonEligibleIcons = [
    'move.png',
    'attack.png',
    'range.png',
    'heal.png'
  ];

  // negative effects
  static RichText negEffectInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(text: "These enhancements can be placed on any"),
      TextSpan(text: " main ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text:
              "ability line that targets enemies. The specified condition is applied to all "
              "targets of that ability unless they are immune. Curse can be "
              "added multiple times to the same ability line. Summon abilities"),
      TextSpan(text: " cannot ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "be enhanced with effects.")
    ]),
  );

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
  static RichText posEffectInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(text: "These enhancements can be placed on any"),
      TextSpan(text: " main ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "ability line that targets allies or yourself. "
              "The specified condition is applied to all targets of that ability. "
              "Bless can be added multiple times to the same ability line. Summon abilities"),
      TextSpan(text: " cannot ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "be enhanced with effects.")
    ]),
  );

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
  static RichText jumpInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(
          text: "This enhancement can be placed on any move ability line. "
              "The movement is now considered a Jump. A summon's Move"),
      TextSpan(text: " cannot ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "be enhanced with Jump.")
//    ImageSpan(AssetImage('images/move.png'),
//        imageHeight: iconHeight, imageWidth: iconWidth),
//    TextSpan(
//        text:
//        style: CustomTextStyle.dialogText())
    ]),
  );

  static List<String> jumpIcon = ['jump.png'];
  static List<String> jumpEligibleIcons = ['move.png'];

  // specific element
  static RichText specificElementInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(text: "These enhancements can be placed on any"),
      TextSpan(text: " main ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "ability line. The specific element is created when the "
              "ability is used.")
    ]),
  );

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
  static RichText anyElementInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(text: "This enhancement can be placed on any"),
      TextSpan(text: " main ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "ability line. The player chooses the element that is created "
              "when the ability is used."),
    ]),
  );

  static List<String> anyElementIcon = ['elem_any.png'];

  // hex
  static RichText hexInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(
          text: "This enhancement can be placed to increase the graphical "
              "depiction of an"),
      TextSpan(text: " area attack. ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "The new Hex becomes an additional target of "
              "the attack. Adding a Hex is"),
      TextSpan(text: " not ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "subject to the multiple target fee.")
    ]),
  );

  static List<String> hexIcon = ['hex.png'];
  static List<String> hexEligibleIcons = ['hex.png'];

  // multiple targets
  static RichText multipleTargetsInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(
          text:
              "If an ability targets multiple enemies or allies, the enhancement base cost "
              "is"),
      TextSpan(text: " doubled. ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: "This includes abilities that target 'All adjacent enemies' or "
              "'All allies within range 3', for example. Adding +1 Target will"),
//    ImageSpan(AssetImage('images/plus_one.png'),
//        imageHeight: inTextIconWidth, imageWidth: inTextIconHeight),
//    TextSpan(text: " to ", style: CustomTextStyle.dialogText()),
//    ImageSpan(AssetImage('images/target_in_text.png'),
//        imageHeight: inTextIconWidth, imageWidth: inTextIconHeight),
      TextSpan(text: " always ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "be double base cost, while adding a Hex will"),
      TextSpan(text: " never ", style: CustomTextStyle.dialogTextBold()),
      TextSpan(text: "be.")
    ]),
  );
  static String multipleTargetsInfoTitle = "Multiple Targets Multiplier";

  static String previousRetirementsInfoTitle = "Previous Retirements";
  static RichText previousRetirementsInfoBody = RichText(
    text: TextSpan(style: CustomTextStyle.dialogText(), children: <TextSpan>[
      TextSpan(
          text:
              "When starting a new character, you are alloted an amount of gold"
              " equal to"),
      TextSpan(text: " 15x(L+1)", style: CustomTextStyle.dialogTextBold()),
      TextSpan(
          text: ", where L is your character's level. For instance, "
              "a level 3 character would start with 60 gold.\nYou are "
              "also awarded 1 bonus perk for each previously retired character"
              " in addition to the standard perk for each level beyond 1."),
    ]),
  );
}

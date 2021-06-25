import 'package:flutter/material.dart';

class Strings {
  // developer website url
  static String devWebsiteUrl = 'https://www.tomkatcreative.com/contact';

  // general info
  static String generalInfoTitle = "Enhancements";

  static RichText generalInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText2,
        children: <TextSpan>[
          const TextSpan(
              text: "Congratulations! Now that your company has earned"),
          TextSpan(
            text: " 'The Power of Enhancement' ",
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const TextSpan(
              text: "global achievement, its members can purchase enhancements "
                  "to permanently augment their class's cards. This is done by paying the associated "
                  "cost (determined by card level, previous enhancements, type of enhancement, and number of targets) "
                  "and adding a sticker to the card. Players can only enhance a number of cards"),
          TextSpan(
            text: " less than or equal to ",
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const TextSpan(
              text: "the Prosperity level of Gloomhaven. Only abilities with a "
                  "small translucent circle beside them can be enhanced, and only one "
                  "enhancement per circle can be added. Once an enhancement is placed,"),
          TextSpan(
            text: " it persists through subsequent playthroughs ",
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const TextSpan(text: "with that class. A "),
          TextSpan(
              text: "main ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(
              text: "ability is an ability that is written in larger font, "
                  "whereas a"),
          TextSpan(
              text: " non-main ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(text: "ability is written in a smaller font below a"),
          TextSpan(
              text: " main ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(text: "ability. A summon's stats can"),
          TextSpan(
              text: " only ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(text: "be augmented with +1 enhancements.")
        ],
      ),
    );
  }

  // card level information
  static String cardLevelInfoTitle = "Card Level Fee";
  static RichText cardLevelInfoBody(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2,
            children: const <TextSpan>[
          TextSpan(
              text: "25g is added to the cost of an enhancement "
                  "for each card level beyond 1 or x.")
        ]));
  }

  // existing enhancements information
  static String previousEnhancementsInfoTitle = "Previous Enhancements Fee";
  static RichText previousEnhancementsInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "75g is added to the cost of an enhancement for each previous "
                    "enhancement on the"),
            TextSpan(
              text: " same action. ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
                text: "An action is defined as the top "
                    "or bottom half of a card. This fee"),
            TextSpan(
              text: " does not ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
                text: "apply to an enhancement on a top action where a bottom "
                    "action enhancement already exists, or vice versa.")
          ]),
    );
  }

  // plus one for character
  static RichText plusOneCharacterInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "This enhancement can be placed on any ability line with a"),
            TextSpan(
              text: " numerical value. ",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const TextSpan(
                text:
                    "That value is increased by 1. Increasing a Target by 1 is"),
            TextSpan(
              text: " always ",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: "subject to the multiple target fee.")
          ]),
    );
  }

  // plus one for summon
  static RichText plusOneSummonInfoBody(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2,
            children: <TextSpan>[
          const TextSpan(
              text: "This enhancement can be placed on any summon ability"
                  " with a"),
          TextSpan(
              text: " numerical value. ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(text: "That value is increased by 1.")
        ]));
  }

  // negative effects
  static RichText negEffectInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(text: "These enhancements can be placed on any"),
            TextSpan(
                text: " main ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(
                text:
                    "ability line that targets enemies. The specified condition is applied to all "
                    "targets of that ability unless they are immune. Curse can be "
                    "added multiple times to the same ability line. Summon abilities"),
            TextSpan(
                text: " cannot ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(text: "be enhanced with effects.")
          ]),
    );
  }

  // positive effects
  static RichText posEffectInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(text: "These enhancements can be placed on any"),
            TextSpan(
                text: " main ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(
                text: "ability line that targets allies or yourself. "
                    "The specified condition is applied to all targets of that ability. "
                    "Bless can be added multiple times to the same ability line. Summon abilities"),
            TextSpan(
                text: " cannot ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(text: "be enhanced with effects.")
          ]),
    );
  }

  // move
  static RichText jumpInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "This enhancement can be placed on any move ability line. "
                    "The movement is now considered a Jump. A summon's Move"),
            TextSpan(
                text: " cannot ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(text: "be enhanced with Jump.")
          ]),
    );
  }

  // specific element
  static RichText specificElementInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(text: "These enhancements can be placed on any"),
            TextSpan(
                text: " main ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(
                text: "ability line. The specific element is created when the "
                    "ability is used.")
          ]),
    );
  }

  // any element
  static RichText anyElementInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(text: "This enhancement can be placed on any"),
            TextSpan(
                text: " main ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(
                text:
                    "ability line. The player chooses the element that is created "
                    "when the ability is used."),
          ]),
    );
  }

  static List<String> anyElementIcon = ['elem_any.svg'];

  // hex
  static RichText hexInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "This enhancement can be placed to increase the graphical "
                    "depiction of an"),
            TextSpan(
              text: " area attack. ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
                text: "The new Hex becomes an additional target of "
                    "the attack. Adding a Hex is"),
            TextSpan(
              text: " not ",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(text: "subject to the multiple target fee.")
          ]),
    );
  }

  static List<String> hexIcon = ['hex.svg'];
  static List<String> hexEligibleIcons = ['hex.svg'];

  // multiple targets
  static RichText multipleTargetsInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "If an ability targets multiple enemies or allies, the enhancement base cost "
                    "is"),
            TextSpan(
                text: " doubled. ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(
                text:
                    "This includes abilities that target 'All adjacent enemies' or "
                    "'All allies within range 3', for example. Adding +1 Target will"),
            TextSpan(
                text: " always ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(
                text: "be double base cost, while adding a Hex will"),
            TextSpan(
                text: " never ",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(text: "be.")
          ]),
    );
  }

  static String multipleTargetsInfoTitle = "Multiple Targets Multiplier";

  static String previousRetirementsInfoTitle = "Previous Retirements";
  static RichText previousRetirementsInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "When starting a new character, you are alloted an amount of gold"
                    " equal to"),
            TextSpan(
              text: " 15x(L+1)",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
                text: ", where L is your character's level. For instance, "
                    "a level 3 character would start with 60 gold.\nYou are "
                    "also awarded 1 bonus perk for each previously retired character"
                    " in addition to the standard perk for each level beyond 1."),
          ]),
    );
  }
}

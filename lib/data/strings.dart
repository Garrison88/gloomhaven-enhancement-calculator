import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/utils/utils.dart';

class Strings {
  // developer website url
  static String devWebsiteUrl = 'https://www.tomkatcreative.com/contact';

  // general info
  static String generalInfoTitle = 'Enhancements';

  static RichText generalInfoBody(
    BuildContext context, {
    required bool gloomhavenMode,
    required bool darkMode,
  }) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(
              text:
                  'Congratulations! Now that your company has ${gloomhavenMode ? 'earned' : 'built'}'),
          TextSpan(
            text:
                " ${gloomhavenMode ? 'The Power of Enhancement global achievement' : 'The Enhancer (Building 44)'}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          TextSpan(
              text: ', its members can purchase enhancements '
                  "to permanently augment their class's cards. This is done by paying the associated "
                  "cost (determined by card level, number of previous enhancements, type of enhancement, etc.) "
                  "and adding a sticker to the card. ${gloomhavenMode ? 'Players can only enhance a number of cards' : ''}"),
          if (gloomhavenMode)
            TextSpan(
              text: ' less than or equal to ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          TextSpan(
            text:
                "${gloomhavenMode ? 'the Prosperity level of Gloomhaven. ' : ''}\n\nOnly abilities with a "
                "small translucent icon beside them can be enhanced, and only one "
                "enhancement per icon can be added.",
          ),
          if (!gloomhavenMode) ...[
            const TextSpan(text: '\n'),
            ...Utils.generateCheckRowDetails(
              context,
              "A pip_square symbol can hold a pip_plus_one sticker. If the action is MOVE and is not a summon ability, it can hold either a pip_plus_one sticker or a JUMP sticker.\nA pip_circle symbol can hold anything a pip_square can hold, or an Element sticker.\nA pip_diamond symbol can hold anything a pip_circle can hold, or a negative condition sticker.\nA pip_diamond_plus symbol can hold anything a pip_circle can hold, or a positive condition sticker.\nA pip_hex symbol can only hold a Hex sticker.\n",
              darkMode,
            ),
          ],
          const TextSpan(
            text: "\nOnce an enhancement is placed,",
          ),
          TextSpan(
            text: " it persists through subsequent playthroughs ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const TextSpan(
              text:
                  "with that class (unless you have chosen to use the 'Temporary Enhancement' variant).\n\nA "),
          TextSpan(
              text: "main ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(
              text: "ability is an ability that is written in larger font, "
                  "whereas a"),
          TextSpan(
              text: " non-main ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(text: "ability is written in a smaller font below a"),
          TextSpan(
              text: " main ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(text: "ability. A summon's stats can"),
          TextSpan(
            text: " only ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          ...Utils.generateCheckRowDetails(
            context,
            "be augmented with pip_plus_one enhancements.",
            darkMode,
          ),
          if (!gloomhavenMode)
            ...Utils.generateCheckRowDetails(
              context,
              "\n\nSome enhancements do not fall neatly into the categories on the cost chart. When determining their base cost, treat damage traps as ATTACK+1 enhancements (50g), healing traps as HEAL+1 enhancements (30g), and the movement of tokens and tiles as MOVE+1 enhancements (30g).",
              darkMode,
            ),
        ],
      ),
    );
  }

  // temporary enhancement variant
  static String temporaryEnhancement = "Temporary Enhancement Variant";
  static RichText temporaryEnhancementInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: const <TextSpan>[
            TextSpan(
                text:
                    "Temporary enhancements don't persist between playthroughs and have a reduced cost. First, calculate the"
                    " normal enhancement cost, including any discounts. Next, if "
                    "the card has at least one previous enhancement, reduce the cost "
                    "by 20 gold (as indicated by the trailing * character beside the penalty cost). Finally, reduce the entire cost by 20 percent, rounded up (as indicated by the trailing * character on the total Enhancement cost)."),
          ]),
    );
  }

  // card level information
  static String cardLevelInfoTitle = "Card Level Fee";
  static RichText cardLevelInfoBody(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
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
          style: Theme.of(context).textTheme.bodyMedium,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "75g is added to the cost of an enhancement for each previous "
                    "enhancement on the"),
            TextSpan(
              text: " same action. ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
                text: "An action is defined as the top "
                    "or bottom half of a card. This fee"),
            TextSpan(
              text: " does not ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
  static RichText plusOneCharacterInfoBody(
    BuildContext context,
    bool gloomhavenMode,
  ) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "This enhancement can be placed on any ability line with a"),
            TextSpan(
              text: " numerical value. ",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const TextSpan(
                text:
                    "That value is increased by 1. Increasing a Target by 1 is"),
            TextSpan(
              text: " ${gloomhavenMode ? 'always' : 'never'} ",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: "subject to the multiple targets multiplier."),
          ]),
    );
  }

  // plus one for summon
  static RichText plusOneSummonInfoBody(
    BuildContext context,
    bool gloomhavenMode,
  ) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          const TextSpan(
              text: "This enhancement can be placed on any summon ability"
                  " with a"),
          TextSpan(
              text: " numerical value. ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(text: "That value is increased by 1."),
          if (!gloomhavenMode) ...[
            const TextSpan(text: " Summon stat enhancements are"),
            TextSpan(
              text: " never ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(text: "subject to the persistent icon multiplier."),
          ]
        ],
      ),
    );
  }

  // negative effects
  static RichText negEffectInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: <TextSpan>[
            const TextSpan(text: "These enhancements can be placed on any"),
            TextSpan(
                text: " main ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(
                text:
                    "ability line that targets enemies. The specified condition is applied to all "
                    "targets of that ability unless they are immune. Curse can be "
                    "added multiple times to the same ability line. Summon abilities"),
            TextSpan(
                text: " cannot ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          style: Theme.of(context).textTheme.bodyMedium,
          children: <TextSpan>[
            const TextSpan(text: "These enhancements can be placed on any"),
            TextSpan(
                text: " main ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(
                text: "ability line that targets allies or yourself. "
                    "The specified condition is applied to all targets of that ability. "
                    "Bless can be added multiple times to the same ability line. Summon abilities"),
            TextSpan(
                text: " cannot ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          style: Theme.of(context).textTheme.bodyMedium,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "This enhancement can be placed on any move ability line. "
                    "The movement is now considered a Jump. A summon's Move"),
            TextSpan(
                text: " cannot ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const TextSpan(text: "be enhanced with Jump.")
          ]),
    );
  }

  // specific element
  static RichText specificElementInfoBody(
    BuildContext context,
    bool gloomhavenMode,
  ) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          const TextSpan(text: "These enhancements can be placed on any"),
          TextSpan(
            text: " main ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const TextSpan(
              text: "ability line. The specific element is created when the "
                  "ability is used."),
          if (!gloomhavenMode) ...[
            const TextSpan(text: " Element enhancements are"),
            TextSpan(
              text: " never ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(text: "subject to the multiple targets multiplier."),
          ],
        ],
      ),
    );
  }

  // any element
  static RichText anyElementInfoBody(
    BuildContext context,
    bool gloomhavenMode,
  ) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          const TextSpan(text: "This enhancement can be placed on any"),
          TextSpan(
              text: " main ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const TextSpan(
              text:
                  "ability line. The player chooses the element that is created "
                  "when the ability is used."),
          if (!gloomhavenMode) ...[
            const TextSpan(text: " Element enhancements are"),
            TextSpan(
              text: " never ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(text: "subject to the multiple targets multiplier."),
          ],
        ],
      ),
    );
  }

  static List<String> anyElementIcon = ['elem_any.svg'];

  // hex
  static RichText hexInfoBody(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: <TextSpan>[
            const TextSpan(
                text:
                    "This enhancement can be placed to increase the graphical "
                    "depiction of an"),
            TextSpan(
              text: " area attack. ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
                text: "The new Hex becomes an additional target of "
                    "the attack. Adding a Hex is"),
            TextSpan(
              text: " never ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(text: "subject to the multiple targets multiplier.")
          ]),
    );
  }

  static List<String> hexIcon = ['hex.svg'];
  static List<String> hexEligibleIcons = ['hex.svg'];

  static String multipleTargetsInfoTitle = "Multiple Targets Multiplier";

  // multiple targets
  static RichText multipleTargetsInfoBody(
    BuildContext context, {
    required bool gloomhavenMode,
    required bool enhancerLvl2,
    required bool darkMode,
  }) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <InlineSpan>[
          const TextSpan(
              text:
                  "If an ability targets multiple enemies or allies, the enhancement base cost "
                  "is"),
          TextSpan(
            text: " doubled",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const TextSpan(
            text:
                // " (as indicated by the trailing \u2020 character beside the Enhancement type cost)
                ". This includes abilities that target 'All adjacent enemies' or "
                "'All allies within",
          ),
          ...Utils.generateCheckRowDetails(
            context,
            " RANGE 3', for example.",
            darkMode,
          ),
          if (gloomhavenMode) ...[
            const TextSpan(text: "This will"),
            TextSpan(
              text: " always ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ...Utils.generateCheckRowDetails(
              context,
              "apply to adding Target+1, and it will",
              darkMode,
            ),
            // const TextSpan(text: "apply to adding +1 Target, and it will"),
            TextSpan(
              text: "never ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(text: "apply to adding a Hex."),
          ] else ...[
            const TextSpan(text: "This will"),
            TextSpan(
              text: " never ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ...Utils.generateCheckRowDetails(
              context,
              "apply to adding Target+1, enhancing an ability with an Element, "
              "or adding a Hex.${enhancerLvl2 ? '\nThis multiplier is applied before the discount applied by upgrading the Enhancer (Building 44) to lvl 2.\nFor example, with the Enhancer lvl 2 upgrade, adding WOUND to an action that has multiple targets will cost 140 gold, calculated as (75x2)-10.' : ''}",
              darkMode,
            ),
          ],
        ],
      ),
    );
  }

  static String lostNonPersistentInfoTitle = "Lost & Non-Persistent";

  // lost non-persistent
  static RichText lostNonPersistentInfoBody(
    BuildContext context,
  ) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: const <TextSpan>[
          TextSpan(
              text:
                  "If the action has a Lost icon, but no Persistent icon, halve the base cost."),
        ],
      ),
    );
  }

  static String persistentInfoTitle = "Persistent";

  // persistent
  static RichText persistentInfoBody(
    BuildContext context,
  ) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          const TextSpan(
              text:
                  "If the action has a Persistent icon, whether or not there is a Lost icon, triple the base cost. This"),
          TextSpan(
            text: " does not ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const TextSpan(text: "apply to summon stat enhancements."),
        ],
      ),
    );
  }

  static String newCharacterInfoTitle = "New Character";
  static RichText newCharacterInfoBody(
    BuildContext context, {
    required bool gloomhavenMode,
  }) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: gloomhavenMode
              ? <TextSpan>[
                  const TextSpan(
                      text:
                          "When starting a new character in Gloomhaven, you can choose to immediately level up to any level less than or equal to the current Prosperity Level of the city, gaining the benefits for each level in sequence.\nYou are also alloted an amount of gold"
                          " equal to"),
                  TextSpan(
                    text: " 15x(L+1)",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const TextSpan(
                      text:
                          ", where L is your character's starting level.\nFor example, "
                          "if the city is at Prosperity Level 3, you could start a character at level 1, 2, or 3, and would be alloted 30, 45, or 60 gold, respectively."),
                ]
              : <TextSpan>[
                  const TextSpan(
                    text:
                        "When starting a new character in Frosthaven, you can choose to immediately level up to any level less than or equal to the current Prosperity Level of the city divided by 2 (rounded up), gaining the benefits for each level in sequence."
                        "\nYou are also alloted an amount of gold equal to",
                  ),
                  TextSpan(
                    text: " 10xP+20",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const TextSpan(
                    text:
                        ", where 'P' is the current Prosperity Level.\nFor example, if the city is at Prosperity Level 3, you could start a character at level 1 or 2, and would be alloted 40 gold. This gold must be spent "
                        "immediately on items in the available purchasable supply, and any "
                        "unspent gold is forfeited.",
                  ),
                ]),
    );
  }
}

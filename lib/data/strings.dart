import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/utils/game_text_parser.dart';

/// Centralized string content for the app
///
/// This class stores all UI text as markdown-formatted strings, which are then
/// parsed into RichText using GameTextParser. This separates content from presentation
/// and makes the strings easier to read, maintain, and test.
class Strings {
  // ============================================================================
  // STATIC CONTENT
  // ============================================================================

  static const String devWebsiteUrl = 'https://www.tomkatcreative.com/contact';

  // ============================================================================
  // GENERAL INFO
  // ============================================================================

  static const String generalInfoTitle = 'Enhancements';

  static String _generalInfoContent({required bool gloomhavenMode}) {
    final achievement = gloomhavenMode
        ? '**The Power of Enhancement global achievement**'
        : '**The Enhancer (Building 44)**';

    final earnedOrBuilt = gloomhavenMode ? 'earned' : 'built';

    final prosperityLimit = gloomhavenMode
        ? 'Players can only enhance a number of cards **less than or equal to** the Prosperity level of Gloomhaven. '
        : '';

    final pipInfo = gloomhavenMode
        ? ''
        : '''

 · A pip_square symbol can hold a pip_plus_one sticker. If the action is MOVE and is not a summon ability, it can hold either a pip_plus_one sticker or a JUMP sticker.
 · A pip_circle symbol can hold anything a pip_square can hold, or an Element sticker.
 · A pip_diamond symbol can hold anything a pip_circle can hold, or a negative condition sticker.
 · A pip_diamond_plus symbol can hold anything a pip_circle can hold, or a positive condition sticker.
 · A pip_hex symbol can only hold a Hex sticker.
''';

    final trapInfo = gloomhavenMode
        ? ''
        : '''

Some enhancements do not fall neatly into the categories on the cost chart. When determining their base cost, treat damage traps as ATTACK+1 enhancements (50g), healing traps as HEAL+1 enhancements (30g), and the movement of tokens and tiles as MOVE+1 enhancements (30g).''';

    return '''Congratulations! Now that your company has $earnedOrBuilt $achievement, its members can purchase enhancements to permanently augment their class's cards. This is done by paying the associated cost (determined by card level, number of previous enhancements, type of enhancement, etc.) and adding a sticker to the card. $prosperityLimit
Only abilities with a small translucent icon beside them can be enhanced, and only one enhancement per icon can be added.$pipInfo

Once an enhancement is placed, **it persists through subsequent playthroughs** with that class (unless you have chosen to use the 'Temporary Enhancement' variant).

A **main** ability is an ability that is written in larger font, whereas a **non-main** ability is written in a smaller font below a **main** ability. A summon's stats can **only** be augmented with pip_plus_one enhancements.$trapInfo''';
  }

  static RichText generalInfoBody(
    BuildContext context, {
    required bool gloomhavenMode,
    required bool darkMode,
  }) {
    return _buildRichText(
      context,
      _generalInfoContent(gloomhavenMode: gloomhavenMode),
      darkMode,
    );
  }

  // ============================================================================
  // TEMPORARY ENHANCEMENT
  // ============================================================================

  static const String temporaryEnhancement = "'Temporary Enhancement' Variant";

  static const String _temporaryEnhancementContent =
      "Temporary enhancements don't persist between playthroughs and have a reduced cost. "
      "First, calculate the normal enhancement cost, including any discounts. Next, if "
      "the card has at least one previous enhancement, reduce the cost by 20 gold (as "
      "indicated by the trailing † symbol after the Previous Enhancements penalty cost). "
      "Finally, reduce the entire cost by 20 percent, rounded up (as indicated by the "
      "trailing † symbol on the total Enhancement cost).";

  static RichText temporaryEnhancementInfoBody(
    BuildContext context,
    bool darkMode,
  ) {
    return _buildRichText(context, _temporaryEnhancementContent, darkMode);
  }

  // ============================================================================
  // CARD LEVEL
  // ============================================================================

  static const String cardLevelInfoTitle = "Card Level Fee";

  static const String _cardLevelContent =
      "25g is added to the cost of an enhancement for each card level beyond 1 or x.";

  static RichText cardLevelInfoBody(BuildContext context, bool darkMode) {
    return _buildRichText(context, _cardLevelContent, darkMode);
  }

  // ============================================================================
  // PREVIOUS ENHANCEMENTS
  // ============================================================================

  static const String previousEnhancementsInfoTitle =
      "Previous Enhancements Fee";

  static const String _previousEnhancementsContent =
      "75g is added to the cost of an enhancement for each previous enhancement on the "
      "**same action.** An action is defined as the top or bottom half of a card. This fee "
      "**does not** apply to an enhancement on a top action where a bottom action "
      "enhancement already exists, or vice versa.";

  static RichText previousEnhancementsInfoBody(
    BuildContext context,
    bool darkMode,
  ) {
    return _buildRichText(context, _previousEnhancementsContent, darkMode);
  }

  // ============================================================================
  // PLUS ONE CHARACTER
  // ============================================================================

  static String _plusOneCharacterContent({required bool gloomhavenMode}) {
    final targetMultiplier = gloomhavenMode ? 'always' : 'never';
    return "This enhancement can be placed on any ability line with a **numerical value.** "
        "That value is increased by 1. Increasing a Target by 1 is **$targetMultiplier** "
        "subject to the multiple targets multiplier.";
  }

  static RichText plusOneCharacterInfoBody(
    BuildContext context,
    bool gloomhavenMode,
    bool darkMode,
  ) {
    return _buildRichText(
      context,
      _plusOneCharacterContent(gloomhavenMode: gloomhavenMode),
      darkMode,
    );
  }

  // ============================================================================
  // PLUS ONE SUMMON
  // ============================================================================

  static String _plusOneSummonContent({required bool gloomhavenMode}) {
    final persistentInfo = gloomhavenMode
        ? ''
        : ' Summon stat enhancements are **never** subject to the persistent icon multiplier.';

    return "This enhancement can be placed on any summon ability with a **numerical value.** "
        "That value is increased by 1.$persistentInfo";
  }

  static RichText plusOneSummonInfoBody(
    BuildContext context,
    bool gloomhavenMode,
    bool darkMode,
  ) {
    return _buildRichText(
      context,
      _plusOneSummonContent(gloomhavenMode: gloomhavenMode),
      darkMode,
    );
  }

  // ============================================================================
  // NEGATIVE EFFECTS
  // ============================================================================

  static const String _negEffectContent =
      "These enhancements can be placed on any **main** ability line that targets enemies. "
      "The specified condition is applied to all targets of that ability unless they are "
      "immune. Curse can be added multiple times to the same ability line. Summon abilities "
      "**cannot** be enhanced with effects.";

  static RichText negEffectInfoBody(BuildContext context, bool darkMode) {
    return _buildRichText(context, _negEffectContent, darkMode);
  }

  // ============================================================================
  // POSITIVE EFFECTS
  // ============================================================================

  static const String _posEffectContent =
      "These enhancements can be placed on any **main** ability line that targets allies "
      "or yourself. The specified condition is applied to all targets of that ability. "
      "Bless can be added multiple times to the same ability line. Summon abilities "
      "**cannot** be enhanced with effects.";

  static RichText posEffectInfoBody(BuildContext context, bool darkMode) {
    return _buildRichText(context, _posEffectContent, darkMode);
  }

  // ============================================================================
  // JUMP
  // ============================================================================

  static const String _jumpContent =
      "This enhancement can be placed on any move ability line. The movement is now "
      "considered a Jump. A summon's Move **cannot** be enhanced with Jump.";

  static RichText jumpInfoBody(BuildContext context, bool darkMode) {
    return _buildRichText(context, _jumpContent, darkMode);
  }

  // ============================================================================
  // SPECIFIC ELEMENT
  // ============================================================================

  static String _specificElementContent({required bool gloomhavenMode}) {
    final multiplierInfo = gloomhavenMode
        ? ''
        : ' Element enhancements are **never** subject to the multiple targets multiplier.';

    return "These enhancements can be placed on any **main** ability line. The specific "
        "element is created when the ability is used.$multiplierInfo";
  }

  static RichText specificElementInfoBody(
    BuildContext context,
    bool gloomhavenMode,
    bool darkMode,
  ) {
    return _buildRichText(
      context,
      _specificElementContent(gloomhavenMode: gloomhavenMode),
      darkMode,
    );
  }

  // ============================================================================
  // ANY ELEMENT
  // ============================================================================

  static String _anyElementContent({required bool gloomhavenMode}) {
    final multiplierInfo = gloomhavenMode
        ? ''
        : ' Element enhancements are **never** subject to the multiple targets multiplier.';

    return "This enhancement can be placed on any **main** ability line. The player chooses "
        "the element that is created when the ability is used.$multiplierInfo";
  }

  static RichText anyElementInfoBody(
    BuildContext context,
    bool gloomhavenMode,
    bool darkMode,
  ) {
    return _buildRichText(
      context,
      _anyElementContent(gloomhavenMode: gloomhavenMode),
      darkMode,
    );
  }

  static const List<String> anyElementIcon = ['elem_any.svg'];

  // ============================================================================
  // HEX
  // ============================================================================

  static const String _hexContent =
      "This enhancement can be placed to increase the graphical depiction of an "
      "**area attack.** The new Hex becomes an additional target of the attack. Adding "
      "a Hex is **never** subject to the multiple targets multiplier.";

  static RichText hexInfoBody(BuildContext context, bool darkMode) {
    return _buildRichText(context, _hexContent, darkMode);
  }

  static const List<String> hexIcon = ['hex.svg'];
  static const List<String> hexEligibleIcons = ['hex.svg'];

  // ============================================================================
  // MULTIPLE TARGETS
  // ============================================================================

  static const String multipleTargetsInfoTitle = "Multiple Targets Multiplier";

  static String _multipleTargetsContent({
    required bool gloomhavenMode,
    required bool enhancerLvl2,
  }) {
    final gloomhavenRules = gloomhavenMode
        ? "This will **always** apply to adding Target+1, and it will **never** apply to adding a Hex."
        : "This will **never** apply to adding Target+1, enhancing an ability with an Element, or adding a Hex."
              "${enhancerLvl2 ? '\nThis multiplier is applied before the discount applied by upgrading the Enhancer (Building 44) to lvl 2.\nFor example, with the Enhancer lvl 2 upgrade, adding WOUND to an action that has multiple targets will cost 140 gold, calculated as (75x2)-10.' : ''}";

    return "If an ability targets multiple enemies or allies, the enhancement base cost is "
        "**doubled**. This includes abilities that target 'All adjacent enemies' or "
        "'All allies within RANGE 3', for example. $gloomhavenRules";
  }

  static RichText multipleTargetsInfoBody(
    BuildContext context, {
    required bool gloomhavenMode,
    required bool enhancerLvl2,
    required bool darkMode,
  }) {
    return _buildRichText(
      context,
      _multipleTargetsContent(
        gloomhavenMode: gloomhavenMode,
        enhancerLvl2: enhancerLvl2,
      ),
      darkMode,
    );
  }

  // ============================================================================
  // LOST NON-PERSISTENT
  // ============================================================================

  static const String lostNonPersistentInfoTitle = "Lost & Non-Persistent";

  static const String _lostNonPersistentContent =
      "If the action has a Lost icon, but no Persistent icon, halve the base cost.";

  static RichText lostNonPersistentInfoBody(
    BuildContext context,
    bool darkMode,
  ) {
    return _buildRichText(context, _lostNonPersistentContent, darkMode);
  }

  // ============================================================================
  // PERSISTENT
  // ============================================================================

  static const String persistentInfoTitle = "Persistent";

  static const String _persistentContent =
      "If the action has a Persistent icon, whether or not there is a Lost icon, triple "
      "the base cost. This **does not** apply to summon stat enhancements.";

  static RichText persistentInfoBody(BuildContext context, bool darkMode) {
    return _buildRichText(context, _persistentContent, darkMode);
  }

  // ============================================================================
  // NEW CHARACTER
  // ============================================================================

  static const String newCharacterInfoTitle = "New Character";

  static String _newCharacterContent({required bool gloomhavenMode}) {
    if (gloomhavenMode) {
      return "When starting a new character in Gloomhaven, you can choose to immediately "
          "level up to any level less than or equal to the current Prosperity Level of the "
          "city, gaining the benefits for each level in sequence.\nYou are also alloted an "
          "amount of gold equal to **15x(L+1)**, where L is your character's starting level.\n"
          "For example, if the city is at Prosperity Level 3, you could start a character at "
          "level 1, 2, or 3, and would be alloted 30, 45, or 60 gold, respectively.";
    } else {
      return "When starting a new character in Frosthaven, you can choose to immediately "
          "level up to any level less than or equal to the current Prosperity Level of the "
          "city divided by 2 (rounded up), gaining the benefits for each level in sequence.\n"
          "You are also alloted an amount of gold equal to **10xP+20**, where 'P' is the "
          "current Prosperity Level.\nFor example, if the city is at Prosperity Level 3, "
          "you could start a character at level 1 or 2, and would be alloted 40 gold. This "
          "gold must be spent immediately on items in the available purchasable supply, and "
          "any unspent gold is forfeited.";
    }
  }

  static RichText newCharacterInfoBody(
    BuildContext context, {
    required bool gloomhavenMode,
    required bool darkMode,
  }) {
    return _buildRichText(
      context,
      _newCharacterContent(gloomhavenMode: gloomhavenMode),
      darkMode,
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Build a RichText widget from markdown-formatted string
  ///
  /// This uses the GameTextParser to convert markdown syntax (**bold**, *italic*,
  /// icons, etc.) into properly formatted InlineSpans.
  static RichText _buildRichText(
    BuildContext context,
    String content,
    bool darkMode,
  ) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: GameTextParser.parse(context, content, darkMode),
      ),
    );
  }
}

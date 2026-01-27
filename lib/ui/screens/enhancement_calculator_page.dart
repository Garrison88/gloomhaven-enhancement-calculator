import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/l10n/app_localizations.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/theme/theme_provider.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/info_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/calculator/calculator_section_card.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/calculator/card_level_body.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/calculator/cost_display.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/calculator/enhancement_type_body.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/calculator/info_button_config.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/calculator/previous_enhancements_body.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/expandable_cost_chip.dart';
import 'package:gloomhaven_enhancement_calc/utils/themed_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

class EnhancementCalculatorPage extends StatefulWidget {
  const EnhancementCalculatorPage({super.key});

  @override
  State<EnhancementCalculatorPage> createState() =>
      _EnhancementCalculatorPageState();
}

class _EnhancementCalculatorPageState extends State<EnhancementCalculatorPage> {
  @override
  Widget build(BuildContext context) {
    final enhancementCalculatorModel = context
        .watch<EnhancementCalculatorModel>();
    // Watch ThemeProvider to rebuild when theme changes
    final themeProvider = context.watch<ThemeProvider>();
    enhancementCalculatorModel.calculateCost(notify: false);
    final darkTheme = themeProvider.useDarkMode;
    final edition = SharedPrefs().gameEdition;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
                child: ListView(
                  controller: context
                      .read<CharactersModel>()
                      .enhancementCalcScrollController,
                  padding: EdgeInsets.only(
                    // Extra padding when chip and FAB are present
                    bottom: enhancementCalculatorModel.showCost ? 80 : 16,
                  ),
                  children: <Widget>[
                    // === CALCULATION INPUTS (change per enhancement) ===

                    // 1. ENHANCEMENT TYPE - core selection
                    _EnhancementTypeCard(
                      edition: edition,
                      enhancementCalculatorModel: enhancementCalculatorModel,
                    ),

                    // 2. CARD LEVEL
                    _CardLevelCard(
                      edition: edition,
                      enhancementCalculatorModel: enhancementCalculatorModel,
                      darkTheme: darkTheme,
                    ),

                    // 3. PREVIOUS ENHANCEMENTS
                    _PreviousEnhancementsCard(
                      edition: edition,
                      enhancementCalculatorModel: enhancementCalculatorModel,
                      darkTheme: darkTheme,
                    ),

                    // 4. MODIFIERS

                    // 4a. MULTIPLE TARGETS
                    CalculatorSectionCard(
                      layout: CardLayoutVariant.toggle,
                      infoConfig: InfoButtonConfig.titleMessage(
                        title: Strings.multipleTargetsInfoTitle,
                        message: Strings.multipleTargetsInfoBody(
                          context,
                          edition: edition,
                          enhancerLvl2:
                              edition.hasEnhancerLevels &&
                              SharedPrefs().enhancerLvl2,
                          darkMode: darkTheme,
                        ),
                      ),
                      title: AppLocalizations.of(context).multipleTargets,
                      toggleValue: enhancementCalculatorModel.multipleTargets,
                      toggleEnabled:
                          !enhancementCalculatorModel.disableMultiTargetsSwitch,
                      onToggleChanged: (bool value) {
                        enhancementCalculatorModel.multipleTargets = value;
                      },
                    ),

                    // 4b. LOSS NON-PERSISTENT (GH2E and FH only)
                    if (edition.hasLostModifier)
                      CalculatorSectionCard(
                        layout: CardLayoutVariant.toggle,
                        infoConfig: InfoButtonConfig.titleMessage(
                          title: Strings.lostNonPersistentInfoTitle(
                            edition: edition,
                          ),
                          message: Strings.lostNonPersistentInfoBody(
                            context,
                            edition,
                            darkTheme,
                          ),
                        ),
                        subtitle: AppLocalizations.of(
                          context,
                        ).lossNonPersistent,
                        titleWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ThemedSvg(assetKey: 'LOSS', width: iconSize),
                            if (edition.hasPersistentModifier) ...[
                              const SizedBox(width: largePadding),
                              SizedBox(
                                width: iconSize + 16,
                                height: iconSize + 11,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ThemedSvg(
                                      assetKey: 'PERSISTENT',
                                      width: iconSize,
                                    ),
                                    Positioned(
                                      right: 5,
                                      child: SvgPicture.asset(
                                        'images/ui/not.svg',
                                        width: iconSize + 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        toggleValue:
                            enhancementCalculatorModel.lostNonPersistent,
                        toggleEnabled:
                            !enhancementCalculatorModel.persistent &&
                            (edition.hasPersistentModifier ||
                                enhancementCalculatorModel
                                        .enhancement
                                        ?.category !=
                                    EnhancementCategory.summonPlusOne),
                        onToggleChanged: (bool value) {
                          enhancementCalculatorModel.lostNonPersistent = value;
                        },
                      ),

                    // 4c. PERSISTENT (FH only)
                    if (edition.hasPersistentModifier)
                      CalculatorSectionCard(
                        layout: CardLayoutVariant.toggle,
                        infoConfig: InfoButtonConfig.titleMessage(
                          title: Strings.persistentInfoTitle,
                          message: Strings.persistentInfoBody(
                            context,
                            darkTheme,
                          ),
                        ),
                        subtitle: AppLocalizations.of(context).persistent,
                        titleWidget: ThemedSvg(
                          assetKey: 'PERSISTENT',
                          width: iconSize,
                        ),
                        toggleValue: enhancementCalculatorModel.persistent,
                        toggleEnabled:
                            enhancementCalculatorModel.enhancement?.category !=
                                EnhancementCategory.summonPlusOne &&
                            !enhancementCalculatorModel.lostNonPersistent,
                        onToggleChanged: (bool value) {
                          enhancementCalculatorModel.persistent = value;
                        },
                      ),

                    // === DISCOUNTS & SETTINGS (set once) ===
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: largePadding,
                      ),
                      child: Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: largePadding,
                            ),
                            child: Text(
                              AppLocalizations.of(context).discountsAndSettings,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),

                    // 5. HAIL'S DISCOUNT
                    CalculatorSectionCard(
                      layout: CardLayoutVariant.toggle,
                      infoConfig: InfoButtonConfig.titleMessage(
                        title: Strings.hailsDiscountTitle,
                        message: Strings.hailsDiscountInfoBody(
                          context,
                          darkTheme,
                        ),
                      ),
                      title: AppLocalizations.of(context).hailsDiscount,
                      toggleValue: enhancementCalculatorModel.hailsDiscount,
                      onToggleChanged: (bool value) {
                        enhancementCalculatorModel.hailsDiscount = value;
                      },
                    ),

                    // 6. TEMPORARY ENHANCEMENT
                    CalculatorSectionCard(
                      layout: CardLayoutVariant.toggle,
                      infoConfig: InfoButtonConfig.titleMessage(
                        title: Strings.temporaryEnhancement,
                        message: Strings.temporaryEnhancementInfoBody(
                          context,
                          darkTheme,
                        ),
                      ),
                      title: AppLocalizations.of(context).temporaryEnhancement,
                      subtitle: AppLocalizations.of(context).variant,
                      toggleValue:
                          enhancementCalculatorModel.temporaryEnhancementMode,
                      onToggleChanged: (bool value) {
                        enhancementCalculatorModel.temporaryEnhancementMode =
                            value;
                      },
                    ),

                    // 7. SCENARIO 114 REWARD (PARTY BOON) - Gloomhaven/GH2E only
                    if (edition.supportsPartyBoon)
                      CalculatorSectionCard(
                        layout: CardLayoutVariant.toggle,
                        infoConfig: InfoButtonConfig.titleMessage(
                          title: Strings.scenario114RewardTitle,
                          message: Strings.scenario114RewardInfoBody(
                            context,
                            darkTheme,
                          ),
                        ),
                        title: AppLocalizations.of(context).scenario114Reward,
                        subtitle: AppLocalizations.of(
                          context,
                        ).forgottenCirclesSpoilers,
                        toggleValue: SharedPrefs().partyBoon,
                        onToggleChanged: (bool value) {
                          setState(() {
                            SharedPrefs().partyBoon = value;
                            enhancementCalculatorModel.calculateCost();
                          });
                        },
                      ),

                    // 8. BUILDING 44 (ENHANCER) - Frosthaven only
                    if (edition.hasEnhancerLevels)
                      _Building44Card(
                        enhancementCalculatorModel: enhancementCalculatorModel,
                        darkTheme: darkTheme,
                        onDialogClosed: () => setState(() {}),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Cost chip overlay
        if (enhancementCalculatorModel.showCost)
          ExpandableCostChip(
            totalCost: enhancementCalculatorModel.totalCost,
            steps: enhancementCalculatorModel.getCalculationBreakdown(),
            enhancement: enhancementCalculatorModel.enhancement,
          ),
      ],
    );
  }
}

/// Card Level selector card using the new component system.
class _CardLevelCard extends StatelessWidget {
  final dynamic edition;
  final EnhancementCalculatorModel enhancementCalculatorModel;
  final bool darkTheme;

  const _CardLevelCard({
    required this.edition,
    required this.enhancementCalculatorModel,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final partyBoon = edition.supportsPartyBoon && SharedPrefs().partyBoon;
    final enhancerLvl3 =
        edition.hasEnhancerLevels && SharedPrefs().enhancerLvl3;
    final level = enhancementCalculatorModel.cardLevel;
    final baseCost = 25 * level;
    final actualCost = enhancementCalculatorModel.cardLevelPenalty(level);

    return CalculatorSectionCard(
      infoConfig: InfoButtonConfig.titleMessage(
        title: Strings.cardLevelInfoTitle,
        message: Strings.cardLevelInfoBody(
          context,
          darkTheme,
          edition: edition,
          partyBoon: partyBoon,
          enhancerLvl3: enhancerLvl3,
        ),
      ),
      title: '${AppLocalizations.of(context).cardLevel}: ${level + 1}',
      body: CardLevelBody(model: enhancementCalculatorModel),
      costConfig: CostDisplayConfig(
        baseCost: baseCost,
        discountedCost: actualCost != baseCost ? actualCost : null,
      ),
    );
  }
}

/// Previous Enhancements selector card using the new component system.
class _PreviousEnhancementsCard extends StatelessWidget {
  final dynamic edition;
  final EnhancementCalculatorModel enhancementCalculatorModel;
  final bool darkTheme;

  const _PreviousEnhancementsCard({
    required this.edition,
    required this.enhancementCalculatorModel,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final enhancerLvl4 =
        edition.hasEnhancerLevels && SharedPrefs().enhancerLvl4;
    final tempEnhancements =
        enhancementCalculatorModel.temporaryEnhancementMode;
    final selected = enhancementCalculatorModel.previousEnhancements;
    final baseCost = 75 * selected;
    final actualCost = enhancementCalculatorModel.previousEnhancementsPenalty(
      selected,
    );

    return CalculatorSectionCard(
      infoConfig: InfoButtonConfig.titleMessage(
        title: Strings.previousEnhancementsInfoTitle,
        message: Strings.previousEnhancementsInfoBody(
          context,
          darkTheme,
          edition: edition,
          enhancerLvl4: enhancerLvl4,
        ),
      ),
      title: AppLocalizations.of(context).previousEnhancements,
      body: PreviousEnhancementsBody(model: enhancementCalculatorModel),
      costConfig: CostDisplayConfig(
        baseCost: baseCost,
        discountedCost: actualCost != baseCost ? actualCost : null,
        marker: tempEnhancements ? '\u2020' : null,
      ),
    );
  }
}

/// Enhancement Type selector card using the new component system.
class _EnhancementTypeCard extends StatelessWidget {
  final dynamic edition;
  final EnhancementCalculatorModel enhancementCalculatorModel;

  const _EnhancementTypeCard({
    required this.edition,
    required this.enhancementCalculatorModel,
  });

  @override
  Widget build(BuildContext context) {
    final enhancement = enhancementCalculatorModel.enhancement;

    return CalculatorSectionCard(
      infoConfig: enhancement != null
          ? InfoButtonConfig.category(category: enhancement.category)
          : InfoButtonConfig.titleMessage(
              title: '',
              message: RichText(text: const TextSpan()),
              enabled: false,
            ),
      title: AppLocalizations.of(context).enhancementType,
      body: EnhancementTypeBody(
        model: enhancementCalculatorModel,
        edition: edition,
      ),
    );
  }
}

/// Building 44 (Enhancer) card - special case with dialog.
class _Building44Card extends StatelessWidget {
  final EnhancementCalculatorModel enhancementCalculatorModel;
  final bool darkTheme;
  final VoidCallback onDialogClosed;

  const _Building44Card({
    required this.enhancementCalculatorModel,
    required this.darkTheme,
    required this.onDialogClosed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 4 : 1,
      color: isDark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: mediumPadding),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) {
                    return InfoDialog(
                      title: Strings.building44Title,
                      message: Strings.building44InfoBody(context, darkTheme),
                    );
                  },
                ),
              ),
              title: Text(AppLocalizations.of(context).building44),
              subtitle: Text(
                AppLocalizations.of(context).frosthavenSpoilers,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.grey),
              ),
              onTap: () => _showEnhancerDialog(context),
            ),
            Positioned(
              right: 32.5,
              child: IgnorePointer(
                ignoring: true,
                child: Icon(
                  Icons.open_in_new,
                  size: 30,
                  color: colorScheme.onSurface.withValues(alpha: .75),
                ),
              ),
            ),
            const SizedBox(width: 32.5),
          ],
        ),
      ),
    );
  }

  void _showEnhancerDialog(BuildContext context) {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              AppLocalizations.of(context).enhancer,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          content: StatefulBuilder(
            builder: (_, innerSetState) {
              return Container(
                constraints: const BoxConstraints(maxWidth: maxDialogWidth),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEnhancerLevel(
                        context,
                        innerSetState,
                        level: 1,
                        subtitle: AppLocalizations.of(context).buyEnhancements,
                        value: true,
                        enabled: false,
                      ),
                      _buildEnhancerLevel(
                        context,
                        innerSetState,
                        level: 2,
                        subtitle: AppLocalizations.of(
                          context,
                        ).reduceEnhancementCosts,
                        value: SharedPrefs().enhancerLvl2,
                        onChanged: (val) {
                          if (val != null) {
                            innerSetState(() {
                              SharedPrefs().enhancerLvl2 = val;
                              enhancementCalculatorModel.calculateCost();
                            });
                          }
                        },
                      ),
                      _buildEnhancerLevel(
                        context,
                        innerSetState,
                        level: 3,
                        subtitle: AppLocalizations.of(
                          context,
                        ).reduceLevelPenalties,
                        value: SharedPrefs().enhancerLvl3,
                        onChanged: (val) {
                          if (val != null) {
                            innerSetState(() {
                              SharedPrefs().enhancerLvl3 = val;
                              enhancementCalculatorModel.calculateCost();
                            });
                          }
                        },
                      ),
                      _buildEnhancerLevel(
                        context,
                        innerSetState,
                        level: 4,
                        subtitle: AppLocalizations.of(
                          context,
                        ).reduceRepeatPenalties,
                        value: SharedPrefs().enhancerLvl4,
                        onChanged: (val) {
                          if (val != null) {
                            innerSetState(() {
                              SharedPrefs().enhancerLvl4 = val;
                              enhancementCalculatorModel.calculateCost();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).close),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((_) => onDialogClosed());
  }

  Widget _buildEnhancerLevel(
    BuildContext context,
    StateSetter innerSetState, {
    required int level,
    required String subtitle,
    required bool value,
    bool enabled = true,
    ValueChanged<bool?>? onChanged,
  }) {
    final isActive = value;

    return CheckboxListTile(
      title: Text(
        _getLevelLabel(context, level),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: SharedPrefs().useDefaultFonts ? 25 : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: isActive ? null : Colors.grey,
          fontSize: 20,
        ),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }

  String _getLevelLabel(BuildContext context, int level) {
    switch (level) {
      case 1:
        return AppLocalizations.of(context).lvl1;
      case 2:
        return AppLocalizations.of(context).lvl2;
      case 3:
        return AppLocalizations.of(context).lvl3;
      case 4:
        return AppLocalizations.of(context).lvl4;
      default:
        return '';
    }
  }
}

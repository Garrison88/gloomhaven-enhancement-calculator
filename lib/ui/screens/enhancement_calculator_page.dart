import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/l10n/app_localizations.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/theme/theme_provider.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/info_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/enhancement_type_selector.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/expandable_cost_chip.dart';
import 'package:gloomhaven_enhancement_calc/utils/themed_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

class EnhancementCalculatorPage extends StatefulWidget {
  const EnhancementCalculatorPage({super.key});

  @override
  State<EnhancementCalculatorPage> createState() =>
      _EnhancementCalculatorPageState();
}

class _EnhancementCalculatorPageState extends State<EnhancementCalculatorPage> {
  // Color _editionColor(GameEdition edition) {
  //   switch (edition) {
  //     case GameEdition.gloomhaven:
  //     case GameEdition.gloomhaven2e:
  //       return const Color(0xffa98274);
  //     case GameEdition.frosthaven:
  //       return const Color(0xff6ab7ff);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    EnhancementCalculatorModel enhancementCalculatorModel = context
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
            OutlinedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) {
                  return InfoDialog(
                    title: Strings.generalInfoTitle,
                    message: Strings.generalInfoBody(
                      context,
                      edition: edition,
                      darkMode: Theme.of(context).brightness == Brightness.dark,
                    ),
                  );
                },
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Text(
                AppLocalizations.of(context).generalGuidelines,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
                child: ListView(
                  padding: EdgeInsets.only(
                    // Extra padding when chip and FAB are present
                    bottom: enhancementCalculatorModel.showCost ? 80 : 16,
                  ),
                  children: <Widget>[
                    // SCENARIO 114 REWARD (PARTY BOON) - Gloomhaven/GH2E only
                    if (edition.supportsPartyBoon) ...[
                      SwitchListTile(
                        value: SharedPrefs().partyBoon,
                        onChanged: (bool value) {
                          setState(() {
                            SharedPrefs().partyBoon = value;
                            enhancementCalculatorModel.calculateCost();
                          });
                        },
                        title: AutoSizeText(
                          AppLocalizations.of(context).scenario114Reward,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context).forgottenCirclesSpoilers,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(color: Colors.grey),
                        ),
                        secondary: IconButton(
                          icon: const Icon(Icons.info_outline_rounded),
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) {
                              return InfoDialog(
                                title: Strings.scenario114RewardTitle,
                                message: Strings.scenario114RewardInfoBody(
                                  context,
                                  darkTheme,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const EnhancementDivider(),
                    ],
                    // TEMPORARY ENHANCEMENT
                    SwitchListTile(
                      value:
                          enhancementCalculatorModel.temporaryEnhancementMode,
                      onChanged: (bool value) {
                        enhancementCalculatorModel.temporaryEnhancementMode =
                            value;
                      },
                      title: AutoSizeText(
                        AppLocalizations.of(
                          context,
                        ).temporaryEnhancementVariant,
                        maxLines: 2,
                      ),
                      secondary: IconButton(
                        icon: const Icon(Icons.info_outline_rounded),
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (_) {
                            return InfoDialog(
                              title: Strings.temporaryEnhancement,
                              message: Strings.temporaryEnhancementInfoBody(
                                context,
                                darkTheme,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const EnhancementDivider(),
                    // BUILDING 44 (ENHANCER) - Frosthaven only
                    if (edition.hasEnhancerLevels) ...[
                      Stack(
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
                                    message: Strings.building44InfoBody(
                                      context,
                                      darkTheme,
                                    ),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              AppLocalizations.of(context).building44,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context).frosthavenSpoilers,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            onTap: () {
                              showDialog<bool>(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        AppLocalizations.of(context).enhancer,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineLarge,
                                      ),
                                    ),
                                    content: StatefulBuilder(
                                      builder: (_, innerSetState) {
                                        return Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: maxDialogWidth,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CheckboxListTile(
                                                  title: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).lvl1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: null,
                                                          fontSize:
                                                              SharedPrefs()
                                                                  .useDefaultFonts
                                                              ? 25
                                                              : null,
                                                        ),
                                                  ),
                                                  subtitle: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).buyEnhancements,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          color:
                                                              SharedPrefs()
                                                                  .enhancerLvl1
                                                              ? null
                                                              : Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                  ),
                                                  value: true,
                                                  onChanged: null,
                                                ),
                                                CheckboxListTile(
                                                  title: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).lvl2,
                                                  ),
                                                  subtitle: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).reduceEnhancementCosts,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          color:
                                                              SharedPrefs()
                                                                  .enhancerLvl2
                                                              ? null
                                                              : Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                  ),
                                                  value: SharedPrefs()
                                                      .enhancerLvl2,
                                                  onChanged: (bool? val) {
                                                    if (val != null) {
                                                      innerSetState(() {
                                                        SharedPrefs()
                                                                .enhancerLvl2 =
                                                            val;
                                                        enhancementCalculatorModel
                                                            .calculateCost();
                                                      });
                                                    }
                                                  },
                                                ),
                                                CheckboxListTile(
                                                  title: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).lvl3,
                                                  ),
                                                  subtitle: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).reduceLevelPenalties,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          color:
                                                              SharedPrefs()
                                                                  .enhancerLvl3
                                                              ? null
                                                              : Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                  ),
                                                  value: SharedPrefs()
                                                      .enhancerLvl3,
                                                  onChanged: (bool? val) {
                                                    if (val != null) {
                                                      innerSetState(() {
                                                        SharedPrefs()
                                                                .enhancerLvl3 =
                                                            val;
                                                        enhancementCalculatorModel
                                                            .calculateCost();
                                                      });
                                                    }
                                                  },
                                                ),
                                                CheckboxListTile(
                                                  title: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).lvl4,
                                                  ),
                                                  subtitle: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).reduceRepeatPenalties,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          color:
                                                              SharedPrefs()
                                                                  .enhancerLvl4
                                                              ? null
                                                              : Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                  ),
                                                  value: SharedPrefs()
                                                      .enhancerLvl4,
                                                  onChanged: (bool? val) {
                                                    if (val != null) {
                                                      innerSetState(() {
                                                        SharedPrefs()
                                                                .enhancerLvl4 =
                                                            val;
                                                        enhancementCalculatorModel
                                                            .calculateCost();
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
                                        child: Text(
                                          AppLocalizations.of(context).close,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ).then((_) {
                                setState(() {});
                              });
                            },
                          ),
                          Positioned(
                            right: 32.5,
                            child: IgnorePointer(
                              ignoring: true,
                              child: Icon(
                                Icons.open_in_new,
                                size: 30,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: .75),
                              ),
                            ),
                          ),
                          const SizedBox(width: 32.5),
                        ],
                      ),
                      const EnhancementDivider(),
                    ],
                    // HAIL'S DISCOUNT
                    SwitchListTile(
                      value: enhancementCalculatorModel.hailsDiscount,
                      onChanged: (bool value) {
                        enhancementCalculatorModel.hailsDiscount = value;
                      },
                      secondary: IconButton(
                        icon: const Icon(Icons.info_outline_rounded),
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (_) {
                            return InfoDialog(
                              title: Strings.hailsDiscountTitle,
                              message: Strings.hailsDiscountInfoBody(
                                context,
                                darkTheme,
                              ),
                            );
                          },
                        ),
                      ),
                      title: AutoSizeText(
                        AppLocalizations.of(context).hailsDiscount,
                        maxLines: 1,
                      ),
                    ),
                    const EnhancementDivider(),
                    // CARD LEVEL
                    _CardLevelSelector(
                      edition: edition,
                      enhancementCalculatorModel: enhancementCalculatorModel,
                      darkTheme: darkTheme,
                    ),
                    const EnhancementDivider(),
                    // PREVIOUS ENHANCEMENTS
                    _PreviousEnhancementsSelector(
                      edition: edition,
                      enhancementCalculatorModel: enhancementCalculatorModel,
                      darkTheme: darkTheme,
                    ),
                    const EnhancementDivider(),
                    // ENHANCEMENT
                    _EnhancementTypeSelector(
                      edition: edition,
                      enhancementCalculatorModel: enhancementCalculatorModel,
                    ),
                    const EnhancementDivider(),
                    // MULTIPLE TARGETS
                    SwitchListTile(
                      value: enhancementCalculatorModel.multipleTargets,
                      onChanged:
                          !enhancementCalculatorModel.disableMultiTargetsSwitch
                          ? (bool value) {
                              enhancementCalculatorModel.multipleTargets =
                                  value;
                            }
                          : null,
                      secondary: IconButton(
                        icon: Icon(
                          Icons.info_outline_rounded,
                          color: darkTheme ? Colors.white : Colors.black,
                        ),
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (_) {
                            return InfoDialog(
                              title: Strings.multipleTargetsInfoTitle,
                              message: Strings.multipleTargetsInfoBody(
                                context,
                                edition: edition,
                                enhancerLvl2:
                                    edition.hasEnhancerLevels &&
                                    SharedPrefs().enhancerLvl2,
                                darkMode: darkTheme,
                              ),
                            );
                          },
                        ),
                      ),
                      title: AutoSizeText(
                        AppLocalizations.of(context).multipleTargets,
                      ),
                    ),
                    // LOSS NON-PERSISTENT (GH2E and FH only)
                    if (edition.hasLostModifier) ...[
                      SwitchListTile(
                        value: enhancementCalculatorModel.lostNonPersistent,
                        // Disable when: persistent is on (FH), OR
                        // in GH2E mode with summon stat selected (summons excluded)
                        onChanged:
                            enhancementCalculatorModel.persistent ||
                                (!edition.hasPersistentModifier &&
                                    enhancementCalculatorModel
                                            .enhancement
                                            ?.category ==
                                        EnhancementCategory.summonPlusOne)
                            ? null
                            : (bool value) {
                                enhancementCalculatorModel.lostNonPersistent =
                                    value;
                              },
                        secondary: IconButton(
                          icon: Icon(
                            Icons.info_outline_rounded,
                            color: darkTheme ? Colors.white : Colors.black,
                          ),
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) {
                              return InfoDialog(
                                title: Strings.lostNonPersistentInfoTitle(
                                  edition: edition,
                                ),
                                message: Strings.lostNonPersistentInfoBody(
                                  context,
                                  edition,
                                  darkTheme,
                                ),
                              );
                            },
                          ),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ThemedSvg(assetKey: 'LOSS', width: iconSize),
                            // Only show "not persistent" icon in FH mode
                            // (GH2E doesn't have persistent modifier)
                            if (edition.hasPersistentModifier)
                              SizedBox(
                                width: iconSize + 16,
                                height: iconSize + 11,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      child: ThemedSvg(
                                        assetKey: 'PERSISTENT',
                                        width: iconSize,
                                      ),
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
                        ),
                      ),
                    ],
                    // PERSISTENT (FH only)
                    if (edition.hasPersistentModifier) ...[
                      SwitchListTile(
                        value: enhancementCalculatorModel.persistent,
                        onChanged:
                            enhancementCalculatorModel.enhancement?.category ==
                                    EnhancementCategory.summonPlusOne ||
                                enhancementCalculatorModel.lostNonPersistent
                            ? null
                            : (bool value) {
                                enhancementCalculatorModel.persistent = value;
                              },
                        secondary: IconButton(
                          icon: Icon(
                            Icons.info_outline_rounded,
                            color: darkTheme ? Colors.white : Colors.black,
                          ),
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) {
                              return InfoDialog(
                                title: Strings.persistentInfoTitle,
                                message: Strings.persistentInfoBody(
                                  context,
                                  darkTheme,
                                ),
                              );
                            },
                          ),
                        ),
                        title: ThemedSvg(
                          assetKey: 'PERSISTENT',
                          width: iconSize,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
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

class EnhancementDivider extends StatelessWidget {
  const EnhancementDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(endIndent: 24, indent: 24, height: 1);
  }
}

/// Material 3 DropdownMenu for selecting card level (1-9)
class _CardLevelSelector extends StatelessWidget {
  final dynamic edition;
  final EnhancementCalculatorModel enhancementCalculatorModel;
  final bool darkTheme;

  const _CardLevelSelector({
    required this.edition,
    required this.enhancementCalculatorModel,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final partyBoon = edition.supportsPartyBoon && SharedPrefs().partyBoon;
    final enhancerLvl3 =
        edition.hasEnhancerLevels && SharedPrefs().enhancerLvl3;

    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.info_outline_rounded),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) {
            return InfoDialog(
              title: Strings.cardLevelInfoTitle,
              message: Strings.cardLevelInfoBody(
                context,
                darkTheme,
                edition: edition,
                partyBoon: partyBoon,
                enhancerLvl3: enhancerLvl3,
              ),
            );
          },
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).cardLevel),
          const SizedBox(height: 8),
          _buildCardLevelSlider(context, enhancementCalculatorModel),
        ],
      ),
    );
  }

  Widget _buildCardLevelSlider(
    BuildContext context,
    EnhancementCalculatorModel model,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final level = model.cardLevel;
    final displayLevel = level + 1;
    final baseCost = 25 * level;
    final actualCost = model.cardLevelPenalty(level);
    final hasDiscount = actualCost != baseCost && level > 0;

    return Column(
      children: [
        // Slider with level labels
        Slider(
          value: level.toDouble(),
          min: 0,
          max: 8,
          divisions: 8,
          label: displayLevel.toString(),
          onChanged: (value) {
            model.cardLevel = value.round();
          },
        ),
        // Level numbers below slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(9, (i) {
            final isSelected = i == level;
            return Text(
              '${i + 1}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            );
          }),
        ),
        const SizedBox(height: mediumPadding),
        // Cost display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: level == 0
              ? Text(
                  '0g',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : hasDiscount
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${baseCost}g',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${actualCost}g',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  '${baseCost}g',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
        ),
      ],
    );
  }
}

/// Material 3 SegmentedButton for selecting previous enhancements (0-3)
class _PreviousEnhancementsSelector extends StatelessWidget {
  final dynamic edition;
  final EnhancementCalculatorModel enhancementCalculatorModel;
  final bool darkTheme;

  const _PreviousEnhancementsSelector({
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

    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.info_outline_rounded),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) {
            return InfoDialog(
              title: Strings.previousEnhancementsInfoTitle,
              message: Strings.previousEnhancementsInfoBody(
                context,
                darkTheme,
                edition: edition,
                enhancerLvl4: enhancerLvl4,
              ),
            );
          },
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).previousEnhancements),
          const SizedBox(height: smallPadding),
          // Cost breakdown text
          _buildCostBreakdown(context, enhancerLvl4, tempEnhancements),
          const SizedBox(height: smallPadding),
          // Segmented button
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment<int>(value: 0, label: Text('None')),
                ButtonSegment<int>(value: 1, label: Text('1')),
                ButtonSegment<int>(value: 2, label: Text('2')),
                ButtonSegment<int>(value: 3, label: Text('3')),
              ],
              selected: {enhancementCalculatorModel.previousEnhancements},
              onSelectionChanged: (Set<int> selected) {
                enhancementCalculatorModel.previousEnhancements =
                    selected.first;
              },
              showSelectedIcon: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown(
    BuildContext context,
    bool enhancerLvl4,
    bool tempEnhancements,
  ) {
    final selected = enhancementCalculatorModel.previousEnhancements;
    // if (selected == 0) {
    //   return const SizedBox.shrink();
    // }

    final baseCost = 75 * selected;
    final actualCost = enhancementCalculatorModel.previousEnhancementsPenalty(
      selected,
    );
    final hasDiscount = actualCost != baseCost;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDiscount) ...[
            Text(
              '${baseCost}g',
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${actualCost}g',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (tempEnhancements)
              Text(
                ' \u2020',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
          ] else
            Text(
              '${baseCost}g',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// Material 3 button that opens a searchable bottom sheet for enhancement type
class _EnhancementTypeSelector extends StatelessWidget {
  final dynamic edition;
  final EnhancementCalculatorModel enhancementCalculatorModel;

  const _EnhancementTypeSelector({
    required this.edition,
    required this.enhancementCalculatorModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final enhancement = enhancementCalculatorModel.enhancement;

    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.info_outline_rounded),
        onPressed: enhancement != null
            ? () => showDialog<void>(
                context: context,
                builder: (_) {
                  return InfoDialog(category: enhancement.category);
                },
              )
            : null,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).enhancementType),
          const SizedBox(height: 8),
          // Tappable button that shows current selection or placeholder
          InkWell(
            onTap: () {
              EnhancementTypeSelector.show(
                context,
                currentSelection: enhancement,
                edition: edition,
                onSelected: (selected) {
                  enhancementCalculatorModel.enhancementSelected(selected);
                },
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: enhancement != null
                        ? _buildSelectedEnhancement(context, enhancement)
                        : Text(
                            AppLocalizations.of(context).type,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedEnhancement(
    BuildContext context,
    Enhancement enhancement,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPlusOne =
        enhancement.category == EnhancementCategory.charPlusOne ||
        enhancement.category == EnhancementCategory.target ||
        enhancement.category == EnhancementCategory.summonPlusOne;

    final baseCost = enhancement.cost(edition: edition);
    final discountedCost = enhancementCalculatorModel.enhancementCost(
      enhancement,
    );
    final hasDiscount = discountedCost != baseCost;

    return Row(
      children: [
        if (enhancement.assetKey != null) ...[
          _buildEnhancementIcon(enhancement, isPlusOne),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(enhancement.name, style: theme.textTheme.bodyLarge),
        ),
        // Cost display
        hasDiscount
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${baseCost}g',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${discountedCost}g',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                '${baseCost}g',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
      ],
    );
  }

  Widget _buildEnhancementIcon(Enhancement enhancement, bool isPlusOne) {
    if (enhancement.name == 'Element') {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              top: 5,
              left: 5,
              child: SvgPicture.asset(
                'images/elements/elem_dark.svg',
                width: 10,
              ),
            ),
            Positioned(
              top: 4,
              left: 7,
              child: SvgPicture.asset(
                'images/elements/elem_air.svg',
                width: 11,
              ),
            ),
            Positioned(
              top: 3,
              right: 6,
              child: SvgPicture.asset(
                'images/elements/elem_ice.svg',
                width: 12,
              ),
            ),
            Positioned(
              top: 0,
              right: 2,
              bottom: 2,
              child: SvgPicture.asset(
                'images/elements/elem_fire.svg',
                width: 13,
              ),
            ),
            Positioned(
              bottom: 1,
              right: 4,
              child: SvgPicture.asset(
                'images/elements/elem_earth.svg',
                width: 14,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 3,
              child: SvgPicture.asset(
                'images/elements/elem_light.svg',
                width: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ThemedSvg(
      assetKey: enhancement.assetKey!,
      width: iconSize,
      showPlusOneOverlay: isPlusOne,
    );
  }
}

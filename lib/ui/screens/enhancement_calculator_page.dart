import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
// import 'package:gloomhaven_enhancement_calc/models/game_edition.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/theme/theme_provider.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/info_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/cost_bottom_sheet.dart';
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
                'General Guidelines',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(horizontal: smallPadding),
                child: ListView(
                  padding: EdgeInsets.only(
                    bottom: enhancementCalculatorModel.showCost ? 100 : 88,
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
                    title: const AutoSizeText(
                      'Scenario 114 Reward',
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      'Forgotten Circles spoilers',
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
                  value: enhancementCalculatorModel.temporaryEnhancementMode,
                  onChanged: (bool value) {
                    enhancementCalculatorModel.temporaryEnhancementMode = value;
                  },
                  title: const AutoSizeText(
                    'Variant: Temporary Enhancement †',
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
                        title: const Text('Building 44'),
                        subtitle: Text(
                          'Frosthaven spoilers',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(color: Colors.grey),
                        ),
                        onTap: () {
                          showDialog<bool>(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                    'Enhancer',
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
                                                'Lvl 1',
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
                                                'Buy enhancements',
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
                                              title: const Text('Lvl 2'),
                                              subtitle: Text(
                                                'and reduce all enhancement costs by 10 gold',
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
                                              value: SharedPrefs().enhancerLvl2,
                                              onChanged: (bool? val) {
                                                if (val != null) {
                                                  innerSetState(() {
                                                    SharedPrefs().enhancerLvl2 =
                                                        val;
                                                    enhancementCalculatorModel
                                                        .calculateCost();
                                                  });
                                                }
                                              },
                                            ),
                                            CheckboxListTile(
                                              title: const Text('Lvl 3'),
                                              subtitle: Text(
                                                'and reduce level penalties by 10 gold per level',
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
                                              value: SharedPrefs().enhancerLvl3,
                                              onChanged: (bool? val) {
                                                if (val != null) {
                                                  innerSetState(() {
                                                    SharedPrefs().enhancerLvl3 =
                                                        val;
                                                    enhancementCalculatorModel
                                                        .calculateCost();
                                                  });
                                                }
                                              },
                                            ),
                                            CheckboxListTile(
                                              title: const Text('Lvl 4'),
                                              subtitle: Text(
                                                'and reduce repeat penalties by 25 gold per enhancement',
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
                                              value: SharedPrefs().enhancerLvl4,
                                              onChanged: (bool? val) {
                                                if (val != null) {
                                                  innerSetState(() {
                                                    SharedPrefs().enhancerLvl4 =
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
                                    child: const Text('Close'),
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
                  title: const AutoSizeText('Hail\'s Discount ‡', maxLines: 1),
                ),
                const EnhancementDivider(),
                // CARD LEVEL
                ListTile(
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
                            partyBoon:
                                edition.supportsPartyBoon &&
                                SharedPrefs().partyBoon,
                            enhancerLvl3:
                                edition.hasEnhancerLevels &&
                                SharedPrefs().enhancerLvl3,
                          ),
                        );
                      },
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Card Level'),
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            alignment: Alignment.center,
                            value: enhancementCalculatorModel.cardLevel,
                            items: EnhancementData.cardLevels(
                              context,
                              partyBoon:
                                  edition.supportsPartyBoon &&
                                  SharedPrefs().partyBoon,
                              enhancerLvl3:
                                  edition.hasEnhancerLevels &&
                                  SharedPrefs().enhancerLvl3,
                            ),
                            onChanged: (int? value) {
                              if (value != null) {
                                enhancementCalculatorModel.cardLevel = value;
                              }
                            },
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const EnhancementDivider(),
                // PREVIOUS ENHANCEMENTS
                ListTile(
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
                            enhancerLvl4: SharedPrefs().enhancerLvl4,
                          ),
                        );
                      },
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Previous Enhancements'),
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            alignment: Alignment.center,
                            value:
                                enhancementCalculatorModel.previousEnhancements,
                            items: EnhancementData.previousEnhancements(
                              context,
                              enhancerLvl4:
                                  edition.hasEnhancerLevels &&
                                  SharedPrefs().enhancerLvl4,
                              tempEnhancements: enhancementCalculatorModel
                                  .temporaryEnhancementMode,
                            ),
                            onChanged: (int? value) {
                              if (value != null) {
                                enhancementCalculatorModel
                                        .previousEnhancements =
                                    value;
                              }
                            },
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const EnhancementDivider(),
                // ENHANCEMENT
                ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.info_outline_rounded),
                    onPressed: enhancementCalculatorModel.enhancement != null
                        ? () => showDialog<void>(
                            context: context,
                            builder: (_) {
                              return InfoDialog(
                                category: enhancementCalculatorModel
                                    .enhancement!
                                    .category,
                              );
                            },
                          )
                        : null,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enhancement Type'),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<Enhancement>(
                          alignment: Alignment.center,
                          hint: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Type',
                              style: DropdownMenuThemeData(
                                textStyle: Theme.of(
                                  context,
                                ).textTheme.bodyMedium,
                              ).textStyle?.copyWith(color: Colors.grey),
                            ),
                          ),
                          isExpanded: true,
                          value: enhancementCalculatorModel.enhancement,
                          items: EnhancementData.enhancementTypes(
                            context,
                            edition: edition,
                          ),
                          onChanged: (Enhancement? selectedEnhancement) {
                            if (selectedEnhancement != null) {
                              enhancementCalculatorModel.enhancementSelected(
                                selectedEnhancement,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const EnhancementDivider(),
                // MULTIPLE TARGETS
                SwitchListTile(
                  value: enhancementCalculatorModel.multipleTargets,
                  onChanged:
                      !enhancementCalculatorModel.disableMultiTargetsSwitch
                      ? (bool value) {
                          enhancementCalculatorModel.multipleTargets = value;
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
                  title: const AutoSizeText('Multiple Targets'),
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
                                    'images/not.svg',
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
                    title: ThemedSvg(assetKey: 'PERSISTENT', width: iconSize),
                  ),
                  const SizedBox(height: 4),
                ],
              ],
            ),
          ),
        ),
          ],
        ),
        // Cost bottom sheet overlay
        if (enhancementCalculatorModel.showCost)
          CostBottomSheet(
            totalCost: enhancementCalculatorModel.totalCost,
            steps: enhancementCalculatorModel.getCalculationBreakdown(),
            enhancement: enhancementCalculatorModel.enhancement,
            temporaryMode: enhancementCalculatorModel.temporaryEnhancementMode,
            hailsDiscount: enhancementCalculatorModel.hailsDiscount,
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

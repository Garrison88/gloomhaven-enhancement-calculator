import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/info_dialog.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

class EnhancementCalculatorPage extends StatefulWidget {
  const EnhancementCalculatorPage({
    super.key,
  });

  @override
  State<EnhancementCalculatorPage> createState() =>
      _EnhancementCalculatorPageState();
}

class _EnhancementCalculatorPageState extends State<EnhancementCalculatorPage> {
  // final ScrollController scrollController = ScrollController();
  // bool isBottom = false;

  // @override
  // void initState() {
  //   super.initState();
  //   scrollController.addListener(() {
  //     if ((scrollController.offset >=
  //         scrollController.position.maxScrollExtent)) {
  //       setState(() {
  //         isBottom = true;
  //       });
  //     } else {
  //       setState(() {
  //         isBottom = false;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    EnhancementCalculatorModel enhancementCalculatorModel =
        context.watch<EnhancementCalculatorModel>();
    enhancementCalculatorModel.calculateCost(notify: false);

    return Column(
      children: [
        OutlinedButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) {
              return InfoDialog(
                title: Strings.generalInfoTitle,
                message: Strings.generalInfoBody(
                  context,
                  gloomhavenMode: SharedPrefs().gloomhavenMode,
                  darkMode: Theme.of(context).brightness == Brightness.dark,
                ),
              );
            },
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              width: 2.0,
              color:
                  Color(SharedPrefs().gloomhavenMode ? 0xffa98274 : 0xff6ab7ff),
            ),
          ),
          child: Text(
            '${SharedPrefs().gloomhavenMode ? 'Gloomhaven' : 'Frosthaven'} Guidelines',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(horizontal: smallPadding),
            child: ListView(
              // controller: scrollController,
              children: <Widget>[
                // TEMPORARY ENHANCEMENT
                SwitchListTile(
                  value: enhancementCalculatorModel.temporaryEnhancementMode,
                  onChanged: (bool value) {
                    enhancementCalculatorModel.temporaryEnhancementMode = value;
                  },
                  title: const AutoSizeText(
                    'Variant: Temporary Enhancement*',
                    maxLines: 2,
                  ),
                  secondary: IconButton(
                    icon: const Icon(
                      Icons.info_outline_rounded,
                    ),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) {
                        return InfoDialog(
                          title: Strings.temporaryEnhancement,
                          message:
                              Strings.temporaryEnhancementInfoBody(context),
                        );
                      },
                    ),
                  ),
                ),
                const EnhancementDivider(),
                // CARD LEVEL
                ListTile(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.info_outline_rounded,
                    ),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) {
                        return InfoDialog(
                          title: Strings.cardLevelInfoTitle,
                          message: Strings.cardLevelInfoBody(context),
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
                              partyBoon: SharedPrefs().gloomhavenMode &&
                                  SharedPrefs().partyBoon,
                              enhancerLvl3: !SharedPrefs().gloomhavenMode &&
                                  SharedPrefs().enhancerLvl3,
                            ),
                            onChanged: (int? value) {
                              if (value != null) {
                                enhancementCalculatorModel.cardLevel = value;
                              }
                            },
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
                    icon: const Icon(
                      Icons.info_outline_rounded,
                    ),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) {
                        return InfoDialog(
                          title: Strings.previousEnhancementsInfoTitle,
                          message: Strings.previousEnhancementsInfoBody(
                            context,
                          ),
                        );
                      },
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Previous Enhancements',
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            alignment: Alignment.center,
                            value:
                                enhancementCalculatorModel.previousEnhancements,
                            items: EnhancementData.previousEnhancements(
                              context,
                              enhancerLvl4: !SharedPrefs().gloomhavenMode &&
                                  SharedPrefs().enhancerLvl4,
                              tempEnhancements: enhancementCalculatorModel
                                  .temporaryEnhancementMode,
                            ),
                            onChanged: (int? value) {
                              if (value != null) {
                                enhancementCalculatorModel
                                    .previousEnhancements = value;
                              }
                            },
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
                    icon: const Icon(
                      Icons.info_outline_rounded,
                    ),
                    onPressed: enhancementCalculatorModel.enhancement != null
                        ? () => showDialog<void>(
                              context: context,
                              builder: (_) {
                                return InfoDialog(
                                  category: enhancementCalculatorModel
                                      .enhancement!.category,
                                );
                              },
                            )
                        : null,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enhancement Type',
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Enhancement>(
                            alignment: Alignment.center,
                            hint: Text(
                              'Type',
                              style: DropdownMenuThemeData(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium)
                                  .textStyle
                                  ?.copyWith(color: Colors.grey),
                            ),
                            value: enhancementCalculatorModel.enhancement,
                            items: EnhancementData.enhancementTypes(
                              context,
                              gloomhavenMode: SharedPrefs().gloomhavenMode,
                              enhancerLvl2: SharedPrefs().enhancerLvl2,
                            ),
                            onChanged: (Enhancement? selectedEnhancement) {
                              if (selectedEnhancement != null) {
                                enhancementCalculatorModel
                                    .enhancementSelected(selectedEnhancement);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const EnhancementDivider(),
                // MULTIPLE TARGETS
                SwitchListTile(
                  value: enhancementCalculatorModel.multipleTargets,
                  onChanged: !enhancementCalculatorModel
                          .disableMultiTargetsSwitch
                      ? (bool value) {
                          enhancementCalculatorModel.multipleTargets = value;
                        }
                      : null,
                  secondary: IconButton(
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color:
                          SharedPrefs().darkTheme ? Colors.white : Colors.black,
                    ),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) {
                        return InfoDialog(
                          title: Strings.multipleTargetsInfoTitle,
                          message: Strings.multipleTargetsInfoBody(
                            context,
                            gloomhavenMode: SharedPrefs().gloomhavenMode,
                            enhancerLvl2: !SharedPrefs().gloomhavenMode &&
                                SharedPrefs().enhancerLvl2,
                            darkMode: SharedPrefs().darkTheme,
                          ),
                        );
                      },
                    ),
                  ),
                  title: const AutoSizeText('Multiple Targets'), // \u2020
                ),

                if (!SharedPrefs().gloomhavenMode) ...[
                  // LOSS NON-PERSISTENT
                  SwitchListTile(
                    value: enhancementCalculatorModel.lostNonPersistent,
                    onChanged: enhancementCalculatorModel.persistent
                        ? null
                        : (bool value) {
                            enhancementCalculatorModel.lostNonPersistent =
                                value;
                          },
                    secondary: IconButton(
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: SharedPrefs().darkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) {
                          return InfoDialog(
                            title: Strings.lostNonPersistentInfoTitle,
                            message: Strings.lostNonPersistentInfoBody(
                              context,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.dark
                              ? 'images/loss.svg'
                              : 'images/loss_light.svg',
                          width: iconSize,
                        ),
                        SizedBox(
                          width: iconSize + 16,
                          height: iconSize + 11,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                child: SvgPicture.asset(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? 'images/persistent.svg'
                                      : 'images/persistent_light.svg',
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
                  // PERSISTENT
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
                        color: SharedPrefs().darkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) {
                          return InfoDialog(
                            title: Strings.persistentInfoTitle,
                            message: Strings.persistentInfoBody(
                              context,
                            ),
                          );
                        },
                      ),
                    ),
                    title: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'images/persistent.svg'
                          : 'images/persistent_light.svg',
                      width: iconSize,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ],
            ),
          ),
        ),
        Visibility(
          visible: enhancementCalculatorModel.showCost,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // isBottom
                //     ? SizedBox()
                //     :
                const Divider(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                  ),
                  child: AutoSizeText(
                    'Total Cost',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (enhancementCalculatorModel.temporaryEnhancementMode)
                      const Text(
                        ' ',
                      ),
                    Text(
                      '${enhancementCalculatorModel.totalCost}g',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    if (enhancementCalculatorModel.temporaryEnhancementMode)
                      Text(
                        '*',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: enhancementCalculatorModel.showCost ? 24 : 82,
        )
      ],
    );
  }
}

class EnhancementDivider extends StatelessWidget {
  const EnhancementDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      endIndent: 24,
      indent: 24,
      height: 1,
    );
  }
}

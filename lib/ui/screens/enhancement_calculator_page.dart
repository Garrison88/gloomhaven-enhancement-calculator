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
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

class EnhancementCalculatorPage extends StatelessWidget {
  const EnhancementCalculatorPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EnhancementCalculatorModel enhancementCalculatorModel =
        context.watch<EnhancementCalculatorModel>();
    enhancementCalculatorModel.calculateCost(notify: false);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: smallPadding),
        child: SingleChildScrollView(
          controller:
              context.read<CharactersModel>().enhancementCalcScrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: smallPadding / 2),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (_) {
                            return InfoDialog(
                              title: Strings.generalInfoTitle,
                              message: Strings.generalInfoBody(
                                context,
                                gloomhavenMode: SharedPrefs().gloomhavenMode,
                                darkMode: Theme.of(context).brightness ==
                                    Brightness.dark,
                              ),
                            );
                          },
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(
                              SharedPrefs().gloomhavenMode
                                  ? 0xffa98274
                                  : 0xff6ab7ff,
                            ),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.info_outlined,
                          color: SharedPrefs().gloomhavenMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        label: Text(
                          '${SharedPrefs().gloomhavenMode ? 'Gloomhaven' : 'Frosthaven'} Guidelines',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: SharedPrefs().gloomhavenMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  // TEMPORARY ENHANCEMENT
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                          ),
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) {
                              return InfoDialog(
                                title: Strings.temporaryEnhancement,
                                message: Strings.temporaryEnhancementInfoBody(
                                    context),
                              );
                            },
                          ),
                        ),
                        const Expanded(
                          child: AutoSizeText(
                            'Variant: Temporary Enhancement*',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            right: smallPadding,
                          ),
                        ),
                        Switch(
                          value: enhancementCalculatorModel
                              .temporaryEnhancementMode,
                          onChanged: (bool value) {
                            enhancementCalculatorModel
                                .temporaryEnhancementMode = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  // CARD LEVEL
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
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
                        const Text('Card Level:'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
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
                      ],
                    ),
                  ),
                  // PREVIOUS ENHANCEMENTS
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
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
                        const Expanded(
                          child: AutoSizeText(
                            'Previous Enhancements:',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            right: smallPadding,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            hint: const Text(
                              'None',
                            ),
                            value:
                                enhancementCalculatorModel.previousEnhancements,
                            items: EnhancementData.previousEnhancements(
                              context,
                              enhancerLvl4: !SharedPrefs().gloomhavenMode &&
                                  SharedPrefs().enhancerLvl4,
                            ),
                            onChanged: (int? value) {
                              if (value != null) {
                                enhancementCalculatorModel
                                    .previousEnhancements = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ENHANCEMENT
                  Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                              ),
                              onPressed:
                                  enhancementCalculatorModel.enhancement != null
                                      ? () => showDialog<void>(
                                            context: context,
                                            builder: (_) {
                                              return InfoDialog(
                                                category:
                                                    enhancementCalculatorModel
                                                        .enhancement!.category,
                                              );
                                            },
                                          )
                                      : null,
                            ),
                            const Text(
                              'Enhancement Type:',
                            ),
                            const IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Colors.transparent,
                                ),
                                onPressed: null),
                          ],
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<Enhancement>(
                            hint: const Text(
                              'Type',
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
                      ],
                    ),
                  ),
                  // MULTIPLE TARGETS
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
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
                        const AutoSizeText('Multiple Targets?'), // \u2020
                        Switch(
                          value: enhancementCalculatorModel.multipleTargets,
                          onChanged: !enhancementCalculatorModel
                                  .disableMultiTargetsSwitch
                              ? (bool value) {
                                  enhancementCalculatorModel.multipleTargets =
                                      value;
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  if (!SharedPrefs().gloomhavenMode) ...[
                    // LOSS NON-PERSISTENT
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
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
                          Switch(
                            value: enhancementCalculatorModel.lostNonPersistent,
                            onChanged: enhancementCalculatorModel.persistent
                                ? null
                                : (bool value) {
                                    enhancementCalculatorModel
                                        .lostNonPersistent = value;
                                  },
                          ),
                        ],
                      ),
                    ),
                    // PERSISTENT
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
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
                          SvgPicture.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? 'images/persistent.svg'
                                : 'images/persistent_light.svg',
                            width: iconSize,
                          ),
                          Switch(
                            value: enhancementCalculatorModel.persistent,
                            onChanged: enhancementCalculatorModel
                                            .enhancement?.category ==
                                        EnhancementCategory.summonPlusOne ||
                                    enhancementCalculatorModel.lostNonPersistent
                                ? null
                                : (bool value) {
                                    enhancementCalculatorModel.persistent =
                                        value;
                                  },
                          ),
                        ],
                      ),
                    ),
                    // BUILDING 44
                    // Card(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       IconButton(
                    //         icon: const Icon(
                    //           Icons.info_outline,
                    //         ),
                    //         onPressed: () => showDialog<void>(
                    //           context: context,
                    //           builder: (_) {
                    //             return InfoDialog(
                    //               title: Strings.persistentInfoTitle,
                    //               message: Strings.persistentInfoBody(
                    //                 context,
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //       SvgPicture.asset(
                    //         Theme.of(context).brightness == Brightness.dark
                    //             ? 'images/persistent.svg'
                    //             : 'images/persistent_light.svg',
                    //         width: iconSize,
                    //       ),
                    //       Switch(
                    //         value: enhancementCalculatorModel.persistent,
                    //         onChanged: enhancementCalculatorModel
                    //                         .enhancement?.category ==
                    //                     EnhancementCategory.summonPlusOne ||
                    //                 enhancementCalculatorModel.lostNonPersistent
                    //             ? null
                    //             : (bool value) {
                    //                 enhancementCalculatorModel.persistent =
                    //                     value;
                    //               },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ],
              ),
              Opacity(
                opacity: enhancementCalculatorModel.showCost ? 1 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AutoSizeText(
                        'Enhancement Cost:',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (enhancementCalculatorModel.temporaryEnhancementMode)
                          const Text(
                            ' ',
                            style: TextStyle(fontSize: 40),
                          ),
                        Text(
                          '${enhancementCalculatorModel.totalCost}g',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: 80,
                                letterSpacing: 4,
                              ),
                        ),
                        if (enhancementCalculatorModel.temporaryEnhancementMode)
                          const Text(
                            '*',
                            style: TextStyle(fontSize: 40),
                          ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 82,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

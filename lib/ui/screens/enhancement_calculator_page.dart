import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import '../../viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';
import '../../data/constants.dart';
import '../../data/enhancement_data.dart';
import '../../data/strings.dart';
import '../../models/enhancement.dart';
import '../../shared_prefs.dart';
import '../dialogs/info_dialog.dart';

class EnhancementCalculatorPage extends StatelessWidget {
  const EnhancementCalculatorPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EnhancementCalculatorModel enhancementCalculatorModel =
        context.watch<EnhancementCalculatorModel>();
    enhancementCalculatorModel.calculateCost(notify: false);

    return Center(
      child: Container(
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
                              message: Strings.generalInfoBody(context),
                            );
                          },
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.info_outlined,
                          color: ThemeData.estimateBrightnessForColor(
                                      Theme.of(context).colorScheme.primary) ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        label: Text(
                          'General Guidelines',
                          style: TextStyle(
                            color: ThemeData.estimateBrightnessForColor(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary) ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
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
                                SharedPrefs().partyBoon),
                            onChanged: (int value) {
                              enhancementCalculatorModel.cardLevel = value;
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
                                    context),
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
                            items: EnhancementData.previousEnhancements(),
                            onChanged: (int value) {
                              enhancementCalculatorModel.previousEnhancements =
                                  value;
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
                                    enhancementCalculatorModel.enhancement !=
                                            null
                                        ? () => showDialog<void>(
                                              context: context,
                                              builder: (_) {
                                                return InfoDialog(
                                                  category:
                                                      enhancementCalculatorModel
                                                          .enhancement.category,
                                                );
                                              },
                                            )
                                        : null),
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
                              SharedPrefs().gloomhavenMode,
                            ),
                            onChanged: (Enhancement selectedEnhancement) {
                              enhancementCalculatorModel
                                  .enhancementSelected(selectedEnhancement);
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
                                  SharedPrefs().gloomhavenMode,
                                ),
                              );
                            },
                          ),
                        ),
                        const AutoSizeText('Multiple Targets?'),
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
                  // LOSS NON-PERSISTENT
                  if (!SharedPrefs().gloomhavenMode)
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
                            SharedPrefs().darkTheme
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
                                    SharedPrefs().darkTheme
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
                  if (!SharedPrefs().gloomhavenMode)
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
                            SharedPrefs().darkTheme
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
                    Text(
                      '${enhancementCalculatorModel.enhancementCost} g',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          .copyWith(fontSize: 80),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 104),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';

import '../models/enhancement.dart';
import '../shared_prefs.dart';
import 'constants.dart';

enum EnhancementCategory {
  title,
  charPlusOne,
  target,
  summonPlusOne,
  negEffect,
  posEffect,
  jump,
  specElem,
  anyElem,
  hex,
}

class EnhancementData {
  static final List<Enhancement> enhancements = [
    // plus one
    Enhancement(
      EnhancementCategory.title,
      'Character',
      iconPath: 'plus_one.svg',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Move',
      ghCost: 30,
      iconPath: 'move.svg',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Attack',
      ghCost: 50,
      iconPath: 'attack.svg',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Range',
      ghCost: 30,
      iconPath: 'range.svg',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.target,
      'Target',
      ghCost: 50,
      iconPath:
          SharedPrefs().darkTheme ? 'target_alt.svg' : 'target_alt_light.svg',
      fhCost: 75,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Shield',
      ghCost: 100,
      iconPath: 'shield.svg',
      fhCost: 80,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Retaliate',
      ghCost: 100,
      iconPath: 'retaliate.svg',
      fhCost: 60,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Pierce',
      ghCost: 30,
      iconPath: 'pierce.svg',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Heal',
      ghCost: 30,
      iconPath: SharedPrefs().darkTheme ? 'heal.svg' : 'heal_light.svg',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Push',
      ghCost: 30,
      iconPath: 'push.svg',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Pull',
      ghCost: 30,
      iconPath: 'pull.svg',
      fhCost: 20,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Teleport',
      ghCost: 40,
      iconPath: 'teleport.svg',
      fhCost: 50,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.title,
      'Summon',
      iconPath: 'plus_one.svg',
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      'HP',
      ghCost: 50,
      iconPath: 'hp.svg',
      fhCost: 40,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      'Move',
      ghCost: 100,
      iconPath: 'move.svg',
      fhCost: 60,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      'Attack',
      ghCost: 100,
      iconPath: 'attack.svg',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      'Range',
      ghCost: 50,
      iconPath: 'range.svg',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.title,
      'Effect',
    ),
    // positive effects
    Enhancement(
      EnhancementCategory.posEffect,
      'Regenerate',
      ghCost: 50,
      iconPath: 'regenerate.svg',
      fhCost: 40,
    ),
    Enhancement(
      EnhancementCategory.posEffect,
      'Ward',
      ghCost: 75,
      iconPath: 'ward.svg',
      fhCost: 75,
    ),
    Enhancement(
      EnhancementCategory.posEffect,
      'Strengthen',
      ghCost: 50,
      iconPath: 'strengthen.svg',
      fhCost: 100,
    ),
    Enhancement(
      EnhancementCategory.posEffect,
      'Bless',
      ghCost: 50,
      iconPath: 'bless.svg',
      fhCost: 75,
    ),
    // negative effects
    Enhancement(
      EnhancementCategory.negEffect,
      'Wound',
      ghCost: 75,
      iconPath: 'wound.svg',
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Poison',
      ghCost: 75,
      iconPath: 'poison.svg',
      fhCost: 50,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Immobilize',
      ghCost: 100,
      iconPath: 'immobilize.svg',
      fhCost: 150,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Muddle',
      ghCost: 50,
      iconPath: 'muddle.svg',
      fhCost: 40,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Curse',
      ghCost: 75,
      iconPath: 'curse.svg',
      fhCost: 150,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Disarm',
      ghCost: 150,
      iconPath: 'disarm.svg',
    ),
    Enhancement(
      EnhancementCategory.jump,
      'Jump',
      ghCost: 50,
      iconPath: 'jump.svg',
      fhCost: 60,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.specElem,
      'Element',
      ghCost: 100,
      iconPath: 'elem_fire.svg',
    ),
    Enhancement(
      EnhancementCategory.anyElem,
      'Wild Element',
      ghCost: 150,
      iconPath: 'elem_any.svg',
    ),
    Enhancement(
      EnhancementCategory.title,
      'Current Hexes',
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '2 hexes',
      ghCost: 100,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '3 hexes',
      ghCost: 66,
      fhCost: 67,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '4 hexes',
      ghCost: 50,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '5 hexes',
      ghCost: 40,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '6 hexes',
      ghCost: 33,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '7 hexes',
      ghCost: 28,
      fhCost: 29,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '8 hexes',
      ghCost: 25,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '9 hexes',
      ghCost: 22,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '10 hexes',
      ghCost: 20,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '11 hexes',
      ghCost: 18,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '12 hexes',
      ghCost: 16,
      fhCost: 17,
      iconPath: 'hex.svg',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '13 hexes',
      ghCost: 15,
      iconPath: 'hex.svg',
    ),
  ];

  static List<DropdownMenuItem<int>> cardLevels(
    BuildContext context, {
    required bool partyBoon,
    required bool enhancerLvl3,
  }) {
    EnhancementCalculatorModel enhancementCalculatorModel =
        Provider.of(context, listen: false);
    List<DropdownMenuItem<int>> list = [];
    for (int x = 0; x <= 8; x++) {
      list.add(
        DropdownMenuItem(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <TextSpan>[
                if (x == 0)
                  const TextSpan(text: '1 / x')
                else ...[
                  TextSpan(text: '${x + 1} ('),
                  if (enhancerLvl3 || (!enhancerLvl3 && partyBoon)) ...[
                    TextSpan(
                      text: '${25 * x}g',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                    ),
                    const TextSpan(
                      text: ' ',
                    ),
                    TextSpan(
                      text:
                          '${enhancementCalculatorModel.cardLevelPenalty(x)}g',
                      // style: Theme.of(context).textTheme.bodyMedium.copyWith(
                      //       color: Colors.green,
                      //     ),
                    ),
                    const TextSpan(text: ')'),
                  ] else ...[
                    TextSpan(
                      text: '${25 * x}g)',
                    ),
                  ],
                ],
              ],
            ),
          ),
          value: x,
        ),
      );
    }
    return list;
  }

  static List<DropdownMenuItem<int>> previousEnhancements(
    BuildContext context, {
    bool enhancerLvl4 = false,
    bool tempEnhancements = false,
  }) {
    EnhancementCalculatorModel enhancementCalculatorModel =
        Provider.of(context, listen: false);
    List<DropdownMenuItem<int>> list = [];
    for (int x = 0; x <= 3; x++) {
      list.add(
        DropdownMenuItem(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <TextSpan>[
                if (x == 0)
                  const TextSpan(text: 'None')
                else ...[
                  TextSpan(text: '$x ('),
                  if (enhancerLvl4 || tempEnhancements) ...[
                    TextSpan(
                      text: '${75 * x}g',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                    ),
                    const TextSpan(
                      text: ' ',
                    ),
                    TextSpan(
                      text:
                          '${enhancementCalculatorModel.previousEnhancementsPenalty(x)}g${tempEnhancements ? '*' : ''}',
                    ),
                    const TextSpan(text: ')'),
                  ] else ...[
                    TextSpan(
                      text: '${75 * x}g)',
                    ),
                  ],
                ],
              ],
            ),
          ),
          value: x,
        ),
      );
    }
    return list;
  }

  static List<DropdownMenuItem<Enhancement>> enhancementTypes(
    BuildContext context, {
    required bool gloomhavenMode,
    required bool enhancerLvl2,
  }) {
    EnhancementCalculatorModel enhancementCalculatorModel =
        Provider.of(context, listen: false);
    List<DropdownMenuItem<Enhancement>> list = [];
    for (final Enhancement enhancement in enhancements) {
      if ((!gloomhavenMode && enhancement.name == 'Disarm') ||
          (gloomhavenMode && enhancement.name == 'Ward')) {
        continue;
      }
      list.add(
        enhancement.category == EnhancementCategory.title
            ? DropdownMenuItem(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // if there is an icon beside the title, display it and add
                    // a spacer
                    children: enhancement.iconPath != null
                        ? <Widget>[
                            SvgPicture.asset(
                              'images/${enhancement.iconPath}',
                              width: iconSize,
                              height: iconSize,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              enhancement.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    // decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            // add an empty spacer to the right to center the
                            // title
                            const SizedBox(
                              width: iconSize,
                            ),
                          ]
                        : <Widget>[
                            Text(
                              enhancement.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    // decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                  ),
                ),
                value: enhancement,
              )
            : DropdownMenuItem(
                child: Row(
                  children: <Widget>[
                    // add small +1 icon beside move if it's eligible
                    enhancement.category == EnhancementCategory.charPlusOne ||
                            enhancement.category ==
                                EnhancementCategory.target ||
                            enhancement.category ==
                                EnhancementCategory.summonPlusOne
                        ? Stack(
                            alignment: const Alignment(
                              1.75,
                              -1.75,
                            ),
                            children: <Widget>[
                              enhancement.invertIconColor &&
                                      SharedPrefs().darkTheme
                                  ? SvgPicture.asset(
                                      'images/${enhancement.iconPath}',
                                      width: iconSize,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      'images/${enhancement.iconPath}',
                                      width: iconSize,
                                    ),
                              SvgPicture.asset(
                                'images/plus_one.svg',
                                width: iconSize * .5,
                                height: iconSize * .5,
                              ),
                            ],
                          )
                        // otherwise, no +1 icon
                        : enhancement.invertIconColor && SharedPrefs().darkTheme
                            ? SvgPicture.asset(
                                'images/${enhancement.iconPath}',
                                width: iconSize,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              )
                            : enhancement.name == 'Element'
                                ? SizedBox(
                                    width: iconSize,
                                    height: iconSize,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: 5,
                                          top: 5,
                                          left: 5,
                                          child: SvgPicture.asset(
                                            'images/elem_dark.svg',
                                            width: 10,
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          left: 7,
                                          child: SvgPicture.asset(
                                            'images/elem_air.svg',
                                            width: 11,
                                          ),
                                        ),
                                        Positioned(
                                          top: 3,
                                          right: 6,
                                          child: SvgPicture.asset(
                                            'images/elem_ice.svg',
                                            width: 12,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 2,
                                          bottom: 2,
                                          child: SvgPicture.asset(
                                            'images/elem_fire.svg',
                                            width: 13,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 1,
                                          right: 4,
                                          child: SvgPicture.asset(
                                            'images/elem_earth.svg',
                                            width: 14,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 3,
                                          child: SvgPicture.asset(
                                            'images/elem_light.svg',
                                            width: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'images/${enhancement.iconPath}',
                                    width: iconSize,
                                  ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ${enhancement.name} ',
                          ),
                          const TextSpan(text: '('),
                          if ((EnhancementCalculatorModel
                                      .eligibleForMultipleTargets(
                                    enhancement,
                                    gloomhavenMode: gloomhavenMode,
                                  ) &&
                                  enhancementCalculatorModel.multipleTargets) ||
                              (!gloomhavenMode &&
                                  (enhancerLvl2 ||
                                      enhancementCalculatorModel
                                          .lostNonPersistent ||
                                      enhancementCalculatorModel
                                          .persistent))) ...[
                            TextSpan(
                              text:
                                  '${enhancement.cost(gloomhavenMode: gloomhavenMode)}g',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.grey,
                                    color: Colors.grey,
                                    decorationThickness: .75,
                                  ),
                            ),
                            const TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                              text:
                                  '${enhancementCalculatorModel.enhancementCost(enhancement)}g',
                            ),
                            const TextSpan(text: ')'),
                          ] else ...[
                            TextSpan(
                              text:
                                  '${enhancement.cost(gloomhavenMode: gloomhavenMode)}g)',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                value: enhancement,
              ),
      );
    }
    return list;
  }
}

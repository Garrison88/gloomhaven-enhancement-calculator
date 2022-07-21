import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      null,
      'plus_one.svg',
      ' For Character',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      30,
      'move.svg',
      'Move',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      40,
      'teleport.svg',
      'Teleport',
      fhCost: 50,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      50,
      'attack.svg',
      'Attack',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      30,
      'range.svg',
      'Range',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      100,
      'shield.svg',
      'Shield',
      fhCost: 80,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      30,
      'push.svg',
      'Push',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      30,
      'pull.svg',
      'Pull',
      fhCost: 20,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      30,
      'pierce.svg',
      'Pierce',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      100,
      'retaliate.svg',
      'Retaliate',
      fhCost: 60,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      30,
      SharedPrefs().darkTheme ? 'heal.svg' : 'heal_light.svg',
      'Heal',
    ),
    Enhancement(
      EnhancementCategory.target,
      50,
      SharedPrefs().darkTheme ? 'target_alt.svg' : 'target_alt_light.svg',
      'Target',
      fhCost: 75,
    ),
    Enhancement(
      EnhancementCategory.title,
      null,
      'plus_one.svg',
      ' For Summon',
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      100,
      'move.svg',
      'Summon Move',
      fhCost: 60,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      100,
      'attack.svg',
      'Summon Attack',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      50,
      'range.svg',
      'Summon Range',
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      50,
      'hp.svg',
      'Summon HP',
      fhCost: 40,
      invertIconColor: true,
    ),
    // negative effects
    Enhancement(
      EnhancementCategory.title,
      null,
      null,
      'Effect',
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      75,
      'poison.svg',
      'Poison',
      fhCost: 50,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      75,
      'wound.svg',
      'Wound',
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      50,
      'muddle.svg',
      'Muddle',
      fhCost: 40,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      100,
      'immobilize.svg',
      'Immobilize',
      fhCost: 150,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      150,
      'disarm.svg',
      'Disarm',
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      75,
      'curse.svg',
      'Curse',
      fhCost: 150,
    ),
    // positive effects
    Enhancement(
      EnhancementCategory.posEffect,
      50,
      'strengthen.svg',
      'Strengthen',
      fhCost: 100,
    ),
    Enhancement(
      EnhancementCategory.posEffect,
      50,
      'bless.svg',
      'Bless',
      fhCost: 75,
    ),
    Enhancement(
      EnhancementCategory.posEffect,
      50,
      'regenerate.svg',
      'Regenerate',
      fhCost: 40,
    ),
    Enhancement(
      EnhancementCategory.jump,
      50,
      'jump.svg',
      'Jump',
      fhCost: 60,
      invertIconColor: true,
    ),
    Enhancement(
      EnhancementCategory.specElem,
      100,
      'elem_fire.svg',
      'Element',
    ),
    Enhancement(
      EnhancementCategory.anyElem,
      150,
      'elem_any.svg',
      'Wild Element',
    ),
    Enhancement(
      EnhancementCategory.title,
      null,
      'hex.svg',
      ' Hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      100,
      'hex.svg',
      '2 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      66,
      'hex.svg',
      '3 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      50,
      'hex.svg',
      '4 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      40,
      'hex.svg',
      '5 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      33,
      'hex.svg',
      '6 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      28,
      'hex.svg',
      '7 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      25,
      'hex.svg',
      '8 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      22,
      'hex.svg',
      '9 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      20,
      'hex.svg',
      '10 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      18,
      'hex.svg',
      '11 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      16,
      'hex.svg',
      '12 Current Hexes',
    ),
    Enhancement(
      EnhancementCategory.hex,
      15,
      'hex.svg',
      '13 Current Hexes',
    ),
  ];

  static List<DropdownMenuItem<int>> cardLevels(bool partyBoon) {
    List<DropdownMenuItem<int>> list = [];
    for (int x = 0; x <= 8; x++) {
      list.add(
        DropdownMenuItem(
          child: Text(
            x == 0 ? '1 / x' : '${x + 1} (${(x * (partyBoon ? 20 : 25))}g)',
          ),
          value: x,
        ),
      );
    }
    return list;
  }

  static List<DropdownMenuItem<int>> previousEnhancements() {
    List<DropdownMenuItem<int>> list = [];
    for (int x = 0; x <= 3; x++) {
      list.add(
        DropdownMenuItem(
          child: Text(
            x == 0 ? 'None' : '$x (${(x * 75)}g)',
          ),
          value: x,
        ),
      );
    }
    return list;
  }

  static List<DropdownMenuItem<Enhancement>> enhancementTypes(
    bool gloomhavenMode,
  ) {
    List<DropdownMenuItem<Enhancement>> list = [];
    for (final Enhancement enhancement in enhancements) {
      if (!gloomhavenMode && enhancement.name == 'Disarm') {
        continue;
      }
      list.add(
        enhancement.category == EnhancementCategory.title
            ? DropdownMenuItem(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // if there is an icon beside the title, display it and add a spacer
                    children: enhancement.icon != null
                        ? <Widget>[
                            SvgPicture.asset('images/${enhancement.icon}',
                                width: iconSize, height: iconSize),

                            Text(
                              enhancement.name,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // add an empty spacer to the right to center the title
                            Container(width: iconSize),
                          ]
                        : <Widget>[
                            Text(
                              enhancement.name,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
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
                            alignment: const Alignment(1.75, -1.75),
                            children: <Widget>[
                              enhancement.invertIconColor &&
                                      SharedPrefs().darkTheme
                                  ? SvgPicture.asset(
                                      'images/${enhancement.icon}',
                                      width: iconSize,
                                      color: Colors.white,
                                    )
                                  : SvgPicture.asset(
                                      'images/${enhancement.icon}',
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
                                'images/${enhancement.icon}',
                                width: iconSize,
                                color: Colors.white,
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
                                    'images/${enhancement.icon}',
                                    width: iconSize,
                                  ),
                    Text(
                      ' ${enhancement.name} (${gloomhavenMode ? enhancement.ghCost : enhancement.fhCost ?? enhancement.ghCost}g)',
                    )
                  ],
                ),
                value: enhancement),
      );
    }
    return list;
  }
}

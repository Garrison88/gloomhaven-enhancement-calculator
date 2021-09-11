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
    Enhancement(EnhancementCategory.title, null, 'plus_one.svg', false,
        ' For Character'),
    Enhancement(EnhancementCategory.charPlusOne, 30, 'move.svg', true, 'Move'),
    Enhancement(
        EnhancementCategory.charPlusOne, 40, 'teleport.svg', true, 'Teleport'),
    Enhancement(
        EnhancementCategory.charPlusOne, 50, 'attack.svg', true, 'Attack'),
    Enhancement(
        EnhancementCategory.charPlusOne, 30, 'range.svg', true, 'Range'),
    Enhancement(
        EnhancementCategory.charPlusOne, 100, 'shield.svg', true, 'Shield'),
    Enhancement(EnhancementCategory.charPlusOne, 30, 'push.svg', false, 'Push'),
    Enhancement(EnhancementCategory.charPlusOne, 30, 'pull.svg', false, 'Pull'),
    Enhancement(
        EnhancementCategory.charPlusOne, 30, 'pierce.svg', false, 'Pierce'),
    Enhancement(EnhancementCategory.charPlusOne, 100, 'retaliate.svg', true,
        'Retaliate'),
    Enhancement(EnhancementCategory.charPlusOne, 30, 'heal.svg', true, 'Heal'),
    Enhancement(EnhancementCategory.target, 50, 'target.svg', false, 'Target'),
    Enhancement(
        EnhancementCategory.title, null, 'plus_one.svg', false, ' For Summon'),
    Enhancement(
        EnhancementCategory.summonPlusOne, 100, 'move.svg', true, 'Move'),
    Enhancement(
        EnhancementCategory.summonPlusOne, 100, 'attack.svg', true, 'Attack'),
    Enhancement(
        EnhancementCategory.summonPlusOne, 50, 'range.svg', true, 'Range'),
    Enhancement(EnhancementCategory.summonPlusOne, 50, 'heal.svg', true, 'HP'),
    // negative effects
    Enhancement(EnhancementCategory.title, null, null, false, 'Effect'),
    Enhancement(
        EnhancementCategory.negEffect, 75, 'poison.svg', false, 'Poison'),
    Enhancement(EnhancementCategory.negEffect, 75, 'wound.svg', false, 'Wound'),
    Enhancement(
        EnhancementCategory.negEffect, 50, 'muddle.svg', false, 'Muddle'),
    Enhancement(EnhancementCategory.negEffect, 100, 'immobilize.svg', false,
        'Immobilize'),
    Enhancement(
        EnhancementCategory.negEffect, 150, 'disarm.svg', false, 'Disarm'),
    Enhancement(EnhancementCategory.negEffect, 75, 'curse.svg', false, 'Curse'),
    // positive effects
    Enhancement(EnhancementCategory.posEffect, 50, 'strengthen.svg', false,
        'Strengthen'),
    Enhancement(EnhancementCategory.posEffect, 50, 'bless.svg', false, 'Bless'),
    Enhancement(EnhancementCategory.posEffect, 50, 'regenerate.svg', false,
        'Regenerate'),
    Enhancement(EnhancementCategory.jump, 50, 'jump.svg', true, 'Jump'),
    Enhancement(EnhancementCategory.specElem, 100, 'elem_fire.svg', false,
        'Specific Element'),
    Enhancement(
        EnhancementCategory.anyElem, 150, 'elem_any.svg', false, 'Any Element'),
    Enhancement(EnhancementCategory.title, null, 'hex.svg', false, ' Hex'),
    Enhancement(
        EnhancementCategory.hex, 100, 'hex.svg', false, '2 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 66, 'hex.svg', false, '3 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 50, 'hex.svg', false, '4 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 40, 'hex.svg', false, '5 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 33, 'hex.svg', false, '6 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 28, 'hex.svg', false, '7 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 25, 'hex.svg', false, '8 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 22, 'hex.svg', false, '9 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 20, 'hex.svg', false, '10 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 18, 'hex.svg', false, '11 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 16, 'hex.svg', false, '12 Current Hexes'),
    Enhancement(
        EnhancementCategory.hex, 15, 'hex.svg', false, '13 Current Hexes'),
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

  static List<DropdownMenuItem<Enhancement>> enhancementTypes() {
    List<DropdownMenuItem<Enhancement>> list = [];
    for (final Enhancement enhancement in enhancements) {
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
                value: enhancement)
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
                              enhancement.invertColor && SharedPrefs().darkTheme
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
                        : enhancement.invertColor && SharedPrefs().darkTheme
                            ? SvgPicture.asset(
                                'images/${enhancement.icon}',
                                width: iconSize,
                                color: Colors.white,
                              )
                            : SvgPicture.asset(
                                'images/${enhancement.icon}',
                                width: iconSize,
                              ),
                    Text(
                      ' ${enhancement.name} (${enhancement.baseCost}g)',
                    )
                  ],
                ),
                value: enhancement),
      );
    }
    return list;
  }
}

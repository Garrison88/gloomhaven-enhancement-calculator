import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import '../enums/enhancement_category.dart';
import '../models/enhancement.dart';
import 'constants.dart';

final List<Enhancement> enhancementsList = [
  // plus one
  Enhancement(
      EnhancementCategory.title, null, 'plus_one.png', false, ' For Character'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'move.png', true, 'Move'),
  Enhancement(
      EnhancementCategory.charPlusOne, 40, 'teleport.png', true, 'Teleport'),
  Enhancement(
      EnhancementCategory.charPlusOne, 50, 'attack.png', true, 'Attack'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'range.png', true, 'Range'),
  Enhancement(
      EnhancementCategory.charPlusOne, 100, 'shield.png', true, 'Shield'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'push.png', false, 'Push'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'pull.png', false, 'Pull'),
  Enhancement(
      EnhancementCategory.charPlusOne, 30, 'pierce.png', false, 'Pierce'),
  Enhancement(
      EnhancementCategory.charPlusOne, 100, 'retaliate.png', true, 'Retaliate'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'heal.png', true, 'Heal'),
  Enhancement(EnhancementCategory.target, 50, 'target.png', false, 'Target'),
  Enhancement(
      EnhancementCategory.title, null, 'plus_one.png', false, ' For Summon'),
  Enhancement(EnhancementCategory.summonPlusOne, 100, 'move.png', true, 'Move'),
  Enhancement(
      EnhancementCategory.summonPlusOne, 100, 'attack.png', true, 'Attack'),
  Enhancement(
      EnhancementCategory.summonPlusOne, 50, 'range.png', true, 'Range'),
  Enhancement(EnhancementCategory.summonPlusOne, 50, 'heal.png', true, 'HP'),
  // negative effects
  Enhancement(EnhancementCategory.title, null, null, false, 'Effect'),
  Enhancement(EnhancementCategory.negEffect, 75, 'poison.png', false, 'Poison'),
  Enhancement(EnhancementCategory.negEffect, 75, 'wound.png', false, 'Wound'),
  Enhancement(EnhancementCategory.negEffect, 50, 'muddle.png', false, 'Muddle'),
  Enhancement(EnhancementCategory.negEffect, 100, 'immobilize.png', false,
      'Immobilize'),
  Enhancement(
      EnhancementCategory.negEffect, 150, 'disarm.png', false, 'Disarm'),
  Enhancement(EnhancementCategory.negEffect, 75, 'curse.png', false, 'Curse'),
  // positive effects
  Enhancement(
      EnhancementCategory.posEffect, 50, 'strengthen.png', false, 'Strengthen'),
  Enhancement(EnhancementCategory.posEffect, 50, 'bless.png', false, 'Bless'),
  Enhancement(
      EnhancementCategory.posEffect, 50, 'regenerate.png', false, 'Regenerate'),
  Enhancement(EnhancementCategory.jump, 50, 'jump.png', true, 'Jump'),
  Enhancement(EnhancementCategory.specElem, 100, 'elem_fire.png', false,
      'Specific Element'),
  Enhancement(
      EnhancementCategory.anyElem, 150, 'elem_any.png', false, 'Any Element'),
  Enhancement(EnhancementCategory.title, null, 'hex.png', false, ' Hex'),
  Enhancement(
      EnhancementCategory.hex, 100, 'hex.png', false, '2 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 66, 'hex.png', false, '3 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 50, 'hex.png', false, '4 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 40, 'hex.png', false, '5 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 33, 'hex.png', false, '6 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 28, 'hex.png', false, '7 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 25, 'hex.png', false, '8 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 22, 'hex.png', false, '9 Current Hexes'),
  Enhancement(
      EnhancementCategory.hex, 20, 'hex.png', false, '10 Current Hexes'),
  Enhancement(
      EnhancementCategory.hex, 18, 'hex.png', false, '11 Current Hexes'),
  Enhancement(
      EnhancementCategory.hex, 16, 'hex.png', false, '12 Current Hexes'),
  Enhancement(
      EnhancementCategory.hex, 15, 'hex.png', false, '13 Current Hexes'),
];

List<DropdownMenuItem<int>> cardLevelList(bool partyBoon) {
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

List<DropdownMenuItem<int>> previousEnhancementsList() {
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

List<DropdownMenuItem<Enhancement>> enhancementTypeList() {
  List<DropdownMenuItem<Enhancement>> list = [];
  enhancementsList.forEach((enhancement) => list.add(
        enhancement.category == EnhancementCategory.title
            ? DropdownMenuItem(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // if there is an icon beside the title, display it and add a spacer
                    children: enhancement.icon != null
                        ? <Widget>[
                            Image.asset('images/${enhancement.icon}',
                                width: iconWidth, height: iconHeight),

                            Text(
                              '${enhancement.name}',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // add an empty spacer to the right to center the title
                            Container(width: iconWidth),
                          ]
                        : <Widget>[
                            Text(
                              '${enhancement.name}',
                              style: TextStyle(
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
                            alignment: Alignment(1.0, -1.0),
                            children: <Widget>[
                              enhancement.invertColor && SharedPrefs().darkTheme
                                  ? Image.asset(
                                      'images/${enhancement.icon}',
                                      width: iconWidth,
                                      color: Colors.white,
                                    )
                                  : Image.asset(
                                      'images/${enhancement.icon}',
                                      width: iconWidth,
                                    ),
                              Image.asset(
                                'images/plus_one.png',
                                width: iconWidth * .5,
                                height: iconWidth * .5,
                              ),
                            ],
                          )
                        // otherwise, no +1 icon
                        : enhancement.invertColor && SharedPrefs().darkTheme
                            ? Image.asset(
                                'images/${enhancement.icon}',
                                width: iconWidth,
                                color: Colors.white,
                              )
                            : Image.asset(
                                'images/${enhancement.icon}',
                                width: iconWidth,
                              ),
                    Text(
                      ' ${enhancement.name} (${enhancement.baseCost}g)',
                    )
                  ],
                ),
                value: enhancement),
      ));
  return list;
}

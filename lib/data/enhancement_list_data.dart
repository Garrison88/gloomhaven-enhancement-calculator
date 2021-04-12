import 'package:flutter/material.dart';
import '../enums/enhancement_category.dart';
import '../models/enhancement.dart';
import 'constants.dart';

final List<Enhancement> enhancementList = [
  // plus one
  Enhancement(
      EnhancementCategory.title, null, 'plus_one.png', ' For Character'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'move.png', 'Move'),
  Enhancement(EnhancementCategory.charPlusOne, 40, 'teleport.png', 'Teleport'),
  Enhancement(EnhancementCategory.charPlusOne, 50, 'attack.png', 'Attack'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'range.png', 'Range'),
  Enhancement(EnhancementCategory.charPlusOne, 100, 'shield.png', 'Shield'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'push.png', 'Push'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'pull.png', 'Pull'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'pierce.png', 'Pierce'),
  Enhancement(
      EnhancementCategory.charPlusOne, 100, 'retaliate.png', 'Retaliate'),
  Enhancement(EnhancementCategory.charPlusOne, 30, 'heal.png', 'Heal'),
  Enhancement(EnhancementCategory.target, 50, 'target.png', 'Target'),
  Enhancement(EnhancementCategory.title, null, 'plus_one.png', ' For Summon'),
  Enhancement(EnhancementCategory.summonPlusOne, 100, 'move.png', 'Move'),
  Enhancement(EnhancementCategory.summonPlusOne, 100, 'attack.png', 'Attack'),
  Enhancement(EnhancementCategory.summonPlusOne, 50, 'range.png', 'Range'),
  Enhancement(EnhancementCategory.summonPlusOne, 50, 'heal.png', 'HP'),
  // negative effects
  Enhancement(EnhancementCategory.title, null, null, 'Effect'),
  Enhancement(EnhancementCategory.negEffect, 75, 'poison.png', 'Poison'),
  Enhancement(EnhancementCategory.negEffect, 75, 'wound.png', 'Wound'),
  Enhancement(EnhancementCategory.negEffect, 50, 'muddle.png', 'Muddle'),
  Enhancement(
      EnhancementCategory.negEffect, 100, 'immobilize.png', 'Immobilize'),
  Enhancement(EnhancementCategory.negEffect, 150, 'disarm.png', 'Disarm'),
  Enhancement(EnhancementCategory.negEffect, 75, 'curse.png', 'Curse'),
  // positive effects
  Enhancement(
      EnhancementCategory.posEffect, 50, 'strengthen.png', 'Strengthen'),
  Enhancement(EnhancementCategory.posEffect, 50, 'bless.png', 'Bless'),
  Enhancement(
      EnhancementCategory.posEffect, 50, 'regenerate.png', 'Regenerate'),
  Enhancement(EnhancementCategory.jump, 50, 'jump.png', 'Jump'),
  Enhancement(
      EnhancementCategory.specElem, 100, 'elem_fire.png', 'Specific Element'),
  Enhancement(EnhancementCategory.anyElem, 150, 'elem_any.png', 'Any Element'),
  Enhancement(EnhancementCategory.title, null, 'hex.png', ' Hex'),
  Enhancement(EnhancementCategory.hex, 100, 'hex.png', '2 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 66, 'hex.png', '3 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 50, 'hex.png', '4 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 40, 'hex.png', '5 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 33, 'hex.png', '6 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 28, 'hex.png', '7 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 25, 'hex.png', '8 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 22, 'hex.png', '9 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 20, 'hex.png', '10 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 18, 'hex.png', '11 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 16, 'hex.png', '12 Current Hexes'),
  Enhancement(EnhancementCategory.hex, 15, 'hex.png', '13 Current Hexes')
];

List<DropdownMenuItem<int>> cardLevelList = _generateCardLevelList(8);
List<DropdownMenuItem<int>> previousEnhancementsList =
    _generatePreviousEnhancementsList(3);
List<DropdownMenuItem<Enhancement>> enhancementTypeList =
    _generateEnhancementList(enhancementList);

_generateCardLevelList(int _maxLevel) {
  List<DropdownMenuItem<int>> _list = [];
  for (int x = 0; x <= _maxLevel; x++) {
    _list.add(DropdownMenuItem(
        child: Text(
          x == 0 ? '1 / x' : '${x + 1} (${(x * 25)}g)',
        ),
        value: x));
  }
  return _list;
}

_generatePreviousEnhancementsList(int _maxNumber) {
  List<DropdownMenuItem<int>> _list = [];
  for (int x = 0; x <= _maxNumber; x++) {
    _list.add(DropdownMenuItem(
        child: Text(
          x == 0 ? 'None' : '$x (${(x * 75)}g)',
        ),
        value: x));
  }
  return _list;
}

_generateEnhancementList(List<Enhancement> _enhancementsList) {
  List<DropdownMenuItem<Enhancement>> _list = [];
  _enhancementsList.forEach((_enhancement) => _list.add(
        _enhancement.category == EnhancementCategory.title
            ? DropdownMenuItem(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // if there is an icon beside the title, display it and add a spacer
                    children: _enhancement.icon != null
                        ? <Widget>[
                            Image.asset('images/${_enhancement.icon}',
                                width: _enhancement.icon == 'plus_one.png'
                                    ? plusOneWidth
                                    : iconWidth,
                                height: _enhancement.icon == 'plus_one.png'
                                    ? plusOneHeight
                                    : iconHeight),
                            Text(
                              '${_enhancement.name}',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // add an empty spacer to the right to center the title
                            Container(
                                width: _enhancement.icon == 'plus_one.png'
                                    ? plusOneWidth
                                    : iconWidth),
                          ]
                        : <Widget>[
                            Text(
                              '${_enhancement.name}',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                  ),
                ),
                value: _enhancement)
            : DropdownMenuItem(
                child: Row(
                  children: <Widget>[
                    // add small +1 icon beside move if it's eligible
                    _enhancement.category == EnhancementCategory.charPlusOne ||
                            _enhancement.category ==
                                EnhancementCategory.target ||
                            _enhancement.category ==
                                EnhancementCategory.summonPlusOne
                        ? Stack(
                            alignment: Alignment(1.0, -1.0),
                            children: <Widget>[
                              Image.asset('images/${_enhancement.icon}',
                                  width: iconWidth),
                              Image.asset('images/plus_one_border.png',
                                  width: plusOneWidth / 2,
                                  height: plusOneHeight / 2)
                            ],
                          )
                        // otherwise, no +1 icon
                        : Image.asset(
                            'images/${_enhancement.icon}',
                            width: iconWidth,
                          ),
                    Text(
                      ' ${_enhancement.name} (${_enhancement.baseCost}g)',
                    )
                  ],
                ),
                value: _enhancement),
      ));
  return _list;
}

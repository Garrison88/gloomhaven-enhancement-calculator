import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

List<PlayerClass> classList = [
  PlayerClass('Mindthief', 4, 'dfgbf'),
  PlayerClass('Scoundrel', 4, 'dfgbf'),
  PlayerClass('Brute', 4, 'dfgbf'),
  PlayerClass('Spellweaver', 4, 'dfgbf'),
  PlayerClass('Cragheart', 4, 'dfgbf'),
  PlayerClass('gdfg,', 4, 'dfgbf'),
  PlayerClass('gdfg,', 4, 'dfgbf'),
  PlayerClass('gdfg,', 4, 'dfgbf'),
  PlayerClass('gdfg,', 4, 'dfgbf')
];

List<DropdownMenuItem<PlayerClass>> classListMenuItems =
    _generatePreviousEnhancementsList(classList);

_generatePreviousEnhancementsList(List<PlayerClass> _classList) {
  List<DropdownMenuItem<PlayerClass>> _list = [];
  for (int x = 0; x < _classList.length; x++) {
    _list.add(DropdownMenuItem(
        child: Text('${_classList[x].className}',
            style: TextStyle(fontFamily: secondaryFontFamily)),
        value: _classList[x]));
  }
  return _list;
}

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';

List<int> tierOneEnhancements = [1, 3, 5, 6, 7, 9]; // 30g
List<int> tierTwoEnhancements = [2, 10, 14, 15, 19, 23, 24, 25]; // 50g
List<int> tierThreeEnhancements = [17, 18, 22]; // 75g
List<int> tierFourEnhancements = [4, 8, 12, 13, 20, 26]; // 100g
List<int> tierFiveEnhancements = [21, 27]; // 150g
// enhancements not eligible for multiple target fee
// Single Target Enhancements = 4, 8, 10, 15, 25
// DropDownList Titles = 0, 11, 16, 28

List<DropdownMenuItem<int>> levelList = [
  DropdownMenuItem(
      child: Text('1', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 1),
  DropdownMenuItem(
      child: Text('2', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 2),
  DropdownMenuItem(
      child: Text('3', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 3),
  DropdownMenuItem(
      child: Text('4', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 4),
  DropdownMenuItem(
      child: Text('5', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 5),
  DropdownMenuItem(
      child: Text('6', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 6),
  DropdownMenuItem(
      child: Text('7', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 7),
  DropdownMenuItem(
      child: Text('8', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 8),
  DropdownMenuItem(
      child: Text('9', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 9),
];

List<DropdownMenuItem<int>> levelOfTargetCardList = [
  DropdownMenuItem(
      child: Text('1 / x', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 0),
  DropdownMenuItem(
      child: Text('2 (25g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 1),
  DropdownMenuItem(
      child: Text('3 (50g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 2),
  DropdownMenuItem(
      child: Text('4 (75g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 3),
  DropdownMenuItem(
      child:
          Text('5 (100g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 4),
  DropdownMenuItem(
      child:
          Text('6 (125g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 5),
  DropdownMenuItem(
      child:
          Text('7 (150g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 6),
  DropdownMenuItem(
      child:
          Text('8 (175g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 7),
  DropdownMenuItem(
      child:
          Text('9 (200g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 8),
];

List<DropdownMenuItem<int>> enhancementsOnTargetActionList = [
  DropdownMenuItem(
      child: Text('None', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 0),
  DropdownMenuItem(
      child: Text('1 (75g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 1),
  DropdownMenuItem(
      child:
          Text('2 (150g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 2),
  DropdownMenuItem(
      child:
          Text('3 (225g)', style: TextStyle(fontFamily: secondaryFontFamily)),
      value: 3)
];

//List<EnhancementDropDownItem> enhancementTypeList = []..add(EnhancementDropDownItem(Enhancement('fgd', 5, 'gvef', false, false)));

List<DropdownMenuItem<int>> enhancementTypeList = [
  DropdownMenuItem(
      child: Center(
          child: Text('+1 For Characters',
              style: TextStyle(
                  fontFamily: secondaryFontFamily,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold))),
      value: 0),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/move.png', width: iconWidth),
          Text(' Move (30g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 1),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/attack.png', width: iconWidth),
          Text(' Attack (50g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 2),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/range.png', width: iconWidth),
          Text('Range (30g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 3),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/shield.png', width: iconWidth),
          Text(' Shield (100g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 4),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/push.png', width: iconWidth),
          Text(' Push (30g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 5),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/pull.png', width: iconWidth),
          Text(' Pull (30g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 6),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/pierce.png', width: iconWidth),
          Text(' Pierce (30g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 7),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/retaliate.png', width: iconWidth),
          Text(' Retaliate (100g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 8),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/heal.png', width: iconWidth),
          Text(' Heal (30g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 9),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/target.png', width: iconWidth),
          Text(' Target (50g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 10),
  DropdownMenuItem(
      child: Center(
        child: Text('+1 For Summons',
            style: TextStyle(
                fontFamily: secondaryFontFamily,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold)),
//        key: Key('range'),
      ),
      value: 11),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/move.png', width: iconWidth),
          Text(' Move (100g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 12),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/attack.png', width: iconWidth),
          Text(' Attack (100g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 13),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/range.png', width: iconWidth),
          Text(' Range (50g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 14),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/heal.png', width: iconWidth),
          Text(' HP (50g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 15),
  DropdownMenuItem(
      child: Center(
          child: Text('Effects',
              style: TextStyle(
                  fontFamily: secondaryFontFamily,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold))),
      value: 16),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/poison.png', width: iconWidth),
          Text(' Poison (75g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 17),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/wound.png', width: iconWidth),
          Text(' Wound (75g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 18),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/muddle.png', width: iconWidth),
          Text(' Muddle (50g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 19),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/immobilize.png', width: iconWidth),
          Text(' Immobilize (100g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 20),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/disarm.png', width: iconWidth),
          Text(' Disarm (150g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 21),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/curse.png', width: iconWidth),
          Text(' Curse (75g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 22),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/strengthen.png', width: iconWidth),
          Text(' Strengthen (50g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 23),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/bless.png', width: iconWidth),
          Text(' Bless (50g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 24),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/jump.png', width: iconWidth),
          Text(' Jump (50g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 25),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/elements.png', width: iconWidth),
          Text(' Specific Element (100g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 26),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/elements.png', width: iconWidth),
          Text(' Any Element (150g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 27),
  DropdownMenuItem(
      child: Center(
          child: Text('Hex',
              style: TextStyle(
                  fontFamily: secondaryFontFamily,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold))),
      value: 28),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 2 Current Targets (100g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 29),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 3 Current Targets (66g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 30),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 4 Current Targets (50g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 31),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 5 Current Targets (40g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 32),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 6 Current Targets (33g)',
              style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 33)
];

List<DropdownMenuItem<int>> existingHexesList = [
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 2 (100g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 2),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 3 (66g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 3),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 4 (50g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 4),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 5 (40g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 5),
  DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Image.asset('images/hex_target.png', width: iconWidth),
          Text(' 6 (33g)', style: TextStyle(fontFamily: secondaryFontFamily))
        ],
      ),
      value: 6)
];

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../../data/character_sheet_list_data.dart';
// import '../../data/constants.dart';
// import '../../data/strings.dart';
// import '../../main.dart';
// import '../../models/player_class.dart';
// import '../dialogs/show_info.dart';
// import '../widgets/perk_section.dart';

// class CharacterSheetPage extends StatefulWidget {
//   // CharacterSheetPage({Key key, this.character}) : super(key: key);

//   // final Character character;

//   @override
//   State<StatefulWidget> createState() {
//     return CharacterSheetPageState();
//   }
// }

// class CharacterSheetPageState extends State<CharacterSheetPage> {
// //  List<Item> _itemList = [
// //    Item('sgg', 56, Slot('sgf', 'sgfd')),
// //    Item('allf', 56, Slot('sgf', 'sgfd')),
// //    Item('54y', 56, Slot('sgf', 'sgfd')),
// //    Item('####', 56, Slot('sgf', 'sgfd')),
// //    Item('vv--f', 56, Slot('sgf', 'sgfd')),
// //  ];
// //
// //  List<GridItem> _gridList;

//   bool _isEditable = false,
//       _firstCheck = false,
//       _secondCheck = false,
//       _thirdCheck = false,
//       _2FirstCheck = false,
//       _2SecondCheck = false,
//       _2ThirdCheck = false,
//       _3FirstCheck = false,
//       _3SecondCheck = false,
//       _3ThirdCheck = false,
//       _4FirstCheck = false,
//       _4SecondCheck = false,
//       _4ThirdCheck = false,
//       _5FirstCheck = false,
//       _5SecondCheck = false,
//       _5ThirdCheck = false,
//       _6FirstCheck = false,
//       _6SecondCheck = false,
//       _6ThirdCheck = false;
//   PlayerClass _selectedClass;

// //  Item _selectedItem;
//   final TextEditingController _previousRetirementsTextFieldController =
//       TextEditingController();
//   final TextEditingController _xpTextFieldController = TextEditingController();
//   final TextEditingController _goldTextFieldController =
//       TextEditingController();
//   final TextEditingController _charNameTextFieldController =
//       TextEditingController();
//   final TextEditingController _notesTextFieldController =
//       TextEditingController();
//   int _charLevel = 1, _nextLevelXp = 45;

// //  double rating = 0;

// //  Slot _selectedSlot;

//   @override
//   void initState() {
//     super.initState();
// //    _gridList = [];
//     _readFromSharedPrefs();
// //    setState(() {
// //      for (int x = 0; x < _itemList.length; x++) {
// //        _gridList.add(GridItem(_itemList[x]));
// //      }
// //    });
//     _handleExpChanged();
//     // print(widget.character.name);
//   }

//   Future _readFromSharedPrefs() async {
// //     setState(() {
// //       _selectedClass = prefs.getInt('selectedClass') != null && classList != null
// //           ? classList[prefs.getInt('selectedClass')]
// //           : classList[0];
// //       _previousRetirementsTextFieldController.text =
// //           prefs.getString('previousRetirements') ?? '0';
// //       _charNameTextFieldController.text = prefs.getString('characterName') ?? '';
// //       _xpTextFieldController.text = prefs.getString('characterXP') ?? '0';
// //       _goldTextFieldController.text = prefs.getString('characterGold') ?? '0';
// //       _firstCheck = prefs.getBool('firstCheck') ?? false;
// //       _secondCheck = prefs.getBool('secondCheck') ?? false;
// //       _thirdCheck = prefs.getBool('thirdCheck') ?? false;
// //       _2FirstCheck = prefs.getBool('2FirstCheck') ?? false;
// //       _2SecondCheck = prefs.getBool('2SecondCheck') ?? false;
// //       _2ThirdCheck = prefs.getBool('2ThirdCheck') ?? false;
// //       _3FirstCheck = prefs.getBool('3FirstCheck') ?? false;
// //       _3SecondCheck = prefs.getBool('3SecondCheck') ?? false;
// //       _3ThirdCheck = prefs.getBool('3ThirdCheck') ?? false;
// //       _4FirstCheck = prefs.getBool('4FirstCheck') ?? false;
// //       _4SecondCheck = prefs.getBool('4SecondCheck') ?? false;
// //       _4ThirdCheck = prefs.getBool('4ThirdCheck') ?? false;
// //       _5FirstCheck = prefs.getBool('5FirstCheck') ?? false;
// //       _5SecondCheck = prefs.getBool('5SecondCheck') ?? false;
// //       _5ThirdCheck = prefs.getBool('5ThirdCheck') ?? false;
// //       _6FirstCheck = prefs.getBool('6FirstCheck') ?? false;
// //       _6SecondCheck = prefs.getBool('6SecondCheck') ?? false;
// //       _6ThirdCheck = prefs.getBool('6ThirdCheck') ?? false;
// //       _notesTextFieldController.text = prefs.getString('notes') ?? null;
// // //      json
// // //          .decode(prefs.getString('itemsList'))
// // //          .forEach((map) => _itemList.add(Item.fromJson(map)));
// // //    });
// //     });
//   }

//   Future _writeToSharedPrefs() async {
//     setState(() {
//       // prefs.setInt('selectedClass', classList.indexOf(_selectedClass));
//       prefs.setString(
//           'previousRetirements', _previousRetirementsTextFieldController.text);
//       prefs.setString('characterName', _charNameTextFieldController.text);
//       prefs.setString('characterXP', _xpTextFieldController.text);
//       prefs.setString('characterGold', _goldTextFieldController.text);
//       prefs.setBool('firstCheck', _firstCheck);
//       prefs.setBool('secondCheck', _secondCheck);
//       prefs.setBool('thirdCheck', _thirdCheck);
//       prefs.setBool('2FirstCheck', _2FirstCheck);
//       prefs.setBool('2SecondCheck', _2SecondCheck);
//       prefs.setBool('2ThirdCheck', _2ThirdCheck);
//       prefs.setBool('3FirstCheck', _3FirstCheck);
//       prefs.setBool('3SecondCheck', _3SecondCheck);
//       prefs.setBool('3ThirdCheck', _3ThirdCheck);
//       prefs.setBool('4FirstCheck', _4FirstCheck);
//       prefs.setBool('4SecondCheck', _4SecondCheck);
//       prefs.setBool('4ThirdCheck', _4ThirdCheck);
//       prefs.setBool('5FirstCheck', _5FirstCheck);
//       prefs.setBool('5SecondCheck', _5SecondCheck);
//       prefs.setBool('5ThirdCheck', _5ThirdCheck);
//       prefs.setBool('6FirstCheck', _6FirstCheck);
//       prefs.setBool('6SecondCheck', _6SecondCheck);
//       prefs.setBool('6ThirdCheck', _6ThirdCheck);
//       prefs.setString('notes', _notesTextFieldController.text);
// //      prefs.setString('itemsList', json.encode(_itemList));
//     });
//   }

//   void _onClassSelected(PlayerClass _value) {
//     setState(() {
//       _selectedClass = _value;

//       // DynamicTheme.of(context).setThemeData(ThemeData(
//       //   accentColor:
//       //       _selectedClass != null ? _selectedClass.classColor : Color(0xff4e7ec1),
//       //   primarySwatch: Colors.brown,
//       //   // Define the default Font Family
//       //   fontFamily: 'PirataOne',

//       //   // Define the default TextTheme. Use this to specify the default
//       //   // text styling for headlines, titles, bodies of text, and more.
//       //   textTheme: TextTheme(
//       //     // DropDownButton text
//       //     subhead: TextStyle(fontSize: 23.0),
//       //     // Text widgets
//       //     body1: TextStyle(fontSize: 23.0, letterSpacing: 0.7),
//       //   ),
//       // ));
//       _writeToSharedPrefs();
// //      _readFromSharedPrefs();
//     });
//   }

// //  void _handleSlotSelected(Slot _value) {
// //    setState(() {
// //      _selectedSlot = _value;
// ////      print(_value.className);
// //    });
// ////    _writeToSharedPrefs();
// //  }

//   void _toggleEditMode() {
//     _isEditable = !_isEditable;
//     print(_xpTextFieldController.text);
//     _writeToSharedPrefs();
//     _handleExpChanged();
//   }

// //  void _addItem(Item _item) {
// //    setState(() {
// //      _selectedItem = _item;
// //      _itemList.add(_item);
// ////      for (int x = 0; x < _itemList.length; x++) {
// ////        _gridList.add(GridItem(_itemList[x]));
// ////      }
// //    });
// ////    print('clicked');
// //  }

// //  void removeItem(Item _item) {}

// //  void _onSlotSelected(Slot value) {
// //    setState(() {
// //      _selectedSlot = value;
// //    });
// //  }

//   _handleExpChanged() {
//     if (_xpTextFieldController.text != null &&
//         _xpTextFieldController.text != '') {
//       if (int.parse(_xpTextFieldController.text) < levelXpList[0]) {
//         _charLevel = 1;
//         _nextLevelXp = levelXpList[0];
//       } else if (int.parse(_xpTextFieldController.text) < levelXpList[1]) {
//         _charLevel = 2;
//         _nextLevelXp = levelXpList[1];
//       } else if (int.parse(_xpTextFieldController.text) < levelXpList[2]) {
//         _charLevel = 3;
//         _nextLevelXp = levelXpList[2];
//       } else if (int.parse(_xpTextFieldController.text) < levelXpList[3]) {
//         _charLevel = 4;
//         _nextLevelXp = levelXpList[3];
//       } else if (int.parse(_xpTextFieldController.text) < levelXpList[4]) {
//         _charLevel = 5;
//         _nextLevelXp = levelXpList[4];
//       } else if (int.parse(_xpTextFieldController.text) < levelXpList[5]) {
//         _charLevel = 6;
//         _nextLevelXp = levelXpList[5];
//       } else if (int.parse(_xpTextFieldController.text) < levelXpList[6]) {
//         _charLevel = 7;
//         _nextLevelXp = levelXpList[6];
//       } else if (int.parse(_xpTextFieldController.text) < levelXpList[7]) {
//         _charLevel = 8;
//         _nextLevelXp = levelXpList[7];
//       } else {
//         _charLevel = 9;
//         _nextLevelXp = levelXpList[7];
//       }
//     }
//   }

// //  Card getStructuredGridCell(Item item) {
// //    return new Card(
// //        elevation: 1.5,
// //        child: new Column(
// //          crossAxisAlignment: CrossAxisAlignment.stretch,
// //          mainAxisSize: MainAxisSize.min,
// //          verticalDirection: VerticalDirection.down,
// //          children: <Widget>[
// //            new Padding(
// //              padding: EdgeInsets.only(left: 10.0),
// //              child: new Column(
// //                crossAxisAlignment: CrossAxisAlignment.start,
// //                children: <Widget>[
// //                  new Text(item.name),
// //                  new Text(item.slot.name),
// //                  new Text(item.price.toString()),
// //                ],
// //              ),
// //            )
// //          ],
// //        ));
// //  }

//   @override
//   void dispose() {
//     _previousRetirementsTextFieldController.dispose();
//     _xpTextFieldController.dispose();
//     _goldTextFieldController.dispose();
//     _charNameTextFieldController.dispose();
//     _notesTextFieldController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.95),
//           image: DecorationImage(
//               image: AssetImage(_selectedClass != null
//                   ? 'images/class_icons/${_selectedClass.classIconUrl}'
//                   : ''),
//               colorFilter: ColorFilter.mode(
//                   Colors.white.withOpacity(0.95), BlendMode.lighten),
//               fit: BoxFit.fitWidth),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: CustomScrollView(
//             slivers: <Widget>[
//               SliverList(
//                 delegate: SliverChildListDelegate([
//                   Container(
//                     padding: EdgeInsets.only(top: smallPadding),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Expanded(
//                             child: Column(
//                           children: <Widget>[
//                             Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: _isEditable
//                                     ? <Widget>[
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: smallPadding)),
//                                         Container(
//                                             child: Expanded(
//                                                 child: TextField(
//                                           controller:
//                                               _previousRetirementsTextFieldController,
//                                           style: TextStyle(
//                                               fontSize: titleFontSize),
//                                           textAlign: TextAlign.center,
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.deny(
//                                                 RegExp('[\\.|\\,|\\ |\\-]'))
//                                           ],
//                                           keyboardType: TextInputType.number,
//                                           decoration: InputDecoration(
//                                               labelText: 'Retirements',
//                                               hintStyle: TextStyle(
//                                                   fontSize: titleFontSize)),
//                                         ))),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: smallPadding)),
//                                       ]
//                                     : <Widget>[
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: smallPadding)),
//                                         Container(
//                                           child: Text(
//                                             'Retirements: ${_previousRetirementsTextFieldController.text}',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 fontSize: titleFontSize / 2),
//                                           ),
//                                         ),
//                                         IconButton(
//                                             icon: Icon(
//                                               Icons.info_outline,
//                                               color:
//                                                   Theme.of(context).accentColor,
//                                             ),
//                                             onPressed: () {
//                                               showInfoDialog(
//                                                   context,
//                                                   Strings
//                                                       .previousRetirementsInfoTitle,
//                                                   Strings
//                                                       .previousRetirementsInfoBody,
//                                                   null);
//                                             }),
//                                       ]),
//                             _isEditable
//                                 ? Container(
//                                     padding: EdgeInsets.only(
//                                         left: smallPadding,
//                                         right: smallPadding),
//                                     child: TextField(
//                                       controller: _charNameTextFieldController,
//                                       style: TextStyle(
//                                           fontSize: titleFontSize,
//                                           fontFamily: highTower),
//                                       textAlign: TextAlign.center,
//                                       textCapitalization:
//                                           TextCapitalization.words,
//                                       decoration: InputDecoration(
//                                           labelText: 'Name',
//                                           hintStyle: TextStyle(
//                                               fontSize: titleFontSize,
//                                               fontFamily: highTower)),
//                                     ))
//                                 : AutoSizeText(
//                                     _charNameTextFieldController.text,
//                                     maxLines: 2,
//                                     style: TextStyle(
//                                         fontSize: titleFontSize * 1.5,
//                                         fontFamily: highTower),
//                                     textAlign: TextAlign.center,
//                                   ),
//                             // Row(
//                             //     mainAxisAlignment: MainAxisAlignment.center,
//                             //     children: _isEditable
//                             //         ? <Widget>[
//                             //             DropdownButtonHideUnderline(
//                             //               child: DropdownButton<PlayerClass>(
//                             //                 hint: Text(
//                             //                   'Class',
//                             //                   style: TextStyle(
//                             //                       fontSize: titleFontSize),
//                             //                 ),
//                             //                 onChanged: _onClassSelected,
//                             //                 value: _selectedClass,
//                             //                 items: classListMenuItems,
//                             //               ),
//                             //             )
//                             //           ]
//                             //         : <Widget>[
//                             //             Stack(
//                             //               alignment: Alignment(0.0, 0.0),
//                             //               children: <Widget>[
//                             //                 Image.asset('images/xp.png',
//                             //                     width: iconWidth * 1.75),
//                             //                 Text(
//                             //                   '$_charLevel',
//                             //                   style: TextStyle(
//                             //                       color: Colors.white,
//                             //                       fontSize: titleFontSize),
//                             //                 )
//                             //               ],
//                             //             ),
//                             //             Flexible(
//                             //                 child: AutoSizeText(
//                             //                     '${_selectedClass.race} ${_selectedClass.className}',
//                             //                     maxLines: 1,
//                             //                     style: TextStyle(
//                             //                         fontSize: titleFontSize))),
//                             //           ]),
//                           ],
//                         )),
//                       ],
//                     ),
//                   ),
//                   _isEditable
//                       ? Row(
//                           children: <Widget>[
//                             Expanded(
//                               flex: 1,
//                               child: Container(
//                                   padding: EdgeInsets.only(left: smallPadding),
//                                   child: TextField(
//                                     style: TextStyle(fontSize: titleFontSize),
//                                     textAlign: TextAlign.center,
//                                     controller: _xpTextFieldController,
//                                     decoration: InputDecoration(
//                                         labelText: 'XP',
//                                         labelStyle: TextStyle(
//                                             fontSize: dialogFontSize)),
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.deny(
//                                           RegExp('[\\.|\\,|\\ |\\-]'))
//                                     ],
//                                     keyboardType: TextInputType.number,
//                                   )),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(left: 4, right: 4),
//                             ),
//                             Expanded(
//                               flex: 1,
//                               child: Container(
//                                   padding: EdgeInsets.only(right: smallPadding),
//                                   child: TextField(
//                                     style: TextStyle(fontSize: titleFontSize),
//                                     textAlign: TextAlign.center,
//                                     controller: _goldTextFieldController,
//                                     decoration: InputDecoration(
//                                         labelText: 'Gold',
//                                         labelStyle: TextStyle(
//                                             fontSize: dialogFontSize)),
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.deny(
//                                           RegExp('[\\.|\\,|\\ |\\-]')),
//                                     ],
//                                     keyboardType: TextInputType.number,
//                                   )),
//                             ),
//                           ],
//                         )
//                       : Center(
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.all(smallPadding),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Image.asset(
//                                         'images/xp.png',
//                                         width: iconWidth,
//                                       ),
//                                       Text(
//                                         ' ' + _xpTextFieldController.text,
//                                         style:
//                                             TextStyle(fontSize: titleFontSize),
//                                       ),
//                                       Column(
//                                         children: <Widget>[
//                                           Text(
//                                             ' / $_nextLevelXp',
//                                             style: TextStyle(
//                                                 fontSize: titleFontSize / 2),
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(smallPadding),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Image.asset(
//                                         'images/loot.png',
//                                         width: iconWidth,
//                                       ),
//                                       Text(
//                                         ' ' + _goldTextFieldController.text,
//                                         style:
//                                             TextStyle(fontSize: titleFontSize),
//                                       )
//                                     ],
//                                   ),
//                                 ),
// //                                Container(
// //                                  padding: EdgeInsets.all(smallPadding),
// //                                  child: Row(
// //                                    mainAxisAlignment: MainAxisAlignment.center,
// //                                    children: <Widget>[
// //                                      Image.asset(
// //                                        'images/goal.png',
// //                                        width: iconWidth,
// //                                      ),
// //                                      Text(
// //                                        ' ${_thirdCheck ? '3' : _secondCheck ? '2' : _firstCheck ? '1' : '0'} / 3',
// //                                        style:
// //                                            TextStyle(fontSize: titleFontSize),
// //                                      )
// //                                    ],
// //                                  ),
// //                                ),
//                                 Container(
//                                   padding: EdgeInsets.all(smallPadding),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Image.asset(
//                                         'images/equipment_slots/pocket.png',
//                                         width: iconWidth,
//                                       ),
//                                       Text(
//                                         ' ${(_charLevel / 2).round()}',
//                                         style:
//                                             TextStyle(fontSize: titleFontSize),
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
// //                  Expanded(
// //                      flex: 2,
// //                      child:
//                   _isEditable
//                       ? Padding(padding: EdgeInsets.only(bottom: smallPadding))
//                       : Container(),
//                   _isEditable
//                       ? AutoSizeText(
//                           'Battle Goal Checkmarks',
//                           textAlign: TextAlign.center,
//                           maxFontSize: titleFontSize,
//                         )
//                       : Container(),
//                   _isEditable
//                       ? Padding(padding: EdgeInsets.only(bottom: smallPadding))
//                       : Container(),
//                   _isEditable
//                       ? Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Card(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: <Widget>[
//                                         Checkbox(
//                                           value: _firstCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _firstCheck = value;
//                                             _secondCheck = false;
//                                             _thirdCheck = false;
//                                           }),
//                                         ),
//                                         Checkbox(
//                                           value: _secondCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _firstCheck = true;
//                                             _secondCheck = value;
//                                             _thirdCheck = false;
//                                           }),
//                                         ),
//                                         Checkbox(
//                                           value: _thirdCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _firstCheck = true;
//                                             _secondCheck = true;
//                                             _thirdCheck = value;
//                                           }),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Card(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: <Widget>[
//                                         Checkbox(
//                                           value: _2FirstCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _2FirstCheck = value;
//                                             _2SecondCheck = false;
//                                             _2ThirdCheck = false;
//                                           }),
//                                         ),
//                                         Checkbox(
//                                           value: _2SecondCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _2FirstCheck = true;
//                                             _2SecondCheck = value;
//                                             _2ThirdCheck = false;
//                                           }),
//                                         ),
//                                         Checkbox(
//                                           value: _2ThirdCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _2FirstCheck = true;
//                                             _2SecondCheck = true;
//                                             _2ThirdCheck = value;
//                                           }),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Card(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: <Widget>[
//                                         Checkbox(
//                                           value: _3FirstCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _3FirstCheck = value;
//                                             _3SecondCheck = false;
//                                             _3ThirdCheck = false;
//                                           }),
//                                         ),
//                                         Checkbox(
//                                           value: _3SecondCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _3FirstCheck = true;
//                                             _3SecondCheck = value;
//                                             _3ThirdCheck = false;
//                                           }),
//                                         ),
//                                         Checkbox(
//                                           value: _3ThirdCheck,
//                                           onChanged: (bool value) =>
//                                               setState(() {
//                                             _3FirstCheck = true;
//                                             _3SecondCheck = true;
//                                             _3ThirdCheck = value;
//                                           }),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                                 child: Column(
//                               children: <Widget>[
//                                 Card(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: <Widget>[
//                                       Checkbox(
//                                         value: _4FirstCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _4FirstCheck = value;
//                                           _4SecondCheck = false;
//                                           _4ThirdCheck = false;
//                                         }),
//                                       ),
//                                       Checkbox(
//                                         value: _4SecondCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _4FirstCheck = true;
//                                           _4SecondCheck = value;
//                                           _4ThirdCheck = false;
//                                         }),
//                                       ),
//                                       Checkbox(
//                                         value: _4ThirdCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _4FirstCheck = true;
//                                           _4SecondCheck = true;
//                                           _4ThirdCheck = value;
//                                         }),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Card(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: <Widget>[
//                                       Checkbox(
//                                         value: _5FirstCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _5FirstCheck = value;
//                                           _5SecondCheck = false;
//                                           _5ThirdCheck = false;
//                                         }),
//                                       ),
//                                       Checkbox(
//                                         value: _5SecondCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _5FirstCheck = true;
//                                           _5SecondCheck = value;
//                                           _5ThirdCheck = false;
//                                         }),
//                                       ),
//                                       Checkbox(
//                                         value: _5ThirdCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _5FirstCheck = true;
//                                           _5SecondCheck = true;
//                                           _5ThirdCheck = value;
//                                         }),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Card(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: <Widget>[
//                                       Checkbox(
//                                         value: _6FirstCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _6FirstCheck = value;
//                                           _6SecondCheck = false;
//                                           _6ThirdCheck = false;
//                                         }),
//                                       ),
//                                       Checkbox(
//                                         value: _6SecondCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _6FirstCheck = true;
//                                           _6SecondCheck = value;
//                                           _6ThirdCheck = false;
//                                         }),
//                                       ),
//                                       Checkbox(
//                                         value: _6ThirdCheck,
//                                         onChanged: (bool value) => setState(() {
//                                           _6FirstCheck = true;
//                                           _6SecondCheck = true;
//                                           _6ThirdCheck = value;
//                                         }),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ))
//                           ],
//                         )
//                       : Container(),
//                   Padding(padding: EdgeInsets.only(bottom: smallPadding)),
//                   Text(
//                     'Notes',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: titleFontSize),
//                   ),
//                   Padding(padding: EdgeInsets.only(bottom: smallPadding)),
//                   Card(
//                     color: Colors.white,
//                     child: Container(
//                       padding: EdgeInsets.all(smallPadding),
//                       child: _isEditable
//                           ? TextField(
//                               style: TextStyle(fontFamily: highTower),
//                               maxLines: 8,
//                               textCapitalization: TextCapitalization.sentences,
//                               decoration: InputDecoration(
//                                   hintText: 'Notes',
//                                   hintStyle: TextStyle(fontFamily: highTower)),
//                               controller: _notesTextFieldController,
//                             )
//                           : Text(
//                               _notesTextFieldController.text,
//                               style: TextStyle(fontFamily: highTower),
//                             ),
//                     ),
//                   ),
//                   Padding(padding: EdgeInsets.only(bottom: smallPadding)),
//                   !_isEditable
//                       ? Text(
//                           'Perks',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: titleFontSize),
//                         )
//                       : Container(),
// //                  Padding(padding: EdgeInsets.only(bottom: smallPadding)),
//                 ]),
//               ),
//               _isEditable
//                   ? SliverAppBar(backgroundColor: Colors.transparent)
//                   : PerkSection(_selectedClass.perks),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//               foregroundColor: Colors.white,
//               onPressed: _toggleEditMode,
//               child: _isEditable ? Icon(Icons.check) : Icon(Icons.mode_edit)),
//         ),
//       );
// }

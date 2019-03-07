import 'package:auto_size_text/auto_size_text.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/ui/perk_section.dart';

class CharacterSheetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CharacterSheetPageState();
  }
}

class CharacterSheetPageState extends State<CharacterSheetPage> {
//  List<Item> _itemList = [
//    Item('sgg', 56, Slot('sgf', 'sgfd')),
//    Item('allf', 56, Slot('sgf', 'sgfd')),
//    Item('54y', 56, Slot('sgf', 'sgfd')),
//    Item('####', 56, Slot('sgf', 'sgfd')),
//    Item('vv--f', 56, Slot('sgf', 'sgfd')),
//  ];
//
//  List<GridItem> _gridList;

  bool _isEditable = false,
      _firstCheck = false,
      _secondCheck = false,
      _thirdCheck = false;
  PlayerClass _selectedClass;

//  Item _selectedItem;
  final TextEditingController _xpTextFieldController = TextEditingController();
  final TextEditingController _goldTextFieldController =
      TextEditingController();
  final TextEditingController _charNameTextFieldController =
      TextEditingController();
  final TextEditingController _notesTextFieldController =
      TextEditingController();
  int _charLevel = 1, _nextLevelXp = 45;
  double rating = 0;

//  Slot _selectedSlot;

  @override
  void initState() {
    super.initState();
//    _gridList = [];
    _readFromSharedPrefs();
//    setState(() {
//      for (int x = 0; x < _itemList.length; x++) {
//        _gridList.add(GridItem(_itemList[x]));
//      }
//    });
    _handleExpChanged();
  }

  Future _readFromSharedPrefs() async {
    _charNameTextFieldController.text = sp.getString('characterName') ?? '';
    _selectedClass = sp.getInt('selectedClass') != null && classList != null
        ? classList[sp.getInt('selectedClass')]
        : classList[0];
    _xpTextFieldController.text = sp.getString('characterXP') ?? '0';
    _goldTextFieldController.text = sp.getString('characterGold') ?? '0';
    _firstCheck = sp.getBool('firstCheck') ?? false;
    _secondCheck = sp.getBool('secondCheck') ?? false;
    _thirdCheck = sp.getBool('thirdCheck') ?? false;
    _notesTextFieldController.text = sp.getString('notes') ?? null;
//      json
//          .decode(sp.getString('itemsList'))
//          .forEach((map) => _itemList.add(Item.fromJson(map)));
//    });
  }

  Future _writeToSharedPrefs() async {
    setState(() {
      sp.setString('characterName', _charNameTextFieldController.text);
      sp.setInt('selectedClass', classList.indexOf(_selectedClass));
      sp.setString('characterXP', _xpTextFieldController.text);
      sp.setString('characterGold', _goldTextFieldController.text);
      sp.setBool('firstCheck', _firstCheck);
      sp.setBool('secondCheck', _secondCheck);
      sp.setBool('thirdCheck', _thirdCheck);
      sp.setString('notes', _notesTextFieldController.text);
//      sp.setString('itemsList', json.encode(_itemList));
    });
  }

  void _onClassSelected(PlayerClass _value) {
    setState(() {});
    _selectedClass = _value;

    DynamicTheme.of(context).setThemeData(ThemeData(
      accentColor:
          _selectedClass != null ? _selectedClass.color : Color(0xff4e7ec1),
      primarySwatch: Colors.brown,
      // Define the default Font Family
      fontFamily: 'PirataOne',

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        // DropDownButton text
        subhead: TextStyle(fontSize: 23.0),
        // Text widgets
        body1: TextStyle(fontSize: 23.0, letterSpacing: 0.7),
      ),
    ));
    _writeToSharedPrefs();
  }

//  void _handleSlotSelected(Slot _value) {
//    setState(() {
//      _selectedSlot = _value;
////      print(_value.className);
//    });
////    _writeToSharedPrefs();
//  }

  void _toggleEditMode() {
    _isEditable = !_isEditable;
    print(_xpTextFieldController.text);
    _writeToSharedPrefs();
    _handleExpChanged();
  }

//  void _addItem(Item _item) {
//    setState(() {
//      _selectedItem = _item;
//      _itemList.add(_item);
////      for (int x = 0; x < _itemList.length; x++) {
////        _gridList.add(GridItem(_itemList[x]));
////      }
//    });
////    print('clicked');
//  }

//  void removeItem(Item _item) {}

//  void _onSlotSelected(Slot value) {
//    setState(() {
//      _selectedSlot = value;
//    });
//  }

  _handleExpChanged() {
    if (_xpTextFieldController.text != null &&
        _xpTextFieldController.text != '') {
      if (int.parse(_xpTextFieldController.text) < levelXpList[0]) {
        _charLevel = 1;
        _nextLevelXp = levelXpList[0];
      } else if (int.parse(_xpTextFieldController.text) < levelXpList[1]) {
        _charLevel = 2;
        _nextLevelXp = levelXpList[1];
      } else if (int.parse(_xpTextFieldController.text) < levelXpList[2]) {
        _charLevel = 3;
        _nextLevelXp = levelXpList[2];
      } else if (int.parse(_xpTextFieldController.text) < levelXpList[3]) {
        _charLevel = 4;
        _nextLevelXp = levelXpList[3];
      } else if (int.parse(_xpTextFieldController.text) < levelXpList[4]) {
        _charLevel = 5;
        _nextLevelXp = levelXpList[4];
      } else if (int.parse(_xpTextFieldController.text) < levelXpList[5]) {
        _charLevel = 6;
        _nextLevelXp = levelXpList[5];
      } else if (int.parse(_xpTextFieldController.text) < levelXpList[6]) {
        _charLevel = 7;
        _nextLevelXp = levelXpList[6];
      } else if (int.parse(_xpTextFieldController.text) < levelXpList[7]) {
        _charLevel = 8;
        _nextLevelXp = levelXpList[7];
      } else {
        _charLevel = 9;
        _nextLevelXp = levelXpList[7];
      }
    }
  }

//  Card getStructuredGridCell(Item item) {
//    return new Card(
//        elevation: 1.5,
//        child: new Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          mainAxisSize: MainAxisSize.min,
//          verticalDirection: VerticalDirection.down,
//          children: <Widget>[
//            new Padding(
//              padding: EdgeInsets.only(left: 10.0),
//              child: new Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  new Text(item.name),
//                  new Text(item.slot.name),
//                  new Text(item.price.toString()),
//                ],
//              ),
//            )
//          ],
//        ));
//  }

  @override
  void dispose() {
    _xpTextFieldController.dispose();
    _goldTextFieldController.dispose();
    _charNameTextFieldController.dispose();
    _notesTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          image: DecorationImage(
              image: AssetImage(_selectedClass != null
                  ? 'images/class_icons/${_selectedClass.icon}'
                  : ''),
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.95), BlendMode.lighten),
              fit: BoxFit.fitWidth),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: false,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Column(
                          children: <Widget>[
                            _isEditable
                                ? TextField(
                                    controller: _charNameTextFieldController,
                                    style: TextStyle(
                                        fontSize: titleFontSize,
                                        fontFamily: highTower),
                                    textAlign: TextAlign.center,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                        hintText: 'Name',
                                        hintStyle: TextStyle(
                                            fontSize: titleFontSize,
                                            fontFamily: highTower)),
                                  )
                                : Text(
                                    _charNameTextFieldController.text,
                                    style: TextStyle(
                                        fontSize: titleFontSize,
                                        fontFamily: highTower),
                                    textAlign: TextAlign.center,
                                  ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _isEditable
                                    ? <Widget>[
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<PlayerClass>(
                                            hint: Text(
                                              'Class',
                                              style: TextStyle(
                                                  fontSize: titleFontSize),
                                            ),
                                            onChanged: _onClassSelected,
                                            value: _selectedClass,
                                            items: classListMenuItems,
                                          ),
                                        )
                                      ]
                                    : <Widget>[
                                        Stack(
                                          alignment: Alignment(0.0, 0.0),
                                          children: <Widget>[
                                            Image.asset('images/xp.png',
                                                width: iconWidth * 1.75),
                                            Text(
                                              '$_charLevel',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: titleFontSize),
                                            )
                                          ],
                                        ),
                                        Flexible(
                                            child: AutoSizeText(
                                                '${_selectedClass.race} ${_selectedClass.className}',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: titleFontSize))),
                                      ]),
                          ],
                        )),
                      ],
                    ),
                  ),
                  _isEditable
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: smallPadding, right: smallPadding),
                                  child: TextField(
                                    style: TextStyle(fontSize: titleFontSize),
                                    textAlign: TextAlign.center,
                                    controller: _xpTextFieldController,
                                    decoration: InputDecoration(
                                        labelText: 'XP',
                                        labelStyle: TextStyle(
                                            fontSize: dialogFontSize)),
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp('[\\.|\\,|\\ |\\-]'))
                                    ],
                                    keyboardType: TextInputType.number,
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: smallPadding),
                                  child: TextField(
                                style: TextStyle(fontSize: titleFontSize),
                                textAlign: TextAlign.center,
                                controller: _goldTextFieldController,
                                decoration: InputDecoration(
                                    labelText: 'Gold',
                                    labelStyle:
                                        TextStyle(fontSize: dialogFontSize)),
                                inputFormatters: [
                                  BlacklistingTextInputFormatter(
                                      RegExp('[\\.|\\,|\\ |\\-]')),
                                ],
                                keyboardType: TextInputType.number,
                              )),
                            ),
                            Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Checkbox(
                                      value: _firstCheck,
                                      onChanged: (bool value) => setState(() {
                                            _firstCheck = value;
                                            _secondCheck = false;
                                            _thirdCheck = false;
                                          }),
                                    ),
                                    Checkbox(
                                      value: _secondCheck,
                                      onChanged: (bool value) => setState(() {
                                            _firstCheck = true;
                                            _secondCheck = value;
                                            _thirdCheck = false;
                                          }),
                                    ),
                                    Checkbox(
                                      value: _thirdCheck,
                                      onChanged: (bool value) => setState(() {
                                            _firstCheck = true;
                                            _secondCheck = true;
                                            _thirdCheck = value;
                                          }),
                                    )
                                  ],
                                )),
                          ],
                        )
                      : Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(smallPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'images/xp.png',
                                        width: iconWidth,
                                      ),
                                      Text(
                                        ' ' + _xpTextFieldController.text,
                                        style:
                                            TextStyle(fontSize: titleFontSize),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            ' / $_nextLevelXp',
                                            style: TextStyle(
                                                fontSize: titleFontSize / 2),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(smallPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'images/loot.png',
                                        width: iconWidth,
                                      ),
                                      Text(
                                        ' ' + _goldTextFieldController.text,
                                        style:
                                            TextStyle(fontSize: titleFontSize),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(smallPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'images/goal.png',
                                        width: iconWidth,
                                      ),
                                      Text(
                                        ' ${_thirdCheck ? '3' : _secondCheck ? '2' : _firstCheck ? '1' : '0'} / 3',
                                        style:
                                            TextStyle(fontSize: titleFontSize),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(smallPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'images/equipment_slots/pocket.png',
                                        width: iconWidth,
                                      ),
                                      Text(
                                        ' ${(_charLevel / 2).round()}',
                                        style:
                                            TextStyle(fontSize: titleFontSize),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                  Padding(padding: EdgeInsets.only(bottom: smallPadding)),
                  Text(
                    'Notes',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: smallPadding)),
                  Card(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(smallPadding),
                      child: _isEditable
                          ? TextField(
                              style: TextStyle(fontFamily: highTower),
                              maxLines: 8,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  hintText: 'Notes',
                                  hintStyle: TextStyle(fontFamily: highTower)),
                              controller: _notesTextFieldController,
                            )
                          : Text(
                              _notesTextFieldController.text,
                              style: TextStyle(fontFamily: highTower),
                            ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: smallPadding)),
                  !_isEditable
                      ? Text(
                          'Perks',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: titleFontSize),
                        )
                      : Container(),
//                  Padding(padding: EdgeInsets.only(bottom: smallPadding)),
                ]),
              ),
              _isEditable
                  ? SliverAppBar(backgroundColor: Colors.transparent)
                  : PerkSection(_selectedClass.perks),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              onPressed: _toggleEditMode,
              child: _isEditable ? Icon(Icons.check) : Icon(Icons.mode_edit)),
        ),
      );
}

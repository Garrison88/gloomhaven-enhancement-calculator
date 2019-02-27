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
  int _radioValue = 0, _charLevel = 1, _nextLevelXp = 45, _xp = 0;
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

  void _saveChanges() {
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
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.925),
              image: DecorationImage(
                  image: AssetImage(_selectedClass != null
                      ? 'images/class_icons/${_selectedClass.icon}'
                      : ''),
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.925), BlendMode.lighten),
                  fit: BoxFit.fitWidth),
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                children: <Widget>[
                                  _isEditable
                                      ? TextField(
                                          controller:
                                              _charNameTextFieldController,
                                          style: TextStyle(
                                              fontSize: titleFontSize,
                                              fontFamily: secondaryFontFamily),
                                          textAlign: TextAlign.center,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                              hintText: 'Name',
                                              hintStyle: TextStyle(
                                                  fontSize: titleFontSize,
                                                  fontFamily:
                                                      secondaryFontFamily)),
                                        )
                                      : _xpTextFieldController.text != null
                                          ? Text(
                                              _charNameTextFieldController.text,
                                              style: TextStyle(
                                                  fontSize: titleFontSize,
                                                  fontFamily:
                                                      secondaryFontFamily),
                                              textAlign: TextAlign.center,
                                            )
                                          : Container(),
                                  _isEditable ? Container() : Divider(),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _isEditable
                                          ? <Widget>[
                                              DropdownButtonHideUnderline(
                                                child:
                                                    DropdownButton<PlayerClass>(
                                                  hint: Text(
                                                    'Class',
                                                    style: TextStyle(
                                                        fontSize:
                                                            titleFontSize),
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
                                                      width: iconWidth * 1.5),
                                                  Text(
                                                    '$_charLevel',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            titleFontSize),
                                                  )
                                                ],
                                              ),
                                              AutoSizeText(
                                                '${_selectedClass.race} ${_selectedClass.className}',
                                                style: TextStyle(
                                                    fontSize: titleFontSize),
                                              )
                                            ]),
                                ],
                              )),
                            ],
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.all(smallPadding),
                              child: _isEditable
                                  ? TextField(
                                      style: TextStyle(fontSize: titleFontSize),
                                      textAlign: TextAlign.center,
                                      controller: _xpTextFieldController,
                                      decoration: InputDecoration(
                                          labelText: 'XP',
                                          labelStyle: TextStyle(
                                              fontSize: dialogFontSize)),
                                      inputFormatters: [
                                        BlacklistingTextInputFormatter(
                                            RegExp('[\\.|\\,|\\ |\\-]')),
                                      ],
                                      keyboardType:
                                          TextInputType.number,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'images/xp.png',
                                          width: iconWidth,
                                        ),
                                        Text(
                                          ' ' + _xpTextFieldController.text,
                                          style: TextStyle(
                                              fontSize: titleFontSize),
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
                                    )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(smallPadding),
                            child: _isEditable
                                ? TextField(
                                    style: TextStyle(fontSize: titleFontSize),
                                    textAlign: TextAlign.center,
                                    controller: _goldTextFieldController,
                                    decoration: InputDecoration(
                                        labelText: 'Gold',
                                        labelStyle: TextStyle(
                                            fontSize: dialogFontSize)),
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp('[\\.|\\,|\\ |\\-]')),
                                    ],
                                    keyboardType:
                                        TextInputType.number,
                                  )
                                : Row(
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
                        ),
                        Expanded(
                          flex: _isEditable ? 2 : 1,
                          child: Container(
                            padding: EdgeInsets.all(smallPadding),
                            child: _isEditable
                                ? Row(
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
                                  )
                                : Row(
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
                        ),
                      ],
                    ),
                    Card(
                      color: Colors.white.withOpacity(0.50),
                      child: Container(
                        padding: EdgeInsets.all(smallPadding),
                        child: _isEditable
                            ? TextField(
                                style:
                                    TextStyle(fontFamily: secondaryFontFamily),
                                maxLines: 5,
                                decoration: InputDecoration(
                                    hintText: 'Notes',
                                    hintStyle: TextStyle(
                                        fontFamily: secondaryFontFamily)),
                                controller: _notesTextFieldController,
                              )
                            : Text(
                                _notesTextFieldController.text,
                                style:
                                    TextStyle(fontFamily: secondaryFontFamily),
                              ),
                      ),
                    ),
                  ]),
                ),
                _isEditable
                    ? SliverAppBar(backgroundColor: Colors.transparent)
                    : PerkSection(_selectedClass.perks),
              ],
            )),
        floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            onPressed: _saveChanges,
            child: _isEditable ? Icon(Icons.check) : Icon(Icons.mode_edit)));
  }
}

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterSheetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CharacterSheetPageState();
  }
}

class CharacterSheetPageState extends State<CharacterSheetPage> {
  bool _nameIsEditable = false;
  PlayerClass _selectedClass;
  TextEditingController _xpNotesTextFieldController = TextEditingController();
  TextEditingController _goldNotesTextFieldController = TextEditingController();
  TextEditingController _charNameTextFieldController = TextEditingController();
  int _radioValue = 0, _charLevel = 7;

  @override
  void initState() {
    super.initState();
    _readFromSharedPrefs();
  }

  Future _readFromSharedPrefs() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _charNameTextFieldController.text =
          _prefs.getString('characterName') != null
              ? _prefs.getString('characterName')
              : '';
      _selectedClass =
          _prefs.getInt('selectedClass') != null && classList != null
              ? classList[_prefs.getInt('selectedClass')]
              : null;
    });
  }

  Future _writeToSharedPrefs() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs.setString('characterName', _charNameTextFieldController.text);
      _prefs.setInt('SelectedClass', classList.indexOf(_selectedClass));
    });
  }

  void _handleClassSelection(PlayerClass _value) {
    setState(() {
      _selectedClass = _value;
      print(_value.className);
    });
    _writeToSharedPrefs();
  }

  void _handleEditNameButtonClicked() {
    setState(() {
      _nameIsEditable = !_nameIsEditable;
    });
    _writeToSharedPrefs();
  }

//  void _handleRadioValueChange(int value) {
//    setState(() {
//      _radioValue = value;
//
//      switch (_radioValue) {
//        case 0:
//          _radioValue = 1;
//          break;
//        case 1:
//          _radioValue = 2;
//          break;
//        case 2:
//          _radioValue = 3;
//          break;
//      }
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
//      body: LayoutBuilder(
//          builder: (BuildContext context, BoxConstraints viewportConstraints) {
//        return SingleChildScrollView(
//          child: ConstrainedBox(
//            constraints:
//                BoxConstraints(minHeight: viewportConstraints.maxHeight),
//            child: IntrinsicHeight(
      body: Container(
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.amber,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: DropdownButton<PlayerClass>(
                            hint: Text('Class'),
                            onChanged: _handleClassSelection,
                            value: _selectedClass,
                            items: classListMenuItems,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Opacity(
                              opacity: 0.5,
                              child: IconButton(
                                icon: Icon(_nameIsEditable
                                    ? Icons.check
                                    : Icons.mode_edit),
                                onPressed: _handleEditNameButtonClicked,
                              ),
                            ),
                            Expanded(
                              child: _nameIsEditable
                                  ? TextField(
                                      controller: _charNameTextFieldController,
                                      style: TextStyle(fontSize: titleFontSize),
                                      textAlign: TextAlign.center,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                          hintText: 'Name',
                                          hintStyle: TextStyle(
                                              fontSize: titleFontSize)),
                                    )
                                  : Text(
                                      _charNameTextFieldController.text,
                                      style: TextStyle(fontSize: titleFontSize),
                                      textAlign: TextAlign.center,
                                    ),
                            )
                          ],
                        )
                      ],
                    )),
                    Stack(
                      alignment: Alignment(0.0, 0.0),
                      children: <Widget>[
                        Image.asset('images/xp.png', width: 70.0),
                        Text(
                          '$_charLevel',
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
//                  Expanded(
//                    child: TextField(
//                      maxLines: 3,
//                      decoration: InputDecoration(labelText: 'XP Notes'),
//                      controller: _xpNotesTextFieldController,
//                    ),
//                  ),
                  Expanded(
//                    child: TextField(
//                      maxLines: 3,
//                      decoration: InputDecoration(labelText: 'Gold Notes'),
//                      controller: _goldNotesTextFieldController,
//                    ),
//                  ),
                      child: TextField(
                    decoration: InputDecoration(labelText: 'Gold'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                  ))
                ],
              )
            ],
          )
//            ),
//          ),
//        );
//      }),
          ),
    );
  }
}

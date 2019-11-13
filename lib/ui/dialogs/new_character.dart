import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class NewCharacterDialog extends StatefulWidget {
  const NewCharacterDialog({this.onValueChange, this.initialValue});

  final PlayerClass initialValue;
  final void Function(String) onValueChange;

  @override
  _NewCharacterDialogState createState() => _NewCharacterDialogState();
}

class _NewCharacterDialogState extends State<NewCharacterDialog> {
  final TextEditingController _nameTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.initialValue;
  }

  void dispose() {
    _nameTextFieldController.dispose();
    super.dispose();
  }

  _createNewCharacter(String name, PlayerClass playerClass) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    Character character = Character();
    character.name = name;
    character.classCode = playerClass.classCode;
    character.xp = 0;
    character.gold = 0;
    character.notes = 'Add notes here';
    character.checkMarks = 0;
    int id = await helper.insert(character);
    print('inserted row: $id');
    print(character.name);
    print(character.classCode);
  }

  PlayerClass _selectedClass;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text("New Character"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameTextFieldController,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<PlayerClass>(
                  value: _selectedClass,
                  hint: Text(
                    'Class',
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  onChanged: (PlayerClass value) {
                    setState(() {
                      _selectedClass = value;
                    });
                  },
                  items: classListMenuItems,
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              _createNewCharacter(
                  _nameTextFieldController.text, _selectedClass);
              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style:
                  TextStyle(fontSize: secondaryFontSize, fontFamily: highTower),
            ),
          ),
        ],
      );
}

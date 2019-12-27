import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_list_state.dart';

class NewCharacterDialog extends StatefulWidget {
  final PlayerClass initialValue;
  final CharacterListState characterListState;
  final void Function(String) onValueChange;

  NewCharacterDialog(
      {Key key, this.onValueChange, this.initialValue, this.characterListState})
      : super(key: key);

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

  PlayerClass _selectedClass;

  @override
  Widget build(BuildContext context) {
    // final CharacterListState characterListState =
    //     Provider.of<CharacterListState>(context);
    return AlertDialog(
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
                onChanged: (PlayerClass value) => setState(() {
                  _selectedClass = value;
                }),
                items: classListMenuItems,
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            widget.characterListState
                .addCharacter(_nameTextFieldController.text, _selectedClass);
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
}

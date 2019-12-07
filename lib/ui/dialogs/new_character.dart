import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class NewCharacterDialog extends StatefulWidget {
  final PlayerClass initialValue;
  final charactersState;
  final void Function(String) onValueChange;

  NewCharacterDialog(
      {Key key, this.onValueChange, this.initialValue, this.charactersState})
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
    // final CharactersState charactersState = Provider.of<CharactersState>(context);
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
            widget.charactersState
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

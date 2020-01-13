import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/providers/app_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_list_state.dart';
import 'package:provider/provider.dart';

class NewCharacterDialog extends StatefulWidget {
  // final PlayerClass initialValue;
  final CharacterListState characterListState;
  // final void Function(String) onValueChange;

  NewCharacterDialog({Key key, this.characterListState}) : super(key: key);

  @override
  _NewCharacterDialogState createState() => _NewCharacterDialogState();
}

class _NewCharacterDialogState extends State<NewCharacterDialog> {
  final TextEditingController _nameTextFieldController =
      TextEditingController();

  void dispose() {
    _nameTextFieldController.dispose();
    super.dispose();
  }

  PlayerClass _selectedClass = classList[0];

  final _newCharacterFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Character"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _newCharacterFormKey,
              child: TextFormField(
                validator: (value) =>
                    value.isNotEmpty ? null : 'Please enter a name',
                controller: _nameTextFieldController,
                // decoration: InputDecoration(
                //   enabledBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(
                //         color: Color(int.parse(_selectedClass.classColor)),
                //         width: 1.0,
                //         style: BorderStyle.solid),
                //   ),
                // ),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<PlayerClass>(
                value: _selectedClass,
                hint: Text(
                  'Class',
                  style: TextStyle(fontSize: titleFontSize),
                ),
                onChanged: (PlayerClass value) =>
                    setState(() => _selectedClass = value),
                items: classListMenuItems,
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            if (_newCharacterFormKey.currentState.validate()) {
              widget.characterListState
                  .addCharacter(_nameTextFieldController.text, _selectedClass)
                  .whenComplete(() => Navigator.of(context).pop());
            }
          },
          child: Text(
            'Save',
            style:
                TextStyle(fontSize: secondaryFontSize, fontFamily: highTower),
          ),
        ),
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style:
                TextStyle(fontSize: secondaryFontSize, fontFamily: highTower),
          ),
        ),
      ],
    );
  }
}

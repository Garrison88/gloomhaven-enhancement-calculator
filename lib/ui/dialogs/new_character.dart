import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_list_state.dart';

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
  int _initialXp = 1;
  int _previousRetirements = 0;

  final _newCharacterFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _newCharacterFormKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'Name'),
                style:
                    TextStyle(fontFamily: highTower, fontSize: titleFontSize),
                validator: (value) =>
                    value.isNotEmpty ? null : 'Please enter a name',
                controller: _nameTextFieldController,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PlayerClass>(
                      value: _selectedClass,
                      hint: Text(
                        'Class',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      onChanged: (PlayerClass _value) =>
                          setState(() => _selectedClass = _value),
                      items: classListMenuItems,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _initialXp,
                      onChanged: (int value) =>
                          setState(() => _initialXp = value),
                      items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9].map((int _value) {
                        return DropdownMenuItem<int>(
                            value: _value,
                            child: Center(
                              child: Text('Level:  ${_value.toString()}',
                                  style: TextStyle(fontSize: titleFontSize)),
                            ));
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Previous\nRetirements:',
                  // style: TextStyle(fontSize: titleFontSize),
                ),
                Padding(
                  padding: EdgeInsets.only(right: smallPadding),
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: titleFontSize),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(
                          RegExp('[\\.|\\,|\\ |\\-]'))
                    ],
                    // decoration: InputDecoration(hintText: 'Previous Retirements'),
                    keyboardType: TextInputType.number,
                    onChanged: (String value) => setState(() {
                      _previousRetirements = int.parse(value);
                    }),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style:
                TextStyle(fontSize: secondaryFontSize, fontFamily: highTower),
          ),
        ),
        RaisedButton(
          color: Colors.green,
          onPressed: () {
            if (_newCharacterFormKey.currentState.validate()) {
              widget.characterListState
                  .addCharacter(_nameTextFieldController.text, _selectedClass,
                      _initialXp, _previousRetirements)
                  .whenComplete(() => Navigator.of(context).pop());
            }
          },
          child: Text(
            'Create',
            style: TextStyle(
                fontSize: secondaryFontSize,
                fontFamily: highTower,
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}

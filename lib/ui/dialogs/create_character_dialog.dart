import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/custom_search_delegate.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

class CreateCharacterDialog extends StatefulWidget {
  final CharactersModel charactersModel;
  final bool envelopeX;

  CreateCharacterDialog({
    this.charactersModel,
    this.envelopeX,
  });

  @override
  _CreateCharacterDialogState createState() => _CreateCharacterDialogState();
}

class _CreateCharacterDialogState extends State<CreateCharacterDialog> {
  final TextEditingController _nameTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedClass = CharacterData.playerClasses[0];
  }

  void dispose() {
    _nameTextFieldController.dispose();
    super.dispose();
  }

  PlayerClass _selectedClass;
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
                validator: (value) =>
                    value.isNotEmpty ? null : 'Please enter a name',
                controller: _nameTextFieldController,
              ),
            ),
            SizedBox(
              height: smallPadding,
            ),
            Card(
              child: TextButton.icon(
                label: Text(_selectedClass.className),
                onPressed: () async => await showSearch<PlayerClass>(
                  context: context,
                  delegate: CustomSearchDelegate(
                    CharacterData.playerClasses,
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _selectedClass = value;
                    });
                  }
                }),
                icon: Container(
                  width: iconSize + 5,
                  height: iconSize + 5,
                  child: Image.asset(
                    'images/class_icons/${_selectedClass.classIconUrl}',
                    color: Color(int.parse(_selectedClass.classColor)),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: DropdownButton<int>(
                      value: _initialXp,
                      onChanged: (int value) =>
                          setState(() => _initialXp = value),
                      items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9].map((int _value) {
                        return DropdownMenuItem<int>(
                          value: _value,
                          child: Center(
                            child: Text(
                              'Level:  ${_value.toString()}',
                            ),
                          ),
                        );
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
                ),
                SizedBox(
                  width: smallPadding,
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                          RegExp('[\\.|\\,|\\ |\\-]'))
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (String value) => setState(() =>
                        _previousRetirements = value == null || value == ''
                            ? 0
                            : int.parse(value)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: secondaryFontSize,
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () async {
            if (_newCharacterFormKey.currentState.validate()) {
              await widget.charactersModel.createCharacter(
                _nameTextFieldController.text,
                _selectedClass,
                _initialXp,
                _previousRetirements,
              );
              Navigator.pop(context, true);
            }
          },
          child: Text(
            'Create',
            style: TextStyle(
              fontSize: secondaryFontSize,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

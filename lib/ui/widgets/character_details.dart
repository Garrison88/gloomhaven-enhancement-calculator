import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/show_info.dart';
import 'package:provider/provider.dart';

class CharacterDetails extends StatefulWidget {
  @override
  _CharacterDetailsState createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  final TextEditingController _previousRetirementsTextFieldController =
      TextEditingController();
  final TextEditingController _xpTextFieldController = TextEditingController();
  final TextEditingController _goldTextFieldController =
      TextEditingController();
  final TextEditingController _charNameTextFieldController =
      TextEditingController();
  final TextEditingController _notesTextFieldController =
      TextEditingController();
  // int _charLevel = 1;

  @override
  void dispose() {
    _previousRetirementsTextFieldController.dispose();
    _xpTextFieldController.dispose();
    _goldTextFieldController.dispose();
    _charNameTextFieldController.dispose();
    _notesTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CharacterState characterState = Provider.of<CharacterState>(context);
    Character _character = characterState.character;
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            image: DecorationImage(
                image: AssetImage('images/class_icons/${_character.classIcon}'),
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.95), BlendMode.lighten),
                fit: BoxFit.fitWidth),
          ),
          padding: EdgeInsets.only(top: smallPadding),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: smallPadding)),
                              Container(
                                child: Text(
                                  'Retirements: ${_previousRetirementsTextFieldController.text}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: titleFontSize / 2),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onPressed: () {
                                    showInfoAlert(
                                        context,
                                        Strings.previousRetirementsInfoTitle,
                                        Strings.previousRetirementsInfoBody,
                                        null);
                                  }),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              characterState.isEditable
                                  ? IconButton(
                                      color: Colors.red,
                                      tooltip: 'Delete',
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        characterState
                                            .deleteCharacter(_character.id);
                                      })
                                  : Container(),
                              IconButton(
                                icon: Icon(characterState.isEditable
                                    ? Icons.save
                                    : Icons.edit),
                                tooltip:
                                    characterState.isEditable ? 'Save' : 'Edit',
                                onPressed: characterState.isEditable
                                    ? () async => await characterState
                                            .updateCharacter(
                                                _saveEdits(_character))
                                            .then((_) {
                                          _clearTextFields();
                                          characterState.isEditable = false;
                                        })
                                    : () {
                                        characterState.isEditable = true;
                                        _xpTextFieldController.text =
                                            _character.xp == 0
                                                ? ''
                                                : _character.xp.toString();
                                        _goldTextFieldController.text =
                                            _character.gold.toString();
                                        _notesTextFieldController.text =
                                            _character.notes;
                                        _charNameTextFieldController.text =
                                            _character.name;
                                      },
                              ),
                              characterState.isEditable
                                  ? IconButton(
                                      tooltip: 'Cancel',
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        _clearTextFields();
                                        characterState.isEditable = false;
                                      })
                                  : Container(),
                            ],
                          )
                        ]),
                    Container(
                      padding: EdgeInsets.only(
                          left: smallPadding, right: smallPadding),
                      child: characterState.isEditable
                          ? TextField(
                              minLines: 1,
                              maxLines: 2,
                              controller: _charNameTextFieldController,
                              style: TextStyle(
                                  fontSize: titleFontSize * 1.5,
                                  fontFamily: highTower),
                              textAlign: TextAlign.center,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: titleFontSize * 1.5,
                                      fontFamily: highTower)),
                            )
                          : AutoSizeText(
                              _character.name,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: titleFontSize * 1.5,
                                  fontFamily: highTower),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            alignment: Alignment(0.0, 0.0),
                            children: <Widget>[
                              Image.asset('images/xp.png',
                                  width: iconWidth * 1.75),
                              Text(
                                '${characterState.level}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleFontSize),
                              )
                            ],
                          ),
                          Flexible(
                              child: AutoSizeText('${_character.classCode}',
                                  maxLines: 1,
                                  style: TextStyle(fontSize: titleFontSize))),
                        ]),
                  ],
                )),
              ],
            ),
            Center(
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
                          characterState.isEditable
                              ? Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: TextField(
                                    // maxLength: 3,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(fontSize: titleFontSize),
                                    textAlign: TextAlign.center,
                                    controller: _xpTextFieldController,
                                    decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        // labelText: '${_character.xp}'
                                        // hintText: '${_character.xp}'),
                                        ),
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp('[\\.|\\,|\\ |\\-]'))
                                    ],
                                    keyboardType: TextInputType.number,
                                  ),
                                )
                              : Text(
                                  ' ${_character.xp}',
                                  style: TextStyle(fontSize: titleFontSize),
                                ),
                          Text(
                            ' / ${characterState.nextLevelXp}',
                            style: TextStyle(fontSize: titleFontSize / 2),
                          ),
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
                          characterState.isEditable
                              ? Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: TextField(
                                    style: TextStyle(fontSize: titleFontSize),
                                    textAlign: TextAlign.center,
                                    controller: _goldTextFieldController,
                                    decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        // hintText: '${_character.gold}'
                                        ),
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp('[\\.|\\,|\\ |\\-]'))
                                    ],
                                    keyboardType: TextInputType.number,
                                  ),
                                )
                              : Text(
                                  ' ${_character.gold}',
                                  style: TextStyle(fontSize: titleFontSize),
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
                            '1 / 3',
                            style: TextStyle(fontSize: titleFontSize),
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
                            ' ${(characterState.level / 2).round()}',
                            style: TextStyle(fontSize: titleFontSize),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            characterState.isEditable
                ? Padding(padding: EdgeInsets.only(bottom: smallPadding))
                : Container(),
            characterState.isEditable
                ? AutoSizeText(
                    'Battle Goal Checkmarks',
                    textAlign: TextAlign.center,
                    maxFontSize: titleFontSize,
                  )
                : Container(),
            characterState.isEditable
                ? Padding(padding: EdgeInsets.only(bottom: smallPadding))
                : Container(),
            // CheckMarksSection(),
            // characterState.isEditable
            //     ? Row(
            //         children: <Widget>[
            //           Expanded(
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               children: <Widget>[
            //                 Card(
            //                   child: Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceEvenly,
            //                     children: <Widget>[
            //                       Checkbox(
            //                         value: _firstCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _firstCheck = value;
            //                           _secondCheck = false;
            //                           _thirdCheck = false;
            //                         }),
            //                       ),
            //                       Checkbox(
            //                         value: _secondCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _firstCheck = true;
            //                           _secondCheck = value;
            //                           _thirdCheck = false;
            //                         }),
            //                       ),
            //                       Checkbox(
            //                         value: _thirdCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _firstCheck = true;
            //                           _secondCheck = true;
            //                           _thirdCheck = value;
            //                         }),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //                 Card(
            //                   child: Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceEvenly,
            //                     children: <Widget>[
            //                       Checkbox(
            //                         value: _2FirstCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _2FirstCheck = value;
            //                           _2SecondCheck = false;
            //                           _2ThirdCheck = false;
            //                         }),
            //                       ),
            //                       Checkbox(
            //                         value: _2SecondCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _2FirstCheck = true;
            //                           _2SecondCheck = value;
            //                           _2ThirdCheck = false;
            //                         }),
            //                       ),
            //                       Checkbox(
            //                         value: _2ThirdCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _2FirstCheck = true;
            //                           _2SecondCheck = true;
            //                           _2ThirdCheck = value;
            //                         }),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //                 Card(
            //                   child: Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceEvenly,
            //                     children: <Widget>[
            //                       Checkbox(
            //                         value: _3FirstCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _3FirstCheck = value;
            //                           _3SecondCheck = false;
            //                           _3ThirdCheck = false;
            //                         }),
            //                       ),
            //                       Checkbox(
            //                         value: _3SecondCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _3FirstCheck = true;
            //                           _3SecondCheck = value;
            //                           _3ThirdCheck = false;
            //                         }),
            //                       ),
            //                       Checkbox(
            //                         value: _3ThirdCheck,
            //                         onChanged: (bool value) =>
            //                             setState(() {
            //                           _3FirstCheck = true;
            //                           _3SecondCheck = true;
            //                           _3ThirdCheck = value;
            //                         }),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Expanded(
            //               child: Column(
            //             children: <Widget>[
            //               Card(
            //                 child: Row(
            //                   mainAxisAlignment:
            //                       MainAxisAlignment.spaceEvenly,
            //                   children: <Widget>[
            //                     Checkbox(
            //                       value: _4FirstCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _4FirstCheck = value;
            //                         _4SecondCheck = false;
            //                         _4ThirdCheck = false;
            //                       }),
            //                     ),
            //                     Checkbox(
            //                       value: _4SecondCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _4FirstCheck = true;
            //                         _4SecondCheck = value;
            //                         _4ThirdCheck = false;
            //                       }),
            //                     ),
            //                     Checkbox(
            //                       value: _4ThirdCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _4FirstCheck = true;
            //                         _4SecondCheck = true;
            //                         _4ThirdCheck = value;
            //                       }),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //               Card(
            //                 child: Row(
            //                   mainAxisAlignment:
            //                       MainAxisAlignment.spaceEvenly,
            //                   children: <Widget>[
            //                     Checkbox(
            //                       value: _5FirstCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _5FirstCheck = value;
            //                         _5SecondCheck = false;
            //                         _5ThirdCheck = false;
            //                       }),
            //                     ),
            //                     Checkbox(
            //                       value: _5SecondCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _5FirstCheck = true;
            //                         _5SecondCheck = value;
            //                         _5ThirdCheck = false;
            //                       }),
            //                     ),
            //                     Checkbox(
            //                       value: _5ThirdCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _5FirstCheck = true;
            //                         _5SecondCheck = true;
            //                         _5ThirdCheck = value;
            //                       }),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //               Card(
            //                 child: Row(
            //                   mainAxisAlignment:
            //                       MainAxisAlignment.spaceEvenly,
            //                   children: <Widget>[
            //                     Checkbox(
            //                       value: _6FirstCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _6FirstCheck = value;
            //                         _6SecondCheck = false;
            //                         _6ThirdCheck = false;
            //                       }),
            //                     ),
            //                     Checkbox(
            //                       value: _6SecondCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _6FirstCheck = true;
            //                         _6SecondCheck = value;
            //                         _6ThirdCheck = false;
            //                       }),
            //                     ),
            //                     Checkbox(
            //                       value: _6ThirdCheck,
            //                       onChanged: (bool value) => setState(() {
            //                         _6FirstCheck = true;
            //                         _6SecondCheck = true;
            //                         _6ThirdCheck = value;
            //                       }),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ))
            //         ],
            //       )
            //     : Container(),
            Padding(padding: EdgeInsets.only(bottom: smallPadding)),
            Text(
              'Notes',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: titleFontSize),
            ),
            Padding(padding: EdgeInsets.only(bottom: smallPadding)),
            // Card(
            //   color: Colors.white24,
            //   child:
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(smallPadding),
              child: characterState.isEditable
                  ? TextField(
                      style: TextStyle(fontFamily: highTower),
                      minLines: 2,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          // hintText: 'Notes',
                          hintStyle: TextStyle(fontFamily: highTower)),
                      controller: _notesTextFieldController,
                    )
                  : Text(
                      _character.notes,
                      style: TextStyle(fontFamily: highTower),
                    ),
            ),
            // ),
            Padding(padding: EdgeInsets.only(bottom: smallPadding)),
            Text(
              'Perks',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: titleFontSize),
            ),
          ]),
        )
      ]),
    );
  }

  _clearTextFields() {
    _xpTextFieldController.clear();
    _goldTextFieldController.clear();
    _charNameTextFieldController.clear();
    _notesTextFieldController.clear();
  }

  Character _saveEdits(Character _character) {
    Character _updatedCharacter = _character;
    _updatedCharacter.name = _charNameTextFieldController.text.isNotEmpty
        ? _charNameTextFieldController.text
        : _character.name;
    _updatedCharacter.xp = _xpTextFieldController.text.isNotEmpty
        ? int.parse(_xpTextFieldController.text)
        : _character.xp;
    _updatedCharacter.gold = _goldTextFieldController.text.isNotEmpty
        ? int.parse(_goldTextFieldController.text)
        : _character.gold;
    _updatedCharacter.notes = _notesTextFieldController.text.isNotEmpty
        ? _notesTextFieldController.text
        : '';
    return _updatedCharacter;
  }
}

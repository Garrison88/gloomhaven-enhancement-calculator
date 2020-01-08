import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/show_info.dart';
import 'package:gloomhaven_enhancement_calc/view_model/app_model.dart';
import 'package:gloomhaven_enhancement_calc/view_model/characterList_model.dart';
import 'package:gloomhaven_enhancement_calc/view_model/character_model.dart';
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

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<AppModel>(context, listen: false).setAccentColor(
  //         Provider.of<CharacterModel>(context, listen: false)
  //             .character
  //             .classColor);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print("CHARACTER DETAILS PAGE REBUILT");
    final CharacterModel characterState = Provider.of<CharacterModel>(context);
    // final CharacterListState characterListState =
    //     Provider.of<CharacterListState>(context);
    final AppModel appState = Provider.of<AppModel>(context);
        //  Provider.of<AppState>(context, listen: false).setAccentColor(
        //   Provider.of<CharacterState>(context, listen: false)
        //       .character
        //       .classColor);

    // return Consumer<CharacterModel>(
    //     builder: (BuildContext context, CharacterModel characterState, _) {
      Character _character = characterState.character;
      return Container(
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
                              width: MediaQuery.of(context).size.width / 4,
                              child: characterState.isEditable
                                  ? TextField(
                                      style: TextStyle(
                                          fontSize: titleFontSize / 2),
                                      textAlign: TextAlign.center,
                                      controller:
                                          _previousRetirementsTextFieldController,
                                      inputFormatters: [
                                        BlacklistingTextInputFormatter(
                                            RegExp('[\\.|\\,|\\ |\\-]'))
                                      ],
                                      keyboardType: TextInputType.number,
                                    )
                                  : Text(
                                      'Retirements: ${appState.retirements}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: titleFontSize / 2),
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
                                      Provider.of<CharacterListModel>(context,
                                              listen: false)
                                          .deleteCharacter(_character.id);
                                      // Provider.of<CharacterListState>(context,
                                      //         listen: false)
                                      //     .deleteCharacter(_character.id)
                                      //     .then((_) {
                                      // Provider.of<CharacterListState>(context,
                                      //         listen: false)
                                      //     .characterList;
                                      // });
                                      // await characterListState.setCharacterList();
                                      // characterListState.setCharacterList();
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
                                          .then((_) async {
                                        sp.setInt(
                                            'retirements',
                                            int.parse(
                                                _previousRetirementsTextFieldController
                                                    .text));
                                        appState.retirements = int.parse(
                                            _previousRetirementsTextFieldController
                                                .text);
                                        await _clearTextFields();
                                        characterState.isEditable = false;
                                      })
                                  : () {
                                      characterState.isEditable = true;
                                      _previousRetirementsTextFieldController
                                              .text =
                                          appState.retirements.toString();
                                      _xpTextFieldController.text =
                                          _character.xp == 0
                                              ? ''
                                              : _character.xp.toString();
                                      _goldTextFieldController.text =
                                          _character.gold == 0
                                              ? ''
                                              : _character.gold.toString();
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
                              '${characterState.currentLevel}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: titleFontSize),
                            )
                          ],
                        ),
                        Flexible(
                            child: AutoSizeText(
                                '${_character.classRace} ${_character.className}',
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
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(fontSize: titleFontSize),
                                  textAlign: TextAlign.center,
                                  controller: _xpTextFieldController,
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
                          ' ${(characterState.currentLevel / 2).round()}',
                          style: TextStyle(fontSize: titleFontSize),
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
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(smallPadding),
            child: characterState.isEditable
                ? TextField(
                    style: TextStyle(fontFamily: highTower),
                    minLines: 1,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        hintText: 'Notes',
                        hintStyle: TextStyle(fontFamily: highTower)),
                    controller: _notesTextFieldController,
                  )
                : Text(
                    _character.notes,
                    style: TextStyle(fontFamily: highTower),
                  ),
          ),
        ]),
      );
    // });
  }

  _clearTextFields() {
    _previousRetirementsTextFieldController.clear();
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

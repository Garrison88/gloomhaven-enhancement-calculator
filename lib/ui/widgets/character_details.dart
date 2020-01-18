import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/providers/app_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_list_state.dart';
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
    print("CHARACTER DETAILS PAGE REBUILT");
    // final AppState appState = Provider.of<AppState>(context, listen: false);
    return Consumer<CharacterState>(
      builder: (BuildContext context, CharacterState characterState, _) {
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
                                        onChanged: (String value) =>
                                            Provider.of<AppState>(context,
                                                    listen: false)
                                                .retirements = int.parse(value),
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
                                        'Retirements: ${Provider.of<AppState>(context, listen: false).retirements}',
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
                                      icon: Icon(FontAwesomeIcons.trash),
                                      onPressed: () => showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.delete),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            left: smallPadding,
                                                            right:
                                                                smallPadding)),
                                                    Text('Are you sure?'),
                                                  ],
                                                ),
                                                content: Text(
                                                    'There\s no going back!'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              secondaryFontSize,
                                                          fontFamily:
                                                              highTower),
                                                    ),
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.red,
                                                    onPressed: () => Provider
                                                            .of<CharacterListState>(
                                                                context,
                                                                listen: false)
                                                        .deleteCharacter(
                                                            _character.id)
                                                        .whenComplete(() =>
                                                            Navigator.pop(
                                                                context)),
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              secondaryFontSize,
                                                          fontFamily:
                                                              highTower),
                                                    ),
                                                  ),
                                                ],
                                              )))
                                  : Container(),
                              IconButton(
                                  icon: Icon(characterState.isEditable
                                      ? FontAwesomeIcons.lockOpen
                                      : FontAwesomeIcons.lock),
                                  tooltip: characterState.isEditable
                                      ? 'Lock'
                                      : 'Unlock',
                                  onPressed: characterState.isEditable
                                      ? () => characterState.isEditable = false
                                      : () {
                                          if (Provider.of<AppState>(context,
                                                      listen: false)
                                                  .retirements !=
                                              0)
                                            _previousRetirementsTextFieldController
                                                .text = Provider.of<AppState>(
                                                    context,
                                                    listen: false)
                                                .retirements
                                                .toString();
                                          _charNameTextFieldController.text =
                                              _character.name;
                                          if (_character.xp != 0)
                                            _xpTextFieldController.text =
                                                _character.xp.toString();
                                          if (_character.gold != 0)
                                            _goldTextFieldController.text =
                                                _character.gold.toString();
                                          _notesTextFieldController.text =
                                              _character.notes;

                                          characterState.isEditable = true;
                                        }),
                              // characterState.isEditable
                              //     ? IconButton(
                              //         tooltip: 'Cancel',
                              //         icon: Icon(FontAwesomeIcons.lockOpen),
                              //         onPressed: () =>
                              //             characterState.isEditable = false)
                              //     : Container(),
                            ],
                          )
                        ]),
                    Container(
                      padding: EdgeInsets.only(
                          left: smallPadding, right: smallPadding),
                      child: characterState.isEditable
                          ? TextField(
                              onChanged: (String value) => characterState
                                  .updateCharacter(_character..name = value),
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
                                    color: Colors.white,
                                    fontSize: titleFontSize),
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
                                    onChanged: (String value) => characterState
                                        .updateCharacter(_character
                                          ..xp = value == ''
                                              ? 0
                                              : int.parse(value)),
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
                                    onChanged: (String value) => characterState
                                        .updateCharacter(_character
                                          ..gold = value == ''
                                              ? 0
                                              : int.parse(value)),
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
                            '${characterState.checkMarkProgress} / 3',
                            style: TextStyle(fontSize: titleFontSize),
                          )
                        ],
                      ),
                    ),
                    characterState.isEditable
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(smallPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'images/equipment_slots/pocket.png',
                                  width: iconWidth,
                                ),
                                Text(
                                  ' ${characterState.numOfPocketItems}',
                                  style: TextStyle(fontSize: titleFontSize),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
            // NOTES
            characterState.isEditable
                ? Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(bottom: smallPadding)),
                      Text(
                        'Notes',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(smallPadding),
                          child: TextField(
                            onChanged: (String value) => characterState
                                .updateCharacter(_character..notes = value),
                            style: TextStyle(fontFamily: highTower),
                            minLines: 1,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                                hintText: 'Notes',
                                hintStyle: TextStyle(fontFamily: highTower)),
                            controller: _notesTextFieldController,
                          )),
                    ],
                  )
                : characterState.character.notes != ''
                    ? Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: smallPadding)),
                          Text(
                            'Notes',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: titleFontSize),
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: smallPadding)),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(smallPadding),
                            child: Text(
                              _character.notes,
                              style: TextStyle(fontFamily: highTower),
                            ),
                          ),
                        ],
                      )
                    : Container(),
            // BATTLE GOAL CHECKMARKS
            characterState.isEditable
                ? Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(smallPadding),
                        child: AutoSizeText(
                          'Battle Goal Checkmarks',
                          textAlign: TextAlign.center,
                          minFontSize: titleFontSize,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            color: Theme.of(context).accentColor,
                            iconSize:
                                Theme.of(context).textTheme.body1.fontSize,
                            icon: Icon(FontAwesomeIcons.minus),
                            onPressed: () => characterState.decreaseCheckmark(),
                          ),
                          Text(
                            '${characterState.character.checkMarks} / 18',
                            style: TextStyle(fontSize: titleFontSize),
                          ),
                          IconButton(
                            color: Theme.of(context).accentColor,
                            iconSize:
                                Theme.of(context).textTheme.body1.fontSize,
                            icon: Icon(FontAwesomeIcons.plus),
                            onPressed: () => characterState.increaseCheckmark(),
                          )
                        ],
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(
                      //       left: MediaQuery.of(context).size.width / 4,
                      //       right: MediaQuery.of(context).size.width / 4),
                      //   child: GridView.builder(
                      //     physics: NeverScrollableScrollPhysics(),

                      //     shrinkWrap: true,
                      //     itemCount: 18,
                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 3, childAspectRatio: 1),
                      //     itemBuilder: (context, index) {
                      //       // return CheckMarkRow(index);
                      //       // for(var x = 0; x < characterState.character.checkMarks; x++)
                      //       return Checkbox(
                      //         value: false,
                      //         onChanged: (_) => null,
                      //       );
                      //     },
                      //   ),
                      // )
                    ],
                  )
                : Container()
          ]),
        );
      },
    );
    // });
  }

  // _clearTextFields() {
  //   _previousRetirementsTextFieldController.clear();
  //   _xpTextFieldController.clear();
  //   _goldTextFieldController.clear();
  //   _charNameTextFieldController.clear();
  //   _notesTextFieldController.clear();
  // }

  // Character _saveEdits(Character _character) {
  //   Character _updatedCharacter = _character;
  //   _updatedCharacter.name = _charNameTextFieldController.text.isNotEmpty
  //       ? _charNameTextFieldController.text
  //       : _character.name;
  //   _updatedCharacter.xp = _xpTextFieldController.text.isNotEmpty
  //       ? int.parse(_xpTextFieldController.text)
  //       : _character.xp;
  //   _updatedCharacter.gold = _goldTextFieldController.text.isNotEmpty
  //       ? int.parse(_goldTextFieldController.text)
  //       : _character.gold;
  //   _updatedCharacter.notes = _notesTextFieldController.text.isNotEmpty
  //       ? _notesTextFieldController.text
  //       : '';
  //   return _updatedCharacter;
  // }
}

// _showConfirmDeleteDialog(BuildContext _context) {
//   Provider.of<CharacterListState>(_context,
//                                         listen: false)
//                                     .deleteCharacter(_character.id))
// }

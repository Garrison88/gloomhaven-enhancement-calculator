import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/addSubtract_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/addSubtract_button.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characterList_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/show_info.dart';
import 'package:provider/provider.dart';

class CharacterDetails extends StatefulWidget {
  @override
  _CharacterDetailsState createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  final TextEditingController _previousRetirementsTextEditingController =
      TextEditingController();
  final TextEditingController _xpTextEditingController =
      TextEditingController();
  final TextEditingController _goldTextEditingController =
      TextEditingController();
  final TextEditingController _charNameTextEditingController =
      TextEditingController();
  final TextEditingController _notesTextEditingController =
      TextEditingController();

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
  void dispose() {
    _previousRetirementsTextEditingController.dispose();
    _xpTextEditingController.dispose();
    _goldTextEditingController.dispose();
    _charNameTextEditingController.dispose();
    _notesTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<CharacterModel>(
      builder: (BuildContext context, CharacterModel _characterModel, _) =>
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: smallPadding * 3),
              ),
              // RETIREMENTS AND LOCK
              buildRetirementsAndLockSection(_characterModel),
              // NAME AND CLASS
              buildNameAndClassSection(_characterModel),
              // STATS
              buildStatsSection(_characterModel),
              // NOTES
              buildNotesSection(_characterModel),
              // BATTLE GOAL CHECKMARKS
              buildBattleGoalCheckmarksSection(_characterModel),
            ],
          ));

  Widget buildRetirementsAndLockSection(CharacterModel _characterModel) {
    Character _character = _characterModel.character;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: smallPadding)),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: _characterModel.isEditable
                    ? TextField(
                        onChanged: (String value) =>
                            _characterModel.updateCharacter(_character
                              ..previousRetirements =
                                  value == '' ? 0 : int.parse(value)),
                        style: TextStyle(fontSize: titleFontSize / 2),
                        textAlign: TextAlign.center,
                        controller: _previousRetirementsTextEditingController,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(
                              RegExp('[\\.|\\,|\\ |\\-]'))
                        ],
                        keyboardType: TextInputType.number,
                      )
                    : Text(
                        'Retirements: ${_character.previousRetirements}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: titleFontSize / 2),
                      ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () => showInfoDialog(
                      context,
                      Strings.previousRetirementsInfoTitle,
                      Strings.previousRetirementsInfoBody,
                      null)),
            ],
          ),
          Row(
            children: <Widget>[
              _characterModel.isEditable
                  ? IconButton(
                      color: Colors.red,
                      tooltip: 'Delete',
                      icon: Icon(FontAwesomeIcons.trash),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: Text(
                                  'Are you sure? There\'s no going back!',
                                  style: TextStyle(fontSize: titleFontSize),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: secondaryFontSize,
                                          fontFamily: highTower),
                                    ),
                                  ),
                                  RaisedButton(
                                    color: Colors.red,
                                    onPressed: () =>
                                        Provider.of<CharacterListModel>(context,
                                                listen: false)
                                            .deleteCharacter(_character.id)
                                            .whenComplete(
                                                () => Navigator.pop(context)),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: secondaryFontSize,
                                          fontFamily: highTower),
                                    ),
                                  ),
                                ],
                              )))
                  : Container(),
              // TODO: add retire character functionality
              // _characterModel.isEditable
              //     ? IconButton(
              //         color: Colors.blue,
              //         tooltip: 'Retire',
              //         icon: Icon(FontAwesomeIcons.bed),
              //         onPressed: () {
              //           _characterModel.updateCharacter(
              //               _character
              //                 ..isRetired = _character.isRetired
              //                     ? false
              //                     : true);
              //           _characterModel.isEditable = false;
              //         })
              //     : Container(),
              IconButton(
                  icon: Icon(_characterModel.isEditable
                      ? FontAwesomeIcons.lockOpen
                      : FontAwesomeIcons.lock),
                  tooltip: _characterModel.isEditable ? 'Lock' : 'Unlock',
                  onPressed: _characterModel.isEditable
                      ? () => _characterModel.isEditable = false
                      : () {
                          _previousRetirementsTextEditingController.text =
                              _character.previousRetirements != 0
                                  ? _character.previousRetirements.toString()
                                  : '';
                          _charNameTextEditingController.text = _character.name;
                          _xpTextEditingController.text = _character.xp != 0
                              ? _character.xp.toString()
                              : '';
                          _goldTextEditingController.text = _character.gold != 0
                              ? _character.gold.toString()
                              : '';
                          _notesTextEditingController.text = _character.notes;
                          _characterModel.isEditable = true;
                        }),
            ],
          )
        ]);
  }

  Widget buildNameAndClassSection(CharacterModel _characterModel) {
    Character _character = _characterModel.character;
    return Column(
      children: <Widget>[
        _characterModel.isEditable
            ? TextField(
                onChanged: (String value) =>
                    _characterModel.updateCharacter(_character..name = value),
                minLines: 1,
                maxLines: 2,
                controller: _charNameTextEditingController,
                style: TextStyle(
                    fontSize: titleFontSize * 1.5, fontFamily: highTower),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontSize: titleFontSize * 1.5, fontFamily: highTower)),
              )
            : AutoSizeText(
                _character.name,
                maxLines: 2,
                style: TextStyle(
                    fontSize: titleFontSize * 1.5, fontFamily: highTower),
                textAlign: TextAlign.center,
              ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Stack(
            alignment: Alignment(0.0, 0.0),
            children: <Widget>[
              Image.asset('images/xp.png', width: iconWidth * 1.75),
              Text(
                '${_characterModel.currentLevel}',
                style: TextStyle(color: Colors.white, fontSize: titleFontSize),
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
    );
  }

  Widget buildStatsSection(CharacterModel _characterModel) {
    Character _character = _characterModel.character;
    return Center(
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
                  _characterModel.isEditable
                      ? Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              child: TextField(
                                onChanged: (String value) =>
                                    _characterModel.updateCharacter(_character
                                      ..xp =
                                          value == '' ? 0 : int.parse(value)),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: titleFontSize),
                                textAlign: TextAlign.center,
                                controller: _xpTextEditingController,
                                inputFormatters: [
                                  BlacklistingTextInputFormatter(
                                      RegExp('[\\.|\\,|\\ |\\-]'))
                                ],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: smallPadding),
                            ),
                            AddSubtractButton(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AddSubtractDialog(_character.xp, 'XP',
                                            (value) {
                                          _xpTextEditingController.text =
                                              value.toString();
                                          _characterModel.updateCharacter(
                                              _character..xp = value);
                                        }))),
                          ],
                        )
                      : Text(
                          ' ${_character.xp}',
                          style: TextStyle(fontSize: titleFontSize),
                        ),
                  Text(
                    ' / ${_characterModel.nextLevelXp}',
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
                  _characterModel.isEditable
                      ? Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              child: TextField(
                                onChanged: (String value) =>
                                    _characterModel.updateCharacter(_character
                                      ..gold =
                                          value == '' ? 0 : int.parse(value)),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: titleFontSize),
                                textAlign: TextAlign.center,
                                controller: _goldTextEditingController,
                                inputFormatters: [
                                  BlacklistingTextInputFormatter(
                                      RegExp('[\\.|\\,|\\ |\\-]'))
                                ],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: smallPadding),
                            ),
                            AddSubtractButton(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AddSubtractDialog(
                                            _character.gold, 'Gold', (value) {
                                          _goldTextEditingController.text =
                                              value.toString();
                                          _characterModel.updateCharacter(
                                              _character..gold = value);
                                        }))),
                          ],
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
                    '${_characterModel.checkMarkProgress} / 3',
                    style: TextStyle(fontSize: titleFontSize),
                  )
                ],
              ),
            ),
            _characterModel.isEditable
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
                          ' ${_characterModel.numOfPocketItems}',
                          style: TextStyle(fontSize: titleFontSize),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget buildNotesSection(CharacterModel _characterModel) {
    Character _character = _characterModel.character;
    return _characterModel.isEditable
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
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (String value) => _characterModel
                        .updateCharacter(_character..notes = value),
                    style: TextStyle(fontFamily: highTower),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        hintText: 'Notes',
                        hintStyle: TextStyle(fontFamily: highTower)),
                    controller: _notesTextEditingController,
                  )),
            ],
          )
        : _character.notes != ''
            ? Column(
                children: <Widget>[
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
                    child: Text(
                      _character.notes,
                      style: TextStyle(fontFamily: highTower),
                    ),
                  ),
                ],
              )
            : Container();
  }

  Widget buildBattleGoalCheckmarksSection(CharacterModel _characterModel) {
    Character _character = _characterModel.character;
    return _characterModel.isEditable
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
                  Visibility(
                    visible: _character.checkMarks > 0,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      iconSize: Theme.of(context).textTheme.body1.fontSize,
                      icon: Icon(FontAwesomeIcons.minus),
                      onPressed: () => _characterModel.decreaseCheckmark(),
                    ),
                  ),
                  Text(
                    '${_characterModel.character.checkMarks} / 18',
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  Visibility(
                    visible: _character.checkMarks < 18,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      iconSize: Theme.of(context).textTheme.body1.fontSize,
                      icon: Icon(FontAwesomeIcons.plus),
                      onPressed: () => _characterModel.increaseCheckmark(),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Container();
  }
}

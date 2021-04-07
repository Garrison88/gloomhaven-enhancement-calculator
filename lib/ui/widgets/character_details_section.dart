import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/addSubtract_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/addSubtract_button.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/show_info.dart';
import 'package:provider/provider.dart';

class CharacterDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: smallPadding * 3),
        ),
        // RETIREMENTS AND LOCK
        RetirementsAndLockSection(),
        // NAME AND CLASS
        NameAndClassSection(),
        // STATS
        StatsSection(),
        // NOTES
        NotesSection(),
        // BATTLE GOAL CHECKMARKS
        BattleGoalCheckmarksSection(),
      ],
    );
  }
}

class RetirementsAndLockSection extends StatefulWidget {
  @override
  _RetirementsAndLockSectionState createState() =>
      _RetirementsAndLockSectionState();
}

class _RetirementsAndLockSectionState extends State<RetirementsAndLockSection> {
  @override
  void dispose() {
    _previousRetirementsTextEditingController.dispose();
    super.dispose();
  }

  final TextEditingController _previousRetirementsTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: smallPadding)),
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: characterModel.isEditable
                  ? TextField(
                      onChanged: (String value) => characterModel
                          .updateCharacter(characterModel.character
                            ..previousRetirements =
                                value == '' ? 0 : int.parse(value)),
                      style: TextStyle(fontSize: titleFontSize / 2),
                      textAlign: TextAlign.center,
                      controller: _previousRetirementsTextEditingController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp('[\\.|\\,|\\ |\\-]'))
                      ],
                      keyboardType: TextInputType.number,
                    )
                  : Text(
                      'Retirements: ${characterModel.character.previousRetirements}',
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
            characterModel.isEditable
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
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: secondaryFontSize,
                                        fontFamily: highTower),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                  ),
                                  onPressed: () => Provider.of<CharactersModel>(
                                          context,
                                          listen: false)
                                      .deleteCharacter(
                                          characterModel.character.id)
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
            // characterModel.isEditable
            //     ? IconButton(
            //         color: Colors.blue,
            //         tooltip: 'Retire',
            //         icon: Icon(FontAwesomeIcons.bed),
            //         onPressed: () {
            //           characterModel.updateCharacter(
            //               characterModel.character
            //                 ..isRetired = characterModel.character.isRetired
            //                     ? false
            //                     : true);
            //           characterModel.isEditable = false;
            //         })
            //     : Container(),
            IconButton(
                icon: Icon(characterModel.isEditable
                    ? FontAwesomeIcons.lockOpen
                    : FontAwesomeIcons.lock),
                tooltip: characterModel.isEditable ? 'Lock' : 'Unlock',
                onPressed: characterModel.isEditable
                    ? () {
                        characterModel.isEditable = !characterModel.isEditable;
                      }
                    : () {
                        characterModel.isEditable = !characterModel.isEditable;
                        _previousRetirementsTextEditingController.text =
                            characterModel.character.previousRetirements != 0
                                ? characterModel.character.previousRetirements
                                    .toString()
                                : '';
                        characterModel.nameController.text =
                            characterModel.character.name;
                        characterModel.xpController.text =
                            characterModel.character.xp != 0
                                ? characterModel.character.xp.toString()
                                : '';
                        characterModel.goldController.text =
                            characterModel.character.gold != 0
                                ? characterModel.character.gold.toString()
                                : '';
                        characterModel.notesController.text =
                            characterModel.character.notes;
                      }),
          ],
        )
      ],
    );
  }
}

class NameAndClassSection extends StatefulWidget {
  @override
  _NameAndClassSectionState createState() => _NameAndClassSectionState();
}

class _NameAndClassSectionState extends State<NameAndClassSection> {
  @override
  void dispose() {
    Provider.of<CharacterModel>(context, listen: false)
        .nameController
        .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Column(
      children: <Widget>[
        characterModel.isEditable
            ? TextField(
                onChanged: (String value) => characterModel
                    .updateCharacter(characterModel.character..name = value),
                minLines: 1,
                maxLines: 2,
                controller: characterModel.nameController,
                style: TextStyle(
                    fontSize: titleFontSize * 1.5, fontFamily: highTower),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontSize: titleFontSize * 1.5, fontFamily: highTower)),
              )
            : AutoSizeText(
                characterModel.character.name,
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
                '${characterModel.currentLevel}',
                style: TextStyle(color: Colors.white, fontSize: titleFontSize),
              )
            ],
          ),
          Flexible(
              child: AutoSizeText(
                  '${characterModel.character.classRace} ${characterModel.character.className}',
                  maxLines: 1,
                  style: TextStyle(fontSize: titleFontSize))),
        ]),
      ],
    );
  }
}

class StatsSection extends StatefulWidget {
  @override
  _StatsSectionState createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> {
  @override
  void dispose() {
    Provider.of<CharacterModel>(context, listen: false).xpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
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
                  characterModel.isEditable
                      ? Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              child: TextField(
                                onChanged: (String value) => characterModel
                                    .updateCharacter(characterModel.character
                                      ..xp =
                                          value == '' ? 0 : int.parse(value)),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: titleFontSize),
                                textAlign: TextAlign.center,
                                controller: characterModel.xpController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
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
                                            characterModel.character.xp, 'XP',
                                            (value) {
                                          characterModel.xpController.text =
                                              value.toString();
                                          characterModel.updateCharacter(
                                              characterModel.character
                                                ..xp = value);
                                        }))),
                          ],
                        )
                      : Text(
                          ' ${characterModel.character.xp}',
                          style: TextStyle(fontSize: titleFontSize),
                        ),
                  Text(
                    ' / ${characterModel.nextLevelXp}',
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
                  characterModel.isEditable
                      ? Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              child: TextField(
                                onChanged: (String value) => characterModel
                                    .updateCharacter(characterModel.character
                                      ..gold =
                                          value == '' ? 0 : int.parse(value)),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: titleFontSize),
                                textAlign: TextAlign.center,
                                controller: characterModel.goldController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
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
                                            characterModel.character.gold,
                                            'Gold', (value) {
                                          characterModel.goldController.text =
                                              value.toString();
                                          characterModel.updateCharacter(
                                              characterModel.character
                                                ..gold = value);
                                        }))),
                          ],
                        )
                      : Text(
                          ' ${characterModel.character.gold}',
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
                    '${characterModel.checkMarkProgress} / 3',
                    style: TextStyle(fontSize: titleFontSize),
                  )
                ],
              ),
            ),
            characterModel.isEditable
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
                          ' ${characterModel.numOfPocketItems}',
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
}

class NotesSection extends StatefulWidget {
  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  @override
  void dispose() {
    Provider.of<CharacterModel>(context, listen: false)
        .notesController
        .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return characterModel.isEditable
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
                    onChanged: (String value) => characterModel.updateCharacter(
                        characterModel.character..notes = value),
                    style: TextStyle(fontFamily: highTower),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        hintText: 'Notes',
                        hintStyle: TextStyle(fontFamily: highTower)),
                    controller: characterModel.notesController,
                  )),
            ],
          )
        : characterModel.character.notes != ''
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
                      characterModel.character.notes,
                      style: TextStyle(fontFamily: highTower),
                    ),
                  ),
                ],
              )
            : Container();
  }
}

class BattleGoalCheckmarksSection extends StatefulWidget {
  @override
  _BattleGoalCheckmarksSectionState createState() =>
      _BattleGoalCheckmarksSectionState();
}

class _BattleGoalCheckmarksSectionState
    extends State<BattleGoalCheckmarksSection> {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return characterModel.isEditable
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
                    visible: characterModel.character.checkMarks > 0,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      iconSize: Theme.of(context).textTheme.bodyText2.fontSize,
                      icon: Icon(FontAwesomeIcons.minus),
                      onPressed: () => characterModel.decreaseCheckmark(),
                    ),
                  ),
                  Text(
                    '${characterModel.character.checkMarks} / 18',
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  Visibility(
                    visible: characterModel.character.checkMarks < 18,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      iconSize: Theme.of(context).textTheme.bodyText2.fontSize,
                      icon: Icon(FontAwesomeIcons.plus),
                      onPressed: () => characterModel.increaseCheckmark(),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Container();
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/add_subtract_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/characters_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/addSubtract_button.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_section.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/show_info.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    CharactersModel charactersModel = context.watch<CharactersModel>();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: smallPadding * 3),
        ),
        // RETIREMENTS AND LOCK
        RetirementsAndLockSection(
          characterModel: characterModel,
          deleteCharacter: charactersModel.deleteCharacter,
        ),
        // NAME AND CLASS
        NameAndClassSection(
          characterModel: characterModel,
        ),
        // STATS
        StatsSection(
          characterModel: characterModel,
        ),
        // NOTES
        NotesSection(
          characterModel: characterModel,
        ),
        // BATTLE GOAL CHECKMARKS
        BattleGoalCheckmarksSection(
          characterModel: characterModel,
        ),
        PerkSection(
          characterModel: characterModel,
        ),
      ],
    );
  }
}

class RetirementsAndLockSection extends StatefulWidget {
  final CharacterModel characterModel;
  final DeleteCharacter deleteCharacter;

  const RetirementsAndLockSection({
    this.characterModel,
    this.deleteCharacter,
  });
  @override
  _RetirementsAndLockSectionState createState() =>
      _RetirementsAndLockSectionState();
}

class _RetirementsAndLockSectionState extends State<RetirementsAndLockSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: smallPadding),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: widget.characterModel.isEditable
                  ? TextField(
                      onChanged: (String value) => widget.characterModel
                          .updateCharacter(widget.characterModel.character
                            ..previousRetirements =
                                value == '' ? 0 : int.parse(value)),
                      style: TextStyle(fontSize: titleFontSize / 2),
                      textAlign: TextAlign.center,
                      controller:
                          widget.characterModel.previousRetirementsController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp('[\\.|\\,|\\ |\\-]'))
                      ],
                      keyboardType: TextInputType.number,
                    )
                  : Text(
                      'Retirements: ${widget.characterModel.character.previousRetirements}',
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
                null,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            widget.characterModel.isEditable
                ? IconButton(
                    color: Colors.red,
                    tooltip: 'Delete',
                    icon: Icon(FontAwesomeIcons.trash),
                    onPressed: () async => await showDialog<bool>(
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
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: secondaryFontSize,
                                    ),
                                  ),
                                )
                              ],
                            )).then((result) async {
                      CharactersModel charactersModel =
                          Provider.of<CharactersModel>(context, listen: false);
                      if (result) {
                        int _position = charactersModel.characters.indexWhere(
                            (element) =>
                                element.id ==
                                widget.characterModel.character.id);
                        if (_position > charactersModel.characters.length - 2) {
                          _position = _position - 1;
                        }
                        if (_position.isNegative) {
                          _position = 0;
                        }
                        await widget.deleteCharacter(
                            widget.characterModel.character.id);
                        updateCurrentCharacter(context, _position);
                      }
                    }),
                  )
                : Container(),
            // TODO: add retire character functionality
            // widget.characterModel.isEditable
            //     ? IconButton(
            //         color: Colors.blue,
            //         tooltip: 'Retire',
            //         icon: Icon(FontAwesomeIcons.bed),
            //         onPressed: () {
            //           widget.characterModel.updateCharacter(
            //               widget.characterModel.character
            //                 ..isRetired = widget.characterModel.character.isRetired
            //                     ? false
            //                     : true);
            //           widget.characterModel.isEditable = false;
            //         })
            //     : Container(),
            IconButton(
                icon: Icon(widget.characterModel.isEditable
                    ? FontAwesomeIcons.lockOpen
                    : FontAwesomeIcons.lock),
                tooltip: widget.characterModel.isEditable ? 'Lock' : 'Unlock',
                onPressed: widget.characterModel.isEditable
                    ? () {
                        widget.characterModel.isEditable =
                            !widget.characterModel.isEditable;
                      }
                    : () {
                        widget.characterModel.isEditable =
                            !widget.characterModel.isEditable;
                        widget.characterModel.previousRetirementsController
                            .text = widget.characterModel.character
                                    .previousRetirements !=
                                0
                            ? widget
                                .characterModel.character.previousRetirements
                                .toString()
                            : '';
                        widget.characterModel.nameController.text =
                            widget.characterModel.character.name;
                        widget.characterModel.xpController.text =
                            widget.characterModel.character.xp != 0
                                ? widget.characterModel.character.xp.toString()
                                : '';
                        widget.characterModel.goldController.text =
                            widget.characterModel.character.gold != 0
                                ? widget.characterModel.character.gold
                                    .toString()
                                : '';
                        widget.characterModel.notesController.text =
                            widget.characterModel.character.notes;
                      }),
          ],
        )
      ],
    );
  }
}

class NameAndClassSection extends StatefulWidget {
  final CharacterModel characterModel;

  const NameAndClassSection({
    this.characterModel,
  });

  @override
  _NameAndClassSectionState createState() => _NameAndClassSectionState();
}

class _NameAndClassSectionState extends State<NameAndClassSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.characterModel.isEditable
            ? TextField(
                onChanged: (String value) => widget.characterModel
                    .updateCharacter(
                        widget.characterModel.character..name = value),
                minLines: 1,
                maxLines: 2,
                controller: widget.characterModel.nameController,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                  fontSize: titleFontSize * 1.5,
                )),
              )
            : AutoSizeText(
                widget.characterModel.character.name,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment(0.0, 0.0),
              children: <Widget>[
                Image.asset(
                  'images/xp.png',
                  width: iconWidth * 1.75,
                ),
                Text(
                  '${widget.characterModel.currentLevel}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontFamily: pirataOne,
                  ),
                )
              ],
            ),
            Flexible(
              child: AutoSizeText(
                '${widget.characterModel.character.classRace} ${widget.characterModel.character.className}',
                maxLines: 1,
                style: TextStyle(fontSize: titleFontSize),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StatsSection extends StatefulWidget {
  final CharacterModel characterModel;

  const StatsSection({
    this.characterModel,
  });
  @override
  _StatsSectionState createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> {
  @override
  Widget build(BuildContext context) {
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
                  widget.characterModel.isEditable
                      ? Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              child: TextField(
                                onChanged: (String value) =>
                                    widget.characterModel.updateCharacter(widget
                                        .characterModel.character
                                      ..xp =
                                          value == '' ? 0 : int.parse(value)),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                ),
                                textAlign: TextAlign.center,
                                controller: widget.characterModel.xpController,
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
                                            widget.characterModel.character.xp,
                                            'XP', (value) {
                                          widget.characterModel.xpController
                                              .text = value.toString();
                                          widget.characterModel.updateCharacter(
                                              widget.characterModel.character
                                                ..xp = value);
                                        }))),
                          ],
                        )
                      : Text(
                          ' ${widget.characterModel.character.xp}',
                          style: TextStyle(fontSize: titleFontSize),
                        ),
                  Text(
                    ' / ${widget.characterModel.nextLevelXp}',
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
                  widget.characterModel.isEditable
                      ? Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              child: TextField(
                                onChanged: (String value) =>
                                    widget.characterModel.updateCharacter(widget
                                        .characterModel.character
                                      ..gold =
                                          value == '' ? 0 : int.parse(value)),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: titleFontSize),
                                textAlign: TextAlign.center,
                                controller:
                                    widget.characterModel.goldController,
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
                                            widget
                                                .characterModel.character.gold,
                                            'Gold', (value) {
                                          widget.characterModel.goldController
                                              .text = value.toString();
                                          widget.characterModel.updateCharacter(
                                              widget.characterModel.character
                                                ..gold = value);
                                        }))),
                          ],
                        )
                      : Text(
                          ' ${widget.characterModel.character.gold}',
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
                    '${widget.characterModel.checkMarkProgress} / 3',
                    style: TextStyle(fontSize: titleFontSize),
                  )
                ],
              ),
            ),
            widget.characterModel.isEditable
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
                          ' ${widget.characterModel.numOfPocketItems}',
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
  final CharacterModel characterModel;

  const NotesSection({
    this.characterModel,
  });
  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  @override
  Widget build(BuildContext context) {
    return widget.characterModel.isEditable
        ? Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: smallPadding,
                ),
              ),
              Text(
                'Notes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontFamily: pirataOne,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(smallPadding),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (String value) => widget.characterModel
                        .updateCharacter(
                            widget.characterModel.character..notes = value),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Notes',
                    ),
                    controller: widget.characterModel.notesController,
                  )),
            ],
          )
        : widget.characterModel.character.notes != ''
            ? Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: smallPadding),
                  ),
                  Text(
                    'Notes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontFamily: pirataOne,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: smallPadding),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(smallPadding),
                    child: Text(
                      widget.characterModel.character.notes,
                    ),
                  ),
                ],
              )
            : Container();
  }
}

class BattleGoalCheckmarksSection extends StatefulWidget {
  final CharacterModel characterModel;

  const BattleGoalCheckmarksSection({
    this.characterModel,
  });
  @override
  _BattleGoalCheckmarksSectionState createState() =>
      _BattleGoalCheckmarksSectionState();
}

class _BattleGoalCheckmarksSectionState
    extends State<BattleGoalCheckmarksSection> {
  @override
  Widget build(BuildContext context) {
    return widget.characterModel.isEditable
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
                    visible: widget.characterModel.character.checkMarks > 0,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      iconSize: Theme.of(context).textTheme.bodyText2.fontSize,
                      icon: Icon(FontAwesomeIcons.minus),
                      onPressed: () =>
                          widget.characterModel.decreaseCheckmark(),
                    ),
                  ),
                  Text(
                    '${widget.characterModel.character.checkMarks} / 18',
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  Visibility(
                    visible: widget.characterModel.character.checkMarks < 18,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      iconSize: Theme.of(context).textTheme.bodyText2.fontSize,
                      icon: Icon(FontAwesomeIcons.plus),
                      onPressed: () =>
                          widget.characterModel.increaseCheckmark(),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Container();
  }
}

typedef DeleteCharacter = Future<void> Function(int id);

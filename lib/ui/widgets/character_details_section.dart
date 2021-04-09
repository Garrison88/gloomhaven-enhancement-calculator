import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/addSubtract_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/characters_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/addSubtract_button.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_section.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/show_info.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharacterDetailsSection extends StatefulWidget {
  // final CharacterModel characterModel;
  // final DeleteCharacter deleteCharacter;

  // const CharacterDetailsSection({
  //   Key key,
  //   this.characterModel,
  //   this.deleteCharacter,
  // }) : super(key: key);
  @override
  _CharacterDetailsSectionState createState() =>
      _CharacterDetailsSectionState();
}

class _CharacterDetailsSectionState extends State<CharacterDetailsSection> {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    CharactersModel charactersModel = context.watch<CharactersModel>();
    // print('BUILD IN CHARACTER DETAILS SECTION');
    // CharactersModel charactersModel = context.watch<CharactersModel>();
    print(
        'CHARACTER MODEL HASHCODE IN DETAILS SECTION::: ${characterModel.hashCode}');

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: smallPadding * 3),
        ),
        // RETIREMENTS AND LOCK
        RetirementsAndLockSection(
          characterModel: characterModel,
          // charactersModel: charactersModel,
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
  // final CharactersModel charactersModel;
  final CharacterModel characterModel;
  final DeleteCharacter deleteCharacter;

  const RetirementsAndLockSection({
    // this.charactersModel,
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
            Padding(padding: EdgeInsets.only(left: smallPadding)),
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
                    null)),
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
                                        fontFamily: highTower),
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
                                        fontFamily: highTower),
                                  ),
                                ),
                              ],
                            )).then(
                      (result) async {
                        if (result) {
                          int _position = Provider.of<CharactersModel>(context,
                                  listen: false)
                              .characters
                              .indexWhere((element) =>
                                  element.id ==
                                  widget.characterModel.character.id);
                          await widget.deleteCharacter(
                              widget.characterModel.character.id);
                          updateCurrentCharacter(context, _position);
                          setState(() {});
                        }
                      },
                    ),
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

  const NameAndClassSection({Key key, this.characterModel}) : super(key: key);

  @override
  _NameAndClassSectionState createState() => _NameAndClassSectionState();
}

class _NameAndClassSectionState extends State<NameAndClassSection> {
  // @override
  // void dispose() {
  //   Provider.of<CharacterModel>(context, listen: false)
  //       .nameController
  //       .dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // CharacterModel characterModel = context.watch<CharacterModel>();
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
                style: TextStyle(
                    fontSize: titleFontSize * 1.5, fontFamily: highTower),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontSize: titleFontSize * 1.5, fontFamily: highTower)),
              )
            : AutoSizeText(
                widget.characterModel.character.name,
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
                '${widget.characterModel.currentLevel}',
                style: TextStyle(color: Colors.white, fontSize: titleFontSize),
              )
            ],
          ),
          Flexible(
              child: AutoSizeText(
                  '${widget.characterModel.character.classRace} ${widget.characterModel.character.className}',
                  maxLines: 1,
                  style: TextStyle(fontSize: titleFontSize))),
        ]),
      ],
    );
  }
}

class StatsSection extends StatefulWidget {
  final CharacterModel characterModel;

  const StatsSection({Key key, this.characterModel}) : super(key: key);
  @override
  _StatsSectionState createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> {
  // @override
  // void dispose() {
  //   Provider.of<CharacterModel>(context, listen: false).xpController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // CharacterModel characterModel = context.watch<CharacterModel>();
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
                                style: TextStyle(fontSize: titleFontSize),
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

  const NotesSection({Key key, this.characterModel}) : super(key: key);
  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  // @override
  // void dispose() {
  //   Provider.of<CharacterModel>(context, listen: false)
  //       .notesController
  //       .dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // CharacterModel characterModel = context.watch<CharacterModel>();
    return widget.characterModel.isEditable
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
                    onChanged: (String value) => widget.characterModel
                        .updateCharacter(
                            widget.characterModel.character..notes = value),
                    style: TextStyle(fontFamily: highTower),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        hintText: 'Notes',
                        hintStyle: TextStyle(fontFamily: highTower)),
                    controller: widget.characterModel.notesController,
                  )),
            ],
          )
        : widget.characterModel.character.notes != ''
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
                      widget.characterModel.character.notes,
                      style: TextStyle(fontFamily: highTower),
                    ),
                  ),
                ],
              )
            : Container();
  }
}

class BattleGoalCheckmarksSection extends StatefulWidget {
  final CharacterModel characterModel;

  const BattleGoalCheckmarksSection({Key key, this.characterModel})
      : super(key: key);
  @override
  _BattleGoalCheckmarksSectionState createState() =>
      _BattleGoalCheckmarksSectionState();
}

class _BattleGoalCheckmarksSectionState
    extends State<BattleGoalCheckmarksSection> {
  @override
  Widget build(BuildContext context) {
    // CharacterModel characterModel = context.watch<CharacterModel>();
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

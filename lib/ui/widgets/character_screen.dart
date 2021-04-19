import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/add_subtract_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/characters_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/add_subtract_button.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_section.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/show_info.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatelessWidget {
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
        // PERKS
        PerkSection(
          characterModel: Provider.of<CharacterModel>(context, listen: false),
        ),
      ],
    );
  }
}

class RetirementsAndLockSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
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
              child: characterModel.isEditable
                  ? TextField(
                      enableInteractiveSelection: false,
                      onChanged: (String value) => characterModel
                          .updateCharacter(characterModel.character
                            ..previousRetirements =
                                value.isEmpty ? 0 : int.parse(value)),
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.center,
                      controller: characterModel.previousRetirementsController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp('[\\.|\\,|\\ |\\-]'))
                      ],
                      keyboardType: TextInputType.number,
                    )
                  : Text(
                      'Retirements: ${characterModel.character.previousRetirements}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2,
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
                Strings.previousRetirementsInfoBody(context),
                null,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            characterModel.isEditable
                ? IconButton(
                    color: Colors.red,
                    tooltip: 'Delete',
                    iconSize: iconSize,
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await showDialog<bool>(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: Text(
                                'Are you sure? There\'s no going back!',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Cancel',
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
                                    ),
                                  ),
                                )
                              ],
                            );
                          }).then((result) async {
                        if (result) {
                          CharactersModel charactersModel =
                              Provider.of<CharactersModel>(context,
                                  listen: false);
                          int _position = charactersModel.characters.indexWhere(
                              (element) =>
                                  element.id == characterModel.character.id);
                          if (_position >
                              charactersModel.characters.length - 2) {
                            _position = _position - 1;
                          }
                          if (_position.isNegative) {
                            _position = 0;
                          }
                          await charactersModel
                              .deleteCharacter(characterModel.character.id);
                          updateCurrentCharacter(context, _position);
                        }
                      });
                    },
                  )
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
                icon: Icon(
                  characterModel.isEditable ? Icons.check : Icons.edit,
                  color:
                      SharedPrefs().darkTheme ? Colors.white : Colors.black87,
                ),
                iconSize: iconSize,
                tooltip: characterModel.isEditable ? 'Lock' : 'Unlock',
                onPressed: characterModel.isEditable
                    ? () {
                        characterModel.isEditable = false;
                      }
                    : () {
                        characterModel.isEditable = true;
                        characterModel.previousRetirementsController.text =
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

class NameAndClassSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Column(
      children: <Widget>[
        characterModel.isEditable
            ? TextField(
                onChanged: (String value) {
                  characterModel
                      .updateCharacter(characterModel.character..name = value);
                },
                minLines: 1,
                maxLines: 2,
                controller: characterModel.nameController,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
              )
            : AutoSizeText(
                characterModel.character.name,
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
                  width: iconSize * 1.75,
                  color:
                      SharedPrefs().darkTheme ? Colors.white : Colors.black87,
                ),
                Text(
                  '${characterModel.currentLevel}',
                  style: TextStyle(
                    color:
                        SharedPrefs().darkTheme ? Colors.black87 : Colors.white,
                    fontSize: titleFontSize,
                    fontFamily: pirataOne,
                  ),
                )
              ],
            ),
            Flexible(
              child: AutoSizeText(
                '${characterModel.character.classRace} ${characterModel.character.className}',
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

class StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Tooltip(
              message: 'XP',
              child: Container(
                padding: EdgeInsets.all(smallPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/xp.png',
                      width: iconSize + 5,
                      color: SharedPrefs().darkTheme
                          ? Colors.white
                          : Colors.black87,
                    ),
                    characterModel.isEditable
                        ? Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: TextField(
                                  enableInteractiveSelection: false,
                                  onChanged: (String value) {
                                    characterModel.updateCharacter(
                                      characterModel.character
                                        ..xp =
                                            value == '' ? 0 : int.parse(value),
                                    );
                                  },
                                  textAlignVertical: TextAlignVertical.center,
                                  style: Theme.of(context).textTheme.bodyText2,
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
                                onTap: () async {
                                  return await showDialog<int>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddSubtractDialog(
                                          characterModel.character.xp,
                                          'XP',
                                        );
                                      }).then((value) {
                                    if (value != null) {
                                      characterModel.xpController.text =
                                          value.toString();
                                      characterModel.updateCharacter(
                                        characterModel.character..xp = value,
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          )
                        : Text(
                            ' ${characterModel.character.xp}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                    Text(
                      ' / ${characterModel.nextLevelXp}',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize:
                              Theme.of(context).textTheme.bodyText2.fontSize /
                                  2),
                    ),
                  ],
                ),
              ),
            ),
            Tooltip(
              message: 'Gold',
              child: Container(
                padding: EdgeInsets.all(smallPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/loot.png',
                      width: iconSize,
                      color: SharedPrefs().darkTheme
                          ? Colors.white
                          : Colors.black87,
                    ),
                    characterModel.isEditable
                        ? Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: TextField(
                                  enableInteractiveSelection: false,
                                  onChanged: (String value) =>
                                      characterModel.updateCharacter(
                                    characterModel.character
                                      ..gold =
                                          value == '' ? 0 : int.parse(value),
                                  ),
                                  textAlignVertical: TextAlignVertical.center,
                                  style: Theme.of(context).textTheme.bodyText2,
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
                                onTap: () async {
                                  return await showDialog<int>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddSubtractDialog(
                                          characterModel.character.gold,
                                          'Gold',
                                        );
                                      }).then((value) {
                                    if (value != null) {
                                      characterModel.goldController.text =
                                          value.toString();
                                      characterModel.updateCharacter(
                                        characterModel.character..gold = value,
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          )
                        : Text(
                            ' ${characterModel.character.gold}',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                  ],
                ),
              ),
            ),
            Tooltip(
              message: 'Battle Goal Checkmarks',
              child: Container(
                padding: EdgeInsets.all(smallPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/goal.png',
                      width: iconSize,
                      color: SharedPrefs().darkTheme
                          ? Colors.white
                          : Colors.black87,
                    ),
                    Text(
                      '${characterModel.checkMarkProgress} / 3',
                      style: Theme.of(context).textTheme.bodyText2,
                    )
                  ],
                ),
              ),
            ),
            characterModel.isEditable
                ? Container()
                : Tooltip(
                    message: 'Number of Pocket Items Allowed',
                    child: Container(
                      padding: EdgeInsets.all(smallPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/equipment_slots/pocket.png',
                            width: iconSize,
                            color: SharedPrefs().darkTheme
                                ? Colors.white
                                : Colors.black87,
                          ),
                          Text(
                            ' ${characterModel.numOfPocketItems}',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class NotesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return characterModel.isEditable
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
                    onChanged: (String value) {
                      characterModel.updateCharacter(
                          characterModel.character..notes = value);
                    },
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Notes',
                    ),
                    controller: characterModel.notesController,
                  )),
            ],
          )
        : characterModel.character.notes != ''
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
                      characterModel.character.notes,
                    ),
                  ),
                ],
              )
            : Container();
  }
}

class BattleGoalCheckmarksSection extends StatelessWidget {
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
                      onPressed: characterModel.decreaseCheckmark,
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
                      onPressed: characterModel.increaseCheckmark,
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

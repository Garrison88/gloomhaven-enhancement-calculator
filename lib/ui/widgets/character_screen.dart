import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/add_subtract_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/add_subtract_button.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_section.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/show_info.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatefulWidget {
  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen>
    with TickerProviderStateMixin {
  AnimationController _hideFabAnimation;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            _hideFabAnimation.forward();
            break;
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..forward();
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = Provider.of<CharacterModel>(context);
    CharactersModel charactersModel =
        Provider.of<CharactersModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: smallPadding),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: charactersModel.characters.length > 1
                        ? smallPadding * 2
                        : smallPadding,
                  ),
                ),
                // RETIREMENTS and DELETE
                RetirementsAndPocketItemsSection(),
                // NAME and CLASS
                Padding(
                  padding: EdgeInsets.all(smallPadding),
                  child: NameAndClassSection(),
                ),
                // STATS
                Padding(
                  padding: EdgeInsets.all(smallPadding),
                  child: StatsSection(),
                ),
                // NOTES
                characterModel.character.notes.isEmpty &&
                        !characterModel.isEditable
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.all(smallPadding),
                        child: NotesSection(),
                      ),
                // BATTLE GOAL CHECKMARKS
                characterModel.isEditable
                    ? Padding(
                        padding: EdgeInsets.all(smallPadding),
                        child: BattleGoalCheckmarksSection(),
                      )
                    : Container(),
                // PERKS
                Padding(
                  padding: EdgeInsets.all(smallPadding),
                  child: PerkSection(characterModel: characterModel),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _hideFabAnimation,
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          child: Icon(
            characterModel.isEditable ? Icons.check_rounded : Icons.edit,
          ),
          onPressed: () {
            characterModel.isEditable = !characterModel.isEditable;
            charactersModel.isEditMode = !charactersModel.isEditMode;
          },
        ),
      ),
    );
  }
}

class RetirementsAndPocketItemsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: characterModel.isEditable
                  ? TextField(
                      enableInteractiveSelection: false,
                      onChanged: (String value) =>
                          characterModel.updateCharacter(
                        characterModel.character
                          ..previousRetirements =
                              value.isEmpty ? 0 : int.parse(value),
                      ),
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
        Tooltip(
          message: 'Number of Pocket Items Allowed',
          child: Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/equipment_slots/pocket.png',
                  width: iconSize,
                  color:
                      SharedPrefs().darkTheme ? Colors.white : Colors.black87,
                ),
                Text(
                  ' ${characterModel.numOfPocketItems}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  width: smallPadding,
                )
              ],
            ),
          ),
        )
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
        //   ],
        // )
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
            SizedBox(
              width: smallPadding,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Tooltip(
          message: 'XP',
          child: Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/xp.png',
                  width: iconSize + 5,
                  color:
                      SharedPrefs().darkTheme ? Colors.white : Colors.black87,
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
                                    ..xp = value == '' ? 0 : int.parse(value),
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
                          AddSubtractButton(
                            onTap: () async => await showDialog<int>(
                                context: context,
                                builder: (_) => AddSubtractDialog(
                                      characterModel.character.xp,
                                      'XP',
                                    )).then((value) {
                              if (value != null) {
                                characterModel.xpController.text =
                                    value.toString();
                                characterModel.updateCharacter(
                                  characterModel.character..xp = value,
                                );
                              }
                            }),
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
                          Theme.of(context).textTheme.bodyText2.fontSize / 2),
                ),
              ],
            ),
          ),
        ),
        Tooltip(
          message: 'Gold',
          child: Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/loot.png',
                  width: iconSize,
                  color:
                      SharedPrefs().darkTheme ? Colors.white : Colors.black87,
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
                                  ..gold = value == '' ? 0 : int.parse(value),
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
                          AddSubtractButton(
                            onTap: () async => await showDialog<int>(
                                context: context,
                                builder: (_) => AddSubtractDialog(
                                      characterModel.character.gold,
                                      'Gold',
                                    )).then((value) {
                              if (value != null) {
                                characterModel.goldController.text =
                                    value.toString();
                                characterModel.updateCharacter(
                                  characterModel.character..gold = value,
                                );
                              }
                            }),
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
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/goal.png',
                  width: iconSize,
                  color:
                      SharedPrefs().darkTheme ? Colors.white : Colors.black87,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  '${characterModel.checkMarkProgress} / 3',
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NotesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Column(
      children: <Widget>[
        Text(
          'Notes',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: smallPadding,
        ),
        characterModel.isEditable
            ? Container(
                width: MediaQuery.of(context).size.width,
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
                ))
            : Text(
                characterModel.character.notes,
              ),
      ],
    );
  }
}

class BattleGoalCheckmarksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Column(
      children: <Widget>[
        Container(
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
    );
  }
}

typedef DeleteCharacter = Future<void> Function(int id);

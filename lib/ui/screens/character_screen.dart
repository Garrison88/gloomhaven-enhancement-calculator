import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/constants.dart';
import '../../data/strings.dart';
import '../../shared_prefs.dart';
import '../dialogs/add_subtract_dialog.dart';
import '../widgets/perk_section.dart';
import '../../viewmodels/character_model.dart';
import '../dialogs/info_dialog.dart';
import '../../viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({
    Key key,
  }) : super(key: key);

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen>
    with TickerProviderStateMixin {
  AnimationController _hideFabAnimation;
  // final ValueNotifier<bool> _isDialOpen = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
// final ScaffoldMessenger scaffoldMessenger = ScaffoldMessenger();

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
    // print('****ON DISPOSE');
    // Provider.of<CharactersModel>(context, listen: false).isDialOpen.value =
    //     false;
    _hideFabAnimation.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(covariant CharacterScreen oldWidget) {
  //   print('****DID UPDATE WIDGET');
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    CharactersModel charactersModel =
        Provider.of<CharactersModel>(context, listen: false);
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        // key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding),
              child: Column(
                children: <Widget>[
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: charactersModel.characters.length > 1
                  //         ? smallPadding * 2
                  //         : smallPadding,
                  //   ),
                  // ),
                  // RETIREMENTS and POCKET ITEMS
                  const RetirementsAndPocketItemsSection(),
                  // NAME and CLASS
                  const Padding(
                    padding: EdgeInsets.all(smallPadding),
                    child: NameAndClassSection(),
                  ),
                  // STATS
                  const Padding(
                    padding: EdgeInsets.all(smallPadding),
                    child: StatsSection(),
                  ),
                  // RESOURCES
                  /* Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: SharedPrefs().darkTheme
                            ? Colors.white54
                            : Colors.black54,
                      ),
                      // Make rounded corners
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        onExpansionChanged: (value) =>
                            SharedPrefs().resourcesExpanded = value,
                        initiallyExpanded: SharedPrefs().resourcesExpanded,
                        title: const Text(
                          'Resources',
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: smallPadding),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Wrap(
                                runSpacing: smallPadding,
                                spacing: smallPadding,
                                alignment: WrapAlignment.spaceEvenly,
                                children: <Widget>[
                                  ResourceCard(
                                    resource: CharacterData.resources[0],
                                    // name: 'Hide',
                                    // icon: 'images/class_icons/voidwarden.svg',
                                    count: characterModel.character.resourceHide,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceHide = characterModel
                                                .character.resourceHide +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceHide = characterModel
                                                .character.resourceHide -
                                            1,
                                    ),
                                  ),
                                  ResourceCard(
                                    resource: CharacterData.resources[1],
                                    // name: 'Metal',
                                    // icon: 'images/class_icons/doomstalker.svg',
                                    count: characterModel.character.resourceMetal,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceMetal = characterModel
                                                .character.resourceMetal +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceMetal = characterModel
                                                .character.resourceMetal -
                                            1,
                                    ),
                                  ),
                                  ResourceCard(
                                    resource: CharacterData.resources[2],
                                    // name: 'Wood',
                                    // icon: 'images/class_icons/soothsinger.svg',
                                    count: characterModel.character.resourceWood,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceWood = characterModel
                                                .character.resourceWood +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceWood = characterModel
                                                .character.resourceWood -
                                            1,
                                    ),
                                  ),
                                  ResourceCard(
                                    resource: CharacterData.resources[3],
                                    // name: 'Arrow Vine',
                                    // icon: 'images/class_icons/beast_tyrant.svg',
                                    count: characterModel
                                        .character.resourceArrowVine,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceArrowVine = characterModel
                                                .character.resourceArrowVine +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceArrowVine = characterModel
                                                .character.resourceArrowVine -
                                            1,
                                    ),
                                  ),
                                  ResourceCard(
                                    resource: CharacterData.resources[4],
                                    // name: 'Axe Nut',
                                    // icon: 'images/class_icons/red_guard.svg',
                                    count:
                                        characterModel.character.resourceAxeNut,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceAxeNut = characterModel
                                                .character.resourceAxeNut +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceAxeNut = characterModel
                                                .character.resourceAxeNut -
                                            1,
                                    ),
                                  ),
                                  ResourceCard(
                                    resource: CharacterData.resources[5],
                                    // name: 'Rock Root',
                                    // icon: 'images/class_icons/mirefoot.svg',
                                    count:
                                        characterModel.character.resourceRockRoot,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceRockRoot = characterModel
                                                .character.resourceRockRoot +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceRockRoot = characterModel
                                                .character.resourceRockRoot -
                                            1,
                                    ),
                                  ),
                                  ResourceCard(
                                    resource: CharacterData.resources[6],
                                    // name: 'Flame Fruit',
                                    // icon: 'images/class_icons/mirefoot.svg',
                                    count: characterModel
                                        .character.resourceFlameFruit,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceFlameFruit = characterModel
                                                .character.resourceFlameFruit +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceFlameFruit = characterModel
                                                .character.resourceFlameFruit -
                                            1,
                                    ),
                                  ),
                                  ResourceCard(
                                    resource: CharacterData.resources[7],
                                    // name: 'Corpse Cap',
                                    // icon: 'images/class_icons/mirefoot.svg',
                                    count: characterModel
                                        .character.resourceCorpseCap,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceCorpseCap = characterModel
                                                .character.resourceCorpseCap +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceCorpseCap = characterModel
                                                .character.resourceCorpseCap -
                                            1,
                                    ),
                                  ),
                                  ResourceCard(
                                    resource: CharacterData.resources[8],
                                    // name: 'Snow Thistle',
                                    // icon: 'images/class_icons/mirefoot.svg',
                                    count: characterModel
                                        .character.resourceSnowThistle,
                                    increaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceSnowThistle = characterModel
                                                .character.resourceSnowThistle +
                                            1,
                                    ),
                                    decreaseCount: () =>
                                        characterModel.updateCharacter(
                                      characterModel.character
                                        ..resourceSnowThistle = characterModel
                                                .character.resourceSnowThistle -
                                            1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), */
                  // NOTES
                  characterModel.character.notes.isEmpty &&
                          !characterModel.isEditable
                      ? Container()
                      : const Padding(
                          padding: EdgeInsets.all(smallPadding),
                          child: NotesSection(),
                        ),
                  // BATTLE GOAL CHECKMARKS
                  characterModel.isEditable
                      ? const Padding(
                          padding: EdgeInsets.all(smallPadding),
                          child: BattleGoalCheckmarksSection(),
                        )
                      : Container(),
                  // PERKS
                  Padding(
                    padding: const EdgeInsets.all(smallPadding),
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
          child: SpeedDial(
            onOpen: () {
              // charactersModel.isDialOpen.value = true;
              characterModel.isEditable = true;
              charactersModel.isEditMode = true;
            },
            onClose: () {
              // charactersModel.isDialOpen.value = false;
              characterModel.isEditable = false;
              charactersModel.isEditMode = false;
            },
            // openCloseDial: charactersModel.isDialOpen,
            renderOverlay: false,
            heroTag: null,
            foregroundColor: ThemeData.estimateBrightnessForColor(
                        Theme.of(context).colorScheme.secondary) ==
                    Brightness.dark
                ? Colors.white
                : Colors.black,
            icon: Icons.edit,
            // backgroundColor: Color(int.parse('0xff3868F3')),
            activeIcon: Icons.check,
            children: [
              SpeedDialChild(
                child: Icon(
                  characterModel.character.isRetired
                      ? Icons.directions_walk
                      : Icons.elderly,
                ),
                backgroundColor: Colors.blue[300],
                foregroundColor: Colors.white,
                onTap: () async {
                  final String retiredCharactersName =
                      charactersModel.currentCharacter.name;
                  final bool retiredCharacterIsRetired =
                      charactersModel.currentCharacter.isRetired;
                  await charactersModel.retireCurrentCharacter(
                      // context,
                      );
                  scaffoldMessengerKey.currentState != null
                      ? scaffoldMessengerKey.currentState.showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                                '$retiredCharactersName ${retiredCharacterIsRetired ? 'unretired' : 'retired'}'),
                            // action: charactersModel.showRetired
                            //     ? null
                            //     : SnackBarAction(
                            //         label: 'Show',
                            //         onPressed: () {
                            // int index =
                            //     charactersModel.indexOfCurrentCharacter;
                            // setState(() {
                            //   charactersModel.showRetired = true;
                            //   charactersModel.setCurrentCharacter(context,
                            //       index: index);
                            //   // ..updateTheme(context);
                            // });
                            //         }),
                          ),
                        )
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                                '$retiredCharactersName ${retiredCharacterIsRetired ? 'unretired' : 'retired'}'),
                            // action: charactersModel.showRetired
                            //     ? null
                            //     : SnackBarAction(
                            //         label: 'Show',
                            //         onPressed: () {
                            // int index =
                            //     charactersModel.indexOfCurrentCharacter;
                            // setState(() {
                            //   charactersModel.showRetired = true;
                            //   charactersModel.setCurrentCharacter(context,
                            //       index: index);
                            //   // ..updateTheme(context);
                            // });
                            //         }),
                          ),
                        );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.delete),
                backgroundColor: Colors.red[300],
                foregroundColor: Colors.white,
                onTap: () async {
                  showDialog<bool>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: const Text(
                          'Are you sure? This cannot be undone',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text(
                              'Cancel',
                            ),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ).then(
                    (result) async {
                      if (result) {
                        await charactersModel.deleteCurrentCharacter(
                            // context,
                            );
                      }
                    },
                  );
                },
              ),
            ],
          ),
          // FloatingActionButton(
          //   heroTag: null,
          //   child: Icon(
          //     characterModel.isEditable ? Icons.check : Icons.edit,
          //     color: ThemeData.estimateBrightnessForColor(
          //                 Theme.of(context).colorScheme.secondary) ==
          //             Brightness.dark
          //         ? Colors.white
          //         : Colors.black,
          //   ),
          //   onPressed: () {
          //     characterModel.isEditable = !characterModel.isEditable;
          //     charactersModel.isEditMode = !charactersModel.isEditMode;
          //   },
          // ),
        ),
      ),
    );
  }
}

class RetirementsAndPocketItemsSection extends StatelessWidget {
  const RetirementsAndPocketItemsSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            SizedBox(
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
              icon: const Icon(
                Icons.info_outline,
              ),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) {
                  return InfoDialog(
                    title: Strings.previousRetirementsInfoTitle,
                    message: Strings.previousRetirementsInfoBody(context),
                  );
                },
              ),
            ),
          ],
        ),
        Tooltip(
          message: 'Number of pocket items allowed',
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              SvgPicture.asset(
                'images/equipment_slots/pocket.svg',
                width: iconSize,
                color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3.5),
                child: Text(
                  characterModel.numOfPocketItems.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 20,
                      color: SharedPrefs().darkTheme
                          ? Colors.black
                          : Colors.white),
                ),
              ),
              const SizedBox(
                width: smallPadding,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class NameAndClassSection extends StatelessWidget {
  const NameAndClassSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Column(
      children: <Widget>[
        characterModel.isEditable
            ? TextField(
                autocorrect: false,
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
              alignment: const Alignment(0, 0.75),
              children: <Widget>[
                SvgPicture.asset(
                  'images/level.svg',
                  width: iconSize * 1.5,
                  color:
                      SharedPrefs().darkTheme ? Colors.white : Colors.black87,
                ),
                Text(
                  '${characterModel.currentLevel}',
                  style: TextStyle(
                    color:
                        SharedPrefs().darkTheme ? Colors.black87 : Colors.white,
                    fontSize: titleFontSize - 5,
                    fontFamily: pirataOne,
                  ),
                )
              ],
            ),
            const SizedBox(
              width: smallPadding,
            ),
            Flexible(
              child: AutoSizeText(
                '${characterModel.character.playerClass.race} ${characterModel.character.playerClass.className}',
                maxLines: 1,
                style: const TextStyle(fontSize: titleFontSize),
              ),
            ),
          ],
        ),
        if (characterModel.character.isRetired)
          const Text(
            '(retired)',
            style: TextStyle(fontSize: 20),
          ),
      ],
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Tooltip(
          message: 'XP',
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'images/xp.svg',
                width: iconSize + 5,
                color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
              ),
              characterModel.isEditable
                  ? Column(
                      children: <Widget>[
                        SizedBox(
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
                        IconButton(
                          icon: const Icon(Icons.exposure),
                          onPressed: () async => await showDialog<int>(
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
                        // AddSubtractButton(
                        //   onTap: () async => await showDialog<int>(
                        //       context: context,
                        //       builder: (_) => AddSubtractDialog(
                        //             characterModel.character.xp,
                        //             'XP',
                        //           )).then((value) {
                        //     if (value != null) {
                        //       characterModel.xpController.text =
                        //           value.toString();
                        //       characterModel.updateCharacter(
                        //         characterModel.character..xp = value,
                        //       );
                        //     }
                        //   }),
                        // ),
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
        Tooltip(
          message: 'Gold',
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'images/loot.svg',
                width: iconSize,
                color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
              ),
              characterModel.isEditable
                  ? Column(
                      children: <Widget>[
                        SizedBox(
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
                        IconButton(
                          icon: const Icon(Icons.exposure),
                          onPressed: () async => await showDialog<int>(
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
                        // AddSubtractButton(
                        //   onTap: () async => await showDialog<int>(
                        //       context: context,
                        //       builder: (_) => AddSubtractDialog(
                        //             characterModel.character.gold,
                        //             'Gold',
                        //           )).then((value) {
                        //     if (value != null) {
                        //       characterModel.goldController.text =
                        //           value.toString();
                        //       characterModel.updateCharacter(
                        //         characterModel.character..gold = value,
                        //       );
                        //     }
                        //   }),
                        // ),
                      ],
                    )
                  : Text(
                      ' ${characterModel.character.gold}',
                      style: Theme.of(context).textTheme.bodyText2,
                    )
            ],
          ),
        ),
        Tooltip(
          message: 'Battle Goal Checkmarks',
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'images/goal.svg',
                width: iconSize,
                color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                '${characterModel.checkMarkProgress} / 3',
                style: Theme.of(context).textTheme.bodyText2,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class NotesSection extends StatelessWidget {
  const NotesSection({
    Key key,
  }) : super(key: key);

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
        const SizedBox(
          height: smallPadding,
        ),
        characterModel.isEditable
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (String value) {
                    characterModel.updateCharacter(
                        characterModel.character..notes = value);
                  },
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
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
  const BattleGoalCheckmarksSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Column(
      children: <Widget>[
        const AutoSizeText(
          'Battle Goal Checkmarks',
          textAlign: TextAlign.center,
          minFontSize: titleFontSize,
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
                color: Theme.of(context).colorScheme.secondary,
                iconSize: Theme.of(context).textTheme.bodyText2.fontSize,
                icon: const Icon(
                  Icons.remove_circle,
                ),
                onPressed: characterModel.decreaseCheckmark,
              ),
            ),
            Text(
              '${characterModel.character.checkMarks} / 18',
              style: const TextStyle(fontSize: titleFontSize),
            ),
            Visibility(
              visible: characterModel.character.checkMarks < 18,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                color: Theme.of(context).colorScheme.secondary,
                iconSize: Theme.of(context).textTheme.bodyText2.fontSize,
                icon: const Icon(
                  Icons.add_circle,
                ),
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

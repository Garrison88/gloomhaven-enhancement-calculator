import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/core/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/core/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/core/models/character.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/base_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/characterList_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/locator.dart';
import 'package:gloomhaven_enhancement_calc/ui/views/base_view.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/dialogs/show_info.dart';
import 'package:provider/provider.dart';

class CharacterDetails extends StatefulWidget {
  // final Character character;
  // CharacterDetails({this.character});

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
  final TextEditingController _addSubtractXpTextFieldController =
      TextEditingController();
  final TextEditingController _addSubtractGoldTextFieldController =
      TextEditingController();

  // @override
  // void initState() {
  // locator<CharacterModel>().character = widget.character;
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   Provider.of<AppModel>(context, listen: false).setAccentColor(
  //       Provider.of<CharacterModel>(context, listen: false)
  //           .character
  //           .classColor);
  // });
  //   super.initState();
  // }

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
    final characterModel = Provider.of<CharacterModel>(context);
    // BaseView<CharacterModel>(
    //       onModelReady: (character. => character.character = widget.character,
    //       builder: (context, character. child) => Scaffold(
    //         resizeToAvoidBottomPadding: true,
    //         body: character.state == ViewState.Busy
    //             ? Container(
    //                 child: CircularProgressIndicator(),
    //               )
    //             :
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
                          Padding(padding: EdgeInsets.only(left: smallPadding)),
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: characterModel.isEditable
                                ? TextField(
                                    onChanged: (String value) =>
                                        characterModel.updateCharacter(
                                            characterModel.character
                                              ..previousRetirements =
                                                  value == ''
                                                      ? 0
                                                      : int.parse(value)),
                                    style:
                                        TextStyle(fontSize: titleFontSize / 2),
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
                                    'Retirements: ${characterModel.character.previousRetirements}',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontSize: titleFontSize / 2),
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
                                              style: TextStyle(
                                                  fontSize: titleFontSize),
                                            ),
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
                                                      fontFamily: highTower),
                                                ),
                                              ),
                                              RaisedButton(
                                                color: Colors.red,
                                                onPressed: () => Provider.of<
                                                            CharacterListModel>(
                                                        context,
                                                        listen: false)
                                                    .deleteCharacter(
                                                        characterModel
                                                            .character.id)
                                                    .whenComplete(() =>
                                                        Navigator.pop(context)),
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          secondaryFontSize,
                                                      fontFamily: highTower),
                                                ),
                                              ),
                                            ],
                                          )))
                              : Container(),
                          // TODO: add retire character functionality
                          // character.isEditable
                          //     ? IconButton(
                          //         color: Colors.blue,
                          //         tooltip: 'Retire',
                          //         icon: Icon(FontAwesomeIcons.bed),
                          //         onPressed: () {
                          //           character.updateCharacter(
                          //               character.character
                          //                 ..isRetired = character.character.isRetired
                          //                     ? false
                          //                     : true);
                          //           character.isEditable = false;
                          //         })
                          //     : Container(),
                          IconButton(
                              icon: Icon(characterModel.isEditable
                                  ? FontAwesomeIcons.lockOpen
                                  : FontAwesomeIcons.lock),
                              tooltip:
                                  characterModel.isEditable ? 'Lock' : 'Unlock',
                              onPressed: characterModel.isEditable
                                  ? () => characterModel.isEditable = false
                                  : () {
                                      if (characterModel
                                              .character.previousRetirements !=
                                          0)
                                        _previousRetirementsTextFieldController
                                                .text =
                                            characterModel
                                                .character.previousRetirements
                                                .toString();
                                      _charNameTextFieldController.text =
                                          characterModel.character.name;
                                      if (characterModel.character.xp != 0)
                                        _xpTextFieldController.text =
                                            characterModel.character.xp
                                                .toString();
                                      if (characterModel.character.gold != 0)
                                        _goldTextFieldController.text =
                                            characterModel.character.gold
                                                .toString();
                                      _notesTextFieldController.text =
                                          characterModel.character.notes;
                                      characterModel.isEditable = true;
                                    }),
                        ],
                      )
                    ]),
                Container(
                  padding:
                      EdgeInsets.only(left: smallPadding, right: smallPadding),
                  child: characterModel.isEditable
                      ? TextField(
                          onChanged: (String value) =>
                              characterModel.updateCharacter(
                                  characterModel.character..name = value),
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
                          characterModel.character.name,
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
                          Image.asset('images/xp.png', width: iconWidth * 1.75),
                          Text(
                            '${characterModel.currentLevel}',
                            style: TextStyle(
                                color: Colors.white, fontSize: titleFontSize),
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
                      characterModel.isEditable
                          ? Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: TextField(
                                    onChanged: (String value) =>
                                        characterModel.updateCharacter(
                                            characterModel.character
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
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: smallPadding),
                                ),
                                Container(
                                  child: InkWell(
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.minus,
                                            color: Color(int.parse(
                                                characterModel
                                                    .character.classColor)),
                                            size: 15,
                                          ),
                                          Text(
                                            '/',
                                            style: TextStyle(
                                              color: Color(int.parse(
                                                  characterModel
                                                      .character.classColor)),
                                            ),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.plus,
                                            color: Color(int.parse(
                                                characterModel
                                                    .character.classColor)),
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext cxt) {
                                        return Dialog(
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  top: smallPadding,
                                                  bottom: smallPadding),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: IconButton(
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .minus),
                                                        onPressed: () {
                                                          _xpTextFieldController
                                                              .text = (int.parse(
                                                                      _xpTextFieldController.text ==
                                                                              ''
                                                                          ? '0'
                                                                          : _xpTextFieldController
                                                                              .text) -
                                                                  int.parse(
                                                                      _addSubtractXpTextFieldController
                                                                          .text))
                                                              .toString();
                                                          characterModel.updateCharacter(
                                                              characterModel
                                                                  .character
                                                                ..xp = int.parse(
                                                                    _xpTextFieldController
                                                                        .text));
                                                          _addSubtractXpTextFieldController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ),
                                                  Expanded(
                                                    child: TextField(
                                                      inputFormatters: [
                                                        BlacklistingTextInputFormatter(
                                                            RegExp(
                                                                '[\\.|\\,|\\ |\\-]'))
                                                      ],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      autofocus: true,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: 'XP'),
                                                      controller:
                                                          _addSubtractXpTextFieldController,
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize *
                                                                  1.5),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: IconButton(
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .plus),
                                                        onPressed: () {
                                                          _xpTextFieldController
                                                              .text = (int.parse(
                                                                      _xpTextFieldController.text ==
                                                                              ''
                                                                          ? '0'
                                                                          : _xpTextFieldController
                                                                              .text) +
                                                                  int.parse(
                                                                      _addSubtractXpTextFieldController
                                                                          .text))
                                                              .toString();
                                                          characterModel.updateCharacter(
                                                              characterModel
                                                                  .character
                                                                ..xp = int.parse(
                                                                    _xpTextFieldController
                                                                        .text));
                                                          _addSubtractXpTextFieldController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                )
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
                                    onChanged: (String value) =>
                                        characterModel.updateCharacter(
                                            characterModel.character
                                              ..gold = value == ''
                                                  ? 0
                                                  : int.parse(value)),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(fontSize: titleFontSize),
                                    textAlign: TextAlign.center,
                                    controller: _goldTextFieldController,
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
                                Container(
                                  child: InkWell(
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.minus,
                                            color: Color(int.parse(
                                                characterModel
                                                    .character.classColor)),
                                            size: 15,
                                          ),
                                          Text(
                                            '/',
                                            style: TextStyle(
                                              color: Color(int.parse(
                                                  characterModel
                                                      .character.classColor)),
                                            ),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.plus,
                                            color: Color(int.parse(
                                                characterModel
                                                    .character.classColor)),
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext cxt) {
                                        return Dialog(
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  top: smallPadding,
                                                  bottom: smallPadding),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: IconButton(
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .minus),
                                                        onPressed: () {
                                                          _goldTextFieldController
                                                              .text = (int.parse(
                                                                      _goldTextFieldController.text ==
                                                                              ''
                                                                          ? '0'
                                                                          : _goldTextFieldController
                                                                              .text) -
                                                                  int.parse(
                                                                      _addSubtractGoldTextFieldController
                                                                          .text))
                                                              .toString();
                                                          characterModel.updateCharacter(
                                                              characterModel
                                                                  .character
                                                                ..gold = int.parse(
                                                                    _goldTextFieldController
                                                                        .text));
                                                          _addSubtractGoldTextFieldController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ),
                                                  Expanded(
                                                    child: TextField(
                                                      inputFormatters: [
                                                        BlacklistingTextInputFormatter(
                                                            RegExp(
                                                                '[\\.|\\,|\\ |\\-]'))
                                                      ],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      autofocus: true,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: 'Gold'),
                                                      controller:
                                                          _addSubtractGoldTextFieldController,
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize *
                                                                  1.5),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: IconButton(
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .plus),
                                                        onPressed: () {
                                                          _goldTextFieldController
                                                              .text = (int.parse(
                                                                      _goldTextFieldController.text ==
                                                                              ''
                                                                          ? '0'
                                                                          : _goldTextFieldController
                                                                              .text) +
                                                                  int.parse(
                                                                      _addSubtractGoldTextFieldController
                                                                          .text))
                                                              .toString();
                                                          characterModel.updateCharacter(
                                                              characterModel
                                                                  .character
                                                                ..gold = int.parse(
                                                                    _goldTextFieldController
                                                                        .text));
                                                          _addSubtractGoldTextFieldController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                )
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
        ),

        // NOTES
        characterModel.isEditable
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
                        onChanged: (String value) =>
                            characterModel.updateCharacter(
                                characterModel.character..notes = value),
                        style: TextStyle(fontFamily: highTower),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            hintText: 'Notes',
                            hintStyle: TextStyle(fontFamily: highTower)),
                        controller: _notesTextFieldController,
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
                : Container(),
        // BATTLE GOAL CHECKMARKS
        characterModel.isEditable
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
                          iconSize: Theme.of(context).textTheme.body1.fontSize,
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
                          iconSize: Theme.of(context).textTheme.body1.fontSize,
                          icon: Icon(FontAwesomeIcons.plus),
                          onPressed: () => characterModel.increaseCheckmark(),
                        ),
                      ),
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
                  //       // for(var x = 0; x < character.character.checkMarks; x++)
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
  }
  //   ),
  // )
  // );
  // }
  // },
  // );
  // }
  // });
}

// _clearTextFields() {
//   _previousRetirementsTextFieldController.clear();
//   _xpTextFieldController.clear();
//   _goldTextFieldController.clear();
//   _charNameTextFieldController.clear();
//   _notesTextFieldController.clear();
// }

// Character _saveEdits(Character character.character) {
//   Character _updatedCharacter = character.character;
//   _updatedCharacter.name = _charNameTextFieldController.text.isNotEmpty
//       ? _charNameTextFieldController.text
//       : character.character.name;
//   _updatedCharacter.xp = _xpTextFieldController.text.isNotEmpty
//       ? int.parse(_xpTextFieldController.text)
//       : character.character.xp;
//   _updatedCharacter.gold = _goldTextFieldController.text.isNotEmpty
//       ? int.parse(_goldTextFieldController.text)
//       : character.character.gold;
//   _updatedCharacter.notes = _notesTextFieldController.text.isNotEmpty
//       ? _notesTextFieldController.text
//       : '';
//   return _updatedCharacter;
// }
// }

// _showConfirmDeleteDialog(BuildContext _context) {
//   Provider.of<CharacterListState>(_context,
//                                         listen: false)
//                                     .deleteCharacter(character.character.id))
// }

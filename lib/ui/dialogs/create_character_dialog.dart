import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../custom_search_delegate.dart';
import '../../data/character_data.dart';
import '../../data/constants.dart';
// import 'package:gloomhaven_enhancement_calc/models/personal_goal.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

class CreateCharacterDialog extends StatefulWidget {
  final CharactersModel charactersModel;

  const CreateCharacterDialog({
    Key key,
    this.charactersModel,
  }) : super(key: key);

  @override
  _CreateCharacterDialogState createState() => _CreateCharacterDialogState();
}

class _CreateCharacterDialogState extends State<CreateCharacterDialog> {
  final TextEditingController _nameTextFieldController =
      TextEditingController();
  final TextEditingController _classTextFieldController =
      TextEditingController();
  final TextEditingController _personalGoalTextFieldController =
      TextEditingController();
  final TextEditingController _levelTextFieldController =
      TextEditingController();
  final TextEditingController _previousRetirementsTextFieldController =
      TextEditingController();
  final List<int> _levels = List.generate(9, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    _selectedClass = CharacterData.playerClasses[0];
    _classTextFieldController.text = _selectedClass.className;
    _levelTextFieldController.text = '${_levels[0]}';
  }

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _classTextFieldController.dispose();
    _personalGoalTextFieldController.dispose();
    _levelTextFieldController.dispose();
    _previousRetirementsTextFieldController.dispose();
    super.dispose();
  }

  // PersonalGoal _personalGoal;

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
                child: GestureDetector(
              onTap: () => closeMenu(),
              child: Container(
                color: Colors.transparent,
              ),
            )),
            Positioned(
              top: buttonPosition.dy - 100,
              left: buttonPosition.dx,
              width: buttonSize.width / 2,
              child: Material(
                color: Colors.transparent,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _levels.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            _levelTextFieldController.text =
                                _levels[index].toString();
                            closeMenu();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(smallPadding),
                            child: Text(
                              'Level ${_levels[index].toString()}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isLevelMenuOpen = !isLevelMenuOpen;
  }

  void closeMenu() {
    _overlayEntry.remove();
    isLevelMenuOpen = !isLevelMenuOpen;
  }

  PlayerClass _selectedClass;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey _levelKey = LabeledGlobalKey("button_icon");

  OverlayEntry _overlayEntry;
  Size buttonSize;
  Offset buttonPosition;
  bool isLevelMenuOpen = false;
  bool isPersonalGoalMenuOpen = false;

  findButton() {
    RenderBox renderBox = _levelKey.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) =>
                    value.isNotEmpty ? null : 'Please enter a name',
                controller: _nameTextFieldController,
              ),
              TextFormField(
                readOnly: true,
                controller: _classTextFieldController,
                decoration: InputDecoration(
                  labelText: 'Class',
                  suffixIcon: SizedBox(
                    height: iconSize + 5,
                    width: iconSize + 5,
                    child: SvgPicture.asset(
                      'images/class_icons/${_selectedClass.classIconUrl}',
                      color: Color(
                        int.parse(
                          _selectedClass.classColor,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  await showSearch<PlayerClass>(
                    context: context,
                    delegate: CustomSearchDelegate(
                      CharacterData.playerClasses,
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _selectedClass = value;
                        _classTextFieldController.text = value.className;
                      });
                    }
                  });
                },
              ),
              TextFormField(
                enableInteractiveSelection: false,
                key: _levelKey,
                controller: _levelTextFieldController,
                readOnly: true,
                onTap: () => isLevelMenuOpen ? closeMenu() : openMenu(),
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  suffixIconConstraints: BoxConstraints(
                    maxHeight: 0,
                    minWidth: 48,
                  ),
                  labelText: 'Starting Level',
                ),
              ),
              // DropdownButton<PersonalGoal>(
              //   value: _personalGoal,
              //   selectedItemBuilder: (BuildContext context) {
              //     return CharacterData.personalGoals
              //         .map<Widget>((PersonalGoal personalGoal) {
              //       return Text('PG ${personalGoal.id}');
              //     }).toList();
              //   },
              //   items: CharacterData.personalGoals
              //       .map((PersonalGoal personalGoal) {
              //     return DropdownMenuItem<PersonalGoal>(
              //       child: Text('PG ${personalGoal.id}'),
              //       value: personalGoal,
              //     );
              //   }).toList(),
              //   onChanged: (personalGoal) {
              //     setState(() {
              //       _personalGoal = personalGoal;
              //     });
              //   },
              // ),
              // TextFormField(
              //   enableInteractiveSelection: false,
              //   key: _levelKey,
              //   controller: _previousRetirementsTextFieldController,
              //   readOnly: true,
              //   onTap: () => isPersonalGoalMenuOpen ? closeMenu() : openMenu(),
              //   decoration: InputDecoration(
              //     suffixIcon: Icon(Icons.arrow_drop_down),
              //     suffixIconConstraints: BoxConstraints(
              //       maxHeight: 0,
              //       minWidth: 48,
              //     ),
              //     labelText: 'Personal Goal',
              //   ),
              // ),
              TextFormField(
                enableInteractiveSelection: false,
                controller: _previousRetirementsTextFieldController,
                decoration: const InputDecoration(
                  labelText: 'Previous Retirements',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp('[\\.|\\,|\\ |\\-]'))
                ],
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: secondaryFontSize,
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              await widget.charactersModel.createCharacter(
                // context,
                _nameTextFieldController.text,
                _selectedClass,
                initialLevel: int.parse(_levelTextFieldController.text),
                previousRetirements: _previousRetirementsTextFieldController
                        .text.isEmpty
                    ? 0
                    : int.parse(_previousRetirementsTextFieldController.text),
              );
              Navigator.pop(context, true);
            }
          },
          child: const Text(
            'Create',
            style: TextStyle(
              fontSize: secondaryFontSize,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

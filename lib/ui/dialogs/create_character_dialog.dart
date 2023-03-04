import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:gloomhaven_enhancement_calc/models/personal_goal.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

import '../../custom_search_delegate.dart';
import '../../data/character_data.dart';
import '../../data/constants.dart';

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
    faker = Faker();
    _selectedClass = CharacterData.playerClasses[0];
    _classTextFieldController.text = _selectedClass.className;
    _levelTextFieldController.text = '${_levels[0]}';
    placeholderName = _generateRandomName();
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

  String _generateRandomName() {
    return '${faker.person.firstName()} ${faker.person.lastName()}';
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
  Faker faker;
  String placeholderName;
  FocusNode nameFocusNode = FocusNode();

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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleMedium,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      autocorrect: false,
                      focusNode: nameFocusNode,
                      decoration: InputDecoration(
                        hintText: placeholderName,
                        labelText: 'Name',
                      ),
                      controller: _nameTextFieldController,
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.dice),
                    onPressed: () {
                      _nameTextFieldController.clear();
                      FocusScope.of(context).requestFocus(nameFocusNode);
                      setState(() {
                        placeholderName = _generateRandomName();
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleMedium,
                      readOnly: true,
                      controller: _classTextFieldController,
                      decoration: const InputDecoration(
                        labelText: 'Class',
                      ),
                      onTap: () async {
                        await showSearch<PlayerClass>(
                          context: context,
                          delegate: CustomSearchDelegate(
                            CharacterData.playerClasses,
                          ),
                        ).then((value) {
                          FocusScope.of(context).requestFocus(nameFocusNode);
                          if (value != null) {
                            setState(() {
                              _selectedClass = value;
                              _classTextFieldController.text = value.className;
                            });
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'images/class_icons/${_selectedClass.classIconUrl}',
                        colorFilter: ColorFilter.mode(
                          Color(
                            int.parse(
                              _selectedClass.classColor,
                            ),
                          ),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              TextFormField(
                style: Theme.of(context).textTheme.titleMedium,
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
                style: Theme.of(context).textTheme.titleMedium,
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
        TextButton(
          style: Theme.of(context).textButtonTheme.style.copyWith(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) =>
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Colors.black87,
                ),
              ),
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Cancel',
          ),
        ),
        ElevatedButton.icon(
          style: Theme.of(context).textButtonTheme.style.copyWith(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) => Colors.green.withOpacity(0.75),
                ),
              ),
          onPressed: () async {
            await widget.charactersModel.createCharacter(
              _nameTextFieldController.text.isEmpty
                  ? placeholderName
                  : _nameTextFieldController.text,
              _selectedClass,
              initialLevel: int.parse(_levelTextFieldController.text),
              previousRetirements:
                  _previousRetirementsTextFieldController.text.isEmpty
                      ? 0
                      : int.parse(_previousRetirementsTextFieldController.text),
            );
            Navigator.pop(context, true);
          },
          label: const Text(
            'Create',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

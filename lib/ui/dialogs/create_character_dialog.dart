import 'package:auto_size_text/auto_size_text.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
// import 'package:gloomhaven_enhancement_calc/models/personal_goal.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/info_dialog.dart';
import 'package:gloomhaven_enhancement_calc/utils/utils.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/custom_search_delegate.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';

class CreateCharacterDialog extends StatefulWidget {
  final CharactersModel charactersModel;

  const CreateCharacterDialog({
    super.key,
    required this.charactersModel,
  });

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
  final TextEditingController _prosperityLevelTextFieldController =
      TextEditingController();
  bool _gloomhavenMode = true;
  PlayerClass? _selectedClass;
  Faker faker = Faker();
  late String placeholderName;
  FocusNode nameFocusNode = FocusNode();
  Variant _variant = Variant.base;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey _levelKey = LabeledGlobalKey("button_icon");
  late Size buttonSize;
  late Offset buttonPosition;
  bool isLevelMenuOpen = false;
  bool isPersonalGoalMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _levelTextFieldController.text = '1';
    placeholderName = _generateRandomName();
  }

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _classTextFieldController.dispose();
    _personalGoalTextFieldController.dispose();
    _levelTextFieldController.dispose();
    _previousRetirementsTextFieldController.dispose();
    _prosperityLevelTextFieldController.dispose();
    super.dispose();
  }

  String _generateRandomName() {
    return '${faker.person.firstName()} ${faker.person.lastName()}';
  }

  // PersonalGoal _personalGoal;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        constraints: const BoxConstraints(
          maxWidth: maxDialogWidth,
          minWidth: maxDialogWidth,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                title: TextFormField(
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
                trailing: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.dice),
                  onPressed: () {
                    _nameTextFieldController.clear();
                    FocusScope.of(context).requestFocus(nameFocusNode);
                    setState(() {
                      placeholderName = _generateRandomName();
                    });
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                title: TextFormField(
                  validator: (value) =>
                      _selectedClass == null ? 'Please select a Class' : null,
                  readOnly: true,
                  controller: _classTextFieldController,
                  decoration: InputDecoration(
                    labelText:
                        'Class${_variant != Variant.base ? ' (${CharacterData.classVariants[_variant]})' : ''}',
                  ),
                  onTap: () async {
                    SelectedPlayerClass? selectedPlayerClass =
                        await showSearch<SelectedPlayerClass>(
                      context: context,
                      delegate: CustomSearchDelegate(
                        CharacterData.playerClasses,
                      ),
                    );
                    if (selectedPlayerClass != null) {
                      FocusScope.of(context).requestFocus(nameFocusNode);

                      setState(() {
                        _classTextFieldController.text =
                            selectedPlayerClass.playerClass.name;
                        _variant = selectedPlayerClass.variant!;
                        _selectedClass = selectedPlayerClass.playerClass;
                      });
                      _formKey.currentState?.validate();
                    }
                  },
                ),
                trailing: SizedBox(
                  width: 48,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _selectedClass == null
                        ? const Icon(Icons.open_in_new)
                        : SvgPicture.asset(
                            'images/class_icons/${_selectedClass!.icon}',
                            colorFilter: ColorFilter.mode(
                              Color(
                                _selectedClass!.primaryColor,
                              ),
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                title: TextFormField(
                  enableInteractiveSelection: false,
                  key: _levelKey,
                  controller: _levelTextFieldController,
                  readOnly: true,
                  onTap: () async => await _showLevelGridDialog(context),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    suffixIconConstraints: BoxConstraints(
                      maxHeight: 0,
                      minWidth: 48,
                    ),
                    labelText: 'Starting level',
                  ),
                ),
                trailing: SizedBox(
                  width: 48,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'images/level.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onBackground,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
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
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                title: TextFormField(
                  enableInteractiveSelection: false,
                  controller: _previousRetirementsTextFieldController,
                  decoration: const InputDecoration(
                    labelText: 'Previous retirements',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('[\\.|\\,|\\ |\\-]'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
              if (!_gloomhavenMode)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  title: HighlightedWidget(
                    color: const Color(0xff6ab7ff),
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      controller: _prosperityLevelTextFieldController,
                      decoration: const InputDecoration(
                        labelText: 'Prosperity level',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp('[\\.|\\,|\\ |\\-]'),
                        ),
                      ],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              const SizedBox(
                height: smallPadding,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                visualDensity: VisualDensity.compact,
                leading: IconButton(
                  icon: const Icon(
                    Icons.info_outline_rounded,
                  ),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) {
                      return InfoDialog(
                        title: Strings.newCharacterInfoTitle,
                        message: Strings.newCharacterInfoBody(
                          context,
                          gloomhavenMode: _gloomhavenMode,
                        ),
                      );
                    },
                  ),
                ),
                title: Row(
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        'Gloomhaven',
                        minFontSize: 8,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _gloomhavenMode ? null : Colors.grey,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Switch(
                        inactiveThumbImage: const AssetImage(
                          'images/switch_gh.png',
                        ),
                        activeColor: const Color(0xff005cb2),
                        trackColor: MaterialStateProperty.resolveWith(
                          (states) => states.contains(MaterialState.selected)
                              ? const Color(0xff6ab7ff)
                              : const Color(0xffa98274),
                        ),
                        value: !_gloomhavenMode,
                        onChanged: (_) {
                          setState(() {
                            if (!_gloomhavenMode) {
                              _prosperityLevelTextFieldController.clear();
                            }
                            _gloomhavenMode = !_gloomhavenMode;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: AutoSizeText(
                        'Frosthaven',
                        minFontSize: 8,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _gloomhavenMode ? Colors.grey : null,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Cancel',
          ),
        ),
        ElevatedButton.icon(
          style: Theme.of(context).textButtonTheme.style?.copyWith(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) => Colors.green.withOpacity(0.75),
                ),
              ),
          onPressed: () async {
            if (_formKey.currentState != null &&
                _formKey.currentState!.validate()) {
              await widget.charactersModel.createCharacter(
                _nameTextFieldController.text.isEmpty
                    ? placeholderName
                    : _nameTextFieldController.text,
                _selectedClass!,
                initialLevel: int.parse(
                  _levelTextFieldController.text,
                ),
                previousRetirements:
                    _previousRetirementsTextFieldController.text.isEmpty
                        ? 0
                        : int.parse(
                            _previousRetirementsTextFieldController.text,
                          ),
                gloomhavenMode: _gloomhavenMode,
                prosperityLevel: _prosperityLevelTextFieldController.text != ''
                    ? int.parse(_prosperityLevelTextFieldController.text)
                    : 0,
                variant: _variant,
              );
              Navigator.pop(context, true);
            }
          },
          label: Text(
            'Create',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          icon: const Icon(
            Icons.check_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Function to show the dialog with a grid of numbers.
  Future<void> _showLevelGridDialog(BuildContext context) async {
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: SvgPicture.asset(
            'images/level.svg',
            width: iconSize + 5,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onBackground,
              BlendMode.srcIn,
            ),
          ),
          content: SizedBox(
            width: 100,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                final number = index + 1;
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(number);
                  },
                  child: Center(
                    child: Text(
                      number.toString(),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _levelTextFieldController.text = result.toString();
      });
    }
  }
}

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
    Key? key,
    required this.charactersModel,
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
  final TextEditingController _prosperityLevelTextFieldController =
      TextEditingController();
  // final List<int> _levels = List.generate(9, (index) => index + 1);
  bool _gloomhavenMode = true;
  PlayerClass _selectedClass = CharacterData.playerClasses[0];
  Faker faker = Faker();
  late String placeholderName;
  FocusNode nameFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey _levelKey = LabeledGlobalKey("button_icon");
  // late OverlayEntry _overlayEntry;
  late Size buttonSize;
  late Offset buttonPosition;
  bool isLevelMenuOpen = false;
  bool isPersonalGoalMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _classTextFieldController.text = _selectedClass.name;
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

  // OverlayEntry _overlayEntryBuilder() {
  //   return OverlayEntry(
  //     builder: (context) {
  //       return Stack(
  //         children: <Widget>[
  //           Positioned.fill(
  //             child: GestureDetector(
  //               onTap: closeMenu,
  //               child: Container(
  //                 color: Colors.transparent,
  //               ),
  //             ),
  //           ),
  //           Positioned(
  //             top: buttonPosition.dy / 2,
  //             left: buttonPosition.dx,
  //             width: buttonSize.width,
  //             child: Material(
  //               color: Colors.transparent,
  //               child: Card(
  //                 child: ListView.builder(
  //                   padding: EdgeInsets.zero,
  //                   shrinkWrap: true,
  //                   itemCount: _levels.length,
  //                   itemBuilder: (
  //                     context,
  //                     index,
  //                   ) {
  //                     return ListTile(
  //                       visualDensity: VisualDensity.compact,
  //                       onTap: () {
  //                         _levelTextFieldController.text =
  //                             _levels[index].toString();
  //                         closeMenu();
  //                       },
  //                       title: Text(
  //                         'Level ${_levels[index].toString()}',
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void openMenu() {
  //   findButton();
  //   _overlayEntry = _overlayEntryBuilder();
  //   Overlay.of(context).insert(_overlayEntry);
  //   isLevelMenuOpen = !isLevelMenuOpen;
  // }

  // void closeMenu() {
  //   _overlayEntry.remove();
  //   isLevelMenuOpen = !isLevelMenuOpen;
  // }

  // findButton() {
  //   RenderBox renderBox =
  //       _levelKey.currentContext?.findRenderObject() as RenderBox;
  //   buttonSize = renderBox.size;
  //   buttonPosition = renderBox.localToGlobal(Offset.zero);
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        constraints: const BoxConstraints(
          maxWidth: maxDialogWidth,
          minWidth: maxDialogWidth,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: IconButton(
                //     icon: const Icon(
                //       Icons.info_outline_rounded,
                //     ),
                //     onPressed: () => showDialog<void>(
                //       context: context,
                //       builder: (_) {
                //         return InfoDialog(
                //           title: Strings.newCharacterInfoTitle,
                //           message: Strings.newCharacterInfoBody(context),
                //         );
                //       },
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                        readOnly: true,
                        controller: _classTextFieldController,
                        decoration: const InputDecoration(
                          labelText: 'Class',
                        ),
                        onTap: () {
                          showSearch<PlayerClass>(
                            context: context,
                            delegate: CustomSearchDelegate(
                              CharacterData.playerClasses,
                            ),
                          ).then((value) {
                            FocusScope.of(context).requestFocus(nameFocusNode);
                            if (value != null) {
                              setState(() {
                                _selectedClass = value;
                                _classTextFieldController.text = value.name;
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
                          'images/class_icons/${_selectedClass.icon}',
                          colorFilter: ColorFilter.mode(
                            Color(
                              _selectedClass.primaryColor,
                            ),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        key: _levelKey,
                        controller: _levelTextFieldController,
                        readOnly: true,
                        onTap: () async => await _showNumberGridDialog(context),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 0,
                            minWidth: 48,
                          ),
                          labelText: 'Starting level',
                        ),
                      ),
                    ),
                    SizedBox(
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
                  ],
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
                    labelText: 'Previous retirements',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('[\\.|\\,|\\ |\\-]'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                ),
                if (!_gloomhavenMode)
                  HighlightedWidget(
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
                const SizedBox(
                  height: smallPadding,
                ),
                Row(
                  children: [
                    IconButton(
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
              ],
            ),
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
            await widget.charactersModel.createCharacter(
              _nameTextFieldController.text.isEmpty
                  ? placeholderName
                  : _nameTextFieldController.text,
              _selectedClass,
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
            );
            Navigator.pop(context, true);
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
  Future<void> _showNumberGridDialog(BuildContext context) async {
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Level'),
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

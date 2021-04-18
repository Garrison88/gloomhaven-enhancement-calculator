import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/custom_search_delegate.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

class CreateCharacterDialog extends StatefulWidget {
  final CharactersModel charactersModel;

  CreateCharacterDialog({
    this.charactersModel,
  });

  @override
  _CreateCharacterDialogState createState() => _CreateCharacterDialogState();
}

class _CreateCharacterDialogState extends State<CreateCharacterDialog> {
  final TextEditingController _nameTextFieldController =
      TextEditingController();
  final TextEditingController _classTextFieldController =
      TextEditingController();
  final TextEditingController _levelTextFieldController =
      TextEditingController();
  final TextEditingController _previousRetirementsTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedClass = CharacterData.playerClasses[0];
    _classTextFieldController.text = _selectedClass.className;
    _levelTextFieldController.text = '${levels[0]}';
    _previousRetirementsTextFieldController.text = '0';
  }

  void dispose() {
    _nameTextFieldController.dispose();
    _classTextFieldController.dispose();
    _levelTextFieldController.dispose();
    _previousRetirementsTextFieldController.dispose();
    super.dispose();
  }

  List<int> levels = List.generate(9, (index) => index + 1);

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
                      levels.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            _levelTextFieldController.text =
                                '${levels[index].toString()}';
                            closeMenu();
                          },
                          child: Container(
                            width: buttonSize.width / 2,
                            padding: EdgeInsets.all(smallPadding),
                            child: Text(
                              '${levels[index].toString()}',
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
    isMenuOpen = !isMenuOpen;
  }

  void closeMenu() {
    _overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }

  PlayerClass _selectedClass;

  final _formKey = GlobalKey<FormState>();
  GlobalKey _levelKey = LabeledGlobalKey("button_icon");

  OverlayEntry _overlayEntry;
  Size buttonSize;
  Offset buttonPosition;
  bool isMenuOpen = false;

  findButton() {
    RenderBox renderBox = _levelKey.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
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
                suffixIcon: Container(
                  height: iconSize,
                  width: iconSize,
                  child: Image.asset(
                    'images/class_icons/${_selectedClass.classIconUrl}',
                    color: Color(int.parse(_selectedClass.classColor)),
                  ),
                ),
              ),
              onTap: () async => await showSearch<PlayerClass>(
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
              }),
            ),
            TextFormField(
              enableInteractiveSelection: false,
              key: _levelKey,
              controller: _levelTextFieldController,
              readOnly: true,
              onTap: () => isMenuOpen ? closeMenu() : openMenu(),
              decoration: InputDecoration(
                labelText: 'Starting Level',
              ),
            ),
            TextFormField(
              enableInteractiveSelection: false,
              controller: _previousRetirementsTextFieldController,
              decoration: InputDecoration(
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
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
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
            print('${_previousRetirementsTextFieldController.text}');
            if (_formKey.currentState.validate()) {
              await widget.charactersModel.createCharacter(
                _nameTextFieldController.text,
                _selectedClass,
                int.parse(_levelTextFieldController.text),
                _previousRetirementsTextFieldController.text.isEmpty
                    ? 0
                    : int.parse(_previousRetirementsTextFieldController.text),
              );
              Navigator.pop(context, true);
            }
          },
          child: Text(
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

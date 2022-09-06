import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/constants.dart';
import '../../shared_prefs.dart';
import 'character_screen.dart';
import '../../viewmodels/characters_model.dart';
import '../../viewmodels/character_model.dart';
import 'package:provider/provider.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({
    // this.future,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>()
      ..pageController = PageController(
        initialPage: SharedPrefs().initialPage,
      );
    // must watch
    if (context.watch<CharactersModel>().characters.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(
              left: smallPadding * 2,
              right: smallPadding * 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create ${charactersModel.retiredCharactersAreHidden ? 'a' : 'your first'} character using the button below, or restore a backup from the Settings menu',
                  textAlign: TextAlign.center,
                ),
                if (charactersModel.retiredCharactersAreHidden) ...[
                  const SizedBox(
                    height: smallPadding,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: smallPadding),
                    child: Divider(),
                  ),
                  TextButton(
                    onPressed: () => charactersModel.toggleShowRetired(),
                    child: const Text('Show Retired Characters'),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    } else {
      try {
        charactersModel.currentCharacter =
            charactersModel.characters[SharedPrefs().initialPage];
      } catch (e) {
        charactersModel.currentCharacter = charactersModel.characters[0];
      }
      return FutureBuilder<bool>(
          future: null,
          builder: (context, snapshot) {
            return PageView.builder(
              // key: scaffoldKey,
              controller: charactersModel.pageController,
              onPageChanged: (index) {
                charactersModel.onPageChanged(
                  index,
                );
              },
              itemCount: charactersModel.characters.length,
              itemBuilder: (context, int index) {
                CharacterModel _characterModel;
                try {
                  _characterModel = CharacterModel(
                    character: charactersModel.characters[index],
                  )..isEditable = charactersModel.isEditMode;
                } on RangeError {
                  _characterModel = CharacterModel(
                    character: charactersModel.characters[0],
                  )..isEditable = charactersModel.isEditMode;
                }
                return Stack(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SvgPicture.asset(
                            'images/class_icons/${_characterModel.character.playerClass.classIconUrl}',
                            color: _characterModel.character.isRetired
                                ? Colors.black.withOpacity(0.1)
                                : Color(
                                    int.parse(_characterModel
                                        .character.playerClass.classColor),
                                  ).withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                    ChangeNotifierProvider.value(
                      value: _characterModel,
                      child: const CharacterScreen(),
                    ),
                  ],
                );
              },
            );
          });
    }
  }
}

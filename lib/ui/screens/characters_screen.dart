import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import '../../data/constants.dart';
import '../../shared_prefs.dart';
import 'character_screen.dart';
import '../../viewmodels/characters_model.dart';
import '../../viewmodels/character_model.dart';
import 'package:provider/provider.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({
    Key key,
  }) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  Future<List<Character>> _future;
  @override
  void initState() {
    super.initState();
    _future =
        Provider.of<CharactersModel>(context, listen: false).loadCharacters();
  }

  // final CharacterModel _characterModel;
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel =
        Provider.of<CharactersModel>(context, listen: false)
          ..pageController = PageController(
            initialPage: SharedPrefs().initialPage,
          );
    return FutureProvider<List<Character>>(
        // updateShouldNotify: (first, second) => first == second,
        initialData: const [],
        create: (_) => _future,
        child: Consumer<List<Character>>(
          builder: (_, value, __) {
            print("FUTURE RAN");
            // charactersModel.characters = value;
            if (value == null) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Text('Building database. Please wait...'),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else {
              if (charactersModel.characters.isEmpty) {
                print('IS EMPTY');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: smallPadding * 2,
                        right: smallPadding * 2,
                      ),
                      child: const Text(
                        'Create your first character using the button below, or restore a backup from the Settings menu',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              } else {
                print('IS NOT EMPTY');
                try {
                  charactersModel.currentCharacter =
                      charactersModel.characters[SharedPrefs().initialPage];
                } catch (e) {
                  charactersModel.currentCharacter =
                      charactersModel.characters[0];
                }
                return PageView.builder(
                  controller: charactersModel.pageController,
                  onPageChanged: (index) {
                    charactersModel.onPageChanged(
                      index,
                    );
                  },
                  itemCount: charactersModel.characters.length,
                  itemBuilder: (context, int index) {
                    CharacterModel _characterModel;
                    print('ITEM BUILDER CALLED');
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SvgPicture.asset(
                                'images/class_icons/${_characterModel.character.playerClass.classIconUrl}',
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.1),
                              ),
                            ),
                          ),
                        ),
                        ChangeNotifierProvider.value(
                          value: _characterModel,
                          // ignore: prefer_const_constructors
                          child: CharacterScreen(),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
        ));
  }
}

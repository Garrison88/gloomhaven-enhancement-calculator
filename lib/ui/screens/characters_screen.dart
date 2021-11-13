import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
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

  // final Future<List<Character>> future;

//   @override
//   State<CharactersScreen> createState() => _CharactersScreenState();
// }

// class _CharactersScreenState extends State<CharactersScreen> {
//   Future<List<Character>> _future;
//   @override
//   void initState() {
//     super.initState();
//     _future =
//         Provider.of<CharactersModel>(context, listen: false).loadCharacters();
//   }

  // final CharacterModel _characterModel;
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = Provider.of<CharactersModel>(context)
      ..pageController = PageController(
        initialPage: SharedPrefs().initialPage,
      );
    // return FutureBuilder<List<Character>>(
    //   future: future,
    //   builder: (context, snapshot) {
    //     print('future ran');
    //     if (snapshot.connectionState == ConnectionState.done &&
    //         snapshot.hasData) {
    //       if (charactersModel.characters.isEmpty) {
    //         return Padding(
    //           padding: const EdgeInsets.only(bottom: 80),
    //           child: Center(
    //             child: Container(
    //               padding: const EdgeInsets.only(
    //                 left: smallPadding * 2,
    //                 right: smallPadding * 2,
    //               ),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   const Text(
    //                     'Create your first character using the button below, or restore a backup from the Settings menu',
    //                     textAlign: TextAlign.center,
    //                   ),
    //                   // if (charactersModel.retiredCharactersAreHidden) ...const [
    //                   //   Divider(),
    //                   //   Text(
    //                   //     '(Retired characters are hidden. Expose them through the Settings menu)',
    //                   //     textAlign: TextAlign.center,
    //                   //     style: TextStyle(fontSize: 16),
    //                   //   ),
    //                   // ],
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       } else {
    //         try {
    //           charactersModel.currentCharacter =
    //               charactersModel.characters[SharedPrefs().initialPage];
    //         } catch (e) {
    //           charactersModel.currentCharacter = charactersModel.characters[0];
    //         }
    //         return PageView.builder(
    //           controller: charactersModel.pageController,
    //           onPageChanged: (index) {
    //             charactersModel.onPageChanged(
    //               // context,
    //               index,
    //             );
    //           },
    //           itemCount: charactersModel.characters.length,
    //           itemBuilder: (context, int index) {
    //             CharacterModel _characterModel;
    //             try {
    //               _characterModel = CharacterModel(
    //                 character: charactersModel.characters[index],
    //               )..isEditable = charactersModel.isEditMode;
    //             } on RangeError {
    //               _characterModel = CharacterModel(
    //                 character: charactersModel.characters[0],
    //               )..isEditable = charactersModel.isEditMode;
    //             }
    //             return Stack(
    //               children: <Widget>[
    //                 Center(
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(bottom: 80),
    //                     child: Container(
    //                       padding: const EdgeInsets.symmetric(horizontal: 16),
    //                       child: SvgPicture.asset(
    //                         'images/class_icons/${_characterModel.character.playerClass.classIconUrl}',
    //                         color: Theme.of(context)
    //                             .colorScheme
    //                             .secondary
    //                             .withOpacity(0.1),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 ChangeNotifierProvider.value(
    //                   value: _characterModel,
    //                   // ignore: prefer_const_constructors
    //                   child: CharacterScreen(),
    //                 ),
    //               ],
    //             );
    //           },
    //         );
    //       }
    //     } else {
    //       return SizedBox(
    //         width: MediaQuery.of(context).size.width,
    //         height: MediaQuery.of(context).size.height,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: const <Widget>[
    //             Text('Please wait...'),
    //             CircularProgressIndicator(),
    //           ],
    //         ),
    //       );
    //     }
    //   },
    // );
    return FutureProvider<List<Character>>(
        // updateShouldNotify: (first, second) => first == second,
        initialData: const [],
        create: (_) => context.read<CharactersModel>().loadCharacters(),
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
                                color: Color(
                                  int.parse(_characterModel
                                      .character.playerClass.classColor),
                                ).withOpacity(0.1),
                              ),
                            ),
                          ),
                        ),
                        ChangeNotifierProvider.value(
                          value: _characterModel,
                          // ignore: prefer_const_constructors
                          child: const CharacterScreen(),
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

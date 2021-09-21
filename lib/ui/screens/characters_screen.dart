import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/constants.dart';
import '../../models/character.dart';
import '../../shared_prefs.dart';
import 'character_screen.dart';
import '../../viewmodels/characters_model.dart';
import '../../viewmodels/character_model.dart';
import '../dialogs/create_character_dialog.dart';
import 'package:provider/provider.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({
    Key key,
  }) : super(key: key);

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  Future<List<Character>> _runFuture;
  CharacterModel cm;

  @override
  void initState() {
    super.initState();
    CharactersModel charactersModel =
        Provider.of<CharactersModel>(context, listen: false);
    charactersModel.pageController =
        PageController(initialPage: SharedPrefs().initialPage);

    _runFuture =
        Provider.of<CharactersModel>(context, listen: false).loadCharacters();
  }

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel =
        Provider.of<CharactersModel>(context, listen: false);
    return FutureBuilder<List<Character>>(
      future: _runFuture,
      builder: (context, AsyncSnapshot<List<Character>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                            left: smallPadding * 2,
                            right: smallPadding * 2,
                          ),
                          child: const Text(
                            'Create your first character using the button below, or restore a backup from the Settings menu',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(smallPadding),
                        ),
                        IconButton(
                          iconSize: MediaQuery.of(context).size.width / 2,
                          icon: Icon(
                            Icons.add_circle,
                            size: MediaQuery.of(context).size.width / 2,
                          ),
                          onPressed: () async {
                            await showDialog<bool>(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return CreateCharacterDialog(
                                  charactersModel: charactersModel,
                                );
                              },
                            );
                          },
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ])),
            );
          } else {
            try {
              charactersModel.currentCharacter =
                  snapshot.data[SharedPrefs().initialPage];
            } catch (e) {
              charactersModel.currentCharacter = snapshot.data[0];
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                snapshot.data.length > 1
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 8,
                        ),
                        child: SmoothPageIndicator(
                          controller: charactersModel.pageController,
                          count: charactersModel.characters.length,
                          effect: ScrollingDotsEffect(
                            dotColor: Colors.grey.withOpacity(0.5),
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: Color(
                              int.parse(
                                charactersModel
                                    .currentCharacter.playerClass.classColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: PageView.builder(
                    controller: charactersModel.pageController,
                    onPageChanged: (index) {
                      charactersModel.updateCurrentCharacter(
                        context,
                        index: index,
                      );
                    },
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, int index) {
                      try {
                        cm = CharacterModel()
                          ..character = charactersModel.characters[index]
                          ..isEditable = charactersModel.isEditMode;
                      } catch (e) {
                        if (e.runtimeType == RangeError) {
                          cm = CharacterModel()
                            ..character = charactersModel.characters[0]
                            ..isEditable = charactersModel.isEditMode;
                        }
                      }
                      return Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SvgPicture.asset(
                                'images/class_icons/${cm.character.playerClass.classIconUrl}',
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.1),
                              ),
                            ),
                          ),
                          ChangeNotifierProvider.value(
                            value: cm,
                            // ignore: prefer_const_constructors
                            child: CharacterScreen(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Text("Building database. Please wait..."),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}

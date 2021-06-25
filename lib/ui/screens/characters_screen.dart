import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_screen.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/create_character_dialog.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';

class CharactersScreen extends StatefulWidget {
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
                            'Create your first character using the button below',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(smallPadding),
                        ),
                        IconButton(
                          iconSize: MediaQuery.of(context).size.width / 2,
                          icon: Icon(FontAwesomeIcons.plusCircle,
                              size: MediaQuery.of(context).size.width / 2),
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
            charactersModel.currentCharacter =
                snapshot.data[SharedPrefs().initialPage];
            return PageIndicatorContainer(
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
                  cm = CharacterModel()
                    ..character = charactersModel.characters[index]
                    ..isEditable = charactersModel.isEditMode;
                  return Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SvgPicture.asset(
                            'images/class_icons/${cm.character.classIcon.replaceFirst(RegExp(r'.png'), '.svg')}',
                            color: Color(
                              int.parse(SharedPrefs().themeColor),
                            ).withOpacity(0.1),
                          ),
                        ),
                      ),
                      ChangeNotifierProvider.value(
                        value: cm,
                        child: CharacterScreen(),
                      ),
                    ],
                  );
                },
              ),
              align: IndicatorAlign.top,
              length: snapshot.data.length,
              indicatorSpace: smallPadding,
              padding: const EdgeInsets.only(top: 20),
              indicatorColor: snapshot.data.length < 2
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.25),
              indicatorSelectorColor: snapshot.data.length < 2
                  ? Colors.transparent
                  : Theme.of(context).accentColor,
              shape: IndicatorShape.circle(size: 12),
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

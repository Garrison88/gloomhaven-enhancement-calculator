import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/character_screen.dart';
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
            return Container(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              left: smallPadding * 2,
                              right: smallPadding * 2,
                            ),
                            child: Text(
                              'Create your first character using the button below',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
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
                    print('PAGE CHANGED');
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
                    return Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              'images/class_icons/${cm.character.classIcon}',
                              width: iconSize,
                              color: Color(
                                int.parse(SharedPrefs().themeColor),
                              ).withOpacity(0.1),
                            ),
                          ),
                          ChangeNotifierProvider.value(
                            value: cm,
                            child: CharacterScreen(),
                          ),
                        ],
                      ),
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
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Building database. Please wait..."),
                  CircularProgressIndicator(),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            );
          }
        });
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/new_character.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_screen.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';

class CharactersPage extends StatefulWidget {
  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  PageController _pageController =
      PageController(initialPage: prefs.getInt('position') ?? 0);
  Future<List<Character>> _runFuture;
  @override
  void initState() {
    super.initState();
    _runFuture =
        Provider.of<CharactersModel>(context, listen: false).loadCharacters();
  }

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel =
        Provider.of<CharactersModel>(context, listen: false);
    return Scaffold(
      body: FutureBuilder<List<Character>>(
          future: _runFuture,
          builder: (context, AsyncSnapshot<List<Character>> snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: Text(
                  snapshot.error.toString(),
                ),
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
                                'Import your existing character or create a new one using the menu below',
                                style:
                                    TextStyle(fontFamily: nyala, fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(smallPadding),
                            ),
                            Transform.rotate(
                              angle: 45 * pi / 180,
                              child: Icon(FontAwesomeIcons.arrowCircleRight,
                                  size: MediaQuery.of(context).size.width / 2,
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                          ])),
                );
              } else {
                return PageIndicatorContainer(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => updateCurrentCharacter(index),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                  'images/class_icons/${snapshot.data[index].classIcon}',
                                  width: iconWidth,
                                  color: Color(int.parse(Provider.of<AppModel>(
                                              context,
                                              listen: false)
                                          .accentColor))
                                      .withOpacity(0.1)),
                            ),
                            SingleChildScrollView(
                              child: ChangeNotifierProvider<CharacterModel>(
                                create: (context) => CharacterModel(
                                    character: snapshot.data[index]),
                                child: Container(
                                  padding: EdgeInsets.all(smallPadding),
                                  child: CharacterScreen(),
                                ),
                              ),
                            )
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
          }),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            label: 'New Character',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext _) {
                  return NewCharacterDialog(
                    charactersModel: charactersModel,
                  );
                },
              ).then((_) {
                setState(() {});
                if (charactersModel.characters.length <= 1) {
                  Provider.of<AppModel>(context, listen: false).accentColor =
                      charactersModel.characters[0].classColor;
                } else {
                  _pageController.animateToPage(
                    charactersModel.characters.length - 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }
              });
            },
          ),
          // SpeedDialChild(
          //     child: Icon(Icons.save_alt),
          //     backgroundColor: Colors.blue,
          //     label: 'Import Character',
          //     labelStyle: TextStyle(fontSize: 18.0),
          //     onTap: () => charactersModel.addLegacyCharacter().whenComplete(
          //         () => _pageController.animateToPage(
          //             charactersModel.characters.length,
          //             duration: Duration(milliseconds: 600),
          //             curve: Curves.decelerate))),
        ],
      ),
    );
    // });
  }

  updateCurrentCharacter(int index) {
    prefs.setInt('position', index);
    Provider.of<AppModel>(context, listen: false).accentColor =
        Provider.of<CharactersModel>(context, listen: false)
            .characters[index]
            .classColor;
  }
}

import 'dart:math';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/create_character_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_screen.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';

class CharactersPage extends StatefulWidget {
  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  PageController _pageController =
      PageController(initialPage: SharedPrefs().initialPage);
  Future<List<Character>> _runFuture;
  @override
  void initState() {
    super.initState();
    _runFuture =
        Provider.of<CharactersModel>(context, listen: false).loadCharacters();
  }

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = Provider.of<CharactersModel>(context);
    return Scaffold(
      body: FutureBuilder<List<Character>>(
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
                                'Create a new character using the menu below',
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
                    onPageChanged: (index) => updateCurrentCharacter(
                      context,
                      index,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, int index) {
                      CharacterModel cm = CharacterModel();
                      cm.character = snapshot.data[index];
                      print('AT CREATION HASHCODE IS:::: ${cm.hashCode}');
                      return Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                  'images/class_icons/${snapshot.data[index].classIcon}',
                                  width: iconWidth,
                                  color:
                                      Color(int.parse(SharedPrefs().themeColor))
                                          .withOpacity(0.1)),
                            ),
                            SingleChildScrollView(
                              child: ChangeNotifierProvider.value(
                                  value: cm,
                                  child: Container(
                                    padding: EdgeInsets.all(smallPadding),
                                    child: CharacterScreen(),
                                  )),
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
                builder: (_) {
                  return CreateCharacterDialog(
                    charactersModel: charactersModel,
                  );
                },
              ).then((result) {
                if (result) {
                  setState(() {});
                  if (charactersModel.characters.length == 1) {
                    updateCurrentCharacter(context, 0);
                    // Provider.of<AppModel>(context, listen: false).accentColor =
                    //     charactersModel.characters[0].classColor;
                  } else {
                    _pageController.animateToPage(
                      charactersModel.characters.length - 1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  }
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
}

updateCurrentCharacter(
  BuildContext context,
  int index,
) {
  SharedPrefs().initialPage = index;
  SharedPrefs().themeColor =
      Provider.of<CharactersModel>(context, listen: false)
          .characters[index]
          .classColor;
  // Provider.of<AppModel>(context, listen: false).accentColor =
  //     Provider.of<CharactersModel>(context, listen: false)
  //         .characters[index]
  //         .classColor;
  EasyDynamicTheme.of(context).changeTheme(dynamic: true);
}

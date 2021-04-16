import 'dart:math';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
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

class _CharactersScreenState extends State<CharactersScreen>
    with TickerProviderStateMixin {
  AnimationController _hideFabAnimation;
  PageController _pageController =
      PageController(initialPage: SharedPrefs().initialPage);
  Future<List<Character>> _runFuture;

  @override
  void initState() {
    super.initState();
    _runFuture =
        Provider.of<CharactersModel>(context, listen: false).loadCharacters();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _hideFabAnimation.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
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
                                'Create your first character using the button below',
                                style:
                                    TextStyle(fontFamily: nyala, fontSize: 24),
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
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return CreateCharacterDialog(
                                      charactersModel: charactersModel,
                                    );
                                  },
                                ).then((result) {
                                  if (result) {
                                    CharactersModel charactersModel =
                                        Provider.of<CharactersModel>(context,
                                            listen: false);
                                    setState(() {});
                                    if (charactersModel.characters.length ==
                                        1) {
                                      updateCurrentCharacter(context, 0);
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
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ])),
                );
              } else {
                return PageIndicatorContainer(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _hideFabAnimation.forward();
                      return updateCurrentCharacter(
                        context,
                        index,
                      );
                    },
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
                            NotificationListener<ScrollNotification>(
                              onNotification: _handleScrollNotification,
                              child: SingleChildScrollView(
                                child: ChangeNotifierProvider.value(
                                    value: cm,
                                    child: Container(
                                      padding: EdgeInsets.all(smallPadding),
                                      child: CharacterScreen(),
                                    )),
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
      floatingActionButton: ScaleTransition(
        scale: _hideFabAnimation,
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return CreateCharacterDialog(
                  charactersModel: charactersModel,
                );
              },
            ).then((result) {
              if (result) {
                CharactersModel charactersModel =
                    Provider.of<CharactersModel>(context, listen: false);
                setState(() {});
                if (charactersModel.characters.length == 1) {
                  updateCurrentCharacter(context, 0);
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
      ),
    );
  }
}

updateCurrentCharacter(
  BuildContext context,
  int index,
) {
  SharedPrefs().initialPage = index;
  SharedPrefs().themeColor =
      Provider.of<CharactersModel>(context, listen: false).characters.isNotEmpty
          ? Provider.of<CharactersModel>(context, listen: false)
              .characters[index]
              .classColor
          : '0xff4e7ec1';
  EasyDynamicTheme.of(context).changeTheme(dynamic: true);
}

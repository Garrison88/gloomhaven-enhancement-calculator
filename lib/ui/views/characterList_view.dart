import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gloomhaven_enhancement_calc/core/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/core/models/character.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/base_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/characterList_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/locator.dart';
import 'package:gloomhaven_enhancement_calc/ui/views/base_view.dart';
import 'package:gloomhaven_enhancement_calc/ui/views/character_view.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/dialogs/new_character.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';

class CharacterListView extends StatefulWidget {
  // CharactersListService get service => GetIt.I<CharactersListService>();

  @override
  _CharacterListViewState createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  PageController _pageController;
  @override
  Widget build(BuildContext context) => BaseView<CharacterListModel>(
        onModelReady: (model) => model.fetchCharacterList(),
        builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomPadding: true,
          body: model.state == ViewState.Busy
              ? Container(
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
                )
              : model.characterList.length > 0
                  ? PageIndicatorContainer(
                      child: getCharactersUi(model.characterList),
                      align: IndicatorAlign.top,
                      length: model.characterList.length,
                      indicatorSpace: smallPadding,
                      padding: const EdgeInsets.only(top: 20),
                      indicatorColor: model.characterList.length < 2
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.25),
                      indicatorSelectorColor: model.characterList.length < 2
                          ? Colors.transparent
                          : Theme.of(context).accentColor,
                      shape: IndicatorShape.circle(size: 12),
                    )
                  : Center(
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
                                      right: smallPadding * 2),
                                  child: Text(
                                    'Import your existing character or create a new one using the menu below',
                                    style: TextStyle(
                                        fontFamily: nyala, fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(smallPadding),
                                ),
                                Transform.rotate(
                                  angle: 45 * pi / 180,
                                  child: Icon(FontAwesomeIcons.arrowCircleRight,
                                      size:
                                          MediaQuery.of(context).size.width / 2,
                                      color: Colors.grey.withOpacity(0.5)),
                                ),
                              ])
                          // onPressed: () => print("PRESSED"),
                          // ],
                          // ),
                          ),
                    ),
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
                    builder: (BuildContext context) {
                      return NewCharacterDialog(characterListModel: model);
                    },
                  ).whenComplete(() => _pageController.animateToPage(
                      model.characterList.length,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.decelerate));
                },
              ),
              SpeedDialChild(
                  child: Icon(Icons.save_alt),
                  backgroundColor: Colors.blue,
                  label: 'Import Character',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () => model.addLegacyCharacter().whenComplete(() =>
                      _pageController.animateToPage(model.characterList.length,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.decelerate))),
              // SpeedDialChild(
              //     child: Icon(Icons.add),
              //     backgroundColor: Colors.green,
              //     label: 'OPEN OLD CHAR SHEET',
              //     labelStyle: TextStyle(fontSize: 18.0),
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => CharacterSheetPage()),
              //       );
              //     })
            ],
          ),
        ),
        // ),
      );
  // );
  // });

  Widget getCharactersUi(List<Character> characterList) => PageView.builder(
        controller: _pageController = PageController(
            initialPage:
                Provider.of<AppModel>(context, listen: false).position),
        onPageChanged: (_index) {
          Provider.of<AppModel>(context, listen: false).position = _index;
          Provider.of<AppModel>(context, listen: false)
              .setAccentColor(characterList[_index].classColor);
        },
        itemCount: characterList.length,
        itemBuilder: (BuildContext context, int _index) {
          // Provider.of<CharacterModel>(context, listen: false)
          //     .character = model.characterList[_index];
          return BaseView<CharacterModel>(
            onModelReady: (model) => model.character = characterList[_index],
            builder: (context, model, child) => Scaffold(
              resizeToAvoidBottomPadding: true,
              body: model.state == ViewState.Busy
                  ? Container(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                                'images/class_icons/${characterList[_index].classIcon}',
                                width: iconWidth,
                                color: Provider.of<AppModel>(context,
                                        listen: false)
                                    .accentColor
                                    .withOpacity(0.1)

                                // Theme.of(context)
                                //     .accentColor
                                //     .withOpacity(.1),
                                ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color:
                          //         Colors.white.withOpacity(0.95),
                          //     image: DecorationImage(
                          //       image: AssetImage(
                          //           'images/class_icons/${model.characterList[_index].classIcon}'),
                          //       colorFilter: ColorFilter.mode(
                          //           Theme.of(context).accentColor
                          //               .withOpacity(0.95),
                          //           BlendMode.lighten),
                          //     ),
                          //   ),
                          // ),
                          // Container(
                          //   color: Theme.of(context)
                          //       .accentColor
                          //       .withOpacity(0.2),
                          // ),
                          SingleChildScrollView(
                            child: CharacterView(character: model.character),
                          ),
                          // ),
                        ],
                      ),
                    ),
            ),
          );
        },
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/providers/app_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_list_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/new_character.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_sheet_page.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterListPage extends StatefulWidget {
  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    // final AppState appState = Provider.of<AppState>(context, listen: false);
    // _pageController.jumpToPage(appState.position);
    return Consumer<CharacterListState>(builder:
        (BuildContext context, CharacterListState characterListState, _) {
      print("CHARACTER LIST PAGE REBUILT");
      return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: FutureBuilder<bool>(
            future: characterListState.setCharacterList(),
            builder: (context, AsyncSnapshot<bool> _snapshot) {
              return _snapshot.hasError
                  ? Container(child: Text(_snapshot.error.toString()))
                  : !_snapshot.hasData
                      ? Container(
                          child: Center(child: CircularProgressIndicator()),
                          height: MediaQuery.of(context).size.height,
                        )
                      : PageIndicatorContainer(
                          child: PageView.builder(
                            controller: _pageController = PageController(
                                initialPage: Provider.of<AppState>(context,
                                        listen: false)
                                    .position),
                            onPageChanged: (_index) {
                              Provider.of<AppState>(context, listen: false)
                                  .position = _index;
                              Provider.of<AppState>(context, listen: false)
                                  .setAccentColor(characterListState
                                      .characterList[_index].classColor);
                            },
                            itemCount: characterListState.characterList.length,
                            itemBuilder: (BuildContext context, int _index) {
                              return Container(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'images/class_icons/${characterListState.characterList[_index].classIcon}'),
                                          colorFilter: ColorFilter.mode(
                                              Colors.white.withOpacity(0.9),
                                              BlendMode.lighten),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2),
                                    ),
                                    SingleChildScrollView(
                                      child: ChangeNotifierProvider<
                                          CharacterState>.value(
                                        value: CharacterState(characterListState
                                            .characterList[_index]),
                                        child: Container(
                                          padding: EdgeInsets.all(smallPadding),
                                          child: CharacterPage(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          align: IndicatorAlign.top,
                          length: characterListState.characterList.length,
                          indicatorSpace: smallPadding,
                          padding: const EdgeInsets.only(top: 20),
                          indicatorColor: Colors.white,
                          indicatorSelectorColor: Theme.of(context).accentColor,
                          shape: IndicatorShape.circle(size: 12),
                        );
              // shape: IndicatorShape.roundRectangleShape(size: Size.square(12),cornerSize: Size.square(3)),
              // shape: IndicatorShape.oval(size: Size(12, 8)),
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
                child: Icon(Icons.save_alt),
                backgroundColor: Colors.blue,
                label: 'Import Legacy Character',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async => await characterListState
                    .addLegacyCharacter()
                    .whenComplete(() => _pageController.animateToPage(
                        characterListState.characterList.length,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.decelerate))),
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
              label: 'Add New Character',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NewCharacterDialog(
                        characterListState: characterListState);
                  },
                ).whenComplete(() => _pageController.animateToPage(
                    characterListState.characterList.length,
                    duration: Duration(milliseconds: 600),
                    curve: Curves.decelerate));
              },
            ),
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
      );
    });
  }
}

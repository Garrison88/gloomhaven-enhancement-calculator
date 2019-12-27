import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
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
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final CharacterListState characterListState =
        Provider.of<CharacterListState>(context);
    // _pageController.jumpToPage(appState.position);
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
                          controller: _pageController =
                              PageController(initialPage: appState.position),
                          onPageChanged: (_index) async {
                            var prefs = await SharedPreferences.getInstance();
                            appState.position = _index;
                            prefs.setInt('position', _index);
                            appState.setTheme(characterListState
                                .characterList[_index].classColor);
                            prefs.setString(
                                'themeColor',
                                characterListState
                                    .characterList[_index].classColor);
                          },
                          itemCount: characterListState.characterList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.all(smallPadding),
                              child: Card(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'images/class_icons/${characterListState.characterList[index].classIcon}'),
                                          colorFilter: ColorFilter.mode(
                                              Colors.white.withOpacity(0.9),
                                              BlendMode.lighten),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        color: Color(int.parse(
                                                characterListState
                                                    .characterList[index]
                                                    .classColor))
                                            .withOpacity(0.2)),
                                    SingleChildScrollView(
                                      child: ChangeNotifierProvider<
                                          CharacterState>(
                                        builder: (context) => CharacterState(
                                          characterListState
                                              .characterList[index].id,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(smallPadding),
                                          child: CharacterPage(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        align: IndicatorAlign.top,
                        length: characterListState.characterList.length,
                        indicatorSpace: smallPadding,
                        padding: const EdgeInsets.only(top: 20),
                        indicatorColor: Colors.white,
                        indicatorSelectorColor: appState.accentColor,
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
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor,
              label: 'Import Legacy Character',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async => await characterListState.addLegacyCharacter()),
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            label: 'Add New Character',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NewCharacterDialog(characterListState: characterListState);
                },
              );
              _pageController
                  .jumpToPage(characterListState.characterList.length + 1);
            },
          ),
          SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
              label: 'OPEN OLD CHAR SHEET',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharacterSheetPage()),
                );
              })
        ],
      ),
    );
  }
}

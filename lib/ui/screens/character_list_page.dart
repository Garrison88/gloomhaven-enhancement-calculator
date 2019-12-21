import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_list_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/new_character.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_sheet_page.dart';
import 'package:provider/provider.dart';

class CharacterListPage extends StatefulWidget {
  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  @override
  Widget build(BuildContext context) {
    final CharacterListState characterListState =
        Provider.of<CharacterListState>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: FutureBuilder<bool>(
          future: characterListState.setCharacterList(),
          builder: (context, AsyncSnapshot<bool> _snapshot) {
            return _snapshot.hasError
                ? Container(child: Text(_snapshot.error.toString()))
                : !_snapshot.hasData
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        child: PageView.builder(
                          // store this controller in a State to save the carousel scroll position
                          controller: PageController(viewportFraction: .95),
                          itemCount: characterListState.characterList.length,
                          itemBuilder: (BuildContext context, int index) {
                            // Character _character =
                            //     ;
                            return SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  // Card(
                                  //   child: Container(
                                  //     height: 58,
                                  //     width: MediaQuery.of(context).size.width,
                                  //     color: Color(int.parse(_character.classColor)),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.start,
                                  //       children: <Widget>[
                                  //         Expanded(
                                  //           child: Image.asset(
                                  //             'images/class_icons/${_character.classIcon}',
                                  //             color: Color(int.parse(
                                  //                 _character.classColor)),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //             child: AutoSizeText(
                                  //           _character.name,
                                  //           minFontSize: titleFontSize,
                                  //           maxLines: 1,
                                  //           overflow: TextOverflow.ellipsis,
                                  //           style: TextStyle(
                                  //               fontFamily: nyala,
                                  //               color: Colors.white),
                                  //         ))
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Card(
                                    child:
                                        ChangeNotifierProvider<CharacterState>(
                                      builder: (context) => CharacterState(
                                        characterListState
                                            .characterList[index].id,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(smallPadding),
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: CharacterPage(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
          }),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return NewCharacterDialog(charactersState: characterListState);
              },
            ),
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

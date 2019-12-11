import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/characters_list_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/new_character.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_details.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_sheet_page.dart';
import 'package:provider/provider.dart';

class CharacterListPage extends StatefulWidget {
  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  // DatabaseHelper db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final CharactersListState charactersListState =
        Provider.of<CharactersListState>(context);
    return Container(
      child: Scaffold(
        body: FutureBuilder<bool>(
            future: charactersListState.setCharactersList(),
            builder: (context, AsyncSnapshot<bool> _snapshot) {
              // switch (_snapshot.data) {
              // case false:
              if (!_snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return _snapshot.hasError
                    ? Container(child: Text(_snapshot.error.toString()))
                    : ListView.builder(
                        itemCount:
                            charactersListState.getCharactersList().length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider<CharacterState>(
                                          builder: (context) => CharacterState(
                                            charactersListState
                                                .getCharactersList()[index].id,
                                          ),
                                          child: CharacterDetails(
                                              // characterId:
                                              //     _snapshot.data[index].id,
                                              ),
                                        )),
                              );
                            },
                            child: Card(
                              child: Container(
                                height: 58,
                                // color: Color(int.parse(charactersList[index].classColor)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Image.asset(
                                        'images/class_icons/${charactersListState.getCharactersList()[index].classIcon}',
                                        color: Color(int.parse(
                                            charactersListState
                                                .getCharactersList()[index]
                                                .classColor)),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      charactersListState
                                          .getCharactersList()[index]
                                          .name,
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              charactersListState
                                                  .getCharactersList()[index]
                                                  .classColor))),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
              }

              // break;
              // default:
              // ;
              // }
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
                onTap: () async =>
                    await charactersListState.addLegacyCharacter()),
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
              label: 'Add New Character',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NewCharacterDialog(
                      charactersState: charactersListState);
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
                    MaterialPageRoute(
                        builder: (context) => CharacterSheetPage()),
                  );
                })
          ],
        ),
      ),
    );
  }
}

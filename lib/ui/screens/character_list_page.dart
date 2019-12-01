import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/providers/characters_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/new_character.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_sheet_page.dart';
import 'package:provider/provider.dart';

class CharacterListPage extends StatefulWidget {
  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  // List<Character> charactersList = List();

  DatabaseHelper db = DatabaseHelper.instance;
  // List<Character> charactersState = List();

  @override
  void initState() {
    super.initState();
    // db.queryAllRows().then((characters) {
    //   setState(() {
    //     characters.forEach((character) {
    //       charactersList.add(Character.fromMap(character));
    //       print(character.toString());
    //     });
    //   });
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   // final CharactersState charactersState = Provider.of<CharactersState>(context);
  //   // charactersState.setCharactersList();
  //   print("*********DID CHANGE DEPENDENCIES " + charactersList.toString());
  //   super.didChangeDependencies();
  // }

  // List<Character> updateCharactersList() {
  //   db.queryAllRows().then((characters) {
  //       characters.forEach((character) {
  //         charactersList.add(Character.fromMap(character));
  //         print(character.toString());
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final CharactersState charactersState =
        Provider.of<CharactersState>(context);
    DatabaseHelper db = DatabaseHelper.instance;
    // charactersState.setCharactersList();
    // print("********BUILD METHOD " + charactersList.toString());
    return Container(
      child: Scaffold(
        body: ListView.builder(
            itemCount: charactersState.getCharactersList().length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  print(await db
                      .queryCharacterRow(charactersState
                          .getCharactersList()[index]
                          .characterId)
                      .then((char) {
                    return char.name;
                  }));
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CharacterSheetPage(
                  //       character: charactersState.getCharactersList()[index],
                  //     ),
                  //   ),
                  // );
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
                            'images/class_icons/${charactersState.getCharactersList()[index].classIcon}',
                            color: Color(int.parse(charactersState
                                .getCharactersList()[index]
                                .classColor)),
                          ),
                        ),
                        Expanded(
                            child: Text(
                          charactersState.getCharactersList()[index].name,
                          style: TextStyle(
                              color: Color(int.parse(charactersState
                                  .getCharactersList()[index]
                                  .classColor))),
                        ))
                      ],
                    ),
                  ),
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
                onTap: () async => await charactersState.addLegacyCharacter()),
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
              label: 'Add New Character',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NewCharacterDialog(charactersState: charactersState);
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
      ),
    );
  }
}

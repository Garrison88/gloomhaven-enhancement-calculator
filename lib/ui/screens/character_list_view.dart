import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/new_character.dart';

class CharacterListView extends StatefulWidget {
  @override
  _CharacterListViewState createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  List<Character> charactersList = List();
  DatabaseHelper db = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    db.queryAllRows().then((characters) {
      setState(() {
        characters.forEach((character) {
          charactersList.add(Character.fromMap(character));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: ListView.builder(
              itemCount: charactersList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    print(db.queryRow(index));
                  },
                  child: Card(
                    child: Container(
                      height: 50,
                      color: Colors.blue,
                      child: Center(child: Text(charactersList[index].name)),
                    ),
                  ),
                );
              }),
          floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              onPressed: () {
                showDialog(context: context, child: NewCharacterDialog());
              },
              child: Icon(Icons.add))),
    );
  }
}

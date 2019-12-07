import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_list.dart';
import 'package:provider/provider.dart';

class CharacterDetails extends StatefulWidget {
  final characterId;

  CharacterDetails({Key key, this.characterId}) : super(key: key);

  @override
  _CharacterDetailsState createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  // String perk = '';
  List _perks = [];

  @override
  void initState() {
    // _perks = db.queryPerks("SW").then((_perksList) => _perks = _perksList);
    // db.queryCharacterPerk(widget.characterId).then((list) {
    //   // perk = list.associatedPerkId.toString();
    //   // print("SHOULD MATCH CHARACTER ID" + list.associatedPerkId.toString());
    // });
    super.initState();
  }

  final DatabaseHelper db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final CharacterState characterState = Provider.of<CharacterState>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          FutureBuilder<Character>(
              future: characterState.getCharacter(widget.characterId),
              builder: (context, AsyncSnapshot<Character> _snapshot) {
                switch (_snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    return _snapshot.hasError
                        ? Container(child: Text(_snapshot.error.toString()))
                        : Column(
                            children: <Widget>[
                              Text(_snapshot.data.name),
                              Text(_snapshot.data.classCode),
                              Text(_snapshot.data.classColor),
                              Text(_snapshot.data.classIcon),
                              Text("Check Marks: " +
                                  _snapshot.data.checkMarks.toString()),
                              Text("XP: " + _snapshot.data.xp.toString()),
                              Text(_snapshot.data.name),
                              Text("Gold: " + _snapshot.data.gold.toString()),
                              Text(_snapshot.data.notes),
                              FlatButton(
                                child: Text('DELETE'),
                                onPressed: () {
                                  characterState
                                      .deleteCharacter(_snapshot.data.id);
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                }
              }),
          FutureBuilder<List>(
              future: characterState.getCharacterPerks(widget.characterId),
              builder: (context, AsyncSnapshot<List> _snapshot) {
                switch (_snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    return _snapshot.hasError
                            ? Container(child: Text(_snapshot.error.toString()))
                            // : Expanded(child: PerkList(perkList: _snapshot.data))
                            : Text(_snapshot.data.toString())
                        // ListView.builder(
                        //     scrollDirection: Axis.vertical,
                        //     shrinkWrap: true,
                        //     itemCount: _snapshot.data.length,
                        //     itemBuilder: (BuildContext context, int index) {
                        //       print(_snapshot.data[index].toString());
                        //       return Text(_snapshot.data[index].toString());
                        //     })
                        ;
                }
              })

          // Text(perk),
        ],
      ),
    );
  }
}

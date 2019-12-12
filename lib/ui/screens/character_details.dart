import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_perks_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_list.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:provider/provider.dart';

class CharacterDetails extends StatefulWidget {
  // final characterId;

  // CharacterDetails({Key key, this.characterId}) : super(key: key);

  @override
  _CharacterDetailsState createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  // final DatabaseHelper db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final CharacterState characterState = Provider.of<CharacterState>(context);
    return Scaffold(
        body: Container(
      child: FutureBuilder<bool>(
        future: characterState.setCharacter(),
        builder: (context, AsyncSnapshot<bool> _characterSnapshot) =>
            _characterSnapshot.data == true
                ? _characterSnapshot.hasError
                    ? Container(
                        child: Text(_characterSnapshot.error.toString()))
                    : CustomScrollView(slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Text(characterState.getCharacter().name),
                            Text(characterState.getCharacter().classCode),
                            Text(characterState.getCharacter().classColor),
                            Text(characterState.getCharacter().classIcon),
                            Text("Check Marks: " +
                                characterState
                                    .getCharacter()
                                    .checkMarks
                                    .toString()),
                            Text("XP: " +
                                characterState.getCharacter().xp.toString()),
                            Text(characterState.getCharacter().name),
                            Text("Gold: " +
                                characterState.getCharacter().gold.toString()),
                            Text(characterState.getCharacter().notes),
                            FlatButton(
                              child: Text('DELETE'),
                              onPressed: () {
                                characterState.deleteCharacter(
                                    characterState.getCharacter().id);
                                Navigator.of(context).pop();
                              },
                            )
                          ]),
                        ),
                        ChangeNotifierProvider<CharacterPerksState>(
                          builder: (context) => CharacterPerksState(
                              characterState.getCharacter().id),
                          child: PerkList(),
                        )
                      ])
                : Center(child: CircularProgressIndicator()),
      ),
    ));
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_perks_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_list.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:provider/provider.dart';

class CharacterDetails extends StatefulWidget {

  @override
  _CharacterDetailsState createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {

  @override
  Widget build(BuildContext context) {
    final CharacterState characterState = Provider.of<CharacterState>(context);
    // return Scaffold(
    //     body: Container(
    //   child: 
      return FutureBuilder<bool>(
        future: characterState.setCharacter(),
        builder: (context, AsyncSnapshot<bool> _characterSnapshot) =>
            _characterSnapshot.data == true
                ? _characterSnapshot.hasError
                    ? Container(
                        child: Text(_characterSnapshot.error.toString()))
                    : CustomScrollView( slivers: <Widget>[
                        // SliverAppBar(
                        //   floating: true,
                        //   centerTitle: true,
                        //   title: AutoSizeText(
                        //     characterState.character.name,
                        //     maxLines: 1,
                        //     minFontSize: dialogFontSize,
                        //     style: TextStyle(fontFamily: highTower, fontSize: titleFontSize),
                        //   ),
                        //   backgroundColor: Color(int.parse(
                        //       characterState.character.classColor)),
                        // ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'images/class_icons/${characterState.character.classIcon}'),
                                    colorFilter: ColorFilter.mode(
                                        Colors.white.withOpacity(0.95),
                                        BlendMode.lighten),
                                    fit: BoxFit.fitWidth),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(characterState.character.classCode),
                                  Text(
                                      characterState.character.classColor),
                                  Text(characterState.character.classIcon),
                                  Text("Check Marks: " +
                                      characterState
                                          .character
                                          .checkMarks
                                          .toString()),
                                  Text("XP: " +
                                      characterState
                                          .character
                                          .xp
                                          .toString()),
                                  Text(characterState.character.name),
                                  Text("Gold: " +
                                      characterState
                                          .character
                                          .gold
                                          .toString()),
                                  Text(characterState.character.notes),
                                  FlatButton(
                                    child: Text('DELETE'),
                                    onPressed: () {
                                      characterState.deleteCharacter(
                                          characterState.character.id);
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                        ChangeNotifierProvider<CharacterPerksState>(
                          builder: (context) => CharacterPerksState(
                              characterState.character.id),
                          child: PerkList(),
                        )
                      ])
                : Center(child: CircularProgressIndicator()),
      );
    // ));
  }
}

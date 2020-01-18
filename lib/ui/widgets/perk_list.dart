import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/providers/app_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_perks_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

class PerkList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PerkListState();
}

class PerkListState extends State<PerkList> {
  Widget build(BuildContext context) {
    final CharacterState characterState =
        Provider.of<CharacterState>(context, listen: false);
    return FutureBuilder<bool>(
        future: Provider.of<CharacterState>(context).setCharacterPerks(),
        builder: (context, AsyncSnapshot<bool> _perksSnapshot) => _perksSnapshot
                    .data ==
                true
            ? _perksSnapshot.hasError
                ? Container(child: Text(_perksSnapshot.error.toString()))
                : Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(bottom: smallPadding)),
                      Container(
                          padding: EdgeInsets.all(smallPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Perks (',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: titleFontSize),
                              ),
                              Text('${characterState.numOfSelectedPerks}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: titleFontSize,
                                      color: (characterState.getMaximumPerks() +
                                                  Provider.of<AppState>(context,
                                                          listen: false)
                                                      .retirements) >=
                                              characterState.numOfSelectedPerks
                                          ? Colors.black
                                          : Colors.red)),
                              Text(
                                  ' / ${characterState.getMaximumPerks() + Provider.of<AppState>(context, listen: false).retirements})',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: titleFontSize))
                            ],
                          )),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),

                        // crossAxisCount: 1,
                        // childAspectRatio: 5,
                        children: List.generate(
                            characterState.characterPerks.length,
                            (index) => PerkRow(
                                perk: characterState.characterPerks[index])),
                      ),
                      Container(
                        height: 58,
                      )
                    ],
                  )
            : CircularProgressIndicator());
  }
}

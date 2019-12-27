import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_perks_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

class PerkList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PerkListState();
}

class PerkListState extends State<PerkList> {
  Widget build(BuildContext context) {
    final CharacterPerksState characterPerksState =
        Provider.of<CharacterPerksState>(context);
    return FutureBuilder<bool>(
        future: characterPerksState
            .setCharacterPerks(characterPerksState.characterId),
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
                        child: Text(
                          'Perks',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: titleFontSize),
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),

                        // crossAxisCount: 1,
                        // childAspectRatio: 5,
                        children: List.generate(
                            characterPerksState.characterPerks.length,
                            (index) => PerkRow(
                                perk:
                                    characterPerksState.characterPerks[index])),
                      ),
                      Container(height: 58,)
                    ],
                  )
            : CircularProgressIndicator());
  }
}

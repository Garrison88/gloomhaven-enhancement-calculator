import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_perks_state.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';

class PerkList extends StatefulWidget {
  // final int _characterId;

  // PerkList(this._characterId);

  @override
  State<StatefulWidget> createState() => PerkListState();
}

class PerkListState extends State<PerkList> {
  Widget build(BuildContext context) {
    final CharacterPerksState characterPerksState =
        Provider.of<CharacterPerksState>(context);
    return FutureBuilder<bool>(
        future: characterPerksState
            .setCharacterPerks(characterPerksState.getCharacterId()),
        builder: (context, AsyncSnapshot<bool> _perksSnapshot) {
          // bool _isChecked;
          return _perksSnapshot.data == true
              ? _perksSnapshot.hasError
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                      Container(child: Text(_perksSnapshot.error.toString()))
                    ]))
                  : SliverGrid.count(
                      crossAxisCount: 1,
                      childAspectRatio: 5,
                      children: List.generate(
                          characterPerksState.getCharacterPerks().length,
                          (index) => Row(
                                children: <Widget>[
                                  // Checkbox(
                                  //   value: _isChecked,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       _isChecked = value;
                                  //     });
                                  //   },
                                  // ),
                                  Checkbox(
                                      value: characterPerksState
                                          .getCharacterPerks()[index]
                                          .characterPerkIsSelected,
                                      onChanged: (value) {
                                        // setState(
                                        //   () {
                                            characterPerksState.togglePerk(
                                                characterPerksState
                                                        .getCharacterPerks()[
                                                    index]);
                                          },
                                        ),
                                      // }),
                                  Container(
                                    height: 30.0,
                                    width: 1.0,
                                    color: Theme.of(context).accentColor,
                                    margin: EdgeInsets.only(right: 10.0),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      "Character ID is: ${characterPerksState.getCharacterPerks()[index].associatedCharacterId} and Perk ID is: ${characterPerksState.getCharacterPerks()[index].associatedPerkId}",
                                      maxLines: 2,
                                      style: TextStyle(fontFamily: nyala),
                                    ),
                                  )
                                ],
                              )),
                    )
              : SliverList(
                  delegate:
                      SliverChildListDelegate([CircularProgressIndicator()]));
        });

    // });
  }

// Future<String> getPerkDetails(int _index) async {
//   String _details = await characterPerksState.getPerkDetails(characterPerksState.getCharacterPerks()[].associatedPerkId;
// }

}
// };

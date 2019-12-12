import 'package:flutter/material.dart';
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
            .setCharacterPerks(characterPerksState.getCharacterId()),
        builder: (context, AsyncSnapshot<bool> _perksSnapshot) {
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
                          (index) => PerkRow(
                              perk: characterPerksState
                                  .getCharacterPerks()[index])),
                    )
              : SliverList(
                  delegate:
                      SliverChildListDelegate([CircularProgressIndicator()]));
        });
  }
}

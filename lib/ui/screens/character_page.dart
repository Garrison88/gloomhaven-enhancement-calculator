import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_perks_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/character_details.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/check_mark_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_list.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:provider/provider.dart';

class CharacterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CharacterState characterState = Provider.of<CharacterState>(context);
    return FutureBuilder<bool>(
        future: characterState.setCharacter(),
        builder: (context, AsyncSnapshot<bool> _characterSnapshot) =>
            _characterSnapshot.data == true
                ? _characterSnapshot.hasError
                    ? Container(
                        child: Text(_characterSnapshot.error.toString()))
                    : Container(
                        child: Column(
                          children: <Widget>[
                            CharacterDetails(),
                            CheckMarkSection(),
                            ChangeNotifierProvider<CharacterPerksState>(
                              builder: (context) => CharacterPerksState(
                                  characterState.character.id),
                              child: PerkList(),
                            ),
                          ],
                        ),
                      )
                : Center(child: CircularProgressIndicator()));
  }
}

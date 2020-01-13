import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/providers/app_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_perks_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/character_details.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/check_mark_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_list.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:provider/provider.dart';

class CharacterPage extends StatefulWidget {
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).setAccentColor(
          Provider.of<CharacterState>(context, listen: false)
              .character
              .classColor);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final CharacterState characterState = Provider.of<CharacterState>(context);
    // return Consumer<CharacterState>(
    //     builder: (BuildContext context, CharacterState characterState, _) {
    // FutureBuilder<bool>(
    //     future: characterState.setCharacter(),
    //     builder: (context, AsyncSnapshot<bool> _characterSnapshot) =>
    //         _characterSnapshot.data == true
    //             ? _characterSnapshot.hasError
    //                 ? Container(
    //                     child: Text(_characterSnapshot.error.toString()))
    //                 :
    return Container(
      child: Column(
        children: <Widget>[
          CharacterDetails(),
          // characterState.isEditable ? CheckMarkSection() : Container(),
          ChangeNotifierProvider<CharacterPerksState>.value(
            value: CharacterPerksState(
                Provider.of<CharacterState>(context, listen: false)
                    .character
                    .id),
            child: PerkList(),
          ),
        ],
      ),
    );
    // : Center(child: CircularProgressIndicator()));
    // });
  }
}

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/character_details.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/check_mark_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_list.dart';
import 'package:gloomhaven_enhancement_calc/view_model/characterPerks_model.dart';
import 'package:gloomhaven_enhancement_calc/view_model/character_model.dart';
import 'package:provider/provider.dart';

class CharacterPage extends StatefulWidget {
  final Character character;

  CharacterPage({this.character});
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<CharacterModel>(context, listen: false).character =
  //         widget.character;
  //   });
  //   super.initState();
  // }

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
          CheckMarkSection(),
          // ChangeNotifierProvider<CharacterPerksModel>(
          //   create: (context) => CharacterPerksModel(
          //       Provider.of<CharacterModel>(context, listen: false)
          //           .character
          //           .id),
          // child:
          PerkList(),
          // ),
        ],
      ),
    );
    // : Center(child: CircularProgressIndicator()));
    // });
  }
}

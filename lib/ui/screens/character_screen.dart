import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/character_details_section.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatelessWidget {
//   @override
//   _CharacterPageState createState() => _CharacterPageState();
// }

// class _CharacterPageState extends State<CharacterPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      CharacterDetailsSection(),
      PerkSection(
          id: Provider.of<CharacterModel>(context, listen: false).character.id),
    ]));
  }
}

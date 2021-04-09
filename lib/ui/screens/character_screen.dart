import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/character_details_section.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatelessWidget {
//   @override
//   _CharacterScreenState createState() => _CharacterScreenState();
// }

// class _CharacterScreenState extends State<CharacterScreen> {
//   @override
  Widget build(BuildContext context) {
    // CharacterModel characterModel = context.watch<CharacterModel>();
    // CharactersModel charactersModel = context.watch<CharactersModel>();
    return Container(
      child: Column(
        children: <Widget>[
          CharacterDetailsSection(
              // characterModel: characterModel,
              // deleteCharacter: charactersModel.deleteCharacter,
              ),
        ],
      ),
    );
  }
}

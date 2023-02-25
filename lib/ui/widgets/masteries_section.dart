import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/mastery_row.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

class MasteriesSection extends StatefulWidget {
  final CharactersModel charactersModel;
  final Character character;

  const MasteriesSection({
    Key key,
    this.charactersModel,
    this.character,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => MasteriesSectionState();
}

class MasteriesSectionState extends State<MasteriesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Masteries',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: smallPadding + 5,
        ),
        ...widget.character.masteries.map(
          (mastery) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: smallPadding / 2,
            ),
            child: MasteryRow(
              character: widget.character,
              mastery: mastery,
            ),
          ),
        ),
      ],
    );
  }
}

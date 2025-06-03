import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery/mastery.dart';
import 'package:gloomhaven_enhancement_calc/utils/utils.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

class MasteryRow extends StatefulWidget {
  final Character character;
  final Mastery mastery;

  const MasteryRow({
    super.key,
    required this.character,
    required this.mastery,
  });

  @override
  MasteryRowState createState() => MasteryRowState();
}

class MasteryRowState extends State<MasteryRow> {
  double height = 0;

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.watch<CharactersModel>();
    return Container(
      margin: const EdgeInsets.only(right: 6, left: 1),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.character.characterMasteries
                  .firstWhere((mastery) =>
                      mastery.associatedMasteryId == widget.mastery.id)
                  .characterMasteryAchieved
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).dividerColor.withOpacity(0),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(vertical: smallPadding / 2),
      child: Row(
        children: <Widget>[
          Checkbox(
            visualDensity: VisualDensity.comfortable,
            value: widget.character.characterMasteries
                .firstWhere((mastery) =>
                    mastery.associatedMasteryId == widget.mastery.id)
                .characterMasteryAchieved,
            onChanged: charactersModel.isEditMode && !widget.character.isRetired
                ? (bool? value) => value != null
                    ? charactersModel.toggleMastery(
                        characterMasteries: widget.character.characterMasteries,
                        mastery: widget.character.characterMasteries.firstWhere(
                          (mastery) =>
                              mastery.associatedMasteryId == widget.mastery.id,
                        ),
                        value: value,
                      )
                    : null
                : null,
          ),
          Container(
            height: height,
            width: 1,
            color: widget.character.characterMasteries
                    .firstWhere((mastery) =>
                        mastery.associatedMasteryId == widget.mastery.id)
                    .characterMasteryAchieved
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).dividerColor,
            margin: const EdgeInsets.only(right: 12),
          ),
          SizeProviderWidget(
            onChildSize: (Size? size) {
              if (size != null && context.mounted) {
                setState(() {
                  height = size.height * 0.9;
                });
              }
            },
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: smallPadding),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 0.7,
                        ),
                    children: Utils.generateCheckRowDetails(
                      context,
                      widget.mastery.masteryDetails,
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

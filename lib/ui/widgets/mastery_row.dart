import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../shared_prefs.dart';
import '../../utils/utils.dart';
import '../../viewmodels/characters_model.dart';

class MasteryRow extends StatefulWidget {
  final Character character;
  final Mastery mastery;

  const MasteryRow({
    Key key,
    this.character,
    @required this.mastery,
  }) : super(key: key);

  @override
  _MasteryRowState createState() => _MasteryRowState();
}

class _MasteryRowState extends State<MasteryRow> {
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
                      mastery.associatedMasteryId == widget.mastery.masteryId)
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
                    mastery.associatedMasteryId == widget.mastery.masteryId)
                .characterMasteryAchieved,
            onChanged: charactersModel.isEditMode
                ? (value) => charactersModel.toggleMastery(
                      characterMasteries: widget.character.characterMasteries,
                      mastery: widget.character.characterMasteries.firstWhere(
                          (mastery) =>
                              mastery.associatedMasteryId ==
                              widget.mastery.masteryId),
                      value: value,
                    )
                : null,
          ),
          Container(
            height: height,
            width: 1,
            color: widget.character.characterMasteries
                    .firstWhere((mastery) =>
                        mastery.associatedMasteryId == widget.mastery.masteryId)
                    .characterMasteryAchieved
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).dividerColor,
            margin: const EdgeInsets.only(right: 12),
          ),
          SizeProviderWidget(
            onChildSize: (val) {
              setState(() {
                height = val.height * 0.9;
              });
            },
            child: Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: Utils.generateCheckRowDetails(
                    widget.mastery.masteryDetails,
                    SharedPrefs().darkTheme,
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

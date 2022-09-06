import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../models/perk.dart';
import '../../shared_prefs.dart';
import '../../utils/utils.dart';
import '../../viewmodels/characters_model.dart';
import '../../viewmodels/character_model.dart';

class MasteryRow extends StatefulWidget {
  final Mastery mastery;

  const MasteryRow({
    Key key,
    @required this.mastery,
  }) : super(key: key);

  @override
  _MasteryRowState createState() => _MasteryRowState();
}

class _MasteryRowState extends State<MasteryRow> {
  double height = 0;

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    CharactersModel charactersModel = context.watch<CharactersModel>();
    return Container(
      margin: const EdgeInsets.only(right: 6, left: 1),
      decoration: BoxDecoration(
        border: Border.all(
          color: characterModel.characterMasteries
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
            value: characterModel.characterMasteries
                .firstWhere((mastery) =>
                    mastery.associatedMasteryId == widget.mastery.masteryId)
                .characterMasteryAchieved,
            onChanged: charactersModel.isEditMode
                ? (value) => characterModel.toggleMastery(
                      characterModel.characterMasteries.firstWhere((mastery) =>
                          mastery.associatedMasteryId ==
                          widget.mastery.masteryId),
                      value,
                    )
                : null,
          ),
          // widget.perks[0].perkIsGrouped
          //     ? const SizedBox(
          //         width: smallPadding,
          //       )
          // :
          // Container(
          //     height: height,
          //     child: VerticalDivider(
          //       color: allPerksSelected(characterModel)
          //           ? Theme.of(context).colorScheme.secondary
          //           : null,
          //     ),
          //   ),
          Container(
            height: height,
            width: 1,
            color: characterModel.characterMasteries
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
                  style: Theme.of(context).textTheme.bodyText2,
                  children: Utils.generateCheckRowDetails(
                    widget.mastery.masteryDetails,
                    SharedPrefs().darkTheme,
                  ),
                ),
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}

// class SizeProviderWidget extends StatefulWidget {
//   final Widget child;
//   final Function(Size) onChildSize;

//   const SizeProviderWidget({Key key, this.onChildSize, this.child})
//       : super(key: key);
//   @override
//   _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
// }

// class _SizeProviderWidgetState extends State<SizeProviderWidget> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       widget.onChildSize(context.size);
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }

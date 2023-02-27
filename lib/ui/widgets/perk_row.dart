import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../models/perk.dart';
import '../../shared_prefs.dart';
import '../../utils/utils.dart';
import '../../viewmodels/characters_model.dart';

class PerkRow extends StatefulWidget {
  final Character character;
  final List<Perk> perks;

  const PerkRow({
    Key key,
    @required this.character,
    @required this.perks,
  }) : super(key: key);

  @override
  _PerkRowState createState() => _PerkRowState();
}

class _PerkRowState extends State<PerkRow> {
  final List<int> perkIds = [];

  double height = 0;

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.watch<CharactersModel>();
    for (final Perk perk in widget.perks) {
      perkIds.add(perk.perkId);
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: smallPadding / 2),
      child: Row(
        children: <Widget>[
          widget.perks[0].perkIsGrouped
              ? Container(
                  margin: const EdgeInsets.only(right: 6, left: 1),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: allPerksSelected(widget.character)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: List.generate(
                      widget.perks.length,
                      (index) {
                        return Checkbox(
                          visualDensity: VisualDensity.compact,
                          value: widget.character.characterPerks
                              .firstWhere(
                                (element) =>
                                    element.associatedPerkId ==
                                    widget.perks[index].perkId,
                              )
                              .characterPerkIsSelected,
                          onChanged: charactersModel.isEditMode &&
                                  !widget.character.isRetired
                              ? (value) {
                                  charactersModel.togglePerk(
                                    characterPerks:
                                        widget.character.characterPerks,
                                    perk: widget.character.characterPerks
                                        .firstWhere(
                                      (element) =>
                                          element.associatedPerkId ==
                                          widget.perks[index].perkId,
                                    ),
                                    value: value,
                                  );
                                  // value
                                  //     ? widget.character.numOfSelectedPerks++
                                  //     : widget.character.numOfSelectedPerks--;
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                )
              : Row(
                  children: List.generate(
                    widget.perks.length,
                    (index) => Checkbox(
                      visualDensity: VisualDensity.comfortable,
                      value: widget.character.characterPerks
                          .firstWhere((element) =>
                              element.associatedPerkId ==
                              widget.perks[index].perkId)
                          .characterPerkIsSelected,
                      onChanged: charactersModel.isEditMode &&
                              !widget.character.isRetired
                          ? (value) {
                              charactersModel.togglePerk(
                                characterPerks: widget.character.characterPerks,
                                perk: widget.character.characterPerks
                                    .firstWhere((element) =>
                                        element.associatedPerkId ==
                                        widget.perks[index].perkId),
                                value: value,
                              );
                              // value
                              //     ? widget.character.numOfSelectedPerks++
                              //     : widget.character.numOfSelectedPerks--;
                            }
                          : null,
                    ),
                  ),
                ),
          widget.perks[0].perkIsGrouped
              ? const SizedBox(
                  width: smallPadding,
                )
              : Container(
                  height: height,
                  width: 1,
                  color: Theme.of(context).dividerColor,
                  margin: const EdgeInsets.only(right: 12),
                ),
          SizeProviderWidget(
            onChildSize: (val) {
              if (context != null && context.mounted) {
                setState(() {
                  height = val.height * 0.9;
                });
              }
            },
            child: Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium.copyWith(
                        letterSpacing: 0.7,
                      ),
                  children: Utils.generateCheckRowDetails(
                    widget.perks.first.perkDetails,
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

  bool allPerksSelected(
    Character character,
  ) {
    return character.characterPerks
        .where((element) => perkIds.contains(element.associatedPerkId))
        .every((element) => element.characterPerkIsSelected);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../models/perk.dart';
import '../../shared_prefs.dart';
import '../../utils/utils.dart';
import '../../viewmodels/character_model.dart';

class PerkRow extends StatefulWidget {
  final List<Perk> perks;

  const PerkRow({
    Key key,
    @required this.perks,
  }) : super(key: key);

  @override
  _PerkRowState createState() => _PerkRowState();
}

class _PerkRowState extends State<PerkRow> {
  final List<int> _perkIds = [];

  double height = 0;

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    CharactersModel charactersModel = context.watch<CharactersModel>();
    for (final Perk perk in widget.perks) {
      _perkIds.add(perk.perkId);
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
                      color: allPerksSelected(characterModel)
                          ? Theme.of(context).colorScheme.secondary
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
                          value: characterModel.characterPerks
                              .firstWhere(
                                (element) =>
                                    element.associatedPerkId ==
                                    widget.perks[index].perkId,
                              )
                              .characterPerkIsSelected,
                          onChanged: charactersModel.isEditMode
                              ? (value) => characterModel.togglePerk(
                                    characterModel.characterPerks.firstWhere(
                                      (element) =>
                                          element.associatedPerkId ==
                                          widget.perks[index].perkId,
                                    ),
                                    value,
                                  )
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
                      value: characterModel.characterPerks
                          .firstWhere((element) =>
                              element.associatedPerkId ==
                              widget.perks[index].perkId)
                          .characterPerkIsSelected,
                      onChanged: charactersModel.isEditMode
                          ? (value) => characterModel.togglePerk(
                                characterModel.characterPerks.firstWhere(
                                    (element) =>
                                        element.associatedPerkId ==
                                        widget.perks[index].perkId),
                                value,
                              )
                          : null,
                    ),
                  ),
                ),
          widget.perks[0].perkIsGrouped
              ? const SizedBox(
                  width: smallPadding,
                )
              // : Container(
              //     height: height,
              //     child: VerticalDivider(
              //       color: allPerksSelected(characterModel)
              //           ? Theme.of(context).colorScheme.secondary
              //           : null,
              //     ),
              //   ),
              : Container(
                  height: height,
                  width: 1,
                  color:
                      // allPerksSelected(characterModel)
                      //     ? Theme.of(context).colorScheme.secondary
                      // :
                      Theme.of(context).dividerColor,
                  margin: const EdgeInsets.only(right: 12),
                ),
          SizeProviderWidget(
            onChildSize: (val) {
              setState(() {
                height = val.height * 0.9;
              });
            },
            child: Expanded(
              child: SharedPrefs().showPerkImages
                  ? RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        children: Utils.generatePerkDetailsWithInlineIcons(
                          widget.perks.first.perkDetails.split(' '),
                          SharedPrefs().darkTheme,
                        ),
                      ),
                    )
                  : Text(widget.perks.first.perkDetails
                      .replaceAll(RegExp(r'_'), ' ')
                      .replaceAll(RegExp(r'&'), '+')),
            ),
          ),
        ],
      ),
    );
  }

  bool allPerksSelected(
    CharacterModel characterModel,
  ) {
    return characterModel.characterPerks
        .where((element) => _perkIds.contains(element.associatedPerkId))
        .every((element) => element.characterPerkIsSelected);
  }
}

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({Key key, this.onChildSize, this.child})
      : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChildSize(context.size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

typedef TogglePerk = Function(bool value);

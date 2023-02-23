import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';

import '../../data/constants.dart';

class PerksSection extends StatefulWidget {
  final Character character;

  const PerksSection({
    this.character,
    Key key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => PerksSectionState();
}

class PerksSectionState extends State<PerksSection> {
  @override
  Widget build(BuildContext context) {
    List<PerkRow> perkRows = [];
    List<Perk> perkRowPerks = [];
    String details = '';
    for (Perk perk in widget.character.perks) {
      if (details.isEmpty) {
        details = perk.perkDetails;
        perkRowPerks.add(perk);
        continue;
      }
      if (details == perk.perkDetails) {
        perkRowPerks.add(perk);
        continue;
      }
      if (details != perk.perkDetails) {
        perkRows.add(
          PerkRow(
            character: widget.character,
            perks: perkRowPerks,
          ),
        );
        perkRowPerks = [perk];
        details = perk.perkDetails;
      }
    }
    perkRows.add(
      PerkRow(
        character: widget.character,
        perks: perkRowPerks,
      ),
    );

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Perks (',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${widget.character.numOfSelectedPerks()}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium.copyWith(
                    color: widget.character.maximumPerks() >=
                            widget.character.numOfSelectedPerks()
                        ? Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87
                        : Colors.red,
                  ),
            ),
            Text(
              ' / ${widget.character.maximumPerks()})',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
        const SizedBox(
          height: smallPadding,
        ),
        ListView(
          padding: EdgeInsets.zero,
          children: perkRows,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}

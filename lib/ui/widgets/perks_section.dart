import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';

import '../../data/constants.dart';

class PerksSection extends StatelessWidget {
  final Character character;

  const PerksSection({
    this.character,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
              '${character.numOfSelectedPerks()}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium.copyWith(
                    color: Character.maximumPerks(character) >=
                            character.numOfSelectedPerks()
                        ? Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87
                        : Colors.red,
                  ),
            ),
            Text(
              ' / ${Character.maximumPerks(character)})',
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
          children: character.perkRows,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}

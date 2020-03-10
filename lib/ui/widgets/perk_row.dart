import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:provider/provider.dart';

class PerkRow extends StatelessWidget {
  final CharacterPerk perk;
  final Function onToggle;

  PerkRow({this.perk, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      child: Row(
        children: <Widget>[
          Checkbox(
              value: perk.characterPerkIsSelected,
              onChanged: (value) => onToggle(value)),
          Container(
            height: 30.0,
            width: 1.0,
            color: perk.characterPerkIsSelected
                ? Theme.of(context).accentColor
                : Colors.grey,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: FutureBuilder<String>(
                future: Provider.of<CharacterModel>(context, listen: false)
                    .getPerkDetails(perk.associatedPerkId),
                builder: (context, AsyncSnapshot<String> _detailsSnapshot) =>
                    _detailsSnapshot.hasData
                        ? AutoSizeText(
                            _detailsSnapshot.data,
                            maxLines: 2,
                            style: TextStyle(fontFamily: nyala),
                          )
                        : Center(child: CircularProgressIndicator())),
          )
        ],
      ),
    );
  }
}

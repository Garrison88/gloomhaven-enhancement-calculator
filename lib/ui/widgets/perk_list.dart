import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/core/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

class PerkList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PerkListState();
}

class PerkListState extends State<PerkList> {
  Widget build(BuildContext context) {
    final CharacterModel characterModel =
        Provider.of<CharacterModel>(context, listen: false);
    return FutureBuilder<bool>(
        future: Provider.of<CharacterModel>(context).setCharacterPerks(),
        builder: (context, AsyncSnapshot<bool> _perksSnapshot) => _perksSnapshot
                    .data ==
                true
            ? _perksSnapshot.hasError
                ? Container(child: Text(_perksSnapshot.error.toString()))
                : Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(bottom: smallPadding)),
                      Container(
                          padding: EdgeInsets.all(smallPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Perks (',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: titleFontSize),
                              ),
                              Text('${characterModel.numOfSelectedPerks}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: titleFontSize,
                                      color: characterModel.getMaximumPerks() >=
                                              characterModel.numOfSelectedPerks
                                          ? Colors.black
                                          : Colors.red)),
                              Text(' / ${characterModel.getMaximumPerks()})',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: titleFontSize))
                            ],
                          )),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        // crossAxisCount: 1,
                        // childAspectRatio: 5,
                        children: List.generate(
                            characterModel.characterPerks.length,
                            (index) => PerkRow(
                                perk: characterModel.characterPerks[index])),
                      ),
                      Container(
                        height: 58,
                      )
                    ],
                  )
            : CircularProgressIndicator());
  }
}

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

class PerkSection extends StatefulWidget {
  final int id;

  const PerkSection({Key key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PerkSectionState();
}

class PerkSectionState extends State<PerkSection> {
  Future _future;

  @override
  void initState() {
    super.initState();
    _future = Provider.of<CharacterModel>(context, listen: false)
        .loadCharacterPerks(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = Provider.of<CharacterModel>(context);
    return FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Container(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            characterModel.characterPerks = snapshot.data;
            return Column(
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
                  children: List.generate(
                      characterModel.characterPerks.length,
                      (index) => PerkRow(
                            perk: characterModel.characterPerks[index],
                            onToggle: (value) {
                              characterModel.togglePerk(
                                characterModel.characterPerks[index],
                                value,
                              );
                            },
                          )),
                ),
                Container(
                  height: 58,
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

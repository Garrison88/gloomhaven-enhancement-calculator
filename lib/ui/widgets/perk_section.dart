import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';

class PerkSection extends StatefulWidget {
  final CharacterModel characterModel;

  const PerkSection({
    this.characterModel,
  });
  @override
  State<StatefulWidget> createState() => PerkSectionState();
}

class PerkSectionState extends State<PerkSection> {
  Future<List<CharacterPerk>> _runFuture;

  @override
  void initState() {
    super.initState();
    print(
        'HASHCODE BEFORE LOAD CHAR PERKS::::: ${widget.characterModel..hashCode}');
    _runFuture = widget.characterModel
        .loadCharacterPerks(widget.characterModel.character.id);
  }

  @override
  void didUpdateWidget(covariant PerkSection oldWidget) {
    if (oldWidget.characterModel.character.id !=
        widget.characterModel.character.id) {
      _runFuture = widget.characterModel
          .loadCharacterPerks(widget.characterModel.character.id);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CharacterPerk>>(
        future: _runFuture,
        builder: (context, AsyncSnapshot<List<CharacterPerk>> snapshot) {
          if (snapshot.hasError) {
            return Container(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            widget.characterModel.characterPerks = snapshot.data;
            int temp = 0;
            snapshot.data.forEach((element) {
              if (element.characterPerkIsSelected) {
                temp++;
              }
            });
            widget.characterModel.numOfSelectedPerks = temp;
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
                          style: TextStyle(
                              fontSize: titleFontSize, fontFamily: pirataOne),
                        ),
                        Text('${widget.characterModel.numOfSelectedPerks}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: titleFontSize,
                                fontFamily: pirataOne,
                                color: widget.characterModel
                                            .getMaximumPerks() >=
                                        widget.characterModel.numOfSelectedPerks
                                    ? Colors.black
                                    : Colors.red)),
                        Text(
                          ' / ${widget.characterModel.getMaximumPerks()})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: titleFontSize, fontFamily: pirataOne),
                        )
                      ],
                    )),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                      widget.characterModel.characterPerks.length,
                      (index) => PerkRow(
                            perk: widget.characterModel.characterPerks[index],
                            togglePerk: (value) {
                              widget.characterModel.togglePerk(
                                widget.characterModel.characterPerks[index],
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

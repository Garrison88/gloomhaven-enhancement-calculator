import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

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
    _runFuture = Provider.of<CharacterModel>(context, listen: false)
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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: <Widget>[
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
                        Text(
                          '${widget.characterModel.numOfSelectedPerks}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontFamily: pirataOne,
                              color: widget.characterModel.maximumPerks >=
                                      widget.characterModel.numOfSelectedPerks
                                  ? SharedPrefs().darkTheme
                                      ? Colors.white
                                      : Colors.black87
                                  : Colors.red),
                        ),
                        Text(
                          ' / ${widget.characterModel.maximumPerks})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: titleFontSize, fontFamily: pirataOne),
                        )
                      ],
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                      widget.characterModel.characterPerks.length,
                      (index) {
                        return PerkRow(
                          perk: widget.characterModel.characterPerks[index],
                          togglePerk: (value) {
                            widget.characterModel.togglePerk(
                              widget.characterModel.characterPerks[index],
                              value,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

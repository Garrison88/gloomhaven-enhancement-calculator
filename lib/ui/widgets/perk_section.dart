import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

class PerkSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PerkSectionState();
}

class PerkSectionState extends State<PerkSection> {
  Future<List<List<dynamic>>> _futures;

  @override
  void initState() {
    super.initState();
    _futures = Future.wait([
      Provider.of<CharacterModel>(context, listen: false).loadCharacterPerks(
          Provider.of<CharacterModel>(context, listen: false).character.id),
      Provider.of<CharacterModel>(context, listen: false).loadPerks(
          Provider.of<CharacterModel>(context, listen: false)
              .character
              .classCode),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    CharacterModel _characterModel =
        Provider.of<CharacterModel>(context, listen: false);
    return FutureBuilder(
        future: _futures,
        builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Container(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            _characterModel.characterPerks = snapshot.data[0];
            int temp = 0;
            snapshot.data[0].forEach((element) {
              if (element.characterPerkIsSelected) {
                temp++;
              }
            });
            _characterModel.numOfSelectedPerks = temp;

            List<PerkRow> _perkRows = [];
            List<Perk> _perkRowPerks = [];
            List<Perk> _perks = [];
            for (var perkMap in snapshot.data[1]) {
              _perks.add(Perk.fromMap(perkMap));
            }
            String _details = '';
            for (Perk _perk in _perks) {
              if (_details.isEmpty) {
                _details = _perk.perkDetails;
                _perkRowPerks.add(_perk);
                continue;
              }
              if (_details == _perk.perkDetails) {
                _perkRowPerks.add(_perk);
                continue;
              }
              if (_details != _perk.perkDetails) {
                _perkRows.add(PerkRow(
                  perks: _perkRowPerks,
                ));
                _perkRowPerks = [_perk];
                _details = _perk.perkDetails;
              }
            }
            _perkRows.add(PerkRow(
              perks: _perkRowPerks,
            ));

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
                          '${Provider.of<CharacterModel>(context).numOfSelectedPerks}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontFamily: pirataOne,
                              color: _characterModel.maximumPerks >=
                                      _characterModel.numOfSelectedPerks
                                  ? SharedPrefs().darkTheme
                                      ? Colors.white
                                      : Colors.black87
                                  : Colors.red),
                        ),
                        Text(
                          ' / ${_characterModel.maximumPerks})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: titleFontSize, fontFamily: pirataOne),
                        )
                      ],
                    ),
                  ),
                  ListView(
                    children: _perkRows,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:provider/provider.dart';

class PerkList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PerkListState();
}

class PerkListState extends State<PerkList> {
  @override
  Widget build(BuildContext context) => Consumer<CharacterModel>(
      builder: (BuildContext context, CharacterModel _characterModel, _) =>
          FutureBuilder<bool>(
              future: Provider.of<CharacterModel>(context).setCharacterPerks(),
              builder: (context, AsyncSnapshot<bool> _perksSnapshot) =>
                  _perksSnapshot.data == true
                      ? _perksSnapshot.hasError
                          ? Container(
                              child: Text(_perksSnapshot.error.toString()))
                          : Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(bottom: smallPadding)),
                                Container(
                                    padding: EdgeInsets.all(smallPadding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Perks (',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: titleFontSize),
                                        ),
                                        Text(
                                            '${_characterModel.numOfSelectedPerks}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: titleFontSize,
                                                color: _characterModel
                                                            .getMaximumPerks() >=
                                                        _characterModel
                                                            .numOfSelectedPerks
                                                    ? Colors.black
                                                    : Colors.red)),
                                        Text(
                                            ' / ${_characterModel.getMaximumPerks()})',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: titleFontSize))
                                      ],
                                    )),
                                ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                      _characterModel.characterPerks.length,
                                      (index) => PerkRow(
                                            perk: _characterModel
                                                .characterPerks[index],
                                            onToggle: (value) =>
                                                _characterModel.togglePerk(
                                                    _characterModel
                                                        .characterPerks[index],
                                                    value),
                                          )),
                                ),
                                Container(
                                  height: 58,
                                )
                              ],
                            )
                      : CircularProgressIndicator()));
}

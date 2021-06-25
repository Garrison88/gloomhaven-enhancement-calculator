import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';

class PerkSection extends StatefulWidget {
  final CharacterModel characterModel;

  const PerkSection({
    Key key,
    this.characterModel,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => PerkSectionState();
}

class PerkSectionState extends State<PerkSection> {
  Future<List<List<dynamic>>> _futures;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant PerkSection oldWidget) {
    if (oldWidget.characterModel.character.id !=
        widget.characterModel.character.id) {
      _loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadData() {
    _futures = Future.wait([
      widget.characterModel
          .loadCharacterPerks(widget.characterModel.character.id),
      widget.characterModel
          .loadPerks(widget.characterModel.character.classCode.toLowerCase()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futures,
      builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text(
            snapshot.error.toString(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          widget.characterModel.characterPerks = snapshot.data[0];
          int temp = 0;
          snapshot.data[0].forEach((element) {
            if (element.characterPerkIsSelected) {
              temp++;
            }
          });
          widget.characterModel.numOfSelectedPerks = temp;

          List<PerkRow> perkRows = [];
          List<Perk> perkRowPerks = [];
          List<Perk> perks = [];
          for (var perkMap in snapshot.data[1]) {
            perks.add(
              Perk.fromMap(perkMap),
            );
          }
          String details = '';
          for (Perk perk in perks) {
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
                  perks: perkRowPerks,
                ),
              );
              perkRowPerks = [perk];
              details = perk.perkDetails;
            }
          }
          perkRows.add(PerkRow(
            perks: perkRowPerks,
          ));

          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Perks (',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    '${Provider.of<CharacterModel>(context).numOfSelectedPerks}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4.copyWith(
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
                    style: Theme.of(context).textTheme.headline4,
                  )
                ],
              ),
              const SizedBox(
                height: smallPadding,
              ),
              ListView(
                children: perkRows,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

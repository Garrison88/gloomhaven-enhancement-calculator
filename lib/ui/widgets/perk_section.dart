import 'package:flutter/material.dart';

import '../../data/constants.dart';
import '../../models/perk.dart';
import 'perk_row.dart';
import '../../viewmodels/character_model.dart';

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
    if (oldWidget.characterModel.character.uuid !=
        widget.characterModel.character.uuid) {
      _loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadData() {
    _futures = Future.wait(
      [
        widget.characterModel.loadCharacterPerks(
          widget.characterModel.character.uuid,
        ),
        widget.characterModel.loadPerks(
          widget.characterModel.character.playerClass.classCode.toLowerCase(),
        ),
      ],
    );
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
          for (final perk in snapshot.data[0]) {
            if (perk.characterPerkIsSelected) {
              temp++;
            }
          }
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
          perkRows.add(
            PerkRow(
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
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    '${widget.characterModel.numOfSelectedPerks}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: widget.characterModel.numOfSelectedPerksColor,
                        ),
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

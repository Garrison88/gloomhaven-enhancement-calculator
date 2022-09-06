import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/mastery_row.dart';

import '../../viewmodels/character_model.dart';

class MasteriesSection extends StatefulWidget {
  final CharacterModel characterModel;

  const MasteriesSection({
    Key key,
    this.characterModel,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => MasteriesSectionState();
}

class MasteriesSectionState extends State<MasteriesSection> {
  Future<List<List<dynamic>>> _futures;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant MasteriesSection oldWidget) {
    if (oldWidget.characterModel.character.uuid !=
        widget.characterModel.character.uuid) {
      _loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadData() {
    _futures = Future.wait(
      [
        widget.characterModel.loadCharacterMasteries(),
        widget.characterModel.loadMasteries(),
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
          widget.characterModel.characterMasteries = snapshot.data[0];
          return widget.characterModel.characterMasteries.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Masteries',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(
                      height: smallPadding + 5,
                    ),
                    ...snapshot.data[1].map(
                      (mastery) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: smallPadding / 2,
                        ),
                        child: MasteryRow(
                          mastery: Mastery.fromMap(
                            mastery,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

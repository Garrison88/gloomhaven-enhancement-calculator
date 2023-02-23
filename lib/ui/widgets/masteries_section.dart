import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/mastery_row.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

class MasteriesSection extends StatefulWidget {
  final CharactersModel charactersModel;

  const MasteriesSection({
    Key key,
    this.charactersModel,
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
    if (oldWidget.charactersModel.currentCharacter.uuid !=
        widget.charactersModel.currentCharacter.uuid) {
      _loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadData() {
    _futures = Future.wait(
      [
        widget.charactersModel.loadCharacterMasteries(),
        widget.charactersModel.loadMasteries(),
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
          widget.charactersModel.characterMasteries = snapshot.data[0];
          return widget.charactersModel.characterMasteries.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Masteries',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
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

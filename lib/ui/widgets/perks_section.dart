import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';

class PerksSection extends StatefulWidget {
  final Character character;
  final String uuid;
  // final CharactersModel charactersModel;

  const PerksSection({
    this.character,
    Key key,
    this.uuid,
    // this.charactersModel,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => PerksSectionState();
}

class PerksSectionState extends State<PerksSection> {
  Future<List<List<dynamic>>> _futures;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadData(widget.uuid);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(widget.uuid);
  }

  @override
  void didUpdateWidget(covariant PerksSection oldWidget) {
    if (oldWidget.uuid != widget.uuid) {
      _loadData(widget.uuid);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadData(String uuid) {
    _futures = Future.wait(
      [
        context.read<CharactersModel>().loadCharacterPerks(uuid),
        context.read<CharactersModel>().loadPerks(uuid),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
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
          // charactersModel.characterPerks = snapshot.data[0];
          // int temp = 0;
          // for (final CharacterPerk perk in snapshot.data[0]) {
          //   if (perk.characterPerkIsSelected) {
          //     temp++;
          //   }
          // }
          // charactersModel.numOfSelectedPerks = temp;

          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Perks (',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${charactersModel.numOfSelectedPerks}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium.copyWith(
                          color: widget.character.maximumPerks() >=
                                  charactersModel.numOfSelectedPerks
                              ? Colors.black87
                              : Colors.red,
                        ),
                  ),
                  Text(
                    ' / ${widget.character.maximumPerks()})',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ],
              ),
              const SizedBox(
                height: smallPadding,
              ),
              ListView(
                padding: EdgeInsets.zero,
                children: snapshot.data[1],
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          );
        } else {
          return Container();
          // return const Center(
          //   child: CircularProgressIndicator(),
          // );
        }
      },
    );
  }
}

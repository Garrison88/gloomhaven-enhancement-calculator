import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/core/models/character.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/base_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/locator.dart';
import 'package:gloomhaven_enhancement_calc/ui/views/base_view.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/character_details.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_list.dart';
import 'package:provider/provider.dart';

class CharacterView extends StatefulWidget {
  final Character character;
  CharacterView({this.character});

  @override
  _CharacterViewState createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  // @override
  // void initState() {
  //   // locator<CharacterModel>().character = widget.character;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<AppModel>(context, listen: false).setAccentColor(
  //         Provider.of<CharacterModel>(context, listen: false)
  //             .character
  //             .classColor);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            CharacterDetails(),
            PerkList(),
          ],
        ),
      );
}

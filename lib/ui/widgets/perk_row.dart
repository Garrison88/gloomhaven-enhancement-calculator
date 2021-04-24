import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/utils/utils.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:provider/provider.dart';

class PerkRow extends StatelessWidget {
  final List<Perk> perks;

  PerkRow({
    this.perks,
  });
  final List<int> _perkIds = [];

  // GlobalKey _key = GlobalKey();

  // double _dividerHeight = _getSizes();

  // double _getSizes() {
  //   final RenderBox renderBoxRed = _key.currentContext.findRenderObject();
  //   final sizeRed = renderBoxRed.size;
  //   print("SIZE of Red: $sizeRed");
  // }
// @override
//        WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = Provider.of<CharacterModel>(context);
    perks.forEach((element) {
      _perkIds.add(element.perkId);
    });
    return Container(
      // key: _key,
      padding: EdgeInsets.symmetric(vertical: smallPadding / 2),
      child: Row(
        children: <Widget>[
          Row(
            children: List.generate(
              perks.length,
              (index) => Checkbox(
                visualDensity: VisualDensity.comfortable,
                value: characterModel.characterPerks
                    .firstWhere((element) =>
                        element.associatedPerkId == perks[index].perkId)
                    .characterPerkIsSelected,
                onChanged: characterModel.isEditable
                    ? (value) => characterModel.togglePerk(
                          characterModel.characterPerks.firstWhere((element) =>
                              element.associatedPerkId == perks[index].perkId),
                          value,
                        )
                    : null,
              ),
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: characterModel.characterPerks
                    .where((element) =>
                        _perkIds.contains(element.associatedPerkId))
                    .every((element) => element.characterPerkIsSelected)
                ? Theme.of(context).accentColor
                : Colors.grey,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: SharedPrefs().showPerkImages
                ? RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2,
                      children: Utils.generatePerkDetailsWithInlineIcons(
                        perks.first.perkDetails.split(' '),
                        SharedPrefs().darkTheme,
                      ),
                    ),
                  )
                : Text('${perks.first.perkDetails}'),
          ),
        ],
      ),
    );
  }
}

typedef TogglePerk = Function(bool value);

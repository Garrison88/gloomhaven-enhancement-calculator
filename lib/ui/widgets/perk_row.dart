import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/utils/utils.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:provider/provider.dart';

class PerkRow extends StatefulWidget {
  final List<Perk> perks;

  PerkRow({
    this.perks,
  });

  @override
  _PerkRowState createState() => _PerkRowState();
}

class _PerkRowState extends State<PerkRow> {
  final List<int> _perkIds = [];

  double height = 0;

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = Provider.of<CharacterModel>(context);
    for (final Perk perk in widget.perks) {
      _perkIds.add(perk.perkId);
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: smallPadding / 2),
      child: Row(
        children: <Widget>[
          Row(
            children: List.generate(
              widget.perks.length,
              (index) => Checkbox(
                visualDensity: VisualDensity.comfortable,
                value: characterModel.characterPerks
                    .firstWhere((element) =>
                        element.associatedPerkId == widget.perks[index].perkId)
                    .characterPerkIsSelected,
                onChanged: characterModel.isEditable
                    ? (value) => characterModel.togglePerk(
                          characterModel.characterPerks.firstWhere((element) =>
                              element.associatedPerkId ==
                              widget.perks[index].perkId),
                          value,
                        )
                    : null,
              ),
            ),
          ),
          Container(
            height: height,
            width: 1,
            color: characterModel.characterPerks
                    .where((element) =>
                        _perkIds.contains(element.associatedPerkId))
                    .every((element) => element.characterPerkIsSelected)
                ? Theme.of(context).accentColor
                : Colors.grey,
            margin: const EdgeInsets.only(right: 10),
          ),
          SizeProviderWidget(
            onChildSize: (val) {
              setState(() {
                height = val.height * 0.9;
              });
            },
            child: Expanded(
              child: SharedPrefs().showPerkImages
                  ? RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        children: Utils.generatePerkDetailsWithInlineIcons(
                          widget.perks.first.perkDetails.split(' '),
                          SharedPrefs().darkTheme,
                        ),
                      ),
                    )
                  : Text(widget.perks.first.perkDetails
                      .replaceAll(RegExp(r'_'), ' ')
                      .replaceAll(RegExp(r'&'), '+')),
            ),
          ),
        ],
      ),
    );
  }
}

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({Key key, this.onChildSize, this.child})
      : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChildSize(context.size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

typedef TogglePerk = Function(bool value);

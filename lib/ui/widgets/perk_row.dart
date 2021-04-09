import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:provider/provider.dart';

class PerkRow extends StatefulWidget {
  final CharacterPerk perk;
  final TogglePerk togglePerk;

  PerkRow({
    this.perk,
    this.togglePerk,
  });

  @override
  _PerkRowState createState() => _PerkRowState();
}

class _PerkRowState extends State<PerkRow> {
  Future<String> _runFuture;

  @override
  void initState() {
    super.initState();
    _runFuture = Provider.of<CharacterModel>(context, listen: false)
        .getPerkDetails(widget.perk.associatedPerkId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      child: Row(
        children: <Widget>[
          Checkbox(
              value: widget.perk.characterPerkIsSelected,
              onChanged: (value) {
                return widget.togglePerk(value);
              }),
          Container(
            height: 30.0,
            width: 1.0,
            color: widget.perk.characterPerkIsSelected
                ? Theme.of(context).accentColor
                : Colors.grey,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: FutureBuilder<String>(
                future: _runFuture,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return AutoSizeText(
                      snapshot.data,
                      maxLines: 2,
                      style: TextStyle(fontFamily: nyala),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error.toString()}');
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
    );
  }
}

typedef TogglePerk = Function(bool value);

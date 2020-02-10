// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:gloomhaven_enhancement_calc/models/perk.dart';
// import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
// import 'package:gloomhaven_enhancement_calc/data/constants.dart';
// import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
// import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
// import 'package:provider/provider.dart';
// import 'package:sqflite/sqflite.dart';

// class PerkRow extends StatefulWidget {
//   final DatabaseHelper db = DatabaseHelper.instance;
//   // final CharacterPerk _characterPerk;

//   // PerkRow(this._characterPerk);

//   @override
//   State<StatefulWidget> createState() => PerkRowState();
// }

// class PerkRowState extends State<PerkRow> {
//   Widget build(BuildContext context) {
//     final CharacterState characterModel = Provider.of<CharacterState>(context);
//     return FutureBuilder<Perk>(
//         future: characterModel.getPerk(_perk),
//         builder: (context, AsyncSnapshot<Perk> _snapshot) {
//           // switch (_snapshot.connectionState) {
//           //   case ConnectionState.none:
//           //   case ConnectionState.waiting:
//           return !_snapshot.hasData
//               ? Center(child: CircularProgressIndicator())
//               :
//               //   break;
//               // default:
//               Container(
//                   padding:
//                       EdgeInsets.only(left: smallPadding, right: smallPadding),
//                   child: Row(
//                     children: <Widget>[
//                       Checkbox(
//                           value: characterModel
//                               .getCharacterPerks()[
//                                   characterModel.getPerk(widget._characterPerk)]
//                               .characterPerkIsSelected,
//                           onChanged: (_) => {}
//                           //     (bool value) => setState(() {
//                           //            characterModel.togglePerk(widget.characterPerk);
//                           //         }),
//                           ),
//                       Container(
//                         height: 30.0,
//                         width: 1.0,
//                         color: Theme.of(context).accentColor,
//                         margin: EdgeInsets.only(right: 10.0),
//                       ),
//                       Expanded(
//                         child: AutoSizeText(
//                           _snapshot.data.perkDetails,
//                           maxLines: 2,
//                           style: TextStyle(fontFamily: nyala),
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//           // }
//         });
//   }
// }

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:provider/provider.dart';

class PerkRow extends StatelessWidget {
  final CharacterPerk perk;
  final Function onToggle;

  PerkRow({this.perk, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      child: Row(
        children: <Widget>[
          Checkbox(
              value: perk.characterPerkIsSelected,
              onChanged: (value) => onToggle(value)),
          Container(
            height: 30.0,
            width: 1.0,
            color: perk.characterPerkIsSelected
                ? Theme.of(context).accentColor
                : Colors.grey,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: FutureBuilder<String>(
                future: Provider.of<CharacterModel>(context, listen: false)
                    .getPerkDetails(perk.associatedPerkId),
                builder: (context, AsyncSnapshot<String> _detailsSnapshot) =>
                    _detailsSnapshot.hasData
                        ? AutoSizeText(
                            _detailsSnapshot.data,
                            maxLines: 2,
                            style: TextStyle(fontFamily: nyala),
                          )
                        : Center(child: CircularProgressIndicator())),
          )
        ],
      ),
    );
  }
}

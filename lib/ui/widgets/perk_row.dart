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
//     final CharacterState characterState = Provider.of<CharacterState>(context);
//     return FutureBuilder<Perk>(
//         future: characterState.getPerk(_perk),
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
//                           value: characterState
//                               .getCharacterPerks()[
//                                   characterState.getPerk(widget._characterPerk)]
//                               .characterPerkIsSelected,
//                           onChanged: (_) => {}
//                           //     (bool value) => setState(() {
//                           //            characterState.togglePerk(widget.characterPerk);
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

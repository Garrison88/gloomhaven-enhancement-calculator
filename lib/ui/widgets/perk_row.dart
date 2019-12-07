import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class PerkRow extends StatefulWidget {
  final CharacterPerk characterPerk;

  PerkRow({Key key, this.characterPerk}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PerkRowState();
}

class PerkRowState extends State<PerkRow> {
  // String _classCode;
  CharacterPerk _perk;
  int _numOfChecks;
  bool _isSelected;
  // Perk perk;

  List<bool> _checkList = [];

  @override
  void initState() {
    super.initState();
    _perk = widget.characterPerk;
    _isSelected = widget.characterPerk.characterPerkIsSelected;
    // _checkList = List.generate(widget.numOfChecks, (i) {
    //   return sp.getBool('$_classCode$_details${i.toString()}') ?? false;
    // });
  }

  Widget build(BuildContext context) {
    // final CharacterState characterState =
    //     Provider.of<CharacterState>(context);
    return Container(
//        color: Colors.white.withOpacity(0.5),
        padding: EdgeInsets.only(left: smallPadding, right: smallPadding),
        child: Text("CharID: ${_perk.associatedCharacterId.toString()}, PerkID: ${_perk.associatedPerkId}, SELECTED: ${_perk.characterPerkIsSelected}"),
        // FutureBuilder<Perk>(
        //       future: characterState.get,
        //       builder: (context, AsyncSnapshot<List> _snapshot) {
        //         switch (_snapshot.connectionState) {
        //           case ConnectionState.none:
        //           case ConnectionState.waiting:
        //             return Center(child: CircularProgressIndicator());
        //             break;
        //           default:
        //             return _snapshot.hasError
        //                 ? Container(child: Text(_snapshot.error.toString()))
        //                 : PerkList(_snapshot.data)
        //                 // ListView.builder(
        //                 //     scrollDirection: Axis.vertical,
        //                 //     shrinkWrap: true,
        //                 //     itemCount: _snapshot.data.length,
        //                 //     itemBuilder: (BuildContext context, int index) {
        //                 //       print(_snapshot.data[index].toString());
        //                 //       return Text(_snapshot.data[index].toString());
        //                 //     })
        //                     ;
        //         }
        //       })
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: <Widget>[
        //     Row(
        //       children: List.generate(
        //         _numOfChecks,
        //         (i) => Checkbox(
        //           value: _checkList[i],
        //           onChanged: (bool value) => setState(() {
        //             // sp.setBool(
        //             //     // save state of checkbox to unique SP
        //             //     '$_classCode$_details${i.toString()}',
        //             //     value);
        //             _checkList[i] = value;
        //           }),
        //         ),
        //       ).toList(),
        //     ),
        //     Container(
        //       height: 30.0,
        //       width: 1.0,
        //       color: Theme.of(context).accentColor,
        //       margin: EdgeInsets.only(right: 10.0),
        //     ),
        //     Expanded(
        //       child: AutoSizeText(
        //         _details,
        //         maxLines: 2,
        //         style: TextStyle(fontFamily: nyala),
        //       ),
        //     ),
        //   ],
        // )
        );
  }
}

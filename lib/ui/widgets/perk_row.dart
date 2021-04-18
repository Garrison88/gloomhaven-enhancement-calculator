import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
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
  Future<Perk> _runFuture;
  String details;

  @override
  void initState() {
    super.initState();
    _runFuture = Provider.of<CharacterModel>(context, listen: false)
        .loadPerk(widget.perk.associatedPerkId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Perk>(
        future: _runFuture,
        builder: (context, AsyncSnapshot<Perk> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            details = snapshot.data.perkDetails;
            List<InlineSpan> list = generateList(
              snapshot.data.perkDetails.split(' '),
            );
            return Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: widget.perk.characterPerkIsSelected,
                    onChanged: widget.togglePerk,
                  ),
                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: widget.perk.characterPerkIsSelected
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                  Expanded(
                    child: SharedPrefs().showPerkImages
                        ? RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText2,
                              children: list,
                            ),
                          )
                        : Text('${snapshot.data.perkDetails}'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error.toString()}');
          } else {
            return Container();
          }
        });
  }
}

// class _PerkRowState extends State<PerkRow> {
//   Future<Perk> _runFuture;

//   @override
//   void initState() {
//     super.initState();
//     _runFuture = Provider.of<CharacterModel>(context, listen: false)
//         .loadPerkDetails(widget.perk.associatedPerkId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Perk>(
//         future: _runFuture,
//         builder: (context, AsyncSnapshot<Perk> snapshot) {
//           if (snapshot.hasData &&
//               snapshot.connectionState == ConnectionState.done) {
//             List<InlineSpan> list = generateList(
//               snapshot.data.perkDetails.split(' '),
//             );
//             return Container(
//               child: Row(
//                 children: <Widget>[
//                   Row(
//                     children: [
//                       for (int i = 0; i < snapshot.data.numOfPerks; i++)
//                         Checkbox(
//                           value: widget.perk.characterPerkIsSelected,
//                           onChanged: widget.togglePerk,
//                         )
//                     ],
//                   ),
//                   Container(
//                     height: 30.0,
//                     width: 1.0,
//                     color: widget.perk.characterPerkIsSelected
//                         ? Theme.of(context).accentColor
//                         : Colors.grey,
//                     margin: EdgeInsets.only(right: 10.0),
//                   ),
//                   Expanded(
//                       // child: FutureBuilder<Perk>(
//                       //     future: _runFuture,
//                       //     builder: (context, AsyncSnapshot<Perk> snapshot) {
//                       //       if (snapshot.hasData &&
//                       //           snapshot.connectionState == ConnectionState.done) {
//                       child: (SharedPrefs().showPerkImages)
//                           ? RichText(
//                               text: TextSpan(
//                                 style: Theme.of(context).textTheme.bodyText2,
//                                 children: list,
//                               ),
//                             )
//                           : Text('${snapshot.data}')

//                       // }),
//                       )
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Text('${snapshot.error.toString()}');
//           } else {
//             return Container();
//           }
//         });
//   }
// }

List<InlineSpan> generateList(List<String> list) {
  List<InlineSpan> inlineList = [];
  list.forEach((element) {
    String assetPath;
    bool invertColor = false;
    switch (element) {
      case ('+0'):
        assetPath = 'attack_modifiers/plus_0.png';
        break;
      case ('+1'):
        assetPath = 'attack_modifiers/plus_1.png';
        break;
      case ('-1'):
        assetPath = 'attack_modifiers/minus_1.png';
        break;
      case ('+2'):
        assetPath = 'attack_modifiers/plus_2.png';
        break;
      case ('-2'):
        assetPath = 'attack_modifiers/minus_2.png';
        break;
      case ('Rolling'):
        assetPath = 'rolling.png';
        break;
      case ('HEAL'):
        assetPath = 'heal.png';
        invertColor = true;
        break;
      case ('SHIELD'):
        assetPath = 'shield.png';
        invertColor = true;
        break;
      case ('STUN'):
        assetPath = 'stun.png';
        break;
      case ('WOUND'):
        assetPath = 'wound.png';
        break;
      case ('CURSE'):
        assetPath = 'curse.png';
        break;
      case ('PIERCE'):
        assetPath = 'pierce.png';
        break;
      case ('REGENERATE,'):
        assetPath = 'regenerate.png';
        break;
      case ('DISARM'):
        assetPath = 'disarm.png';
        break;
      case ('BLESS'):
        assetPath = 'bless.png';
        break;
      case ('TARGET'):
        assetPath = 'target.png';
        break;
      case ('PUSH'):
        assetPath = 'push.png';
        break;
      case ('PULL'):
        assetPath = 'pull.png';
        break;
      case ('IMMOBILIZE'):
        assetPath = 'immobilize.png';
        break;
      case ('POISON'):
        assetPath = 'poison.png';
        break;
      case ('MUDDLE'):
        assetPath = 'muddle.png';
        break;
      case ('INVISIBLE'):
        assetPath = 'invisible.png';
        break;
      // ELEMENTS
      case ('EARTH'):
        assetPath = 'elem_earth.png';
        break;
      case ('AIR'):
        assetPath = 'elem_air.png';
        break;
      case ('DARK'):
        assetPath = 'elem_dark.png';
        break;
      case ('LIGHT'):
        assetPath = 'elem_light.png';
        break;
      case ('ICE'):
        assetPath = 'elem_ice.png';
        break;
      case ('FIRE'):
        assetPath = 'elem_fire.png';
        break;
      case ('FIRE/LIGHT'):
        assetPath = 'elem_fire_light.png';
        break;
      default:
    }
    if (assetPath != null) {
      inlineList.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Tooltip(
            message: '${element.toLowerCase()}',
            child: Container(
              height: 35,
              width: 35,
              child: invertColor && SharedPrefs().darkTheme
                  ? Image.asset(
                      'images/$assetPath',
                      color: Colors.white70,
                    )
                  : Image.asset(
                      'images/$assetPath',
                    ),
            ),
          ),
        ),
      );
    } else {
      inlineList.add(
        TextSpan(text: element),
      );
    }
    inlineList.add(
      TextSpan(text: ' '),
    );
  });
  return inlineList;
}

typedef TogglePerk = Function(bool value);

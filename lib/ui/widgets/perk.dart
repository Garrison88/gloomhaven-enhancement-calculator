import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';

class Perk extends StatefulWidget {
  final String classCode;
  final int numOfChecks;
  final String details;

  Perk(this.classCode, this.numOfChecks, this.details);

  @override
  State<StatefulWidget> createState() => PerkState();
}

class PerkState extends State<Perk> {
  String _classCode;
  int _numOfChecks;
  String _details;

  List<bool> _checkList = [];

  @override
  void initState() {
    super.initState();
    _classCode = widget.classCode;
    _numOfChecks = widget.numOfChecks;
    _details = widget.details;
    _checkList = List.generate(widget.numOfChecks, (i) {
      // get state of checkbox from unique SP
      print('$_classCode$_details${i.toString()}' +
          '${prefs.getBool('$_classCode$_details${i.toString()}')}');
      return prefs.getBool('$_classCode$_details${i.toString()}') ?? false;
    });
  }

  Widget build(BuildContext context) {
    return Container(
//        color: Colors.white.withOpacity(0.5),
        padding: EdgeInsets.only(left: smallPadding, right: smallPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: List.generate(
                _numOfChecks,
                (i) => Checkbox(
                  value: _checkList[i],
                  onChanged: (bool value) => setState(() {
                    prefs.setBool(
                        // save state of checkbox to unique SP
                        '$_classCode$_details${i.toString()}',
                        value);
                    _checkList[i] = value;
                  }),
                ),
              ).toList(),
            ),
            Container(
              height: 30.0,
              width: 1.0,
              color: Theme.of(context).accentColor,
              margin: EdgeInsets.only(right: 10.0),
            ),
            Expanded(
              child: AutoSizeText(
                _details,
                maxLines: 2,
                style: TextStyle(fontFamily: nyala),
              ),
            ),
          ],
        ));
  }
}

//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/ui/character_sheet_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/enhancement_calculator_page.dart';

class NoCharacterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoCharacterPageState();
  }
}

class NoCharacterPageState extends State<NoCharacterPage> {
  Future<void> _askedToLead() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CharacterSheetPage()));
                },
                child: const Text('Treasury department'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, EnhancementCalculatorPage);
                },
                child: const Text('State department'),
              ),
            ],
          );
        })) {
//      case Department.treasury:
//      // Let's go.
//      // ...
//        break;
//      case Department.state:
//      // ...
//        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: MaterialButton(
          onPressed: _askedToLead,
          child: Text('Create Character'),
        ),
      ),
    );
  }
}

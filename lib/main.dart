import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/ui/character_sheet_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/enhancement_calculator_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/bottom_nav.dart';
import 'package:gloomhaven_enhancement_calc/ui/no_character_page.dart';

void main() => runApp(
      MaterialApp(
        title: 'Enhancement Calculator',
        routes: <String, WidgetBuilder>{
          '/enhancementCalculatorPage': (BuildContext context) =>
              EnhancementCalculatorPage(),
          '/noCharacterPage': (BuildContext context) => NoCharacterPage(),
          '/characterSheetPage': (BuildContext context) => CharacterSheetPage()
        },
        theme: ThemeData(
            // Define the default Brightness and Colors
            brightness: Brightness.light,
            primaryColor: Colors.brown,
            accentColor: Colors.blueGrey,

            // Define the default Font Family
            fontFamily: 'PirataOne',

            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              // DropDownButton text
              subhead: TextStyle(fontSize: 23.0),
              // Text widgets
              body1: TextStyle(fontSize: 23.0, letterSpacing: 0.7),
            )),
        home: BottomNav(),
      ),
    );
PageStorageKey enhancementKey = new PageStorageKey('enhancementKey');
final PageStorageBucket bucket = new PageStorageBucket();

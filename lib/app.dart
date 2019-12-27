import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/providers/app_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/bottom_nav.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_sheet_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/enhancement_calculator_page.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp(
      title: 'Gloomhaven Companion',
      routes: {
        '/': (context) => BottomNav(),
        '/enhancementCalculatorPage': (context) => EnhancementCalculatorPage(),
        '/characterSheetPage': (context) => CharacterSheetPage(),
        '/characterDetailsPage': (context) => CharacterPage()
      },
      theme: ThemeData(
          accentColor: appState.accentColor,
          //     ? Color(int.parse(_selectedClass.classColor))
          //     : Color(0xff4e7ec1),
          primaryColor: appState.accentColor,
          // brightness: brightness,
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
      // )
    );
  }
}

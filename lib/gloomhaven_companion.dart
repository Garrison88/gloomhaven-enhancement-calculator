import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/views/characterSheet_view.dart';
import 'package:gloomhaven_enhancement_calc/ui/views/character_view.dart';
import 'package:gloomhaven_enhancement_calc/ui/views/enhancementCalculator_view.dart';
import 'package:gloomhaven_enhancement_calc/ui/views/home_view.dart';
import 'package:provider/provider.dart';

class GloomhavenCompanion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppModel>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gloomhaven Companion',
      routes: {
        '/': (context) => HomeView(),
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

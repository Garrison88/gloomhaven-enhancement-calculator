import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/bottom_nav.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/enhancement_calculator_page.dart';
import 'package:provider/provider.dart';

class GloomhavenCompanion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = context.watch<AppModel>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gloomhaven Companion',
      // routes: {
      //   '/': (context) => BottomNav(),
      //   '/enhancementCalculatorPage': (context) => EnhancementCalculatorPage(),
      //   // '/characterSheetPage': (context) => CharacterSheetPage(),
      //   '/characterDetailsPage': (context) => CharacterScreen()
      // },
      home: BottomNav(),
      theme: ThemeData(
          accentColor: Color(int.parse(appModel.accentColor)),
          primaryColor: Color(int.parse(appModel.accentColor)),
          // brightness: brightness,
          // Define the default Font Family
          fontFamily: 'PirataOne',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            // DropDownButton text
            subtitle1: TextStyle(fontSize: 23.0),
            // Text widgets
            bodyText2: TextStyle(fontSize: 23.0, letterSpacing: 0.7),
          )),
      // )
    );
  }
}

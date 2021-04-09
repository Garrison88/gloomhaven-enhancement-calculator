import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/bottom_nav.dart';

class GloomhavenCompanion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final AppModel appModel = context.watch<AppModel>();
    // ..accentColor = SharedPrefs().themeColor;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gloomhaven Companion',
      // routes: {
      //   '/': (context) => BottomNav(),
      //   '/enhancementCalculatorPage': (context) => EnhancementCalculatorPage(),
      //   // '/characterSheetPage': (context) => CharacterSheetPage(),
      //   '/characterDetailsPage': (context) => CharacterScreen()
      // },
      // ..accentColor = SharedPrefs().themeColor
      // ..envelopeX = SharedPrefs().envelopeX;
      home: BottomNav(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      theme: ThemeData(
        primaryColor: Color(
          int.parse(SharedPrefs().themeColor),
        ),
        fontFamily: 'PirataOne',
        textTheme: TextTheme(
          // DropDownButton text
          subtitle1: TextStyle(fontSize: 23.0),
          // Text widgets
          bodyText2: TextStyle(fontSize: 23.0, letterSpacing: 0.7),
        ),
        brightness: Brightness.light,
        accentColor: Color(
          int.parse(SharedPrefs().themeColor),
        ),
      ),
      // darkTheme: Themes.darkThemeData,
      // theme: ThemeData(
      //     // accentColor: Color(int.parse(appModel.accentColor)),
      //     // primaryColor: Color(int.parse(appModel.accentColor)),
      //     // brightness: brightness,
      //     // Define the default Font Family
      //     fontFamily: 'PirataOne',

      //     // Define the default TextTheme. Use this to specify the default
      //     // text styling for headlines, titles, bodies of text, and more.
      //     textTheme: ),
      // )
    );
  }
}

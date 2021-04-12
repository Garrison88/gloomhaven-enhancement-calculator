import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/bottom_nav.dart';

class GloomhavenCompanion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gloomhaven Companion',
      home: BottomNav(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      theme: ThemeData(
        primaryColor: Color(
          int.parse(
            SharedPrefs().themeColor,
          ),
        ),
        accentColor: Color(
          int.parse(
            SharedPrefs().themeColor,
          ),
        ),
        fontFamily: highTower,
        textTheme: TextTheme(
          subtitle1: TextStyle(
            fontSize: 23.0,
          ),
          bodyText2: TextStyle(
            fontSize: 23.0,
            letterSpacing: 0.7,
          ),
          button: TextStyle(
            fontSize: 23.0,
          ),
          headline1: TextStyle(
            fontFamily: pirataOne,
            color: Colors.black87,
          ),
          headline3: TextStyle(
            fontFamily: pirataOne,
            color: Colors.black87,
          ),
        ),
        brightness: Brightness.light,
      ),
    );
  }
}

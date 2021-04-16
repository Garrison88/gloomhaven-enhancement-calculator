import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/bottom_nav.dart';

class GloomhavenCompanion extends StatelessWidget {
  Color getSwitchThumbColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Color(
        int.parse(
          SharedPrefs().themeColor,
        ),
      ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1);
    }
    return null;
  }

  Color getSwitchTrackColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Color(
        int.parse(
          SharedPrefs().themeColor,
        ),
      ).withOpacity(0.5);
    }
    return null;
  }

  Color getCheckboxColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Color(
        int.parse(
          SharedPrefs().themeColor,
        ),
      ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gloomhaven Companion',
      color: Colors.black,
      home: BottomNav(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      theme: ThemeData(
        primaryColor: Color(
          int.parse(
            SharedPrefs().themeColor,
          ),
        ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1.0),
        accentColor: Color(
          int.parse(
            SharedPrefs().themeColor,
          ),
        ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1.0),
        fontFamily: highTower,
        textTheme: TextTheme(
          subtitle1: TextStyle(
            fontSize: 23.0,
            color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
          ),
          bodyText2: TextStyle(
            fontSize: 25.0,
            letterSpacing: 0.7,
            fontFamily: nyala,
            color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
          ),
          button: TextStyle(
            fontSize: 23.0,
          ),
          headline1: TextStyle(
            fontFamily: pirataOne,
            color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
          ),
          headline3: TextStyle(
            fontFamily: pirataOne,
            color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
        ),
        switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.resolveWith(getSwitchTrackColor),
          thumbColor: MaterialStateProperty.resolveWith(getSwitchThumbColor),
        ),
        // floatingActionButtonTheme: FloatingActionButtonThemeData(),
        brightness:
            SharedPrefs().darkTheme ? Brightness.dark : Brightness.light,
      ),
      // darkTheme: ThemeData(
      //   primaryColor: Color(
      //     int.parse(
      //       SharedPrefs().themeColor,
      //     ),
      //   ).withOpacity(0.5),
      //   accentColor: Color(
      //     int.parse(
      //       SharedPrefs().themeColor,
      //     ),
      //   ).withOpacity(0.5),
      //   fontFamily: highTower,
      //   textTheme: TextTheme(
      //     subtitle1: TextStyle(
      //       fontSize: 23.0,
      //     ),
      //     bodyText2: TextStyle(
      //       fontSize: 23.0,
      //       letterSpacing: 0.7,
      //     ),
      //     button: TextStyle(
      //       fontSize: 23.0,
      //     ),
      //     headline1: TextStyle(
      //       fontFamily: pirataOne,
      //       color: Colors.white,
      //     ),
      //     headline3: TextStyle(
      //       fontFamily: pirataOne,
      //       color: Colors.white,
      //     ),
      //   ),
      //   brightness: Brightness.dark,
      // ),
    );
  }
}

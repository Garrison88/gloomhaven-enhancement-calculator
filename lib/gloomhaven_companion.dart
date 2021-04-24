import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/bottom_nav.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

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
      home: ChangeNotifierProvider(
        child: BottomNav(),
        create: (context) => CharactersModel(),
      ),
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

        // floatingActionButtonTheme: FloatingActionButtonThemeData(
        //   for
        //   backgroundColor: Color(
        //     int.parse(
        //       SharedPrefs().themeColor,
        //     ),
        //   ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1),
        // ),
        textTheme: TextTheme(
          subtitle1: TextStyle(
            fontSize: 23.0,
          ),
          subtitle2: TextStyle(
            fontSize: 15.0,
          ),
          bodyText2: TextStyle(
            fontSize: 25.0,
            letterSpacing: 0.7,
            fontFamily: nyala,
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
            letterSpacing: 2.0,
          ),
          headline4: TextStyle(
            fontFamily: pirataOne,
            color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
            letterSpacing: 2.0,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
        ),
        switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.resolveWith(getSwitchTrackColor),
          thumbColor: MaterialStateProperty.resolveWith(getSwitchThumbColor),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        brightness:
            SharedPrefs().darkTheme ? Brightness.dark : Brightness.light,
      ),
    );
  }
}

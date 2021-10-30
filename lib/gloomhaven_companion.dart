import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'data/constants.dart';
import 'shared_prefs.dart';
import 'ui/screens/home.dart';

class GloomhavenCompanion extends StatelessWidget {
  GloomhavenCompanion({
    Key key,
  }) : super(key: key);

  Color getSwitchThumbColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected)
          ? Color(
              int.parse(
                SharedPrefs().themeColor,
              ),
            ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1)
          : null;

  Color getSwitchTrackColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected)
          ? Color(
              int.parse(
                SharedPrefs().themeColor,
              ),
            ).withOpacity(0.5)
          : null;

  Color getCheckboxColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected)
          ? Color(
              int.parse(
                SharedPrefs().themeColor,
              ),
            ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1)
          : null;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      fontFamily: highTower,
      textTheme: TextTheme(
        subtitle1: const TextStyle(
          fontSize: 23.0,
        ),
        subtitle2: const TextStyle(
          fontSize: 15.0,
        ),
        bodyText2: const TextStyle(
          fontSize: 25.0,
          letterSpacing: 0.7,
          fontFamily: nyala,
        ),
        button: const TextStyle(
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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      brightness: SharedPrefs().darkTheme ? Brightness.dark : Brightness.light,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gloomhaven Companion',
      home: Home(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      theme: theme.copyWith(
        iconTheme: IconThemeData(
          color: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
        colorScheme: theme.colorScheme.copyWith(
          primary: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
          secondary: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
        ),
        switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.resolveWith(getSwitchTrackColor),
          thumbColor: MaterialStateProperty.resolveWith(getSwitchThumbColor),
        ),
      ),
    );
  }
}

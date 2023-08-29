import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class AppTheme {
  static ThemeData lightTheme() => ThemeData(
        // this disabled the splash animation on BottomNavigationBar items
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: highTower,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        textTheme: const TextTheme(
          // This is used for TextFormField
          titleMedium: TextStyle(
            fontSize: 23.0,
          ),
          // subtitle1: TextStyle(
          //   fontSize: 50.0,
          // ),
          // This is used as the default text (Text, AutoSizeText)
          bodyMedium: TextStyle(
            fontSize: 25.0,
            letterSpacing: 0.7,
            fontFamily: nyala,
          ),
          // Name
          displayLarge: TextStyle(
            fontSize: 40,
            fontFamily: pirataOne,
          ),
          // Notes, Perks, and Masteries titles
          headlineMedium: TextStyle(
            fontFamily: pirataOne,
            letterSpacing: 1.5,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: secondaryFontSize,
              fontFamily: nyala,
            ),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            getCheckboxColor,
          ),
          checkColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.disabled)
                    ? ThemeData.estimateBrightnessForColor(
                                getPrimaryThemeColor()) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black87
                    : null,
          ),
        ),
        colorScheme: ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black87,
          primary: getPrimaryThemeColor(),
          onPrimary:
              ThemeData.estimateBrightnessForColor(getPrimaryThemeColor()) ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black87,
          secondary: getPrimaryThemeColor(),
          primaryContainer: getPrimaryThemeColor(),
          secondaryContainer: getPrimaryThemeColor(),
          surfaceTint: getPrimaryThemeColor(),
          outline: Colors.grey[600],
        ),
        chipTheme: const ChipThemeData().copyWith(
          showCheckmark: false,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(
            fontFamily: highTower,
            fontSize: 20,
            color: Colors.black87,
          ),
          // actionTextColor: Colors.black,
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.withOpacity(0.5),
        ),
      );

  static ThemeData darkTheme() => ThemeData(
        // this disabled the splash animation on BottomNavigationBar items
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: highTower,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        textTheme: const TextTheme(
          // This is used for InputDecoration
          titleMedium: TextStyle(
            fontSize: 25.0,
          ),
          // This is used as the default text (Text, AutoSizeText)
          bodyMedium: TextStyle(
            fontSize: 25.0,
            letterSpacing: 0.7,
            fontFamily: nyala,
          ),
          // Name
          displayLarge: TextStyle(
            fontSize: 40,
            fontFamily: pirataOne,
          ),
          // Notes, Perks, and Masteries titles
          headlineMedium: TextStyle(
            fontFamily: pirataOne,
            letterSpacing: 1.5,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: secondaryFontSize,
              fontFamily: nyala,
            ),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            getCheckboxColor,
          ),
          checkColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.disabled)
                    ? ThemeData.estimateBrightnessForColor(
                                getPrimaryThemeColor()) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black87
                    : null,
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: getPrimaryThemeColor(),
          secondary: getPrimaryThemeColor(),
          primaryContainer: getPrimaryThemeColor(),
          secondaryContainer: getPrimaryThemeColor(),
          onPrimary:
              ThemeData.estimateBrightnessForColor(getPrimaryThemeColor()) ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black87,
          surfaceTint: getPrimaryThemeColor(),
          outline: Colors.grey[600],
        ),
        // dividerColor: Colors.grey,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xff1c1b1f),
        ),
        chipTheme: const ChipThemeData().copyWith(
          showCheckmark: false,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(
            0xff1c1b1f,
          ),
          contentTextStyle: TextStyle(
            fontFamily: highTower,
            fontSize: 20,
            color: Colors.white,
          ),
          // actionTextColor: Colors.white,
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.withOpacity(0.5),
        ),
      );
}

Color getPrimaryThemeColor() => Color(SharedPrefs().primaryClassColor);

// Color getSecondaryThemeColor() => Color(
//       CharacterData.playerClassByClassCode(
//         SharedPrefs().currentPlayerClassCode,
//       ).secondaryColor,
//     );

Color? getCheckboxColor(Set<MaterialState> states) =>
    states.contains(MaterialState.selected) &&
            states.contains(MaterialState.disabled)
        ? lighten(getPrimaryThemeColor(), 30)
        : states.contains(MaterialState.selected)
            ? getPrimaryThemeColor()
            : null;

Color? getCheckColor(Set<MaterialState> states) =>
    states.contains(MaterialState.selected) ? Colors.black87 : null;

/// Darken a color by [percent] amount (100 = black)
// ........................................................
Color darken(
  Color color, [
  int percent = 10,
]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(
    color.alpha,
    (color.red * f).round(),
    (color.green * f).round(),
    (color.blue * f).round(),
  );
}

/// Lighten a color by [percent] amount (100 = white)
// ........................................................
Color lighten(
  Color color, [
  int percent = 10,
]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
    color.alpha,
    color.red + ((255 - color.red) * p).round(),
    color.green + ((255 - color.green) * p).round(),
    color.blue + ((255 - color.blue) * p).round(),
  );
}

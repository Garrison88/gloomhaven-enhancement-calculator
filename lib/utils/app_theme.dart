import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    // removes splash animation from InkWell on bottom app bar navigation destination
    splashFactory: NoSplash.splashFactory,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: secondaryFontSize,
          fontFamily: nyala,
        ),
        foregroundColor: Color(
          int.parse(
            SharedPrefs().themeColor,
          ),
        ),
      ),
    ),
    fontFamily: highTower,
    textTheme: const TextTheme(
      // This is used
      titleMedium: TextStyle(
        fontSize: 23.0,
      ),
      // This is used
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
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(
        fontFamily: highTower,
        fontSize: 20,
        color: Color(
          int.parse(
            '0xff424242',
          ),
        ),
      ),
    ),
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // removes splash animation from InkWell on bottom app bar navigation destination
    splashFactory: NoSplash.splashFactory,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: secondaryFontSize,
          fontFamily: nyala,
        ),
        foregroundColor: Color(
          int.parse(
            SharedPrefs().themeColor,
          ),
        ),
      ),
    ),
    fontFamily: highTower,
    textTheme: const TextTheme(
      // This is used
      titleMedium: TextStyle(
        fontSize: 23.0,
      ),
      // This is used
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
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(
        int.parse(
          '0xff424242',
        ),
      ),
      contentTextStyle: const TextStyle(
        fontFamily: highTower,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    brightness: Brightness.dark,
  );
}

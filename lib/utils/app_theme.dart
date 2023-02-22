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
      labelLarge: TextStyle(
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        fontSize: 23.0,
      ),
      titleSmall: TextStyle(
        fontSize: 15.0,
      ),
      bodyMedium: TextStyle(
        fontSize: 25.0,
        letterSpacing: 0.7,
        fontFamily: nyala,
      ),
      displayLarge: TextStyle(
        fontFamily: pirataOne,
        color: Colors.black87,
      ),
      displaySmall: TextStyle(
        fontFamily: pirataOne,
        color: Colors.black87,
        letterSpacing: 1.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: pirataOne,
        color: Colors.black87,
        letterSpacing: 1.5,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
        fontFamily: highTower,
        fontSize: 20,
        color: Colors.white,
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
      labelLarge: TextStyle(
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        fontSize: 23.0,
      ),
      titleSmall: TextStyle(
        fontSize: 15.0,
      ),
      bodyMedium: TextStyle(
        fontSize: 25.0,
        letterSpacing: 0.7,
        fontFamily: nyala,
      ),
      displayLarge: TextStyle(
        fontFamily: pirataOne,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontFamily: pirataOne,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: pirataOne,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
        fontFamily: highTower,
        fontSize: 20,
        color: Colors.black,
      ),
    ),
    brightness: Brightness.dark,
  );
}

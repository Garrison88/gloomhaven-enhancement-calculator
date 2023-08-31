import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class AppTheme {
  static ThemeData lightTheme() => ThemeData(
        // this disabled the splash animation on BottomNavigationBar items
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: SharedPrefs().useDefaultFonts ? openSans : nyala,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        textTheme: SharedPrefs().useDefaultFonts
            ? defaultTextTheme()
            : customTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: SharedPrefs().useDefaultFonts
              ? defaultTextTheme().bodyMedium
              : customTextTheme().bodyMedium,
        ),
        textButtonTheme: textButtonThemeData(),
        checkboxTheme: checkboxThemeData(),
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
        snackBarTheme: snackBarThemeData(),
        dividerTheme: DividerThemeData(
          color: Colors.grey.withOpacity(0.5),
        ),
      );

  static ThemeData darkTheme() => ThemeData(
        // this disabled the splash animation on BottomNavigationBar items
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: SharedPrefs().useDefaultFonts ? openSans : nyala,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        textTheme: SharedPrefs().useDefaultFonts
            ? defaultTextTheme()
            : customTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: SharedPrefs().useDefaultFonts
              ? defaultTextTheme().bodyMedium
              : customTextTheme().bodyMedium,
        ),
        textButtonTheme: textButtonThemeData(),
        checkboxTheme: checkboxThemeData(),
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
        snackBarTheme: snackBarThemeData(),
        dividerTheme: DividerThemeData(
          color: Colors.grey.withOpacity(0.5),
        ),
      );
}

Color getPrimaryThemeColor() => Color(SharedPrefs().primaryClassColor);

TextTheme customTextTheme() => const TextTheme(
      // This is used for TextFormField
      // titleMedium: const TextStyle(
      //   fontSize: 40.0,
      // ),
      // This is used as the default text (Text, AutoSizeText)
      bodyMedium: TextStyle(
        fontSize: 25.0,
        // letterSpacing: SharedPrefs().useDefaultFonts ? null : 0.7,
        fontFamily: nyala,
      ),
      bodyLarge: TextStyle(
        fontSize: 25,
      ),
      // // Name and Enhancement Cost
      // displayLarge: TextStyle(
      //   fontFamily: SharedPrefs().useDefaultFonts ? roboto : pirataOne,
      // ),
      // // Notes, Perks, and Masteries titles
      headlineMedium: TextStyle(
        // fontFamily: nyala,
        letterSpacing: 1.5,
        fontSize: 35,
      ),
    );

TextTheme defaultTextTheme() => const TextTheme(
      // This is used as the default text (Text, AutoSizeText)
      bodyMedium: TextStyle(
        fontSize: 20.0,
        fontFamily: roboto,
      ),
      bodyLarge: TextStyle(
        fontSize: 25,
      ),
    );

CheckboxThemeData checkboxThemeData() => CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith(
        getCheckboxColor,
      ),
      checkColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) => states.contains(MaterialState.disabled)
            ? ThemeData.estimateBrightnessForColor(getPrimaryThemeColor()) ==
                    Brightness.dark
                ? Colors.white
                : Colors.black87
            : null,
      ),
    );

TextButtonThemeData textButtonThemeData() => TextButtonThemeData(
        style: TextButton.styleFrom(
      textStyle: SharedPrefs().useDefaultFonts
          ? defaultTextTheme().bodyMedium
          : customTextTheme().bodyMedium,
    ));

SnackBarThemeData snackBarThemeData() => SnackBarThemeData(
      backgroundColor: SharedPrefs().darkTheme
          ? const Color(
              0xff1c1b1f,
            )
          : Colors.white,
      contentTextStyle: TextStyle(
        fontFamily: highTower,
        fontSize: 20,
        color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
      ),
      // actionTextColor: Colors.black,
    );
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

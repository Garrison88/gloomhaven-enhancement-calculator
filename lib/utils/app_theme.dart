import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class AppTheme {
  static ThemeData lightTheme() => ThemeData(
        // this disabled the splash animation on BottomNavigationBar items
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: SharedPrefs().useDefaultFonts ? inter : nyala,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        textTheme: SharedPrefs().useDefaultFonts
            ? _defaultTextTheme()
            : _customTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: SharedPrefs().useDefaultFonts
              ? _defaultTextTheme().bodyMedium
              : _customTextTheme().bodyMedium,
        ),
        textButtonTheme: _textButtonThemeData(),
        checkboxTheme: _checkboxThemeData(),
        colorScheme: ColorScheme.light(
          surface: Colors.white,
          onSurface: Colors.black87,
          primary: _getPrimaryThemeColor(),
          onPrimary:
              ThemeData.estimateBrightnessForColor(_getPrimaryThemeColor()) ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black87,
          secondary: _getPrimaryThemeColor(),
          primaryContainer: _getPrimaryThemeColor(),
          secondaryContainer: _getPrimaryThemeColor(),
          surfaceTint: _getPrimaryThemeColor(),
          outline: Colors.grey[600],
        ),
        chipTheme: const ChipThemeData().copyWith(
          showCheckmark: false,
        ),
        snackBarTheme: _snackBarThemeData(),
        dividerTheme: DividerThemeData(
          color: Colors.grey.withValues(alpha: 0.5),
        ),
      );

  static ThemeData darkTheme() => ThemeData(
        // this disabled the splash animation on BottomNavigationBar items
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: SharedPrefs().useDefaultFonts ? inter : nyala,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        textTheme: SharedPrefs().useDefaultFonts
            ? _defaultTextTheme()
            : _customTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: SharedPrefs().useDefaultFonts
              ? _defaultTextTheme().bodyMedium
              : _customTextTheme().bodyMedium,
        ),
        textButtonTheme: _textButtonThemeData(),
        checkboxTheme: _checkboxThemeData(),
        colorScheme: ColorScheme.dark(
          primary: _getPrimaryThemeColor(),
          secondary: _getPrimaryThemeColor(),
          primaryContainer: _getPrimaryThemeColor(),
          secondaryContainer: _getPrimaryThemeColor(),
          onPrimary:
              ThemeData.estimateBrightnessForColor(_getPrimaryThemeColor()) ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black87,
          surfaceTint: _getPrimaryThemeColor(),
          outline: Colors.grey[600],
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xff1c1b1f),
        ),
        chipTheme: const ChipThemeData().copyWith(
          showCheckmark: false,
        ),
        snackBarTheme: _snackBarThemeData(),
        dividerTheme: DividerThemeData(
          color: Colors.grey.withValues(alpha: 0.5),
        ),
      );
}

Color _getPrimaryThemeColor() => Color(SharedPrefs().primaryClassColor);

TextTheme _customTextTheme() => const TextTheme().copyWith(
      // This is used as the default text (Text, AutoSizeText)
      bodyMedium: const TextStyle(
        fontSize: 25.0,
        fontFamily: nyala,
      ),
      // Previous retirements, Resources
      bodyLarge: const TextStyle(
        fontSize: 25,
      ),
      // Character name
      displayMedium: const TextStyle(
        fontFamily: pirataOne,
        letterSpacing: 1.5,
      ),
      // Notes, Perks, and Masteries titles
      headlineMedium: const TextStyle(
        fontSize: 35,
      ),
    );

TextTheme _defaultTextTheme() => const TextTheme().copyWith(
      // This is used as the default text (Text, AutoSizeText)
      bodyMedium: const TextStyle(
        fontSize: 20.0,
        fontFamily: inter,
      ),
      // Previous retirements, Resources
      bodyLarge: const TextStyle(
        fontSize: 25,
      ),
      // Character name
      displayMedium: const TextStyle(
        fontFamily: inter,
      ),
    );

CheckboxThemeData _checkboxThemeData() => CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        _getCheckboxColor,
      ),
      checkColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => states.contains(WidgetState.disabled)
            ? ThemeData.estimateBrightnessForColor(_getPrimaryThemeColor()) ==
                    Brightness.dark
                ? Colors.white
                : Colors.black87
            : null,
      ),
    );

TextButtonThemeData _textButtonThemeData() => TextButtonThemeData(
        style: TextButton.styleFrom(
      textStyle: SharedPrefs().useDefaultFonts
          ? _defaultTextTheme().bodyMedium
          : _customTextTheme().bodyMedium,
    ));

SnackBarThemeData _snackBarThemeData() => SnackBarThemeData(
      backgroundColor: SharedPrefs().darkTheme
          ? const Color(
              0xff1c1b1f,
            )
          : Colors.white,
      actionTextColor: SharedPrefs().darkTheme
          ? Colors.white
          : const Color(
              0xff1c1b1f,
            ),
      contentTextStyle: SharedPrefs().useDefaultFonts
          ? _defaultTextTheme().bodyMedium?.copyWith(
                color: SharedPrefs().darkTheme
                    ? Colors.white
                    : const Color(
                        0xff1c1b1f,
                      ),
              )
          : _customTextTheme().bodyMedium?.copyWith(
                color: SharedPrefs().darkTheme
                    ? Colors.white
                    : const Color(
                        0xff1c1b1f,
                      ),
              ),
    );
// Color getSecondaryThemeColor() => Color(
//       CharacterData.playerClassByClassCode(
//         SharedPrefs().currentPlayerClassCode,
//       ).secondaryColor,
//     );

Color? _getCheckboxColor(Set<WidgetState> states) =>
    states.contains(WidgetState.selected) &&
            states.contains(WidgetState.disabled)
        ? lighten(_getPrimaryThemeColor(), 30)
        : states.contains(WidgetState.selected)
            ? _getPrimaryThemeColor()
            : null;

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

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/theme/theme_config.dart';
import 'package:gloomhaven_enhancement_calc/theme/theme_extensions.dart';

class AppThemeBuilder {
  /// The dark surface color used throughout the app.
  /// Used for: Scaffold background, BottomNavigationBar, system nav bar, etc.
  static const Color darkSurface = Color(0xff1c1b1f);
  // Cache themes to avoid rebuilding
  static final Map<int, ThemeData> _lightThemeCache = {};
  static final Map<int, ThemeData> _darkThemeCache = {};

  static ThemeData buildLightTheme(ThemeConfig config) {
    final cacheKey = config.hashCode;

    if (_lightThemeCache.containsKey(cacheKey)) {
      return _lightThemeCache[cacheKey]!;
    }

    final theme = _buildTheme(config: config, brightness: Brightness.light);

    _lightThemeCache[cacheKey] = theme;
    return theme;
  }

  static ThemeData buildDarkTheme(ThemeConfig config) {
    final cacheKey = config.hashCode;

    if (_darkThemeCache.containsKey(cacheKey)) {
      return _darkThemeCache[cacheKey]!;
    }

    final theme = _buildTheme(config: config, brightness: Brightness.dark);

    _darkThemeCache[cacheKey] = theme;
    return theme;
  }

  static void clearCache() {
    _lightThemeCache.clear();
    _darkThemeCache.clear();
  }

  static ThemeData _buildTheme({
    required ThemeConfig config,
    required Brightness brightness,
  }) {
    // Use the EXACT seed color, not a generated palette
    final primaryColor = config.seedColor;

    // Calculate onPrimary color based on brightness of the primary color
    final onPrimaryColor =
        ThemeData.estimateBrightnessForColor(primaryColor) == Brightness.dark
        ? Colors.white
        : Colors.black87;

    // Build ColorScheme with exact colors
    final colorScheme = brightness == Brightness.light
        ? ColorScheme.light(
            surface: Colors.white,
            onSurface: Colors.black87,
            primary: primaryColor,
            onPrimary: onPrimaryColor,
            secondary: primaryColor,
            primaryContainer: primaryColor,
            secondaryContainer: primaryColor,
            surfaceTint: primaryColor,
            outline: Colors.grey[600],
          )
        : ColorScheme.dark(
            // surface: darkSurface,
            primary: primaryColor,
            secondary: primaryColor,
            primaryContainer: primaryColor,
            secondaryContainer: primaryColor,
            onPrimary: onPrimaryColor,
            surfaceTint: primaryColor,
            outline: Colors.grey[600],
          );

    final textTheme = config.useDefaultFonts
        ? _buildDefaultTextTheme(brightness)
        : _buildCustomTextTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: config.useDefaultFonts ? inter : nyala,
      textTheme: textTheme,

      // Disable splash effects
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,

      // Component themes
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: textTheme.bodyMedium,
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: textTheme.bodyMedium),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected) &&
              states.contains(WidgetState.disabled)) {
            return _lighten(primaryColor, 30);
          }
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return onPrimaryColor;
          }
          return null;
        }),
      ),

      chipTheme: const ChipThemeData(showCheckmark: false),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? darkSurface
            : Colors.white,
        actionTextColor: brightness == Brightness.dark
            ? Colors.white
            : darkSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: brightness == Brightness.dark ? Colors.white : darkSurface,
        ),
      ),

      dividerTheme: DividerThemeData(color: Colors.grey.withValues(alpha: 0.5)),

      bottomNavigationBarTheme: brightness == Brightness.dark
          ? const BottomNavigationBarThemeData(backgroundColor: darkSurface)
          : null,

      // Add custom extension with exact character color
      extensions: [
        AppThemeExtension(
          characterPrimary: primaryColor,
          characterSecondary: primaryColor,
          characterAccent: _adjustColor(primaryColor, brightness),
        ),
      ],
    );
  }

  static TextTheme _buildDefaultTextTheme(Brightness brightness) {
    return const TextTheme().copyWith(
      bodyMedium: const TextStyle(fontSize: 20.0, fontFamily: inter),
      bodyLarge: const TextStyle(fontSize: 25),
      displayMedium: const TextStyle(fontFamily: inter),
    );
  }

  static TextTheme _buildCustomTextTheme(Brightness brightness) {
    return const TextTheme().copyWith(
      bodyMedium: const TextStyle(fontSize: 25.0, fontFamily: nyala),
      bodyLarge: const TextStyle(fontSize: 25),
      displayMedium: const TextStyle(fontFamily: pirataOne, letterSpacing: 1.5),
      headlineMedium: const TextStyle(fontSize: 35),
    );
  }

  static Color _adjustColor(Color color, Brightness brightness) {
    // Create lighter/darker variants based on brightness
    return brightness == Brightness.dark
        ? _lighten(color, 10)
        : _darken(color, 10);
  }

  static Color _darken(Color color, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final f = 1 - percent / 100;
    return Color.fromARGB(
      (color.a * 255).round(),
      (color.r * f * 255).round(),
      (color.g * f * 255).round(),
      (color.b * f * 255).round(),
    );
  }

  static Color _lighten(Color color, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final p = percent / 100;
    final r = color.r * 255;
    final g = color.g * 255;
    final b = color.b * 255;
    return Color.fromARGB(
      (color.a * 255).round(),
      (r + (255 - r) * p).round(),
      (g + (255 - g) * p).round(),
      (b + (255 - b) * p).round(),
    );
  }
}

import 'package:flutter/material.dart';

class ThemeConfig {
  final Color seedColor;
  final bool useDarkMode;
  final bool useDefaultFonts;

  const ThemeConfig({
    required this.seedColor,
    required this.useDarkMode,
    required this.useDefaultFonts,
  });

  ThemeConfig copyWith({
    Color? seedColor,
    bool? useDarkMode,
    bool? useDefaultFonts,
  }) {
    return ThemeConfig(
      seedColor: seedColor ?? this.seedColor,
      useDarkMode: useDarkMode ?? this.useDarkMode,
      useDefaultFonts: useDefaultFonts ?? this.useDefaultFonts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeConfig &&
          runtimeType == other.runtimeType &&
          seedColor == other.seedColor &&
          useDarkMode == other.useDarkMode &&
          useDefaultFonts == other.useDefaultFonts;

  @override
  int get hashCode => Object.hash(seedColor, useDarkMode, useDefaultFonts);
}

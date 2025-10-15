import 'package:flutter/material.dart';

/// Extension for character-specific colors and custom theme properties
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color characterPrimary;
  final Color characterSecondary;
  final Color characterAccent;
  final bool isRetiredCharacter;

  const AppThemeExtension({
    required this.characterPrimary,
    required this.characterSecondary,
    required this.characterAccent,
    this.isRetiredCharacter = false,
  });

  @override
  AppThemeExtension copyWith({
    Color? characterPrimary,
    Color? characterSecondary,
    Color? characterAccent,
    bool? isRetiredCharacter,
  }) {
    return AppThemeExtension(
      characterPrimary: characterPrimary ?? this.characterPrimary,
      characterSecondary: characterSecondary ?? this.characterSecondary,
      characterAccent: characterAccent ?? this.characterAccent,
      isRetiredCharacter: isRetiredCharacter ?? this.isRetiredCharacter,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      characterPrimary: Color.lerp(
        characterPrimary,
        other.characterPrimary,
        t,
      )!,
      characterSecondary: Color.lerp(
        characterSecondary,
        other.characterSecondary,
        t,
      )!,
      characterAccent: Color.lerp(characterAccent, other.characterAccent, t)!,
      isRetiredCharacter: t < 0.5
          ? isRetiredCharacter
          : other.isRetiredCharacter,
    );
  }
}

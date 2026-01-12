import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/theme/theme_extensions.dart';

extension ThemeContextExtension on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;

  Color get characterPrimary => appTheme.characterPrimary;
  Color get characterSecondary => appTheme.characterSecondary;
  Color get characterAccent => appTheme.characterAccent;
}

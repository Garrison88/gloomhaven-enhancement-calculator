import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class AppModel extends ChangeNotifier {
  AppModel();
  final PageController pageController = PageController();
  ThemeMode _themeMode = SharedPrefs().darkTheme
      ? ThemeMode.dark
      : ThemeMode.light;
  bool _useDefaultFonts = SharedPrefs().useDefaultFonts;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  bool get useDefaultFonts => _useDefaultFonts;

  set useDefaultFonts(bool mode) {
    _useDefaultFonts = mode;
    notifyListeners();
  }

  void updateTheme({ThemeMode? themeMode}) {
    if (themeMode != null) {
      _themeMode = themeMode;
    }
    notifyListeners();
  }

  int _page = 0;

  int get page => _page;

  set page(int page) {
    _page = page;
    notifyListeners();
  }
}

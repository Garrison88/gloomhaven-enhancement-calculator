import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  AppModel(
    this.pageController,
    this._themeMode,
  );
  final PageController pageController;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void updateTheme({
    ThemeMode themeMode,
  }) {
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

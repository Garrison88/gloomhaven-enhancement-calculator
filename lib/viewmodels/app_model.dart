import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class AppModel extends ChangeNotifier {
  AppModel();
  final PageController pageController = PageController();
  ThemeMode _themeMode =
      SharedPrefs().darkTheme ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void updateTheme({
    ThemeMode? themeMode,
  }) {
    if (themeMode != null) {
      _themeMode = themeMode;
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarIconBrightness:
              themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: themeMode == ThemeMode.dark
              ? const Color(
                  0xff1c1b1f,
                )
              : Colors.white,
        ),
      );
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

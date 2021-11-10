// import 'package:flutter/material.dart';

// class ThemeModel extends ChangeNotifier {
//   bool _isDark;
//   ThemePreferences _preferences;
//   bool get isDark => _isDark;

//   ThemeModel() {
//     _isDark = false;
//     _preferences = ThemePreferences();
//     getPreferences();
//   }
// //Switching themes in the flutter apps - Flutterant
//   set isDark(bool value) {
//     _isDark = value;
//     _preferences.setTheme(value);
//     notifyListeners();
//   }

//   getPreferences() async {
//     _isDark = await _preferences.getTheme();
//     notifyListeners();
//   }
// }
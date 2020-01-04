import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState with ChangeNotifier {
  Color _accentColor;
  int _retirements = 0;
  int _position;

  AppState(this._position, this._accentColor);

  get accentColor => _accentColor;

  setAccentColor(String _color) {
    SharedPreferences.getInstance().then((_prefs) {
      _prefs.setString('themeColor', _color);
      _accentColor = Color(int.parse(_color));
    });

    notifyListeners();
  }

  get retirements => _retirements;

  set retirements(int _numOfRetirements) {
    _retirements = _numOfRetirements;
    notifyListeners();
  }

  get position => this._position;

  set position(int _position) {
    SharedPreferences.getInstance().then((_prefs) {
      _prefs.setInt('position', _position);
      this._position = _position;
    });
    notifyListeners();
  }
}

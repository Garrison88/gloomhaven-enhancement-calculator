import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  Color _accentColor;
  int _retirements = 0;
  int _position;

  AppState(this._position, this._accentColor);

  get accentColor => _accentColor;

  setTheme(String _color) {
    _accentColor = Color(int.parse(_color));
    notifyListeners();
  }

  get retirements => _retirements;

  set retirements(int _numOfRetirements) {
    _retirements = _numOfRetirements;
    notifyListeners();
  }

  get position => this._position;

  set position(int _position) {
    this._position = _position;
    notifyListeners();
  }
}

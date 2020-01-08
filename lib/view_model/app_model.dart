import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/view_model/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends BaseModel {
  Color _accentColor;
  int _retirements = 0;
  int _position;

  AppModel(this._position, this._accentColor);

  get accentColor => _accentColor;

  setAccentColor(String _color) {
    SharedPreferences.getInstance().then((_prefs) {
      _prefs.setString('themeColor', _color);
      _accentColor = Color(int.parse(_color));
    });

    notifyChange();
  }

  get retirements => _retirements;

  set retirements(int _numOfRetirements) {
    _retirements = _numOfRetirements;
    notifyChange();
  }

  get position => this._position;

  set position(int _position) {
    SharedPreferences.getInstance().then((_prefs) {
      _prefs.setInt('position', _position);
      this._position = _position;
    });
    notifyChange();
  }
}

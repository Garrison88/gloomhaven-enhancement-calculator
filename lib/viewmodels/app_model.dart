import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {
  Color _accentColor;
  // int _retirements = 0;
  int _position;
  // bool _isEditable = false;

  AppModel(this._position, this._accentColor);

  // set isEditable(bool _value) {
  //   _isEditable = _value;
  //   // notifyListeners();
  // }

  // get isEditable => _isEditable;

  get accentColor => _accentColor;

  setAccentColor(String _color) {
    SharedPreferences.getInstance().then((_prefs) {
      _prefs.setString('themeColor', _color);
      _accentColor = Color(int.parse(_color));
    });

    notifyListeners();
  }

  // int get retirements {
  //   SharedPreferences.getInstance().then((_prefs) {
  //     _retirements = int.parse(_prefs.getString('previousRetirements') ?? '0');
  //   });
  //   return _retirements;
  // }

  // set retirements(int _numOfRetirements) {
  //   SharedPreferences.getInstance().then((_prefs) =>
  //       _prefs.setString('previousRetirements', _numOfRetirements.toString()));
  //   _retirements = _numOfRetirements;
  // }

  get position => this._position;

  set position(int _position) => SharedPreferences.getInstance().then((_prefs) {
        _prefs.setInt('position', _position);
        this._position = _position;
        notifyListeners();
      });
}

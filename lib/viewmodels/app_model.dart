import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {
  String _accentColor = '0xff4e7ec1';
  // int _position;
  bool _envelopeX;

  // PageController _pageController;

  // PageController get pageController => _pageController;

  // set pageController(PageController pageController) {
  //   _pageController = pageController;
  // }

  String get accentColor => _accentColor;

  set accentColor(String color) {
    SharedPreferences.getInstance().then((_prefs) {
      _prefs.setString('themeColor', color.toString());
      _accentColor = color;
    });

    notifyListeners();
  }

  get envelopeX => this._envelopeX;

  set envelopeX(bool _envelopeX) =>
      SharedPreferences.getInstance().then((_prefs) {
        _prefs.setBool('envelope_x', _envelopeX);
        this._envelopeX = _envelopeX;
        notifyListeners();
      });

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

  // get position => _position;

  // set position(int _position) => SharedPreferences.getInstance().then((_prefs) {
  //       _prefs.setInt('position', _position);
  //       this._position = _position;
  //       notifyListeners();
  //     });
}

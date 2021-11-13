import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  AppModel();
  PageController pageController = PageController();
  int _page = 0;

  int get page => _page;

  set page(int page) {
    _page = page;
    notifyListeners();
  }
}

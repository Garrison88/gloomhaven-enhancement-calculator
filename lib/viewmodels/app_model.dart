import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  AppModel(this.pageController);
  final PageController pageController;
  int _page = 0;

  int get page => _page;

  set page(int page) {
    _page = page;
    notifyListeners();
  }
}

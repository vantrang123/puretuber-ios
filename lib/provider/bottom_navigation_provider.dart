import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier {
  PageSelected pageSelected = PageSelected.home;

  void onPageChanged(PageSelected data) {
    if (data != pageSelected) {
      pageSelected = data;
      notifyListeners();
    }
  }
}

enum PageSelected {
  home,
  discover,
  settings
}

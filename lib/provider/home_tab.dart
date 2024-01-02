
import 'package:flutter/material.dart';

enum HomeScreenTab { All, Music, Entertainment, Sport, Style }

class HomeTabProvider extends ChangeNotifier {
  late HomeScreenTab _currentHomeTab;

  HomeTabProvider() {
    currentHomeTab = HomeScreenTab.All;
  }

  HomeScreenTab get currentHomeTab => _currentHomeTab;

  set currentHomeTab(HomeScreenTab tab) {
    _currentHomeTab = tab;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class ShowHideControl extends ChangeNotifier {
  bool _idShow = true;

  bool get idShow => _idShow;

  void onChange(bool value) {
    _idShow = value;
    notifyListeners();
  }
}

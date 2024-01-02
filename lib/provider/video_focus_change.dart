import 'package:flutter/material.dart';

class VideoFocusChange extends ChangeNotifier {
  String _idFocus = '';

  String get idFocus => _idFocus;

  void onChange(String value) {
    _idFocus = value;
    notifyListeners();
  }

  void setDefault(String value) {
    _idFocus = value;
  }
}

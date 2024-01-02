import 'package:flutter/material.dart';

class VideoDurationChange extends ChangeNotifier {
  Duration _position = Duration();

  Duration get position => _position;
  void onChange(Duration value) {
    _position = value;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class VideoControlProvider extends ChangeNotifier {
  bool _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  void exitFullScreen() {
    _isFullScreen = false;
    notifyListeners();
  }

  bool _isEnd = false;

  bool get isEnd => _isEnd;

  void setVideoStatusEnd(bool value) {
    _isEnd = value;
    notifyListeners();
  }

  void setPlayStateChange() {
    notifyListeners();
  }
}

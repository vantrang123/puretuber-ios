import 'package:flutter/material.dart';

class AudioControlProvider extends ChangeNotifier {
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void setPlayStatus(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  bool _isShowPanel = true;
  bool get isShowPanel => _isShowPanel;

  void setShowPanelStatus(bool value) {
    _isShowPanel = value;
    notifyListeners();
  }

  bool _isEnd = false;
  bool get isEnd => _isEnd;

  void setVideoStatusEnd(bool value) {
    _isEnd = value;
    notifyListeners();
  }
}

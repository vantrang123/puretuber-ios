import 'package:flutter/material.dart';

class CollapsedPanelControl extends ChangeNotifier {
  bool _isShowPanel = true;

  bool get isShowPanel => _isShowPanel;

  void setStatus(bool value) {
    _isShowPanel = value;
    notifyListeners();
  }
}

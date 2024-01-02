import 'package:flutter/material.dart';

class AppUpdateProvider extends ChangeNotifier {
  bool get isShow => _isShow;
  bool _isShow = false;

  bool get isCriticalUpdate => _isCriticalUpdate;
  bool _isCriticalUpdate = false;

  String get newVersion => _newVersion;
  String _newVersion = '';

  void showUpdateApp(String newVersion, bool isCriticalUpdate) {
    _newVersion = newVersion;
    _isCriticalUpdate = isCriticalUpdate;
    _isShow = true;
    notifyListeners();
  }

  void hideUpdateApp() {
    _isShow = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class LoadMoreProvider extends ChangeNotifier {
  bool _isShowLoadingLoadMore = false;

  bool get isShowLoadingLoadMore => _isShowLoadingLoadMore;

  void setLoadingLoadMore(bool value) {
    _isShowLoadingLoadMore = value;
    notifyListeners();
  }
}

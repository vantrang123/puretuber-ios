import 'package:flutter/material.dart';

class ManagerSearchProvider extends ChangeNotifier {
  late bool searchRunning;
  late FocusNode searchBarFocusNode;
  late TextEditingController searchController;
  late String youtubeSearchQuery;

  ManagerSearchProvider() {
    // Variables
    searchBarFocusNode = FocusNode();
    searchController = new TextEditingController();
    searchRunning = false;
    youtubeSearchQuery = "";
  }

  bool get showSearchBar {
    /*if (youtubeSearch != null) {
      return true;
    } else */
    if (searchBarFocusNode.hasFocus) {
      return true;
    } else if (searchRunning) {
      return true;
    } else {
      return false;
    }
  }

  void setState() {
    notifyListeners();
  }
}

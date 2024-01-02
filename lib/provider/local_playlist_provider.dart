import 'package:flutter/material.dart';

import '../data/local/datasources/video/local_playlist_datasource.dart';
import '../di/components/service_locator.dart';
import '../models/video_model.dart';

class LocalPlaylistProvider extends ChangeNotifier {
  void onChange(Video video) async {
    await getIt<LocalPlaylistDataSource>().insert(video);

    notifyListeners();
  }

  void newPlaylist() {
    notifyListeners();
  }

  void updateStatus() {
    notifyListeners();
  }
}

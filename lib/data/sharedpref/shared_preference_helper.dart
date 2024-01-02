import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../constants/strings.dart';
import '../../models/video_model.dart';
import 'constants/preferences.dart';

class SharedPreferenceHelper {
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.auth_token);
  }

  VideoPlayerController? get lastVideoController {
    final value = _sharedPreference.getString(Preferences.last_video_controller);
    return value == "" || value == null ? null : (jsonDecode(value) as VideoPlayerController);
  }

  void saveLastVideoController(VideoPlayerController data) {
    _sharedPreference.setString(Preferences.last_video_controller, data.toString());
  }

  Future<List<Video>?> getSavedVideos() async {
    final List<String>? videosJsonList = _sharedPreference.getStringList(Preferences.current_videos);
    if (videosJsonList != null) {
      List<Video> videos = videosJsonList.map((jsonString) => Video.fromJson(jsonDecode(jsonString))).toList();
      return videos;
    }
    return null;
  }

  void saveVideos(List<Video>? videos) {
    if (videos != null && videos.isNotEmpty) {
      final List<String> videoJsonList = videos.map((video) => jsonEncode(video.toMap())).toList();
      _sharedPreference.setStringList(Preferences.current_videos, videoJsonList);
    }
  }

  Future<int?> get countTimesPlay async {
    return _sharedPreference.getInt(Preferences.count_times_play);
  }

  void increaseTimesTimesPlay() async {
    final currentValue = await countTimesPlay;
    final value = (currentValue ?? 0) + 1;
    _sharedPreference.setInt(Preferences.count_times_play, value);
  }

  Future<void> resetTimesPlay() async {
    _sharedPreference.setInt(Preferences.count_times_play, 0);
  }

  void saveLocalPlaylists(List<String> name) {
    _sharedPreference.setStringList(Preferences.local_playlist, name);
  }

  Future<List<String>?> getLocalPlaylists() async {
    List<String>? favoriteName =
    _sharedPreference.getStringList(Preferences.local_playlist);
    if (null == favoriteName) {
      favoriteName = [Strings.watchLater];
    }
    return favoriteName;
  }

  Future<bool?> get isDeniedAds async {
    return _sharedPreference.getBool(Preferences.isDeniedAds);
  }

  void saveDeniedAds(bool data) {
    _sharedPreference.setBool(Preferences.isDeniedAds, data);
  }

  Future<int?> get timesOpenApp async {
    return _sharedPreference.getInt(Preferences.count_time_open_app);
  }

  void saveTimeOpenApp(int type) {
    _sharedPreference.setInt(Preferences.count_time_open_app, type);
  }
}

import 'dart:convert';

import 'package:sembast/sembast.dart';

import '../../../../models/video_list.dart';
import '../../../../models/video_model.dart';
import '../../constants/db_constants.dart';

class VideoDataSource {
  final _videoLocalStore = intMapStoreFactory.store(DBConstants.STORE_NAME);
  final Database _db;

  VideoDataSource(this._db);

  Future<int> insert(Video video) async =>
      await _videoLocalStore.add(_db, video.toMap());

  Future<int> count() async => await _videoLocalStore.count(_db);

  Future<VideoList> getVideosFromDb() async {
    var videosList;

    final recordSnapshots = await _videoLocalStore.find(_db);
    if (recordSnapshots.length > 0) {
      videosList = VideoList(
          videos: recordSnapshots.reversed.map((snapshot) {
        final encodedString = jsonEncode(snapshot.value);
        final valueMap = json.decode(encodedString);
        final video = Video.fromJson(valueMap);
        return video;
      }).toList());
    } else
      VideoList().videos = [];

    return videosList;
  }

  Future<int> update(Video video) async {
    final finder = Finder(filter: Filter.byKey(video.id));
    return await _videoLocalStore.update(_db, video.toMap(), finder: finder);
  }

  Future<int> delete(Video video) async {
    final finder = Finder(filter: Filter.byKey(video.id));
    return await _videoLocalStore.delete(_db, finder: finder);
  }

  Future deleteAll() async {
    await _videoLocalStore.drop(_db);
  }

  Future<void> insertOrUpdate(Video video) async {
    final recordSnapshots = await _videoLocalStore.find(_db);
    if (recordSnapshots.length > 0) {
      bool isFound = false;
      final List<Map<String, Object?>> videoList = [];
      for (int i = 0; i < recordSnapshots.length; i++) {
        final snapshot = recordSnapshots[i];
        final encodedString = jsonEncode(snapshot.value);
        final valueMap = json.decode(encodedString);
        final localVideo = Video.fromJson(valueMap);
        if (localVideo.id == video.id) {
          isFound = true;
        } else videoList.add(localVideo.toMap());
      }
      videoList.add(video.toMap());
      if (isFound) {
        await _videoLocalStore.drop(_db);
        if (videoList.length > 20) {
          final newList = videoList.getRange(videoList.length - 20, 20).toList();
          _videoLocalStore.addAll(_db, newList);
        } else await _videoLocalStore.addAll(_db, videoList);
      } else
        await _videoLocalStore.add(_db, video.toMap());
    } else {
      await _videoLocalStore.add(_db, video.toMap());
    }
  }
}

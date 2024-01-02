import 'dart:convert';

import 'package:sembast/sembast.dart';

import '../../../../models/video_list.dart';
import '../../../../models/video_model.dart';
import '../../constants/db_constants.dart';

class LocalPlaylistDataSource {
  final _videoLocalStore = intMapStoreFactory.store(DBConstants.STORE_USER_PLAYLIST_NAME);
  final Database _db;

  LocalPlaylistDataSource(this._db);

  Future<int> insert(Video video) async =>
      await _videoLocalStore.add(_db, video.toMap());

  Future<int> count() async => await _videoLocalStore.count(_db);

  Future<VideoList> getVideosFromDb() async {
    VideoList videosList;

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
      videosList = VideoList()..videos = [];

    return videosList;
  }

  Future<int> update(Video video) async {
    final finder = Finder(filter: Filter.byKey(video.id));
    return await _videoLocalStore.update(_db, video.toMap(), finder: finder);
  }

  Future<int> delete(Video video) async {
    final finder = Finder(filter: Filter.equals('id', video.id));
    return await _videoLocalStore.delete(_db, finder: finder);
  }

  Future deleteAll() async {
    await _videoLocalStore.drop(_db);
  }
}

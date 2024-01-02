import 'package:mobx/mobx.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';
import 'dart:async';

import '../../models/video_list_search.dart';
import '../error/error_store.dart';

part 'soundcloud_search_store.g.dart';

class SoundCloudSearchStore = _SoundCloudSearchStore with _$SoundCloudSearchStore;

abstract class _SoundCloudSearchStore with Store {

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  @observable
  VideoListSearch? videoListSearch;

  @observable
  bool success = false;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideos(String query, bool isRefresh) async {
    final client = SoundcloudClient();
    final stream = client.search(
        query,
        searchFilter: SearchFilter.tracks,
        offset: 0,
        limit: 50
    );
    final streamIterator = StreamIterator(stream);

    while (await streamIterator.moveNext()) {
      for (final result in streamIterator.current) {
        print(result.permalinkUrl);
        // Use pattern matching for mixed streams
      }
    }
  }
}

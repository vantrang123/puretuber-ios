
import 'package:collection/collection.dart';

import 'video_model.dart';

class VideoList {
  List<Video>? videos;

  VideoList({
    this.videos,
  });

  factory VideoList.fromJson(List<dynamic> json) {
    List<Video> videos = <Video>[];
    videos = json.map((video) => Video.fromMap(video)).toList();

    return VideoList(
      videos: videos,
    );
  }

  Map<String, List<Video>> groupByFavoriteName(List<Video> videos) {
    return groupBy(videos, (Video video) => video.favoriteName ?? '');
  }
}

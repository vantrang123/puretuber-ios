import 'package:mobx/mobx.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../../models/content_details_model.dart';
import '../../models/statistics_model.dart';
import '../../models/video_list_search.dart';
import '../../models/video_model.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'video_store.g.dart';

class VideoStore = _VideoStore with _$VideoStore;

abstract class _VideoStore with Store {

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // store variables:-----------------------------------------------------------
  static ObservableFuture<exploreYT.VideoSearchList?> emptyVideoResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<exploreYT.VideoSearchList?> fetchVideosFuture =
  ObservableFuture<exploreYT.VideoSearchList?>(emptyVideoResponse);

  @observable
  VideoListSearch? videoListSearch;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchVideosFuture.status == FutureStatus.pending;

  exploreYT.VideoSearchList? _videoSearchList;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideos(String query, bool isRefresh) async {
    final yt = exploreYT.YoutubeExplode();
    final future = yt.search.search(query);

    fetchVideosFuture = ObservableFuture(future);
    future.then((videoList) {
      _videoSearchList = videoList;
      handleResult(videoList, isRefresh);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future getVideosNextPage() async {
    final future = _videoSearchList?.nextPage();
    if (null != future) {
      fetchVideosFuture = ObservableFuture(future);
      future.then((value) {
        _videoSearchList = value;
        handleResult(value!, false);
      }).catchError((error) {
        errorStore.errorMessage = DioErrorUtil.handleError(error);
      });
    }
  }

  void handleResult(exploreYT.VideoSearchList videoList, bool isRefresh) {
    var myList = <Video>[];

    for (var index = 0; index < videoList.length; index++) {
      final value = videoList[index];
      final durationSplit = value.duration.toString().split(':').reversed.toList();
      final seconds = durationSplit.length >= 1 && durationSplit[0] != 'null' ? durationSplit[0] : 0;
      final minutes = durationSplit.length >= 2 ? durationSplit[1] : 0;
      final hours = durationSplit.length >= 3 ? durationSplit[2] : 0;
      final video = Video(
          id: value.id.value,
          title: value.title,
          thumbnailUrl: value.thumbnails.highResUrl,
          channelTitle: value.author,
          uploadDateRaw: value.uploadDateRaw,
          publishedAt: value.uploadDate.toString(),
          channelId: value.channelId.value,
          contentDetailsModel: ContentDetailsModel(
            duration: 'PT${hours}H${minutes}M${seconds}S',
          ),
          statisticsModel: StatisticsModel(
              viewCount: value.engagement.viewCount.toString()));
      if (null != value.duration) {
        myList.add(video);
      }
    }
    this.videoListSearch = isRefresh == true
        ? VideoListSearch(videos: myList)
        : VideoListSearch(videos: videoListSearch!.videos!..addAll(myList));
  }
}

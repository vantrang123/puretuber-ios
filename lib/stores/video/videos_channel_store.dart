import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../../data/repository/channel_repository.dart';
import '../../models/content_details_model.dart';
import '../../models/statistics_model.dart';
import '../../models/video_list_search.dart';
import '../../models/video_model.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'videos_channel_store.g.dart';

class VideosChannelStore = _VideosChannelStore with _$VideosChannelStore;

abstract class _VideosChannelStore with Store {
  // repository instance
  late ChannelRepository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _VideosChannelStore(ChannelRepository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<exploreYT.ChannelUploadsList?> emptyResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<exploreYT.ChannelUploadsList?> fetchDataFuture =
      ObservableFuture<exploreYT.ChannelUploadsList?>(emptyResponse);

  @observable
  VideoListSearch? videosChannel;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchDataFuture.status == FutureStatus.pending;

  exploreYT.ChannelUploadsList? _channelUploadsList;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideosChannel(String channelId) async {
    final future = _repository.getVideosChannel(channelId);
    fetchDataFuture = ObservableFuture(future);

    future.then((data) {
      this._channelUploadsList = data;
      handleResult(_channelUploadsList!, true);
    }).catchError((error) {
      errorStore.errorMessage = error is DioError ? DioErrorUtil.handleError(error) : errorStore.errorMessage = error.toString();
    });
  }

  @action
  Future getVideosNextPage() async {
    final future = _channelUploadsList?.nextPage();
    if (null != future) {
      fetchDataFuture = ObservableFuture(future);
      future.then((value) {
        _channelUploadsList = value;
        handleResult(value!, false);
      }).catchError((error) {
        errorStore.errorMessage = DioErrorUtil.handleError(error);
      });
    }
  }

  void handleResult(exploreYT.ChannelUploadsList videoList, bool isRefresh) {
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
          channelId: value.channelId.value,
          publishedAt: value.uploadDate.toString(),
          contentDetailsModel: ContentDetailsModel(
            duration: 'PT${hours}H${minutes}M${seconds}S',
          ),
          statisticsModel: StatisticsModel(
              viewCount: value.engagement.viewCount.toString()));
      myList.add(video);
    }
    this.videosChannel = isRefresh == true
        ? VideoListSearch(videos: myList)
        : VideoListSearch(videos: videosChannel!.videos!..addAll(myList));
  }
}

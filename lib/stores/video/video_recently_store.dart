import 'package:mobx/mobx.dart';

import '../../data/local/datasources/video/video_datasource.dart';
import '../../di/components/service_locator.dart';
import '../../models/video_list.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'video_recently_store.g.dart';

class VideoRecentlyStore = _VideoRecentlyStore with _$VideoRecentlyStore;

abstract class _VideoRecentlyStore with Store {

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // store variables:-----------------------------------------------------------
  static ObservableFuture<VideoList?> emptyVideoResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<VideoList?> fetchVideosFuture =
      ObservableFuture<VideoList?>(emptyVideoResponse);

  @observable
  VideoList? videoList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchVideosFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideosRecently(bool isRefresh) async {
    getIt<VideoDataSource>().getVideosFromDb().then((value) {
      this.videoList = value;
    }).catchError((onError) {
      errorStore.errorMessage = DioErrorUtil.handleError(onError);
    });
  }
}

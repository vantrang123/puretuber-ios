import 'package:mobx/mobx.dart';

import '../../data/local/datasources/video/channel_datasource.dart';
import '../../di/components/service_locator.dart';
import '../../models/video_list.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'subscribe_channel_store.g.dart';

class SubscribeChannelStore = _SubscribeChannelStore with _$SubscribeChannelStore;

abstract class _SubscribeChannelStore with Store {

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // store variables:-----------------------------------------------------------
  static ObservableFuture<VideoList?> emptyVideoResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<VideoList?> fetchVideosFuture =
      ObservableFuture<VideoList?>(emptyVideoResponse);

  @observable
  List<String>? channelIds;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchVideosFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getSubscribeChannelId() async {
    getIt<ChannelDataSource>().getChannelIdsFromDb().then((value) {
      this.channelIds = value;
      print('channelIds ${value.length}');
    }).catchError((onError) {
      errorStore.errorMessage = DioErrorUtil.handleError(onError);
    });
  }
}

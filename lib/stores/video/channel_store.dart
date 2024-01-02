import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../../data/repository/channel_repository.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'channel_store.g.dart';

class ChannelStore = _ChannelStore with _$ChannelStore;

abstract class _ChannelStore with Store {
  // repository instance
  late ChannelRepository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _ChannelStore(ChannelRepository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<exploreYT.Channel?> emptyResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<exploreYT.Channel?> fetchDataFuture =
      ObservableFuture<exploreYT.Channel?>(emptyResponse);

  @observable
  exploreYT.Channel? channel;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchDataFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getChannel(String channelId) async {
    final future = _repository.getChannel(channelId);
    fetchDataFuture = ObservableFuture(future);

    future.then((data) {
      this.channel = data;
    }).catchError((error) {
      errorStore.errorMessage = error is DioError ? DioErrorUtil.handleError(error) : errorStore.errorMessage = error.toString();
    });
  }
}

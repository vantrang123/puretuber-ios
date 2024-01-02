import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'player_store.g.dart';

class PlayerStore = _PlayerStore with _$PlayerStore;

abstract class _PlayerStore with Store {
  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // store variables:-----------------------------------------------------------
  static ObservableFuture<VideoPlayerController?> emptyPlayerResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<VideoPlayerController?> controller =
      ObservableFuture<VideoPlayerController?>(emptyPlayerResponse);

  @observable
  VideoPlayerController? playerController;

  @observable
  bool success = false;

  @computed
  bool get loading => controller.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future initVideoPlayerControl(VideoPlayerController controller) async {
    success = false;
    try {
      await Future.wait([controller.initialize()])
          .then((_)  {
            this.playerController?.dispose();
            this.playerController = controller;
            success = true;
          }
      );
    } on Exception catch (error) {
      success = false;
      errorStore.errorMessage = (error is PlatformException ? error.message : DioErrorUtil.handleError(error as DioError))!;
    }
  }
}

import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

part 'explore_store.g.dart';

class ExploreStore = _ExploreStore with _$ExploreStore;

abstract class _ExploreStore with Store {
  // store variables:-----------------------------------------------------------
  static ObservableFuture<String?> emptyVideoResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<String?> fetchVideosFuture =
      ObservableFuture<String?>(emptyVideoResponse);

  @observable
  String? videoStreamUrl;

  @observable
  String? audioStreamUrl;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchVideosFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideoStreamUrl(String videoId) async {
    success = false;
    final yt = exploreYT.YoutubeExplode();
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final streamInfo = manifest.muxed;
    print("Day la link video: ${streamInfo.last.url.toString()}");
    this.videoStreamUrl = streamInfo.last.url.toString();
    this.audioStreamUrl =  Platform.isAndroid ? manifest.audioOnly.last.url.toString() : manifest.audioOnly[1].url.toString() ;
    print("Day la link audio: ${this.audioStreamUrl}");
    success = true;
    yt.close();
  }
}

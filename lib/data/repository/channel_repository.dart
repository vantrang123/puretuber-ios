import 'package:free_tuber/di/components/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../network/apis/my_explore.dart';

class ChannelRepository {
  // Get: ---------------------------------------------------------------------
  Future<Channel> getChannel(String channelId) async {
    final yt = getIt<MyExplore>().youtubeExplode;
    return await yt.channels.get(channelId).then((value) {
      return value;
    }).catchError((error) {
      throw error;
    });
  }

  Future<ChannelUploadsList> getVideosChannel(String channelId) async {
    final yt = getIt<MyExplore>().youtubeExplode;
    return await yt.channels.getUploadsFromPage(channelId).then((value) {
      return value;
    }).catchError((error) {
      throw error;
    });
  }
}

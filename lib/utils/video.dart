import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../models/content_details_model.dart';
import '../models/statistics_model.dart';
import '../models/video_model.dart';

convert(exploreYT.Video value) {
  final durationSplit = value.duration.toString().split(':').reversed.toList();
  final seconds = durationSplit.length >= 1 && durationSplit[0] != 'null' ? durationSplit[0] : 0;
  final minutes = durationSplit.length >= 2 ? durationSplit[1] : 0;
  final hours = durationSplit.length >= 3 ? durationSplit[2] : 0;
  return Video(
      id: value.id.value,
      title: value.title,
      thumbnailUrl: value.thumbnails.highResUrl,
      channelTitle: value.author,
      uploadDateRaw: value.uploadDateRaw ?? "",
      channelId: value.channelId.value,
      contentDetailsModel: ContentDetailsModel(
        duration: 'PT${hours}H${minutes}M${seconds}S',
      ),
      statisticsModel:
      StatisticsModel(viewCount: value.engagement.viewCount.toString()));
}

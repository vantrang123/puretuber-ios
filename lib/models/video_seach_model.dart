import 'content_details_model.dart';
import 'statistics_model.dart';
import 'video_model.dart';

class VideoSearch extends Video {
  String? id;
  String? title;
  String? thumbnailUrl;
  String? channelTitle;
  String? publishedAt;
  String? channelId;
  String? uploaderUrl;
  String? uploaderName;
  StatisticsModel? statisticsModel;
  ContentDetailsModel? contentDetailsModel;

  VideoSearch(
      {this.id,
      this.title,
      this.thumbnailUrl,
      this.channelTitle,
      this.publishedAt,
      this.channelId,
      this.uploaderUrl,
      this.uploaderName,
      this.statisticsModel,
      this.contentDetailsModel});

  // pass in the individual results from searchresult['items']
  factory VideoSearch.fromMap(Map<String, dynamic> item) {
    try {
      return VideoSearch(
          id: item['id']['videoId'],
          title: item['snippet']['title'] ?? "",
          thumbnailUrl: item['snippet']['thumbnails']?['high']['url'] ?? "",
          channelTitle: item['snippet']['channelTitle'] ?? "",
          publishedAt: item['snippet']['publishedAt'] ?? "",
          channelId: item['snippet']['channelId'] ?? "",
          uploaderUrl: "",
          uploaderName: "");
    } catch(_) {
      return VideoSearch();
    }
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "thumbnailUrl": thumbnailUrl,
        "channelTitle": channelTitle,
        "publishedAt": publishedAt,
        "channelId": channelId,
        "uploaderUrl": '',
        "uploaderName": "",
        "avatarModel": channel,
        "statisticsModel": statisticsModel,
        "contentDetailsModel": contentDetailsModel
      };
}

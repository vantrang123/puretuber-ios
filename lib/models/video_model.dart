import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import 'content_details_model.dart';
import 'statistics_model.dart';

class Video {
  String? id;
  String? title;
  String? thumbnailUrl;
  String? channelTitle;
  String? publishedAt;
  String? channelId;
  String? uploaderUrl;
  String? uploaderName;
  exploreYT.Channel? channel;
  StatisticsModel? statisticsModel;
  ContentDetailsModel? contentDetailsModel;
  // VideoListSearch? videosRelated;
  String? author;
  String? uploadDate;
  String? description;
  String? duration;
  String? uploadDateRaw;
  bool isFocus = false;
  String? favoriteName;

  Video(
      {this.id,
      this.title,
      this.thumbnailUrl,
      this.channelTitle,
      this.publishedAt,
      this.channelId,
      this.uploaderUrl,
      this.uploaderName,
      this.channel,
      this.statisticsModel,
      this.contentDetailsModel,
      this.uploadDateRaw,
      this.favoriteName = ''});

  // pass in the individual results from searchresult['items']
  factory Video.fromMap(Map<String, dynamic> item) {
    return Video(
        id: item['id'],
        title: item['snippet']['title'],
        thumbnailUrl: item['snippet']['thumbnails']['high']['url'],
        // thumbnailUrl: item['snippet']['thumbnails']['medium']['url'],
        channelTitle: item['snippet']['channelTitle'],
        publishedAt: item['snippet']['publishedAt'],
        channelId: item['snippet']['channelId'],
        contentDetailsModel: ContentDetailsModel.fromMap(item['contentDetails']),
        statisticsModel: StatisticsModel.fromMap(item['statistics']),
        favoriteName: item['favoriteName']
        // uploaderUrl: "",
        // uploaderName: ""
    );
  }

  Map<String, dynamic> toMap() => {
        'id': '$id',
        'title': '$title',
        'thumbnailUrl': "$thumbnailUrl",
        'channelTitle': "$channelTitle",
        'publishedAt': '$publishedAt',
        'channelId': '$channelId',
        'statisticsModel': statisticsModel?.toMap(),
        'contentDetailsModel': contentDetailsModel?.toMap(),
        'uploadDateRaw': '$uploadDateRaw',
        'favoriteName': '$favoriteName'
      };

  factory Video.fromJson(Map<String, dynamic> item) {
    return Video(
        id: item['id'],
        title: item['title'],
        thumbnailUrl: item['thumbnailUrl'],
        channelTitle: item['channelTitle'],
        publishedAt: item['publishedAt'],
        channelId: item['channelId'],
        contentDetailsModel:
            ContentDetailsModel.fromMap(item['contentDetailsModel']),
        statisticsModel: StatisticsModel.fromMap(item['statisticsModel']),
        uploadDateRaw: item['uploadDateRaw'],
        favoriteName: item['favoriteName']);
  }
}

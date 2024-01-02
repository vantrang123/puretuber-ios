import 'package:locale_plus/locale_plus.dart';

import '../../../../constants/strings.dart';
import '../../../../models/content_details_model.dart';
import '../../../../models/statistics_model.dart';
import '../../../../models/video_list.dart';
import '../../../../models/video_list_search.dart';
import '../../constants/endpoints.dart';
import '../../dio_client.dart';

class VideoApi {
  // dio instance
  final DioClient _dioClient;

  VideoApi(this._dioClient);

  String nextPageFilm = '';
  String nextPageTrendingMusic = '';
  String nextPageTrendingSport = '';
  String nextPageTrendingEntertainment = '';
  String nextPageTrendingGame = '';
  String nextPageAll = '';
  String nextPageVideos = '';

  /// Returns list of trending in response
  Future<VideoList> getVideosTrending(bool isRefresh, String categoryId) async {
    String nextPageToken = '';
    if (isRefresh == true) {
      nextPageToken = '';
    } else {
      switch (categoryId) {
        case Strings.categoryCodeFilm:
          nextPageToken = nextPageFilm;
          break;
        case Strings.categoryCodeMusic:
          nextPageToken = nextPageTrendingMusic;
          break;
        case Strings.categoryCodeSport:
          nextPageToken = nextPageTrendingSport;
          break;
        case Strings.categoryCodeEntertainment:
          nextPageToken = nextPageTrendingEntertainment;
          break;
        case Strings.categoryCodeGame:
          nextPageToken = nextPageTrendingGame;
          break;
      }
    }

    if (nextPageToken != Strings.none) {
      try {
        final regionCode = await LocalePlus().getRegionCode() ?? "US";
        Map<String, String> parameters = {
          'part': 'snippet,contentDetails,statistics',
          'maxResults': '50',
          'chart': 'mostPopular',
          'videoCategoryId': categoryId,
          'pageToken': nextPageToken,
          'key': Strings.apikey,
          'regionCode': regionCode,
        };

        final res = await _dioClient.get(Endpoints.getVideosTrending,
            queryParameters: parameters);

        nextPageToken = res['nextPageToken'] ?? Strings.none;

        switch (categoryId) {
          case Strings.categoryCodeFilm:
            nextPageFilm = nextPageToken;
            break;
          case Strings.categoryCodeMusic:
            nextPageTrendingMusic = nextPageToken;
            break;
          case Strings.categoryCodeSport:
            nextPageTrendingSport = nextPageToken;
            break;
          case Strings.categoryCodeEntertainment:
            nextPageTrendingEntertainment = nextPageToken;
            break;
          case Strings.categoryCodeGame:
            nextPageTrendingGame = nextPageToken;
            break;
        }

        return VideoList.fromJson(res['items']);
      } catch (e) {
        print(e.toString());
        throw e;
      }
    } else {
      return VideoList();
    }
  }

  /// Returns list of trending in response
  Future<VideoList> getVideosTrendingAll(bool isRefresh) async {
    if (isRefresh == true) {
      nextPageAll = '';
    }
    if (nextPageAll != Strings.none) {
      try {
        final regionCode = await LocalePlus().getRegionCode() ?? "US";
        Map<String, String> parameters = {
          'part': 'snippet,contentDetails,statistics',
          'maxResults': '50',
          'chart': 'mostPopular',
          'pageToken': nextPageAll,
          'key': Strings.apikey,
          'regionCode': regionCode,
        };

        final res = await _dioClient.get(Endpoints.getVideosTrending,
            queryParameters: parameters);

        nextPageAll = res['nextPageToken'] ?? Strings.none;

        return VideoList.fromJson(res['items']);
      } catch (e) {
        print(e.toString());
        throw e;
      }
    } else {
      return VideoList();
    }
  }

  /// Returns list of videos in response
  Future<VideoListSearch> getVideos(String query, bool isRefresh) async {
    if (isRefresh == true) {
      nextPageVideos = '';
    }
    try {
      final regionCode = await LocalePlus().getRegionCode() ?? "US";
      Map<String, String> parameters = {
        'part': 'snippet',
        'maxResults': '50',
        'q': query,
        'type': 'video',
        'order': 'relevance',
        'pageToken': nextPageVideos,
        'key': Strings.apikey,
        'regionCode': regionCode
      };
      final res = await _dioClient.get(Endpoints.getVideosSearch,
          queryParameters: parameters);
      nextPageVideos = res['nextPageToken'] ?? '';
      return VideoListSearch.fromJson(res['items']);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<StatisticsModel> getStatisticsVideo(String videoId) async {
    try {
      Map<String, String> parameters = {
        'part': 'statistics',
        'id': videoId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getVideosTrending,
          queryParameters: parameters);
      return StatisticsModel.fromJson(res['items'][0]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<ContentDetailsModel> getContentDetails(String videoId) async {
    try {
      Map<String, String> parameters = {
        'part': 'contentDetails',
        'id': videoId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getVideosTrending,
          queryParameters: parameters);
      return ContentDetailsModel.fromJson(res['items'][0]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  /// Returns list of videos in response
  Future<VideoListSearch> getVideosRelated(
      String videoId, bool isRefresh) async {
    if (isRefresh == true) {
      nextPageVideos = '';
    }
    try {
      final regionCode = await LocalePlus().getRegionCode() ?? "US";
      Map<String, String> parameters = {
        'part': 'snippet',
        'relatedToVideoId': videoId,
        'maxResults': '50',
        'type': 'video',
        'order': 'relevance',
        'pageToken': nextPageVideos,
        'key': Strings.apikey,
        'regionCode': regionCode
      };
      final res = await _dioClient.get(Endpoints.getVideosSearch,
          queryParameters: parameters);
      nextPageVideos = res['nextPageToken'] ?? '';
      return VideoListSearch.fromJson(res['items']);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<VideoListSearch> getVideosChannel(
      String channelId, bool isRefresh) async {
    if (isRefresh == true) {
      nextPageVideos = '';
    }
    try {
      Map<String, String> parameters = {
        'part': 'snippet',
        'id': channelId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getChannel,
          queryParameters: parameters);
      nextPageVideos = res['nextPageToken'] ?? '';
      return VideoListSearch.fromJson(res['items']);
    } catch (e) {
      print("getStatisticsChannelError: " + e.toString());
      throw e;
    }
  }
}

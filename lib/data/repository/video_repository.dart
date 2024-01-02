import 'dart:async';

import 'package:free_tuber/constants/strings.dart';

import '../../models/content_details_model.dart';
import '../../models/statistics_model.dart';
import '../../models/video_list.dart';
import '../../models/video_list_search.dart';
import '../local/datasources/video/video_datasource.dart';
import '../network/apis/videos/video_api.dart';
import '../sharedpref/shared_preference_helper.dart';

class VideoRepository {
  // data source object
  final VideoDataSource _videoDataSource;

  // api objects
  final VideoApi _videoApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  VideoRepository(
      this._videoApi, this._sharedPrefsHelper, this._videoDataSource);

  // Get: ---------------------------------------------------------------------
  Future<VideoList> getVideosTrending(bool isRefresh) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _videoApi
        .getVideosTrendingAll(isRefresh)
        .then((videosTrendingList) {
      return videosTrendingList;
    }).catchError((error) => throw error);
  }

  // Get: ---------------------------------------------------------------------
  Future<VideoList> getVideosTrendingEntertainment(bool isRefresh) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _videoApi
        .getVideosTrending(isRefresh, Strings.categoryCodeEntertainment)
        .then((videosTrendingList) {
      return videosTrendingList;
    }).catchError((error) => throw error);
  }

  // Get: ---------------------------------------------------------------------
  Future<VideoList> getVideosFilm(bool isRefresh) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _videoApi
        .getVideosTrending(isRefresh, Strings.categoryCodeGame)
        .then((videosTrendingList) {
      return videosTrendingList;
    }).catchError((error) => throw error);
  }

  // Get: ---------------------------------------------------------------------
  Future<VideoList> getVideosMusic(bool isRefresh) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _videoApi
        .getVideosTrending(isRefresh, Strings.categoryCodeMusic)
        .then((videosTrendingList) {
      return videosTrendingList;
    }).catchError((error) => throw error);
  }

  // Get: ---------------------------------------------------------------------
  Future<VideoList> getVideosSports(bool isRefresh) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _videoApi
        .getVideosTrending(isRefresh, Strings.categoryCodeSport)
        .then((videosTrendingList) {
      return videosTrendingList;
    }).catchError((error) => throw error);
  }

  // Get: ---------------------------------------------------------------------
  Future<VideoList> getVideosAnother(bool isRefresh) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _videoApi
        .getVideosTrending(isRefresh, Strings.categoryCodeGame)
        .then((videosTrendingList) {
      return videosTrendingList;
    }).catchError((error) => throw error);
  }

  Future<VideoListSearch> getVideos(String query, bool isRefresh) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _videoApi.getVideos(query, isRefresh).then((videosList) {
      return videosList;
    }).catchError((error) => throw error);
  }

  Future<StatisticsModel> getStatisticsVideo(String videoId) async {
    return await _videoApi
        .getStatisticsVideo(videoId)
        .then((videosTrendingList) {
      return videosTrendingList;
    }).catchError((error) => throw error);
  }

  Future<ContentDetailsModel> getContentDetails(String videoId) async {
    return await _videoApi
        .getContentDetails(videoId)
        .then((videosTrendingList) {
      return videosTrendingList;
    }).catchError((error) => throw error);
  }

  Future<VideoListSearch> getVideosRelated(String videoId, bool isRefresh) async {
    return await _videoApi.getVideosRelated(videoId, isRefresh).then((videosList) {
      return videosList;
    }).catchError((error) => throw error);
  }

  Future<VideoListSearch> getVideosChannel(
      String channelId, bool isRefresh) async {
    return await _videoApi
        .getVideosChannel(channelId, isRefresh)
        .then((videosList) {
      return videosList;
    }).catchError((error) => throw error);
  }
}

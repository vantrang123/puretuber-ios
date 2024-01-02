import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ads/interstitial_ads.dart';
import '../../data/local/datasources/video/channel_datasource.dart';
import '../../data/local/datasources/video/local_playlist_datasource.dart';
import '../../data/local/datasources/video/video_datasource.dart';
import '../../data/local/hive_service.dart';
import '../../data/network/apis/my_explore.dart';
import '../../data/network/apis/videos/video_api.dart';
import '../../data/network/dio_client.dart';
import '../../data/repository/channel_repository.dart';
import '../../data/repository/video_repository.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../events/my_event_bus.dart';
import '../../stores/error/error_store.dart';
import '../../stores/explore/explore_store.dart';
import '../../stores/player/player_store.dart';
import '../../stores/video/channel_store.dart';
import '../../stores/video/video_all_store.dart';
import '../../stores/video/video_entertainment_store.dart';
import '../../stores/video/video_music_store.dart';
import '../../stores/video/video_recently_store.dart';
import '../../stores/video/video_sports_store.dart';
import '../../stores/video/video_store.dart';
import '../../stores/video/video_local_store.dart';
import '../../stores/video/videos_channel_store.dart';
import '../../ui/player/audio_manager.dart';
import '../module/local_module.dart';
import '../module/network_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // factories:-----------------------------------------------------------------
  getIt.registerFactory(() => ErrorStore());

  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<Database>(() => LocalModule.provideDatabase());
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(
      NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerLazySingleton<MyEventBus>(() => MyEventBus());
  getIt.registerLazySingleton<MyExplore>(() => MyExplore());
  getIt.registerSingleton(InterstitialAds());

  // api's:---------------------------------------------------------------------
  getIt.registerSingleton(VideoApi(getIt<DioClient>()));

  // data sources
  getIt.registerSingleton(VideoDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(HiveService());
  getIt.registerSingleton(LocalPlaylistDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(ChannelDataSource(await getIt.getAsync<Database>()));

  // repository:----------------------------------------------------------------
  getIt.registerSingleton(VideoRepository(
    getIt<VideoApi>(),
    getIt<SharedPreferenceHelper>(),
    getIt<VideoDataSource>(),
  ));
  getIt.registerSingleton(ChannelRepository());

  // stores
  getIt.registerSingleton(VideoStore());
  getIt.registerSingleton(ExploreStore());
  getIt.registerSingleton(PlayerStore());
  getIt.registerSingleton(VideoLocalStore());
  getIt.registerSingleton(VideoRecentlyStore());
  getIt.registerSingleton(ChannelStore(getIt<ChannelRepository>()));
  getIt.registerSingleton(VideosChannelStore(getIt<ChannelRepository>()));
  getIt.registerSingleton(VideoMusicStore(getIt<VideoRepository>()));
  getIt.registerSingleton(VideoSportsStore(getIt<VideoRepository>()));
  getIt.registerSingleton(VideoAllStore(getIt<VideoRepository>()));
  getIt.registerSingleton(VideoEntertainmentStore(getIt<VideoRepository>()));

  //service
  getIt.registerLazySingleton<AudioManager>(() => AudioManager());
}

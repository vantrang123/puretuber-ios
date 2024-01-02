import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../constants/app_theme.dart';
import '../constants/strings.dart';
import '../data/repository/channel_repository.dart';
import '../data/repository/video_repository.dart';
import '../di/components/service_locator.dart';
import '../provider/bottom_navigation_provider.dart';
import '../provider/collapsed_panel_control.dart';
import '../provider/load_more.dart';
import '../provider/audio_control.dart';
import '../provider/home_tab.dart';
import '../provider/local_playlist_provider.dart';
import '../provider/search_provider.dart';
import '../provider/show_hide_control.dart';
import '../provider/update_app_provider.dart';
import '../provider/video_control.dart';
import '../provider/video_duration_change.dart';
import '../provider/video_focus_change.dart';
import '../stores/explore/explore_store.dart';
import '../stores/player/player_store.dart';
import '../stores/soundcloud/soundcloud_search_store.dart';
import '../stores/video/channel_store.dart';
import '../stores/video/subscribe_channel_store.dart';
import '../stores/video/video_all_store.dart';
import '../stores/video/video_dashboard_store.dart';
import '../stores/video/video_entertainment_store.dart';
import '../stores/video/video_music_store.dart';
import '../stores/video/video_related_store.dart';
import '../stores/video/video_sports_store.dart';
import '../stores/video/videos_channel_store.dart';
import '../stores/video/video_recently_store.dart';
import '../stores/video/video_store.dart';
import '../stores/video/video_local_store.dart';
import '../utils/routes/routes.dart';
import '../widgets/base_widget.dart';
import 'home/home.dart';

class MyApp extends StatelessWidget {
  final VideoStore _videoStore = VideoStore();
  final VideoDashboardStore _videoDashboardStore = VideoDashboardStore();
  final SoundCloudSearchStore _soundCloudSearchStore = SoundCloudSearchStore();
  final VideoRelatedStore _videoRelatedStore = VideoRelatedStore();
  final VideoLocalStore _videoTrendingStore =
      VideoLocalStore();
  final ExploreStore _exploreStore = ExploreStore();
  final PlayerStore _playerStore = PlayerStore();
  final SubscribeChannelStore _subscribeChannelStore = SubscribeChannelStore();
  final ChannelStore _channelStore = ChannelStore(getIt<ChannelRepository>());
  final VideosChannelStore _videoChannelStore = VideosChannelStore(getIt<ChannelRepository>());
  final _videoRecentlyStore = VideoRecentlyStore();
  final VideoAllStore _allStore = VideoAllStore(getIt<VideoRepository>());
  final VideoEntertainmentStore _entertainmentStore = VideoEntertainmentStore(getIt<VideoRepository>());
  final VideoMusicStore _musicStore = VideoMusicStore(getIt<VideoRepository>());
  final VideoSportsStore _sportStore = VideoSportsStore(getIt<VideoRepository>());
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<VideoStore>(create: (_) => _videoStore),
        Provider<VideoDashboardStore>(create: (_) => _videoDashboardStore),
        Provider<SoundCloudSearchStore>(create: (_) => _soundCloudSearchStore),
        Provider<VideoLocalStore>(create: (_) => _videoTrendingStore),
        Provider<ExploreStore>(create: (_) => _exploreStore),
        Provider<PlayerStore>(create: (_) => _playerStore),
        Provider<ChannelStore>(create: (_) =>_channelStore),
        Provider<VideosChannelStore>(create: (_) =>_videoChannelStore),
        Provider<VideoRecentlyStore>(create: (_) =>_videoRecentlyStore),
        Provider<SubscribeChannelStore>(create: (_) => _subscribeChannelStore),
        Provider<VideoRelatedStore>(create: (_) => _videoRelatedStore),
        Provider<VideoAllStore>(create: (_) => _allStore),
        Provider<VideoEntertainmentStore>(create: (_) => _entertainmentStore),
        Provider<VideoMusicStore>(create: (_) => _musicStore),
        Provider<VideoSportsStore>(create: (_) => _sportStore),
        ChangeNotifierProvider<HomeTabProvider>(
            create: (context) => HomeTabProvider()),
        ChangeNotifierProvider<ManagerSearchProvider>(
            create: (context) => ManagerSearchProvider()),
        ChangeNotifierProvider<VideoControlProvider>(
            create: (context) => VideoControlProvider()),
        ChangeNotifierProvider<AudioControlProvider>(
            create: (context) => AudioControlProvider()),
        ChangeNotifierProvider<VideoDurationChange>(
            create: (context) => VideoDurationChange()),
        ChangeNotifierProvider<LoadMoreProvider>(
            create: (context) => LoadMoreProvider()),
        ChangeNotifierProvider<CollapsedPanelControl>(
            create: (context) => CollapsedPanelControl()),
        ChangeNotifierProvider<VideoFocusChange>(
            create: (context) => VideoFocusChange()),
        ChangeNotifierProvider<ShowHideControl>(
            create: (context) => ShowHideControl()),
        ChangeNotifierProvider<LocalPlaylistProvider>(
            create: (context) => LocalPlaylistProvider()),
        ChangeNotifierProvider<AppUpdateProvider>(
            create: (context) => AppUpdateProvider()),
        ChangeNotifierProvider<BottomNavigationProvider>(
            create: (context) => BottomNavigationProvider())
      ],
      child: Observer(
          name: 'global-observer',
          builder: (context) {
            return MaterialApp(
              color: Theme.of(context).scaffoldBackgroundColor,
              debugShowCheckedModeBanner: false,
              title: Strings.appName,
              theme: themeDataDark,
              routes: Routes.routes,
              navigatorKey: _navigator,
              builder: (context, child) => BaseWidget(child: child!),
              home: SafeArea(
                  child: WillPopScope(
                      child: Home(),
                      onWillPop: () {
                        return Future.value(true);
                      })
              ),
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../../models/video_model.dart';
import '../../ui/channel/channel_detail.dart';
import '../../ui/home/home.dart';
import '../../ui/info_app/info_app_screen.dart';
import '../../ui/player/player.dart';
import '../../ui/playlist/playlist_detail_screen.dart';
import '../../ui/search/search.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String player = '/player';
  static const String search = '/search';
  static const String channel = '/channel';
  static const String info = '/info';
  static const String playlist_detail_screen = '/list_video_screen';

  static final routes = <String, WidgetBuilder>{
    player: (BuildContext context) => PlayerScreen(
        video: ((ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map)['video'] as Video,
        isFromCollapsed: ((ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map)['isFromCollapsed'] ?? false),
    channel: (BuildContext context) => ChannelPageDetail(
        channel: ModalRoute.of(context)?.settings.arguments as exploreYT.Channel),
    home: (BuildContext context) => Home(),
    info: (BuildContext context) => InfoAppScreen(),
    playlist_detail_screen: (BuildContext context) => PlaylistDetailScreen(
        type: ((ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map)['type'] ??
            ''
    ),
    search: (BuildContext context) => SearchScreen(),
  };
}

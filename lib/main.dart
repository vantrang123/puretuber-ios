import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_tuber/constants/colors.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'di/components/service_locator.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'models/keyword_search.dart';
import 'ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();
  await setupLocator();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.trangdv.playit.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidShowNotificationBadge: true,
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/ic_notification',
  );
  final appDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);
  Hive.registerAdapter(KeywordSearchAdapter());
  Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(MyApp());
}

Future<void> setPreferredOrientations() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.backgroundColor
  ));
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

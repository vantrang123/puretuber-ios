import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constants/strings.dart';
import '../../../di/components/service_locator.dart';
import '../../../events/my_event_bus.dart';
import '../../../events/reload_video_viewed.dart';
import '../../../stores/video/video_recently_store.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/url_laucher.dart';
import '../../../widgets/local_playlists.dart';
import '../../../widgets/more_item.dart';
import '../../components/streams_large_thumbnail.dart';

class HomeLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideoRecentlyStore _localStore =
    Provider.of<VideoRecentlyStore>(context, listen: false);
    if (!_localStore.loading && (_localStore.videoList == null ||
        _localStore.videoList?.videos?.isEmpty == true)) {
      _localStore.getVideosRecently(true);
    }

    getIt<MyEventBus>().eventBus.on<ReloadVideoViewed>().listen((event) {
      _localStore.getVideosRecently(true);
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 10, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(builder: (context) {
              return _localStore.videoList?.videos?.isNotEmpty == true ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamsLargeThumbnailView(
                    title: 'Watch History',
                    infoItems: _localStore.videoList?.videos ?? [],
                    onReachingListEnd: () {},
                    viewAllCallback: () {
                      Navigator.pushNamed(
                          context,
                          Routes.playlist_detail_screen,
                          arguments: {'type': Strings.recently}
                      );
                    },
                  ),
                  SizedBox(height: 20)
                ],
              )
                  : SizedBox.shrink();
            }),
            LocalPlaylists(),
            SizedBox(height: 20),
            Text('Info',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)
            ),
            SizedBox(height: 2),
            MoreItem(title: 'App Info', iconName: IconType.info, onTap: () {
              Navigator.pushNamed(context, Routes.info);
            }),
            MoreItem(title: 'Term', iconName: IconType.term, onTap: () {
              openUrl('https://lifesolutionstechnology.blogspot.com/2023/12/privacy-policy.html');
            }),
            SizedBox(height: 20),
            Text('About',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)
            ),
            MoreItem(title: 'Rate us', iconName: IconType.rate, onTap: () {
              LaunchReview.launch(androidAppId: Strings.appPackageName, iOSAppId: Strings.appleID);
            }),
            MoreItem(title: 'Share with friends', iconName: IconType.share, onTap: () {
              final box = context.findRenderObject() as RenderBox?;
              Share.share(
                  'https://play.google.com/store/apps/details?id=${Strings.appPackageName}',
                  subject: Strings.appName,
                  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
              );
            }),
          ],
        ),
      ),
    );
  }
}

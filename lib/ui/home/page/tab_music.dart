import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../ads/native_ads.dart';
import '../../../stores/video/video_music_store.dart';
import '../../../widgets/video_large_widget.dart';
import '../../components/shimmer_large.dart';

class TabMusic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get all trending
    final VideoMusicStore _store =
    Provider.of<VideoMusicStore>(context, listen: false);
    if (!_store.loading && _store.videoList == null ||
        _store.videoList?.videos?.isEmpty == true) {
      _store.getVideosMusic(true);
    }
    return Observer(builder: (context) {
      final listData = _store.videoList?.videos ?? [];
      return listData.isNotEmpty ? NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = 200.0;
          if (maxScroll - currentScroll <= delta && !_store.loading) {
            _store.getVideosMusic(false);
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final video = listData[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      VideoLargeWidget(video: video),
                      if (index == 4)
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: NativeAds(type: "Medium"),
                        ),
                    ],
                  )
                );
              }, childCount: listData.length),
            )
          ],
        ),
      ) : ShimmerLarge();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../ads/native_ads.dart';
import '../../../stores/video/video_all_store.dart';
import '../../../widgets/video_large_widget.dart';
import '../../components/shimmer_large.dart';

class TabTrending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get all trending
    final VideoAllStore _trendingAllStore =
    Provider.of<VideoAllStore>(context, listen: false);
    if (!_trendingAllStore.loading && _trendingAllStore.videoList == null ||
        _trendingAllStore.videoList?.videos?.isEmpty == true) {
      _trendingAllStore.getVideosTrendingAll(true);
    }

    return Observer(builder: (context) {
      final listData = _trendingAllStore.videoList?.videos ?? [];
      return listData.isNotEmpty ? NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = 200.0;
          if (maxScroll - currentScroll <= delta && !_trendingAllStore.loading) {
            _trendingAllStore.getVideosTrendingAll(false);
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
                  ),
                );
              }, childCount: listData.length),
            )
          ],
        ),
      ) : ShimmerLarge();
    });
  }
}

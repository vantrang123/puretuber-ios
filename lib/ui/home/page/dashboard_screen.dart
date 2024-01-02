import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../ads/native_ads.dart';
import '../../../stores/video/video_dashboard_store.dart';
import '../../../widgets/video_large_widget.dart';
import '../../components/shimmer_large.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final VideoDashboardStore _videoDashboardStore =
    Provider.of<VideoDashboardStore>(context, listen: false);
    if (!_videoDashboardStore.loading && _videoDashboardStore.videoListSearch?.videos == null ||
        _videoDashboardStore.videoListSearch?.videos?.isEmpty == true) {
      _videoDashboardStore.getVideos('trending music', true);
    }
    return Observer(builder: (context) {
      final listData = _videoDashboardStore.videoListSearch?.videos ?? [];
      return listData.isNotEmpty ? NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = 200.0;
          if (maxScroll - currentScroll <= delta && !_videoDashboardStore.loading) {
            _videoDashboardStore.getVideosNextPage();
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final video = listData[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Column(
                    children: [
                      VideoLargeWidget(video: video),
                      if (index == 0)
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

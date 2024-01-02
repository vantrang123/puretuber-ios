import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../../../ads/native_ads.dart';
import '../../../data/network/apis/my_explore.dart';
import '../../../di/components/service_locator.dart';
import '../../../models/video_model.dart';
import '../../../stores/video/subscribe_channel_store.dart';
import '../../../stores/video/videos_channel_store.dart';
import '../../../utils/routes/routes.dart';
import '../../../widgets/avatar_channel.dart';
import '../../../widgets/video_large_widget.dart';
import '../../components/shimmer_large.dart';

class HomeSubscriptions extends StatefulWidget {
  @override
  _HomeSubscriptions createState() => _HomeSubscriptions();
}

class _HomeSubscriptions extends State<HomeSubscriptions> {
  late SubscribeChannelStore _subscribeChannelStore;
  late VideosChannelStore _videosChannelStore;
  List<Video> listData = [];
  List<String> _channelIds = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    _subscribeChannelStore = Provider.of<SubscribeChannelStore>(context, listen: false);
    _videosChannelStore = Provider.of<VideosChannelStore>(context, listen: false);
    _subscribeChannelStore.getSubscribeChannelId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Observer(builder: (context) {
            final channelIds = _subscribeChannelStore.channelIds ?? [];
            return SizedBox(
                height: 52,
                child: ListView.builder(
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: channelIds.length,
                    itemBuilder: (context, index) {
                      if (channelIds.isNotEmpty) {
                        return _itemChannel(channelIds[index]);
                      } else {
                        return SizedBox.shrink();
                      }
                    }));
          }),
          const SizedBox(height: 8),
          Expanded(
              child: Observer(
                  builder: (context) {
                    if (null != _subscribeChannelStore.channelIds && _subscribeChannelStore.channelIds!.isNotEmpty && (_channelIds.isEmpty || _channelIds != _subscribeChannelStore.channelIds)) {
                      _subscribeChannelStore.channelIds?.forEach((channelId) {
                        _videosChannelStore.getVideosChannel(channelId);
                        listData = [];
                      });
                      _channelIds = _subscribeChannelStore.channelIds!;
                    }


                    if (null != _videosChannelStore.videosChannel?.videos) {
                      listData.addAll(_videosChannelStore.videosChannel!.videos!);

                      _sortByPublishedAt(listData);
                    }

                    if (_subscribeChannelStore.channelIds == null || listData.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.notification),
                            SizedBox(height: 8),
                            Text('No subscribe right now!',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)
                            )
                          ],
                        ),
                      );
                    }

                    return (listData.isEmpty) ? ShimmerLarge() : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            Video video = listData[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  VideoLargeWidget(video: video),
                                  if (index == 0)
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
                    );
                  })
          )
        ],
      ),
    );
  }

  void _sortByPublishedAt(List<Video> listData) {
    listData.sort((a, b) {
      DateTime dateTimeA = DateTime.parse(a.publishedAt!);
      DateTime dateTimeB = DateTime.parse(b.publishedAt!);

      return dateTimeB.compareTo(dateTimeA);
    });
  }

  Widget _itemChannel(String channelId) {
    return FutureBuilder(
        future: getIt<MyExplore>().youtubeExplode.channels.get(channelId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is exploreYT.Channel) {
            final channel = snapshot.data as exploreYT.Channel;
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.channel, arguments: channel);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.only(left: 6, right: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6,
                        offset: const Offset(0,0),
                        color: Theme.of(context).shadowColor.withOpacity(0.01)
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AvatarChannel(url: channel.logoUrl, size: 40, channel: channel),
                    const SizedBox(width: 8),
                    Text(
                        channel.title,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                        maxLines: 1, textAlign: TextAlign.center
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }}
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../../ads/native_ads.dart';
import '../../stores/video/videos_channel_store.dart';
import '../../widgets/video_large_widget.dart';
import '../components/shimmer_container.dart';
import '../components/shimmer_large.dart';
import '../components/text_subscribe_channel.dart';

class ChannelPageDetail extends StatefulWidget {
  final exploreYT.Channel channel;

  ChannelPageDetail({required this.channel});

  @override
  _ChannelPageDetailState createState() => _ChannelPageDetailState();
}

class _ChannelPageDetailState extends State<ChannelPageDetail> {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late VideosChannelStore _videosChannelStore;

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    _videosChannelStore = Provider.of<VideosChannelStore>(context, listen: false);
    if (widget.channel.id.value.isNotEmpty) {
      _videosChannelStore.getVideosChannel(widget.channel.id.value);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    return Column(children: [
      Expanded(
          child: Scaffold(
              extendBodyBehindAppBar: true,
              key: scaffoldKey,
              appBar: AppBar(
                  titleSpacing: 0,
                  title: Text("${widget.channel.title}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )),
                  leading: IconButton(
                    padding: EdgeInsets.only(top: 4),
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 150,
                        child: Stack(
                          children: [
                            Center(child: bannerWidget()),
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                      begin: const Alignment(0.0, -1),
                                      end: const Alignment(0.0, 0.6),
                                      tileMode: TileMode.clamp)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, left: 132),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.channel.title}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${NumberFormat.compact().format(double.parse(widget.channel.subscribersCount.toString() ?? "0"))} Subs",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Colors.white.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                  TextSubscribeChannel(channel: widget.channel)
                                ],
                              ),
                            ),
                            Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey[600]!.withOpacity(0.1),
                                indent: 12,
                                endIndent: 12),
                            Expanded(child: Observer(builder: (context) {
                              final listData = _videosChannelStore.videosChannel?.videos ?? [];
                              return listData.isNotEmpty ? NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  double maxScroll = notification.metrics.maxScrollExtent;
                                  double currentScroll = notification.metrics.pixels;
                                  double delta = 200.0;
                                  if (maxScroll - currentScroll <= delta && !_videosChannelStore.loading) {
                                    _videosChannelStore.getVideosNextPage();
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
                            })),
                          ],
                        ),
                      )
                    ],
                  ),
                  // Profile image
                  Positioned(
                    left: 16,
                    top: 132,
                    // (background container size) - (circle height / 2)
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: true
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 2,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor)),
                              child: Hero(
                                tag: "",
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: FadeInImage(
                                        fadeInDuration:
                                            Duration(milliseconds: 300),
                                        placeholder:
                                            MemoryImage(kTransparentImage),
                                        image: NetworkImage(
                                            widget.channel.logoUrl ??
                                                ""),
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.network("url",
                                                    fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                            )
                          : ShimmerContainer(
                              height: 100,
                              width: 100,
                              borderRadius: BorderRadius.circular(100),
                            ),
                    ),
                  )
                ],
              )))
    ]);
  }

  Widget bannerWidget() {
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: NetworkImage(widget.channel.bannerUrl),
      fit: BoxFit.fitHeight,
      height: 150,
    );
  }

/*StreamsPopupMenu(
  listData: video,
  onDelete: onDelete != null
    ? (item) => onDelete(item)
    : null,
  scaffoldKey: scaffoldKey,
)*/
}

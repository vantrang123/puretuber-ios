import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import '../../di/components/service_locator.dart';
import '../../events/load_more.dart';
import '../../events/my_event_bus.dart';
import '../../models/video_model.dart';
import '../../provider/load_more.dart';
import '../../stores/video/video_local_store.dart';
import '../../stores/video/video_recently_store.dart';
import '../../utils/routes/routes.dart';
import '../../widgets/list_shimmer_small.dart';
import '../components/video_item_horizontal.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String type;

  PlaylistDetailScreen({
    required this.type
  });

  @override
  Widget build(BuildContext context) {
    switch(type) {
      case Strings.recently:
        final VideoRecentlyStore _localStore =
        Provider.of<VideoRecentlyStore>(context, listen: false);
        if (!_localStore.loading && _localStore.videoList == null ||
            _localStore.videoList?.videos?.isEmpty == true) {
          _localStore.getVideosRecently(true);
        }
        break;

      case Strings.watchLater:
        final VideoLocalStore _localStore =
        Provider.of<VideoLocalStore>(context, listen: false);
        if (!_localStore.loading && _localStore.videoList == null ||
            _localStore.videoList?.videos?.isEmpty == true) {
          _localStore.getVideosWatchLater(true);
        }
        break;

      default:
    }
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 44),
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset('assets/images/ic_arrow_left.svg'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      type,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildData(context),
          ),
          Consumer<LoadMoreProvider>(builder: (context, data, child) {
            return Visibility(
                visible: data.isShowLoadingLoadMore,
                child: CupertinoActivityIndicator());
          }),
        ],
      ),
    );
  }

  Widget _buildData(BuildContext context) {
    return Observer(builder: (context) {
      List<Video>? listData = List.empty();
      switch(type) {
        case Strings.recently:
          final VideoRecentlyStore _localStore = Provider.of<VideoRecentlyStore>(context, listen: false);
          listData = _localStore.videoList?.videos ?? List.empty();
          break;

        case Strings.watchLater:
          final VideoLocalStore _localStore = Provider.of<VideoLocalStore>(context, listen: false);
          listData = _localStore.videoList?.videos ?? List.empty();
          break;

        default:
      }

      Future.delayed(Duration(seconds: 1), () {
        Provider.of<LoadMoreProvider>(context, listen: false).setLoadingLoadMore(false);
      });

      return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: listData.isNotEmpty
              ? _listVideos(listData, context)
              : ListShimmerSmall());
    });
  }

  Widget _listVideos(List<Video> listData, BuildContext context) {
    final LoadMoreProvider loadMoreProvider = Provider.of<LoadMoreProvider>(context, listen: false);
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          if (maxScroll == currentScroll && !(loadMoreProvider.isShowLoadingLoadMore)) {
            loadMoreProvider.setLoadingLoadMore(true);
            getIt<MyEventBus>().eventBus.fire(LoadMoreEvent());
          }
          return true;
        },
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: false,
        padding: EdgeInsets.zero,
        itemCount: listData.length,
        itemBuilder: (context, index) {
          Video video = listData[index];
          if (video.id == null)
            return SizedBox.shrink();
          else
            return VideoItemHorizontal(
                video: video,
                onTap: (video) async {
                  Navigator.pushNamed(context, Routes.player,
                      arguments: {'video': video, 'type': type});
                  });
        },
      ));
  }
}

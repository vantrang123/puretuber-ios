import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../data/sharedpref/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../events/load_more.dart';
import '../../events/my_event_bus.dart';
import '../../models/video_model.dart';
import '../../provider/load_more.dart';
import '../../provider/video_focus_change.dart';
import '../../stores/video/video_related_store.dart';
import '../../widgets/list_shimmer_small.dart';
import '../player/audio_manager.dart';
import 'video_item_horizontal.dart';

class StreamsListTile extends StatelessWidget {
  final Video video;
  final Function(dynamic) onTap;
  final bool isFirstLoad;

  StreamsListTile(
      {required this.video, required this.onTap, this.isFirstLoad = true});

  @override
  Widget build(BuildContext context) {
    final LoadMoreProvider loadMoreProvider = Provider.of<LoadMoreProvider>(context, listen: false);
    final manager = getIt<AudioManager>();
    manager.isFromRelated = false;

    final VideoRelatedStore _videoStore = Provider.of<VideoRelatedStore>(context, listen: false);
    if (manager.needLoadVideosRelated || (_videoStore.videoListSearch?.videos?.length ?? 0) == 0) {
      _videoStore.getVideos(video.title ?? '', true);
    }

    manager.needLoadVideosRelated = true;

    getIt<MyEventBus>().eventBus.on<LoadMoreEvent>().listen((event) {
      _videoStore.getVideosNextPage();
    });

    return Observer(builder: (context) {
      List<Video>? listData = List.empty();
      listData = _videoStore.videoListSearch?.videos ?? List.empty();

      getIt<SharedPreferenceHelper>()
        ..saveVideos(listData);

      Future.delayed(Duration(seconds: 1), () {
        loadMoreProvider.setLoadingLoadMore(false);
      });

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              'Up Next',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontSize: 18.0),
            ),
          ),
          AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: listData.isNotEmpty
                  ? _listVideos(listData, context)
                  : ListShimmerSmall())
        ],
      );
    });
  }

  Widget _listVideos(List<Video> listData, BuildContext context) {
    return Consumer<VideoFocusChange>(builder: (context, data, child) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: listData.length,
        itemBuilder: (context, index) {
          Video video = listData[index];
          video.isFocus = video.id == data.idFocus;
          if (video.id == null)
            return SizedBox.shrink();
          else
            return VideoItemHorizontal(
                video: video,
                onTap: (video) {
                  onTap.call(video);
                });
        },
      );
    });
  }
}

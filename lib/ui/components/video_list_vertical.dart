import 'package:flutter/material.dart';
import 'package:free_tuber/ui/components/video_item_horizontal.dart';

import '../../models/video_model.dart';
import '../../widgets/list_shimmer_small.dart';

class VideoListVertical extends StatelessWidget {
  final String title;
  final double paddingTop;
  final List<Video> listData;
  final Function(dynamic) onTap;
  final Function onReachingListEnd;
  final bool isScrollable;

  VideoListVertical(this.title,
      {required this.paddingTop,
      required this.listData,
      required this.onTap,
      required this.onReachingListEnd,
      this.isScrollable = true});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: listData.isNotEmpty
          ? _listVideos(listData, context)
          : Padding(padding: title.isNotEmpty ? EdgeInsets.only(top: 26 + paddingTop) : EdgeInsets.zero, child: ListShimmerSmall(),),
    );
  }

  Widget _listVideos(List<Video> listData, BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = 200.0;
          if (maxScroll - currentScroll <= delta) onReachingListEnd();
          return true;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title.isNotEmpty
                ? Padding(
                    padding:
                        EdgeInsets.only(left: 16, top: paddingTop, bottom: 16),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 0.01,),
                    ),
                  )
                : SizedBox.shrink(),
            Expanded(
                child: ListView.builder(
                    addAutomaticKeepAlives: true,
                    physics: isScrollable
                        ? BouncingScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Video video = listData[index];
                      if (video.id == null)
                        return SizedBox();
                      else
                        return VideoItemHorizontal(video: video, onTap: onTap);
                    },
                    padding: EdgeInsets.zero,
                    itemCount: listData.length)
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../models/video_model.dart';
import '../../utils/routes/routes.dart';
import '../animations/fade_in.dart';
import 'shimmer_container.dart';
import 'text_duration.dart';

class StreamsLargeThumbnailView extends StatelessWidget {
  final List<dynamic> infoItems;
  final bool shrinkWrap;
  final Function(dynamic)? onDelete;
  final bool allowSaveToFavorites;
  final bool allowSaveToWatchLater;
  final Function? onReachingListEnd;
  final String title;
  final VoidCallback? viewAllCallback;

  StreamsLargeThumbnailView({
    required this.infoItems,
    this.shrinkWrap = false,
    this.onDelete,
    this.allowSaveToFavorites = true,
    this.allowSaveToWatchLater = true,
    this.onReachingListEnd,
    required this.title,
    this.viewAllCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return infoItems.isNotEmpty
        ? NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              double maxScroll = notification.metrics.maxScrollExtent;
              double currentScroll = notification.metrics.pixels;
              double delta = 200.0;
              if (maxScroll - currentScroll <= delta) onReachingListEnd!();
              return true;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('$title',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.white)),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        viewAllCallback?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('View all',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < infoItems.length; i++)
                        _videoItem(context, infoItems[i])
                    ],
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [for (int i = 0; i < 10; i++) _shimmerTile(context)],
              ),
            ),
          );
  }

  Widget _thumbnailWidget(infoItem) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          ClipRRect(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: FadeInImage(
                  fadeInDuration: Duration(milliseconds: 200),
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(infoItem.thumbnailUrl),
                  fit: BoxFit.fitWidth,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return ShimmerContainer(
                      height: 96,
                      width: 185,
                      borderRadius: BorderRadius.circular(10),
                    );
                  },
                ),
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius:
                    BorderRadius.circular(3)),
                child: TextDuration(video: infoItem as Video),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoItemDetails(BuildContext context, infoItem) {
    return Container(
      width: 142,
      child: Text(
        "${infoItem.title}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _shimmerTile(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 38),
        Container(
          height: 80,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.6),
                  highlightColor: Theme.of(context).cardColor,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Shimmer.fromColors(
          baseColor: Theme.of(context)
              .scaffoldBackgroundColor
              .withOpacity(0.6),
          highlightColor: Theme.of(context).cardColor,
          child: Container(
            height: 12,
            width: 142,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color:
                Theme.of(context).scaffoldBackgroundColor),
          ),
        )
      ],
    );
  }

  Widget _videoItem(context, dynamic infoItem) {
    return FadeInTransition(
      duration: Duration(milliseconds: 300),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.player,
                arguments: {'video': infoItem});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 14, right: 12),
                child: _thumbnailWidget(infoItem),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4, right: 12),
                child: _infoItemDetails(context, infoItem),
              )
            ],
          )),
    );
  }
}

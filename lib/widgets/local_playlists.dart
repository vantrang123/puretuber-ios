import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../constants/strings.dart';
import '../data/sharedpref/shared_preference_helper.dart';
import '../di/components/service_locator.dart';
import '../models/video_model.dart';
import '../provider/local_playlist_provider.dart';
import '../stores/video/video_local_store.dart';
import '../ui/animations/fade_in.dart';
import '../ui/components/shimmer_container.dart';
import '../utils/routes/routes.dart';
import 'create_local_playlist.dart';

class LocalPlaylists extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalPlaylistProvider>(builder: (context, data, child) {
      return FutureBuilder(
          future:
          getIt<SharedPreferenceHelper>().getLocalPlaylists(),
          builder: (context, snapshot) {
            final VideoLocalStore _localStore = Provider.of<VideoLocalStore>(context, listen: false);
            _localStore.getVideosWatchLater(true);
            return Observer(builder: (context) {
              Map<String, List<Video>> groupedVideos = Map();
              if (null != _localStore.videoList?.videos) {
                groupedVideos = _localStore.videoList!
                    .groupByFavoriteName(
                    _localStore.videoList!.videos!);
              }
              if (snapshot.hasData && snapshot.data is List<String>) {
                final List<String> names = snapshot.data as List<String>;

                return names.isNotEmpty ? NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    double maxScroll = notification.metrics.maxScrollExtent;
                    double currentScroll = notification.metrics.pixels;
                    double delta = 200.0;
                    // if (maxScroll - currentScroll <= delta) onReachingListEnd!();
                    return true;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Playlists',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CreateLocalPlaylist();
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  const Icon(Icons.playlist_add_outlined, color: Colors.white),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      'New playlist',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < names.length; i++)
                              _videoItem(context, groupedVideos, names[i])
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [for (int i = 0; i < 10; i++) _shimmerTile(context)],
                  ),
                );
              }
              return SizedBox.shrink();
            });

          });
    });
  }

  Widget _thumbnailWidget(String thumbnailUrl, int playlistCount) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          ClipRRect(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: thumbnailUrl.isNotEmpty ? FadeInImage(
                  fadeInDuration: Duration(milliseconds: 200),
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(thumbnailUrl),
                  fit: BoxFit.fitWidth,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return ShimmerContainer(
                      height: 96,
                      width: 185,
                      borderRadius: BorderRadius.circular(10),
                    );
                  },
                ) : Container(
                    height: 96,
                    width: 185,
                  color: Colors.grey,
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
                child: Text(
                  "$playlistCount",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 8),
                ),
              ),
            ),
          )
        ],
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

  Widget _videoItem(context, Map<String, List<Video>> groupedVideos, String namePlaylist) {
    int playlistCount = 0;
    String imageUrl = '';
    List<Video>? group;
    groupedVideos.forEach((key, value) {
      if (key == namePlaylist) {
        playlistCount = value.length;
        imageUrl =
            value.firstOrNull?.thumbnailUrl ?? '';
        group = groupedVideos[key];
      }
    });

    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: FadeInTransition(
        duration: Duration(milliseconds: 300),
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context,
                  Routes.playlist_detail_screen,
                  arguments: {'type': Strings.watchLater}
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: _thumbnailWidget(imageUrl, playlistCount),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: _infoItemDetails(namePlaylist),
                )
              ],
            )),
      )
    );
  }

  Widget _infoItemDetails(String namePlaylist) {
    return Container(
      width: 142,
      child: Text(
        '$namePlaylist',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }
}

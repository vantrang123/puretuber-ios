import 'package:flutter/material.dart';
import 'package:free_tuber/utils/date_time_extension.dart';
import 'package:free_tuber/utils/upload_date_string_extension.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../constants/colors.dart';
import '../data/network/apis/my_explore.dart';
import '../di/components/service_locator.dart';
import '../models/video_model.dart';
import '../ui/animations/fade_in.dart';
import '../ui/components/shimmer_container.dart';
import '../ui/components/text_duration.dart';
import '../utils/routes/routes.dart';
import 'avatar_channel.dart';

class VideoLargeWidget extends StatelessWidget {
  final Video video;

  VideoLargeWidget({required this.video});

  @override
  Widget build(BuildContext context) {
    return FadeInTransition(
      duration: Duration(milliseconds: 300),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.player,
                arguments: {'video': video});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _thumbnailWidget(video),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4, right: 16),
                child: _infoItemDetails(context)
              )
            ],
          )),
    );
  }

  Widget _thumbnailWidget(infoItem) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
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
            borderRadius: BorderRadius.circular(10)),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(3)),
              child: TextDuration(video: infoItem as Video),
            ),
          ),
        )
      ],
    );
  }

  Widget _infoItemDetails(BuildContext context) {
    return FutureBuilder(
        future: getIt<MyExplore>().youtubeExplode.channels.get(video.channelId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is exploreYT.Channel) {
            video.channel = (snapshot.data as exploreYT.Channel);
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarChannel(url: video.channel?.logoUrl, channel: video.channel),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${video.title}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${video.channel?.title ?? ""} • ${NumberFormat.compact().format(double.parse(video.statisticsModel?.viewCount ?? "0"))} views • ${video.uploadDateRaw != null ? '${video.uploadDateRaw ?? '0'}'.timeAgoString() : '${video.publishedAt ?? '0'}'.timeAgo()}",
                        style: TextStyle(
                          color: AppColors.textColorGray,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    ],
                  )
              )
            ],
          );
        }
    );
  }
}

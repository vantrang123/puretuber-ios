import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:free_tuber/utils/date_time_extension.dart';
import 'package:free_tuber/utils/upload_date_string_extension.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../constants/colors.dart';
import '../../models/video_model.dart';
import '../animations/fade_in.dart';
import 'shimmer_container.dart';
import 'text_duration.dart';

class VideoItemHorizontal extends StatelessWidget {
  final Function(dynamic) onTap;
  final Video video;

  VideoItemHorizontal({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FadeInTransition(
      duration: Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () => onTap(video),
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(left: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: FadeInImage(
                            fadeInDuration:
                            Duration(milliseconds: 300),
                            placeholder:
                            MemoryImage(kTransparentImage),
                            image: NetworkImage(
                                video.thumbnailUrl ?? ""),
                            fit: BoxFit.fitWidth,
                            imageErrorBuilder:
                                (BuildContext context,
                                Object exception,
                                StackTrace? stackTrace) {
                              return ShimmerContainer(
                                height: 50,
                                width: 50,
                                borderRadius:
                                BorderRadius.circular(10),
                              );
                            }),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.all(6),
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius:
                            BorderRadius.circular(3)),
                        child: !video.isFocus
                            ? TextDuration(video: video)
                            : Container(
                                    height: 8,
                                    child: SpinKitWave(
                                      color: Colors.white,
                                      itemCount: 3,
                                      size: 11, type: SpinKitWaveType.center
                                    ),
                                  ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          video.title ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          video.channelTitle ?? "",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "${NumberFormat.compact().format(double.parse(video.statisticsModel?.viewCount ?? "0"))} views - ${video.uploadDateRaw != null ? '${video.uploadDateRaw ?? '0'}'.timeAgoString() : '${video.publishedAt ?? '0'}'.timeAgo()}",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

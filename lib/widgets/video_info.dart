import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:free_tuber/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/strings.dart';
import '../models/video_model.dart';
import '../provider/local_playlist_provider.dart';
import '../stores/video/video_local_store.dart';
import 'choose_playlist_to_save.dart';

class VideoInfo extends StatelessWidget {
  final Video video;
  final Function() onMoreDetails;

  VideoInfo({required this.video, required this.onMoreDetails});

  @override
  Widget build(BuildContext context) {
    String title = video.title ?? "";
    String views =
        "${NumberFormat.compact().format(double.parse(video.statisticsModel?.viewCount ?? '0'))} views";
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Video Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.video_time, size: 16, color: AppColors.textColorGray),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            (views.contains('-1') ? "" : (views)),
                            style: TextStyle(
                                color: AppColors.textColorGray,
                                fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            final VideoLocalStore _localStore = Provider.of<VideoLocalStore>(context, listen: false);
                            _localStore.getVideosWatchLater(true);
                            showCupertinoModalPopup(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) =>
                                  ChoosePlaylistToSave(callback: (name) {
                                bool alreadySaved = _localStore
                                        .videoList?.videos
                                        ?.where((element) =>
                                            element.id == video.id &&
                                            element.favoriteName == name)
                                        .firstOrNull !=
                                    null;
                                if (name.isNotEmpty && !alreadySaved) {
                                  Provider.of<LocalPlaylistProvider>(context,
                                          listen: false)
                                      .onChange(video..favoriteName = name);
                                }
                              }),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                const Icon(Iconsax.folder_add, size: 16, color: AppColors.textColorGray),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                        color: AppColors.textColorGray,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final box = context.findRenderObject() as RenderBox?;
                            Share.share(
                                'https://www.youtube.com/watch?v=${video.id}',
                                subject: 'https://play.google.com/store/apps/details?id=${Strings.appPackageName}',
                                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                const Icon(Iconsax.share, size: 16, color: AppColors.textColorGray),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    'Share',
                                    style: TextStyle(
                                        color: AppColors.textColorGray,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

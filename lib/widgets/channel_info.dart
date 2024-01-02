import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../data/network/apis/my_explore.dart';
import '../di/components/service_locator.dart';
import '../models/video_model.dart';
import '../ui/components/text_subscribe_channel.dart';
import '../utils/routes/routes.dart';
import 'avatar_channel.dart';

class ChannelInfo extends StatelessWidget {
  final Video video;

  ChannelInfo({required this.video});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt<MyExplore>().youtubeExplode.channels.get(video.channelId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is exploreYT.Channel) {
            video.channel = (snapshot.data as exploreYT.Channel);
          }
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.channel, arguments: video.channel);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: AvatarChannel(url: video.channel?.logoUrl, channel: video.channel),
                    ),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.channel?.title ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              _statisticsChannel(context, video)
                            ],
                          ),
                        )),
                    if (null != video.channel)
                      TextSubscribeChannel(channel: video.channel!),
                    const SizedBox(width: 12)
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  Widget _statisticsChannel(BuildContext context, Video video) {
    return Observer(builder: (context) {
      return Text(
        "${NumberFormat.compact().format(double.parse(video.channel?.subscribersCount.toString() ?? "0"))} subs",
        style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            letterSpacing: 0.2),
      );
    });
  }
}

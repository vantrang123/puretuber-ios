import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../../data/local/datasources/video/channel_datasource.dart';
import '../../di/components/service_locator.dart';
import '../../stores/video/subscribe_channel_store.dart';

class TextSubscribeChannel extends StatelessWidget {
  final exploreYT.Channel channel;
  TextSubscribeChannel({required this.channel});

  @override
  Widget build(BuildContext context) {
    bool subscribed = false;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: Observer(
          builder: (context) {
            String title = 'Subscribe';
            List<String>? channelIds =
                Provider.of<SubscribeChannelStore>(context,
                    listen: false)
                    .channelIds;
            if (channelIds != null &&
                channelIds
                    .where((element) => element == (channel.id.value))
                    .isNotEmpty) {
              title = "Unsubscribe";
              subscribed = true;
            } else {
              title = "Subscribe";
              subscribed = false;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
      ),
      onTap: () async {
        if (channel.id.value.isNotEmpty) {
          if (!subscribed) {
            await getIt<ChannelDataSource>().insert(channel.id.value);
          } else {
            await getIt<ChannelDataSource>().delete(channel.id.value);
          }
          Provider.of<SubscribeChannelStore>(context,
              listen: false).getSubscribeChannelId();
        }
      },
    );
  }
}
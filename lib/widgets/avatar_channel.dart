import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

import '../models/video_model.dart';
import '../ui/components/shimmer_container.dart';
import '../utils/routes/routes.dart';

class AvatarChannel extends StatelessWidget {
  final String? url;
  final exploreYT.Channel? channel;
  final double size;

  AvatarChannel({this.url, this.channel, this.size = 50});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty)
      return ShimmerContainer(
        height: size,
        width: size,
        borderRadius: BorderRadius.circular(100),
      );
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: () {
          if (null != channel) {
            Navigator.pushNamed(context, Routes.channel, arguments: channel);
          }
        },
        child: FadeInImage(
            fadeInDuration: Duration(milliseconds: 300),
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(url!),
            imageErrorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return ShimmerContainer(
                height: size,
                width: size,
                borderRadius: BorderRadius.circular(100),
              );
            },
            height: size,
            width: size,
            fit: BoxFit.cover),
      ),
    );
  }
}

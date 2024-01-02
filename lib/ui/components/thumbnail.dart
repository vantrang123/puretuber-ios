import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Thumbnail extends StatelessWidget {
  final double ratio;
  final String url;

  const Thumbnail({required this.ratio, required this.url});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: Transform.scale(
          scale: 1.01,
          child: FadeInImage(
            fadeInDuration: Duration(milliseconds: 200),
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(url),
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) =>
                Image.network(url, fit: BoxFit.cover),
          )),
    );
  }
}

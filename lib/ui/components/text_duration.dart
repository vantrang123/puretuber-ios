import 'package:flutter/material.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';

import '../../models/video_model.dart';

class TextDuration extends StatelessWidget {
  final Video video;

  TextDuration({required this.video});

  @override
  Widget build(BuildContext context) {
    var duration;
    try {
      duration = IsoDuration.parse(
          '${video.contentDetailsModel?.duration ?? "PT0H0M0S"}');
    } catch (e) {
      duration = IsoDuration.parse('PT0H0M0S');
    }

    return Text(
      "${duration.hours.ceil() > 0 ? duration.hours.ceil().toString() + ":" : ""}" +
          "${duration.minutes.ceil()}:" +
          "${duration.seconds.ceil() >= 10 ? duration.seconds.ceil() : "0${duration.seconds.ceil()}"}",
      style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 8),
    );
  }
}

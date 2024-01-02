import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../di/components/service_locator.dart';
import '../events/audio_listening.dart';
import '../events/my_event_bus.dart';
import '../events/show_collapsed_panel_event.dart';
import '../provider/audio_control.dart';
import '../ui/components/thumbnail.dart';
import '../ui/player/audio_manager.dart';
import '../utils/routes/routes.dart';

class CollapsedPanel extends StatefulWidget {

  @override
  _CollapsedPanelState createState() => _CollapsedPanelState();
}

class _CollapsedPanelState extends State<CollapsedPanel>
    with TickerProviderStateMixin {
  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    final _myEventBus = getIt<MyEventBus>();
    final _audioControl = Provider.of<AudioControlProvider>(context, listen: false);
    _myEventBus.eventBus.on<AudioListeningEvent>().listen((event) {
      _audioControl.setPlayStatus(event.playing);
      if (event.processingState == ProcessingState.completed) {
        _audioControl.setVideoStatusEnd(true);
      } else {
        _audioControl.setVideoStatusEnd(false);
      }
    });

    // listen event show
    _myEventBus.eventBus.on<ShowCollapsedPanelEvent>().listen((event) {
      isShow = event.isShow;
      setState(() {});
    });

    return Consumer<AudioControlProvider>(builder: (context, data, child) {
      final _audioManager = getIt<AudioManager>();
      String title = _audioManager.currentVideo?.title ?? "";
      String author = _audioManager.currentVideo?.channelTitle ?? "";
      String thumbnailUrl = _audioManager.currentVideo?.thumbnailUrl ??
          "https://imag.malavida.com/mvimgbig/download-fs/songtube-31886-0.jpg";

      return InkWell(
        onTap: () {
          // _audioManager.pastPosition = _audioManager.currentPlaybackPosition;
          _audioManager.pause();
          _audioManager.needSyncVideo = true;
          _audioManager.needLoadVideosRelated = false;
          Navigator.pushNamed(context, Routes.player, arguments: {
            'video': _audioManager.currentVideo,
            'isFromCollapsed': true
          });
        },
        child: AnimatedOpacity(
          opacity: isShow ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: isShow && _audioManager.currentVideo != null ? Container(
            height: kBottomNavigationBarHeight,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 46,
                        margin: EdgeInsets.only(left: 16),
                        child: Thumbnail(
                            ratio: 16 / 9, url: thumbnailUrl),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$title",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                              Text(
                                "$author",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textColor),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Play/Pause
                SizedBox(width: 8),
                IconButton(
                    icon: data.isEnd
                        ? SvgPicture.asset(
                        'assets/images/ic_play_small.svg')
                        : data.isPlaying
                        ? SvgPicture.asset(
                        'assets/images/ic_pause_small.svg')
                        : SvgPicture.asset(
                        'assets/images/ic_play_small.svg'),
                    onPressed: () {
                      handlePlayPause(_audioManager, data.isEnd);
                    }),
                InkWell(
                  onTap: () {
                    _audioManager.stopPlayer();
                  },
                  child: Ink(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(EvaIcons.close),
                      )),
                ),
                SizedBox(width: 8)
              ],
            ),
          ) : SizedBox.shrink(),
        ),
      );
    });
  }

  void handlePlayPause(AudioManager manager, bool isEnd) {
    isEnd
        ? manager.seek(Duration(), () => {manager.play()})
        : manager.isPlaying
            ? manager.pause()
            : manager.play();
  }
}

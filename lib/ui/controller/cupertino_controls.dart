import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../models/video_model.dart';
import '../../provider/show_hide_control.dart';
import '../../provider/video_control.dart';
import '../../provider/video_duration_change.dart';
import '../../utils/strings.dart';
import '../player/audio_manager.dart';
import 'center_play_button.dart';
import 'cupertino_progress_bar.dart';
import 'player_progress_colors.dart';

class CupertinoControls extends StatefulWidget {
  CupertinoControls({
    required this.currentVideo,
    required this.controller,
    required this.onNextCallback
  });

  final VideoPlayerController controller;
  final Function(Video) onNextCallback;
  final Video currentVideo;

  @override
  State<StatefulWidget> createState() {
    return _CupertinoControlsState();
  }
}

class _CupertinoControlsState extends State<CupertinoControls>
    with SingleTickerProviderStateMixin {
  Timer? _hideTimer;
  final marginSize = 5.0;
  bool _isShowControl = false;
  late VideoControlProvider _videoControlProvider;
  late ShowHideControl _showHideControl;
  Duration _durationPause = Duration();
  int currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    _videoControlProvider =
        Provider.of<VideoControlProvider>(context, listen: false);
    _showHideControl = Provider.of<ShowHideControl>(context, listen: false);
    return _buildContent();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  Widget _buildContent() {
    final orientation = MediaQuery.of(context).orientation;
    final barHeight = orientation == Orientation.portrait ? 32.0 : 48.0;
    final buttonPadding = orientation == Orientation.portrait ? 16.0 : 24.0;
    if (_videoControlProvider.isEnd) _isShowControl = true;
    return AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: Stack(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                _isShowControl = !_isShowControl;
                _cancelAndRestartTimer();
                setState(() {});
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTopBar(barHeight, buttonPadding),
              _buildButtonControl(barHeight),
              _buildBottomBar(barHeight),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomBar(double barHeight) {
    return Consumer<VideoDurationChange>(builder: (context, data, child) {
      return Container(
          height: barHeight + 17,
          margin: EdgeInsets.only(left: 16, right: 16),
          child: AnimatedOpacity(
              opacity: _isShowControl ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildPosition(data.position),
                      _buildExpandButton()
                    ],
                  ),
                  _buildProgressBar()
                ],
              )
          ));
    });
  }

  GestureDetector _buildExpandButton() {
    VideoControlProvider videoControlProvider =
        Provider.of<VideoControlProvider>(context);
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.black.withOpacity(0.3)),
        child: videoControlProvider.isFullScreen
            ? Icon(EvaIcons.collapse, size: 24.0)
            : Icon(EvaIcons.expandOutline, size: 24.0),
      )
    );
  }

  GestureDetector _buildIconBack(double barHeight, double padding) {
    VideoControlProvider videoControlProvider =
        Provider.of<VideoControlProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (_isShowControl) {
          videoControlProvider.isFullScreen ? _onExpandCollapse() : '';
          Navigator.pop(context);
        } else {
          setState(() {
            _isShowControl = true;
          });
        }
      },
      child: Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.black.withOpacity(0.3)),
          child: Icon(Iconsax.arrow_circle_down, size: 24)),
    );
  }

  GestureDetector _buildSkipBack() {
    return GestureDetector(
        onTap: _skipBack,
        child: AnimatedOpacity(
          opacity: _isShowControl ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: 32,
            height: 32,
            margin: EdgeInsets.only(right: 0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.backward_10_seconds,
              color: Colors.white,
              size: 24,
            ),
          ),
        ));
  }

  GestureDetector _buildSkipForward() {
    return GestureDetector(
      onTap: _skipForward,
      child: AnimatedOpacity(
        opacity: _isShowControl ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: 32,
          height: 32,
          margin: EdgeInsets.only(
            left: 0,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Iconsax.forward_10_seconds,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  void _skipBack() {
    if (_isShowControl) {
      final beginning = Duration.zero.inMilliseconds;
      final skip =
          (widget.controller.value.position - const Duration(seconds: 10))
              .inMilliseconds;
      final duration = Duration(milliseconds: math.max(skip, beginning));
      widget.controller
          .seekTo(duration)
          .then((value) => {getIt<AudioManager>().seek(duration, () {})});
    } else {
      setState(() {
        _isShowControl = true;
      });
    }
    _cancelAndRestartTimer();
  }

  void _skipForward() {
    if (_isShowControl) {
      final end = widget.controller.value.duration.inMilliseconds;
      final skip =
          (widget.controller.value.position + const Duration(seconds: 15))
              .inMilliseconds;
      final duration = Duration(milliseconds: math.min(skip, end));
      widget.controller
          .seekTo(duration)
          .then((value) => {getIt<AudioManager>().seek(duration, () {})});
    } else {
      setState(() {
        _isShowControl = true;
      });
    }
    _cancelAndRestartTimer();
  }

  Widget _buildTopBar(
    double barHeight,
    double buttonPadding,
  ) {
    return AnimatedOpacity(
      opacity: _isShowControl ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        margin: EdgeInsets.only(
          top: 12,
          right: 12,
          left: 12,
        ),
        child: Row(
          children: <Widget>[
            if (true) _buildIconBack(barHeight, buttonPadding),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonControl(double barHeight) {
    final bool isFinished =
        (widget.controller.value.position) >=
            (widget.controller.value.duration);
    return AnimatedOpacity(
      opacity: _isShowControl ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Consumer<VideoControlProvider>(builder: (context, data, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // _buildSkipBack(),
            _buildBack(),
            Consumer<VideoDurationChange>(builder: (context, data, child) {
              return CenterPlayButton(
                isFinished: isFinished,
                isPlaying:
                widget.controller.value.isPlaying == true,
                show: true,
                onPressed: _isShowControl ? _playPause : () {
                  setState(() {
                    _isShowControl = true;
                  });
                },
              );
            }),
            _buildForward(),
            // _buildSkipForward()
          ],
        );
      }),
    );
  }

  Widget _buildPosition(Duration position) {
    return Text(
      '${formatDuration(position)} / ${formatDuration(widget.controller.value.duration)}',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 14.0,
      ),
    );
  }

  Widget _buildProgressBar() {
    return Expanded(
        child: widget.controller.value.isInitialized == true
            ? CupertinoVideoProgressBar(
          widget.controller,
          onDragStart: () {
            setState(() {
              _isShowControl = true;
            });
            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
            });
            _cancelAndRestartTimer();
          },
          onSeekChange: () {
            handleSeekBarChange();
          },
          colors: PlayerProgressColors(),
        )
            : SizedBox.shrink()
    );
  }

  void handleSeekBarChange() {
    widget.controller.play();
    getIt<AudioManager>().pause();
    getIt<AudioManager>().seek(
        widget.controller.value.position, () {});
  }

  void _playPause() {
    if (widget.controller.value.isPlaying == true) {
      widget.controller.pause();
      getIt<AudioManager>().isPauseByUser = true;
      _durationPause = widget.controller.value.position ?? Duration() ;
    } else if (_videoControlProvider.isEnd) {
      // handleRepeat();
    } else {
      widget.controller..seekTo(_durationPause)
        ..play();
      _durationPause = Duration();
    }
    _videoControlProvider.setPlayStateChange();
  }

  GestureDetector _buildBack() {
    return GestureDetector(
        onTap: _isShowControl ? _back : () {
          setState(() {
            _isShowControl = true;
          });
        },
        child: AnimatedOpacity(
          opacity: _isShowControl ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: FutureBuilder(
                  future: getIt<SharedPreferenceHelper>().getSavedVideos(),
                  builder: (context, snapshot) {
                    final relatedVideos = snapshot.data;
                    if (snapshot.hasData && relatedVideos is List<Video>) {
                      currentVideoIndex = relatedVideos.indexWhere((element) => element.id == widget.currentVideo.id);
                    }
                    return Icon(Iconsax.previous, color: currentVideoIndex == 0 ? Colors.white.withOpacity(
                        0.2) : Colors.white);
                    return SvgPicture.asset(
                        'assets/images/ic_back.svg',
                        color: currentVideoIndex == 0 ? Colors.white.withOpacity(
                            0.2) : Colors.white
                    );
                  },
                )
            ),
          ),
        ));
  }

  GestureDetector _buildForward() {
    return GestureDetector(
      onTap: _isShowControl ? _forward : () {
        setState(() {
          _isShowControl = true;
        });
      },
      child: AnimatedOpacity(
        opacity: _isShowControl ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: FutureBuilder(
                future: getIt<SharedPreferenceHelper>().getSavedVideos(),
                builder: (context, snapshot) {
                  final relatedVideos = snapshot.data;
                  if (snapshot.hasData && relatedVideos is List<Video>) {
                    currentVideoIndex = relatedVideos.indexWhere((element) => element.id == widget.currentVideo.id);
                  }
                  return Icon(Iconsax.next);
                  return SvgPicture.asset(
                      'assets/images/ic_forward.svg',
                      color: currentVideoIndex == 0 ? Colors.white.withOpacity(
                          0.2) : Colors.white
                  );
                },
              )
          ),
        ),
      ),
    );
  }

  void _back() async {
    try {
      final listVideo =
          await getIt<SharedPreferenceHelper>().getSavedVideos() ?? [];
      final nextIndex = (listVideo
          .indexWhere((element) => element.id == widget.currentVideo.id) -
          1);
      final videoFocus = listVideo[nextIndex];
      widget.onNextCallback.call(videoFocus);
    } catch (e) {}
  }

  void _forward() async {
    try {
      final listVideo =
          await getIt<SharedPreferenceHelper>().getSavedVideos() ?? [];
      final nextIndex = (listVideo
          .indexWhere((element) => element.id == widget.currentVideo.id) +
          1);
      final videoFocus = listVideo[nextIndex];
      widget.onNextCallback.call(videoFocus);
      setState(() {

      });
    } catch (e) {}
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _showHideControl.onChange(_isShowControl);
    setState(() {
      _startHideTimer();
    });
  }

  void _onExpandCollapse() {
    if (_isShowControl) {
      getIt<AudioManager>().isFromRelated = true;
      VideoControlProvider videoControlProvider =
          Provider.of<VideoControlProvider>(context, listen: false);
      final orientation = MediaQuery.of(context).orientation;
      if (orientation == Orientation.portrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        videoControlProvider.toggleFullScreen();
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        videoControlProvider.exitFullScreen();
      }
    } else {
      setState(() {
        _isShowControl = true;
      });
    }
    _cancelAndRestartTimer();
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 4), () {
      _isShowControl = false;
      _showHideControl.onChange(_isShowControl);
      setState(() {});
    });
  }
}

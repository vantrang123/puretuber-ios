import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:free_tuber/provider/show_hide_control.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../events/audio_listening.dart';
import '../../events/my_event_bus.dart';
import '../../models/video_model.dart';
import '../../provider/video_control.dart';
import '../../provider/video_duration_change.dart';
import '../../stores/player/player_store.dart';
import '../../utils/strings.dart';
import '../player/audio_manager.dart';
import 'center_play_button.dart';
import 'cupertino_progress_bar.dart';
import 'player_progress_colors.dart';

class CustomVideoControls extends StatefulWidget {
  CustomVideoControls({
    required this.currentVideo,
    required this.isListener,
    required this.onRepeatCallback,
    required this.onNextCallback,
    Key? key,
  }) : super(key: key);

  final Video currentVideo;
  late bool isListener;
  final Function() onRepeatCallback;
  final Function(Video) onNextCallback;

  @override
  State<StatefulWidget> createState() {
    return _CustomVideoControlsState();
  }
}

class _CustomVideoControlsState extends State<CustomVideoControls>
    with SingleTickerProviderStateMixin {
  Duration _durationPause = Duration();
  final marginSize = 5.0;
  bool _isShowControl = true;
  late VideoControlProvider _videoControlProvider;
  late VideoDurationChange _durationChange;
  late ShowHideControl _showHideControl;
  final _audioManager = getIt<AudioManager>();
  PlayerStore? _playerStore;
  int currentVideoIndex = 0;
  // Timer? _hideTimer;

  @override
  void initState() {
    _playerStore = Provider.of<PlayerStore>(context, listen: false);
    _durationChange = Provider.of<VideoDurationChange>(context, listen: false);
    _showHideControl = Provider.of<ShowHideControl>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoControlProvider =
        Provider.of<VideoControlProvider>(context, listen: false);
    return _buildContent();
  }

  Widget _buildContent() {
    final orientation = MediaQuery.of(context).orientation;
    final barHeight = 48.0;
    return Observer(builder: (context) {
      if (_playerStore?.playerController?.value.isInitialized == true) {
        _playerStore?.playerController?.removeListener(videoListener);
        _playerStore?.playerController?.addListener(videoListener);
      }

      return SizedBox.shrink();
    });
  }

  Widget _buildFullControl(double barHeight) {
    return Consumer<ShowHideControl>(builder: (builder, data, child) {
      _isShowControl = data.idShow;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: barHeight),
          // _buildButtonPlay(barHeight),
          _buildBottomBar(barHeight)
        ],
      );
    });
  }

  Widget _buildBottomBar(double barHeight) {
    _isShowControl = true;
    return Consumer<VideoDurationChange>(builder: (context, data, child) {
      return Container(
          height: barHeight,
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildPosition(data.position),
                  _buildRemaining(data.position),
                ],
              ),
              _buildProgressBar()
            ],
          ));
    });
  }

  Widget _buildPosition(Duration position) {
    return Text(
      formatDuration(position),
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
      ),
    );
  }

  Widget _buildRemaining(Duration position) {
    final value = (_playerStore?.playerController?.value.duration ?? Duration()) - position;
    return Text(
      '${formatDuration(value)}',
      style: TextStyle(color: Colors.white, fontSize: 14.0),
    );
  }

  GestureDetector _buildBack(double barHeight) {
    return GestureDetector(
        onTap: _isShowControl ? _back : _showControl,
        child: AnimatedOpacity(
          opacity: _isShowControl ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Padding(
                padding: EdgeInsets.all(4),
                child: FutureBuilder(
                  future: getIt<SharedPreferenceHelper>().getSavedVideos(),
                  builder: (context, snapshot) {
                    final relatedVideos = snapshot.data;
                    if (snapshot.hasData && relatedVideos is List<Video>) {
                      currentVideoIndex = relatedVideos.indexWhere((element) => element.id == widget.currentVideo.id);
                    }
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

  GestureDetector _buildForward(double barHeight) {
    return GestureDetector(
      onTap: _isShowControl ? _forward : _showControl,
      child: AnimatedOpacity(
        opacity: _isShowControl ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: SvgPicture.asset('assets/images/ic_forward.svg'),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Expanded(
        child: _playerStore?.playerController?.value.isInitialized == true
            ? CupertinoVideoProgressBar(
                _playerStore!.playerController!,
                onDragStart: () {
                  setState(() {});
                },
                onDragEnd: () {
                  setState(() {});
                },
                onSeekChange: () {
                  handleSeekBarChange();
                },
                colors: PlayerProgressColors(),
              )
            : SizedBox.shrink()
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

  void _showControl() {
    _showHideControl.onChange(true);
  }

  Widget _buildButtonPlay(double barHeight) {
    final bool isFinished =
        (_playerStore?.playerController?.value.position ?? Duration()) >=
            (_playerStore?.playerController?.value.duration ?? Duration());
    return AnimatedOpacity(
      opacity: _isShowControl ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Consumer<VideoControlProvider>(builder: (context, data, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBack(barHeight),
            Consumer<VideoDurationChange>(builder: (context, data, child) {
              return CenterPlayButton(
                isFinished: isFinished,
                isPlaying:
                _playerStore?.playerController?.value.isPlaying == true,
                show: true,
                onPressed: _isShowControl ? _playPause : _showControl,
              );
            }),
            _buildForward(barHeight)
          ],
        );
      }),
    );
  }

  void _playPause() {
    if (_playerStore?.playerController?.value.isPlaying == true) {
      _playerStore?.playerController?.pause();
      _audioManager.isPauseByUser = true;
      _durationPause = _playerStore?.playerController?.value.position ?? Duration() ;
    } else if (_videoControlProvider.isEnd) {
      handleRepeat();
    } else {
      _playerStore?.playerController
        ?..seekTo(_durationPause)
        ..play();
      _durationPause = Duration();
    }
    _videoControlProvider.setPlayStateChange();
  }

  void handleSeekBarChange() {
    _playerStore?.playerController?.play();
    _audioManager.pause();
    _audioManager.seek(
        _playerStore?.playerController?.value.position ?? Duration(), () {});
  }

  void handleRepeat() {
    // _audioManager.pastPosition = Duration();
    _durationPause = Duration();
    _videoControlProvider.setVideoStatusEnd(false);
    widget.onRepeatCallback.call();
  }

  void videoListener() {
    var currentPosition = _playerStore?.playerController?.value.position ?? Duration();

    if (_playerStore?.playerController?.value.hasError == true) {
      _playerStore
          ?.initVideoPlayerControl(VideoPlayerController.networkUrl(
          Uri.parse(_playerStore?.playerController?.dataSource ?? '')))
          .then((value) {
        _playerStore?.playerController
            ?.seekTo(Duration(seconds: _durationPause.inSeconds))
            .then((value) {});
      });
    }

    if (_playerStore?.playerController?.value.isPlaying == true) {
      _durationChange.onChange(currentPosition);
    }

    if (currentPosition.inSeconds >= (_playerStore?.playerController?.value.duration.inSeconds ?? 0) && _playerStore?.playerController?.value.hasError == false) {
      _videoControlProvider.setVideoStatusEnd(true);
      _playerStore?.playerController?.removeListener(videoListener);
      getIt<MyEventBus>().eventBus.fire(
          AudioListeningEvent(ProcessingState.completed));
      _forward();
    } else if (_videoControlProvider.isEnd) {
      _videoControlProvider.setVideoStatusEnd(false);
    }

    if (_playerStore?.playerController?.value.isPlaying == true &&
        _audioManager.isPlaying) {
      _audioManager.pause();
      _playerStore?.playerController?.play().then((value) => setState(() {}));
    }

    if (_audioManager.isPauseByUser && _playerStore?.playerController?.value.isPlaying == true) {
      _audioManager.isPauseByUser = false;
    }
  }
}

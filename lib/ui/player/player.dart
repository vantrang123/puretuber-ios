import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../ads/interstitial_ads.dart';
import '../../ads/native_ads.dart';
import '../../data/local/datasources/video/video_datasource.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../events/load_more.dart';
import '../../events/my_event_bus.dart';
import '../../events/reload_video_viewed.dart';
import '../../events/show_collapsed_panel_event.dart';
import '../../models/video_model.dart';
import '../../provider/load_more.dart';
import '../../provider/video_control.dart';
import '../../provider/video_focus_change.dart';
import '../../stores/explore/explore_store.dart';
import '../../stores/player/player_store.dart';
import '../../widgets/channel_info.dart';
import '../../widgets/measure_size.dart';
import '../../widgets/video_info.dart';
import '../components/streams_list_tile.dart';
import '../components/thumbnail.dart';
import '../controller/cupertino_controls.dart';
import '../controller/custom_video_controls.dart';
import 'audio_manager.dart';

class PlayerScreen extends StatefulWidget {
  late Video video;
  final bool isFromCollapsed;

  PlayerScreen({required this.video, required this.isFromCollapsed});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with WidgetsBindingObserver {
  late ExploreStore _exploreStore;
  PlayerStore? _playerStore;

  AudioManager? _audioManager;
  ScrollController _scrollController = new ScrollController();

  bool isResetVideoController = true;
  bool isAppPause = false;
  bool isFromBackground = false;
  late Widget videoWidget;
  late Widget portraitPage;
  late Widget fullscreenPage;
  late VideoFocusChange _videoFocusChange;

  @override
  void initState() {
    init();
    syncWithAudio();
    WakelockPlus.enable();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _handleStartPlayAudio();
    WakelockPlus.disable();
    getIt<MyEventBus>().eventBus.fire(ShowCollapsedPanelEvent(true));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _handleStartPlayAudio();
      isAppPause = true;
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.resumed) {
      if (isAppPause) {
        isAppPause = false;
        isFromBackground = true;
        syncWithAudio();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  void init() {
    _audioManager = getIt<AudioManager>();
    _exploreStore = Provider.of<ExploreStore>(context, listen: false);
    _playerStore = Provider.of<PlayerStore>(context, listen: false);
    _videoFocusChange = Provider.of<VideoFocusChange>(context, listen: false);

    // hide mini player
    getIt<MyEventBus>().eventBus.fire(ShowCollapsedPanelEvent(false));

    _videoFocusChange.setDefault(widget.video.id ?? '');

    try {
      WidgetsBinding.instance.removeObserver(this);
      WidgetsBinding.instance.addObserver(this);
    } catch (e) {}

    Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }

  void getLinkStream() {
    if (!_exploreStore.loading) {
      _exploreStore.videoStreamUrl = null;
      _exploreStore.audioStreamUrl = null;
      _exploreStore.getVideoStreamUrl(widget.video.id ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    portraitPage = _portraitPage();
    fullscreenPage = _fullscreenPage();
    return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _buildMainContent());
  }

  Widget _buildMainContent() {
    return Consumer<VideoControlProvider>(builder: (context, data, child) {
      return data.isFullScreen ? fullscreenPage : portraitPage;
    });
  }

  Widget _portraitPage() {
    final LoadMoreProvider loadMoreProvider =
        Provider.of<LoadMoreProvider>(context, listen: false);
    return SafeArea(
        top: true,
        bottom: true,
        child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              double maxScroll = notification.metrics.maxScrollExtent;
              double currentScroll = notification.metrics.pixels;
              if (maxScroll == currentScroll &&
                  !(loadMoreProvider.isShowLoadingLoadMore)) {
                loadMoreProvider.setLoadingLoadMore(true);
                getIt<MyEventBus>().eventBus.fire(LoadMoreEvent());
              }
              return true;
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20),
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  observerLinkStream(),
                  _buildVideoPlayer(),
                  _playerControl(),
                  const SizedBox(height: 12),
                  _videoInfo(),
                  const SizedBox(height: 8),
                  NativeAds(type: "Small"),
                  _listRelated(),
                  Consumer<LoadMoreProvider>(builder: (context, data, child) {
                    return Visibility(
                        visible: data.isShowLoadingLoadMore,
                        child: CupertinoActivityIndicator());
                  }),
                ],
              ),
            )));
  }

  Widget _fullscreenPage() {
    return MeasureSize(
        onChange: (Size size) {},
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildVideoPlayer(),
            _playerControl()
          ],
        )
    );
  }

  Widget _playerControl() => Observer(builder: (context) {
        if (_audioManager?.needSyncVideo == true)
          _playerStore?.playerController?.pause();

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomVideoControls(
              currentVideo: widget.video,
              isListener: false,
              onRepeatCallback: () {
                getLinkStream();
              },
              onNextCallback: (video) {
                _handlePlayVideoRelated(video);
              },
            ),
          ],
        );
      });

  void initializePlayer(String url) {
    isResetVideoController = false;
    _playerStore
        ?.initVideoPlayerControl(
        VideoPlayerController.networkUrl(Uri.parse(url)))
        .then((value) {
      seek2LastPosition();
    });
  }

  Widget _videoInfo() => Observer(builder: (context) {
    // _playerStore?.playerController?.value.isInitialized;
    _exploreStore.success;
    return Column(
      children: [
        VideoInfo(video: widget.video, onMoreDetails: () {}),
        ChannelInfo(video: widget.video)
      ],
    );
  });

  Widget _listRelated() {
    return StreamsListTile(
      video: widget.video,
      isFirstLoad: true,
      onTap: (video) async {
        _handlePlayVideoRelated(video);
      },
    );
  }

  void initializeAudio(String url, BuildContext context) {
    _audioManager?.setExplodeStore(_exploreStore);
    _audioManager?.addPlaylist(url, widget.video, context);
  }

  void _handlePlayVideoRelated(Video video) {
    _audioManager?.isFromRelated = true;
    _videoFocusChange.onChange(video.id ?? '');
    _playerStore?.playerController?.pause();
    isResetVideoController = true;

    widget.video = video;
    getLinkStream();
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  Widget _buildVideoPlayer() {
    return Observer(
      builder: (context) {
        if (_playerStore?.playerController?.value.isInitialized == true) {
          _saveVideoToLocal();
        }

        return OrientationBuilder(builder: (context, orientation) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              if (_playerStore?.playerController?.value.isInitialized == true)
                AspectRatio(
                    aspectRatio:
                    _playerStore!.playerController!.value.aspectRatio,
                    child: VideoPlayer(_playerStore!.playerController!)),
              if (_playerStore?.success != true || _exploreStore.success != true)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      Thumbnail(
                          ratio: 16 / 9,
                          url: widget.video.thumbnailUrl ?? ""),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 42,
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle),
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_playerStore?.playerController?.value.isInitialized == true)
                CupertinoControls(
                  currentVideo: widget.video,
                  controller: _playerStore!.playerController!,
                  onNextCallback: (video) {
                    _handlePlayVideoRelated(video);
                  },
                )
            ],
          );
        });
      },
    );
  }

  Widget observerLinkStream() {
    return Observer(builder: (context) {
      if (_exploreStore.videoStreamUrl?.isNotEmpty == true && isResetVideoController) {
        _checkShowAds(() {
          initializePlayer(_exploreStore.videoStreamUrl!);
          initializeAudio(_exploreStore.audioStreamUrl!, context);
        });
      }
      return SizedBox();
    });
  }

  Future<void> _checkShowAds(VoidCallback callback) async {
    // final times =
    //     await getIt<SharedPreferenceHelper>().countTimesPlay ??
    //     0;

    getIt<InterstitialAds>().showAds(() {
      callback.call();
      getIt<SharedPreferenceHelper>().resetTimesPlay();
    });

    // if (times >= 1) {
    //
    // } else {
    //   callback.call();
    //   getIt<SharedPreferenceHelper>().increaseTimesTimesPlay();
    // }
  }

  void _handleStartPlayAudio() {
    try {
      if (_playerStore?.playerController?.value.isPlaying == true || _audioManager?.isPauseByUser == false) {
        _playerStore?.playerController?.pause();
        _audioManager?.play();
        _audioManager?.seek(Duration(seconds: _playerStore!.playerController!.value.position.inSeconds + 1), () => {});
      } else {
        _audioManager?.seek(Duration(seconds: _playerStore!.playerController!.value.position.inSeconds + 1), () => {});
      }
    } catch(e) {}
  }

  Future<void> _saveVideoToLocal() async {
    final localDb = getIt<VideoDataSource>();
    localDb.insertOrUpdate(widget.video).then((value) {
      getIt<MyEventBus>().eventBus.fire(ReloadVideoViewed());
    }).catchError((onError) {});
  }

  void syncWithAudio() {
    if (_playerStore?.playerController?.value.hasError == true &&
        _exploreStore.videoStreamUrl ==
            _playerStore?.playerController?.dataSource) {

      isResetVideoController = true;
      getLinkStream();
    } else
      handleSync();
  }

  void handleSync() async {
    _audioManager!.syncPosition = _audioManager!.currentPlaybackPosition;
    if (_audioManager?.needSyncVideo == true || isFromBackground) {
      if (widget.video.id != _audioManager!.currentVideo!.id) {
        _handlePlayVideoRelated(_audioManager!.currentVideo!);
      }
      else if (_exploreStore.videoStreamUrl ==
          _playerStore?.playerController?.dataSource) {
        isResetVideoController = false;
        seek2LastPosition();
      } else if (_audioManager?.currentVideo != null) {
      }
    } else {
      if (widget.isFromCollapsed) _audioManager?.isFromRelated = false;
      getLinkStream();
      isResetVideoController = true;
    }
  }

  void seek2LastPosition() {
    if (_audioManager!.needSyncVideo || isFromBackground) {
      _audioManager!.pause();

      _playerStore?.playerController
          ?.seekTo(Duration(seconds: (_audioManager!.syncPosition)))
          .then((value) {
        _playerStore?.playerController?.play();
        _audioManager?.needSyncVideo = false;
        isFromBackground = false;
      });
    } else {
      _playerStore?.playerController?.play();
    }
  }
}

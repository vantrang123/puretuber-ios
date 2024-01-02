import 'package:flutter/material.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../data/sharedpref/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../events/audio_listening.dart';
import '../../events/my_event_bus.dart';
import '../../models/video_list_search.dart';
import '../../models/video_model.dart';
import '../../stores/explore/explore_store.dart';

class AudioManager {
  AudioPlayer _player = AudioPlayer();

  final _playlist = ConcatenatingAudioSource(children: []);

  get isPlaying => _player.playing;

  get currentPlaybackPosition => _player.position.inSeconds;

  get currentPlaybackDuration => _player.duration?.inSeconds;

  Video? currentVideo;
  int currentPosition = 0;
  bool needSyncVideo = false;
  bool needLoadVideosRelated = true;
  bool isFromRelated = false;
  bool isPauseByUser = false;
  VideoListSearch? currentVideoList;
  late ExploreStore _exploreStore;
  bool ignoreState = false;
  int syncPosition = 0;

  Future<void> addPlaylist(
      String audioUrl, Video video, BuildContext context) async {
    try {
      _player
        ..playbackEventStream.listen((event) {
          if (!needSyncVideo) {
            currentPosition = event.updatePosition.inSeconds;
          }

          if (!ignoreState &&
              event.processingState == ProcessingState.completed) {
            ignoreState = true;
            onForward();
          }
        })
        ..playerStateStream.listen((event) {
          if (!needSyncVideo) {
            getIt<MyEventBus>().eventBus.fire(AudioListeningEvent(
                event.processingState,
                playing: event.playing));
          }
        })
        ..setLoopMode(LoopMode.off);

      currentVideo = video;
      addAudio(video, audioUrl);
      await _player.setAudioSource(_playlist, initialIndex: 0, initialPosition: Duration.zero);
    } catch (e) {
    }
  }

  void play() => _player.play();

  void pause() {
    _player.pause();
  }

  void stopPlayer() {
    _player.stop();
    _player.dispose();
    _player = AudioPlayer();
    currentVideo = null;
    getIt<MyEventBus>()
        .eventBus
        .fire(AudioListeningEvent(ProcessingState.completed));
  }

  void seek(Duration position, Function() onChange) =>
      _player.seek(position)..then((value) => {onChange.call()});

  void resetAudioPlaying() {
    _player.seek(Duration(seconds: 0), index: 0);
  }

  void onForward() async {
    try {
      final listVideo =
          await getIt<SharedPreferenceHelper>().getSavedVideos() ?? [];
      final nextIndex =
      (listVideo.indexWhere((element) => element.id == currentVideo!.id) +
          1);
      final videoFocus = listVideo[nextIndex];

      _exploreStore.getVideoStreamUrl(videoFocus.id!).then((value) async {
        currentVideo = videoFocus;
        addAudio(videoFocus, _exploreStore.audioStreamUrl!);
        await _player.setAudioSource(_playlist).then((value) {
          _player.seek(Duration(seconds: 0), index: 0);
          ignoreState = false;
        });
      });
      getIt<SharedPreferenceHelper>().increaseTimesTimesPlay();
    } catch (e) {}
  }

  void setExplodeStore(value) => _exploreStore = value;

  void addAudio(Video video, String audioUrl) {
    IsoDuration? duration;
    try {
      duration =
          IsoDuration.parse('${video.contentDetailsModel!.duration!}');
    } catch (e) {
    }
    _playlist.clear();
    _playlist.add(ClippingAudioSource(
        start: Duration(seconds: 0),
        end: Duration(seconds: duration?.toSeconds().toInt() ?? 0),
        child: AudioSource.uri(Uri.parse(audioUrl)),
        tag: MediaItem(
          id: video.id ?? "",
          album: video.channelTitle,
          title: video.title ?? "",
          artUri: Uri.parse(video.thumbnailUrl ?? ""),
        )));
  }
}

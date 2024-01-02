import 'package:just_audio/just_audio.dart';

class AudioListeningEvent {
  ProcessingState processingState;
  bool playing = false;

  AudioListeningEvent(this.processingState, {this.playing = false});
}

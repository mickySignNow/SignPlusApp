import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

startMusic() {
  AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
  Timer.periodic(Duration(seconds: 3), (timer) {
    AudioService.stop();
  });
}

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();
  final _completer = Completer();

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // Connect to the URL
    _audioPlayer.setFilePath('sounds/pristine-609.mp3');
    // await _audioPlayer.setUrl("https://exampledomain.com/song.mp3");
    // Now we're ready to play
    _audioPlayer.play();
  }

  @override
  Future<void> onStop() async {
    // Stop playing audio
    await _audioPlayer.stop();
    // Shut down this background task
    await super.onStop();
  }
}

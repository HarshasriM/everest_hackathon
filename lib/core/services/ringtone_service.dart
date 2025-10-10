import 'package:audioplayers/audioplayers.dart';

/// Service to handle ringtone playback
class RingtoneService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  /// Play ringtone
  Future<void> playRingtone() async {
    if (_isPlaying) return;

    try {
      _isPlaying = true;
      
      // Set release mode to loop
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      
      // Play the ringtone from assets
      // Note: You need to add a ringtone.mp3 file to assets/audio/
      // For now, we'll use a system sound or handle gracefully
      await _audioPlayer.play(AssetSource('audio/ringtone.mp3'));
    } catch (e) {
      // If ringtone file doesn't exist, fail silently
      // In production, you should handle this properly
      print('Error playing ringtone: $e');
      _isPlaying = false;
    }
  }

  /// Stop ringtone
  Future<void> stopRingtone() async {
    if (!_isPlaying) return;

    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      print('Error stopping ringtone: $e');
    }
  }

  /// Check if ringtone is playing
  bool get isPlaying => _isPlaying;

  /// Dispose
  void dispose() {
    _audioPlayer.dispose();
  }
}

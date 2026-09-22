import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:virtual_flute_app/domain/models/audio_settings.dart';
import 'package:virtual_flute_app/domain/models/flute_note.dart';
import 'package:virtual_flute_app/data/services/audio_synth_service.dart';

/// Service managing audio playback pool for low-latency virtual flute playing.
class AudioPlayerService {
  AudioPlayerService({
    AudioSynthService? synthService,
  }) : _synthService = synthService ?? AudioSynthService();

  final AudioSynthService _synthService;
  final List<AudioPlayer> _playerPool = [];
  int _currentPlayerIndex = 0;
  static const int _poolSize = 4;
  bool _isInitialized = false;

  // In-memory cache for synthesized note byte arrays
  final Map<String, Uint8List> _noteWavCache = {};

  void _ensureInitialized() {
    if (_isInitialized) return;
    _isInitialized = true;
    try {
      for (int i = 0; i < _poolSize; i++) {
        final player = AudioPlayer();
        player.setReleaseMode(ReleaseMode.stop);
        _playerPool.add(player);
      }
    } catch (_) {
      // Handle test environments gracefully
    }
  }

  /// Clears the wave cache when audio parameters change (e.g. instrument change).
  void clearCache() {
    _noteWavCache.clear();
  }

  /// Plays a flute note with given audio settings and volume/intensity.
  Future<void> playNote(
    FluteNote note, {
    required AudioSettings settings,
    double intensity = 1.0,
    double durationSeconds = 1.2,
  }) async {
    _ensureInitialized();

    final String cacheKey = '${note.id}_${settings.fluteType.name}_${settings.octaveShift}';

    Uint8List? wavBytes = _noteWavCache[cacheKey];
    if (wavBytes == null) {
      wavBytes = _synthService.generateFluteWav(
        note,
        settings: settings,
        durationSeconds: durationSeconds,
        intensity: intensity,
      );
      _noteWavCache[cacheKey] = wavBytes;
    }

    // Get next player from circular pool
    if (_playerPool.isEmpty) return;
    final AudioPlayer player = _playerPool[_currentPlayerIndex];
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _playerPool.length;

    try {
      await player.stop();
      await player.setVolume(settings.masterVolume * intensity);
      await player.play(BytesSource(wavBytes));
    } catch (_) {
      // Gracefully handle any platform audio busy error
    }
  }

  /// Stops all active audio players immediately.
  Future<void> stopAll() async {
    for (final player in _playerPool) {
      try {
        await player.stop();
      } catch (_) {}
    }
  }

  void dispose() {
    for (final player in _playerPool) {
      player.dispose();
    }
    _playerPool.clear();
    _noteWavCache.clear();
  }
}

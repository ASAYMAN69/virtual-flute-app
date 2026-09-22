import '../../domain/models/audio_settings.dart';
import '../../domain/models/flute_note.dart';
import '../../domain/models/flute_scale.dart';
import '../services/audio_player_service.dart';

/// Repository managing flute note models, scales, and audio triggering.
class FluteRepository {
  FluteRepository({
    AudioPlayerService? audioPlayerService,
  }) : _audioPlayerService = audioPlayerService ?? AudioPlayerService();

  final AudioPlayerService _audioPlayerService;

  List<FluteNote> getAllNotes() => FluteNote.standardNotes;

  List<FluteScale> getScales() => FluteScale.scales;

  FluteNote resolveNoteFromHoles(List<bool> holes, {int octaveShift = 0}) {
    return FluteNote.findMatchingNote(holes, octaveShift: octaveShift);
  }

  Future<void> playFluteNote(
    FluteNote note, {
    required AudioSettings settings,
    double intensity = 1.0,
    double durationSeconds = 1.2,
  }) async {
    await _audioPlayerService.playNote(
      note,
      settings: settings,
      intensity: intensity,
      durationSeconds: durationSeconds,
    );
  }

  Future<void> stopSound() async {
    await _audioPlayerService.stopAll();
  }

  void onSettingsChanged() {
    _audioPlayerService.clearCache();
  }

  void dispose() {
    _audioPlayerService.dispose();
  }
}

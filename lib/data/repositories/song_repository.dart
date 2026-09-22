import '../../domain/models/flute_song.dart';
import '../../domain/models/recording.dart';

/// Repository managing songs library and user performance recordings.
class SongRepository {
  final List<FluteSong> _songs = List.from(FluteSong.defaultSongs);
  final List<FluteRecording> _recordings = [];

  List<FluteSong> getSongs() => List.unmodifiable(_songs);

  FluteSong? getSongById(String id) {
    try {
      return _songs.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<FluteRecording> getRecordings() => List.unmodifiable(_recordings);

  void saveRecording(FluteRecording recording) {
    _recordings.insert(0, recording);
  }

  void deleteRecording(String id) {
    _recordings.removeWhere((r) => r.id == id);
  }
}

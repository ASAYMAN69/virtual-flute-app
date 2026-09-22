import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_flute_app/data/repositories/flute_repository.dart';
import 'package:virtual_flute_app/data/repositories/song_repository.dart';
import 'package:virtual_flute_app/domain/models/recording.dart';

void main() {
  group('Repository Unit Tests', () {
    test('FluteRepository provides all standard notes and scales', () {
      final fluteRepo = FluteRepository();
      expect(fluteRepo.getAllNotes().length, greaterThanOrEqualTo(12));
      expect(fluteRepo.getScales().length, greaterThanOrEqualTo(4));
    });

    test('SongRepository handles song library and recordings correctly', () {
      final songRepo = SongRepository();
      final songs = songRepo.getSongs();
      expect(songs.isNotEmpty, isTrue);

      final song = songRepo.getSongById(songs.first.id);
      expect(song, isNotNull);

      final rec = FluteRecording(
        id: 'rec_1',
        title: 'Test Melody',
        createdAt: DateTime.now(),
        events: const [
          RecordedNoteEvent(noteId: 'A4', timestampMs: 0, durationMs: 400, intensity: 0.8),
        ],
        totalDurationMs: 400,
        fluteTypeName: 'Concert Flute',
      );

      songRepo.saveRecording(rec);
      expect(songRepo.getRecordings().length, equals(1));
      expect(songRepo.getRecordings().first.title, equals('Test Melody'));

      songRepo.deleteRecording('rec_1');
      expect(songRepo.getRecordings().isEmpty, isTrue);
    });
  });
}

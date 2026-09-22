import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_flute_app/data/services/audio_synth_service.dart';
import 'package:virtual_flute_app/domain/models/audio_settings.dart';
import 'package:virtual_flute_app/domain/models/flute_note.dart';

void main() {
  group('AudioSynthService Pure Acoustic Synthesis Tests', () {
    late AudioSynthService synthService;
    late FluteNote testNote;

    setUp(() {
      synthService = AudioSynthService();
      testNote = FluteNote.standardNotes.firstWhere((n) => n.id == 'A4');
    });

    test('Generates valid RIFF/WAVE header and PCM byte buffer', () {
      const settings = AudioSettings(fluteType: FluteType.concertFlute);
      final Uint8List wavBytes = synthService.generateFluteWav(
        testNote,
        settings: settings,
        durationSeconds: 0.5,
      );

      // Check header length & RIFF identifiers
      expect(wavBytes.length, greaterThan(44));
      expect(String.fromCharCodes(wavBytes.sublist(0, 4)), equals('RIFF'));
      expect(String.fromCharCodes(wavBytes.sublist(8, 12)), equals('WAVE'));
      expect(String.fromCharCodes(wavBytes.sublist(12, 16)), equals('fmt '));
      expect(String.fromCharCodes(wavBytes.sublist(36, 40)), equals('data'));
    });

    test('WAV size scales proportionally with requested duration', () {
      const settings = AudioSettings();
      final wavShort = synthService.generateFluteWav(testNote, settings: settings, durationSeconds: 0.2);
      final wavLong = synthService.generateFluteWav(testNote, settings: settings, durationSeconds: 0.8);

      expect(wavLong.length, greaterThan(wavShort.length));
    });

    test('Different FluteTypes produce non-empty valid wave bytes', () {
      for (final type in FluteType.values) {
        final settings = AudioSettings(fluteType: type);
        final wav = synthService.generateFluteWav(testNote, settings: settings, durationSeconds: 0.3);
        expect(wav.isNotEmpty, isTrue);
      }
    });
  });
}

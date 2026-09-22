import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_flute_app/domain/models/flute_note.dart';
import 'package:virtual_flute_app/domain/models/flute_scale.dart';

void main() {
  group('FluteNote Domain Unit Tests', () {
    test('Standard flute note frequencies are acoustically accurate', () {
      final a4 = FluteNote.standardNotes.firstWhere((n) => n.id == 'A4');
      expect(a4.frequency, equals(440.0));
      expect(a4.solfege, equals('La'));

      final c4 = FluteNote.standardNotes.firstWhere((n) => n.id == 'C4');
      expect(c4.frequency, closeTo(261.63, 0.01));
      expect(c4.solfege, equals('Do'));
    });

    test('All closed holes produces low note (D4/C4)', () {
      final allClosed = [true, true, true, true, true, true];
      final note = FluteNote.findMatchingNote(allClosed, octaveShift: 0);
      expect(note.name, equals('D'));
      expect(note.octave, equals(4));
    });

    test('All open holes produces high C# / C', () {
      final allOpen = [false, false, false, false, false, false];
      final note = FluteNote.findMatchingNote(allOpen, octaveShift: 0);
      expect(note.name, isIn(['C#', 'C']));
    });

    test('Octave shift calculates correct frequencies', () {
      final a4 = FluteNote.standardNotes.firstWhere((n) => n.id == 'A4');
      final highA = a4.getShiftedFrequency(12.0); // 1 octave up
      expect(highA, closeTo(880.0, 0.01));

      final lowA = a4.getShiftedFrequency(-12.0); // 1 octave down
      expect(lowA, closeTo(220.0, 0.01));
    });

    test('FluteScale correctly determines notes membership', () {
      final cMajor = FluteScale.scales.firstWhere((s) => s.id == 'c_major');
      final cNote = FluteNote.standardNotes.firstWhere((n) => n.id == 'C4');
      final fSharpNote = FluteNote.standardNotes.firstWhere((n) => n.id == 'F#4');

      expect(cMajor.contains(cNote), isTrue);
      expect(cMajor.contains(fSharpNote), isFalse);
    });
  });
}

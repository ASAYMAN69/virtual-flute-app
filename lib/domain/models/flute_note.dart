import 'dart:math' as math;

/// Represents the state of a tone hole on the flute.
enum HoleState {
  open,
  closed,
  half,
}

/// Represents a musical flute note with pitch, acoustic frequency, and standard fingering.
class FluteNote {
  const FluteNote({
    required this.id,
    required this.name,
    required this.solfege,
    required this.frequency,
    required this.octave,
    required this.holePattern,
    this.altName,
  });

  final String id;
  final String name;
  final String solfege;
  final double frequency;
  final int octave;
  /// Standard 6-hole fingering pattern from top (closest to mouthpiece) to bottom.
  /// true = closed, false = open
  final List<bool> holePattern;
  final String? altName;

  String get displayName => '$name$octave';

  /// Standard Concert C Flute / Tin Whistle Notes
  static const List<FluteNote> standardNotes = [
    // Octave 4
    FluteNote(
      id: 'C4',
      name: 'C',
      solfege: 'Do',
      frequency: 261.63,
      octave: 4,
      holePattern: [true, true, true, true, true, true],
    ),
    FluteNote(
      id: 'D4',
      name: 'D',
      solfege: 'Re',
      frequency: 293.66,
      octave: 4,
      holePattern: [true, true, true, true, true, true],
    ),
    FluteNote(
      id: 'D#4',
      name: 'D#',
      altName: 'Eb',
      solfege: 'Ri',
      frequency: 311.13,
      octave: 4,
      holePattern: [true, true, true, true, true, false],
    ),
    FluteNote(
      id: 'E4',
      name: 'E',
      solfege: 'Mi',
      frequency: 329.63,
      octave: 4,
      holePattern: [true, true, true, true, true, false],
    ),
    FluteNote(
      id: 'F4',
      name: 'F',
      solfege: 'Fa',
      frequency: 349.23,
      octave: 4,
      holePattern: [true, true, true, true, false, false],
    ),
    FluteNote(
      id: 'F#4',
      name: 'F#',
      altName: 'Gb',
      solfege: 'Fi',
      frequency: 369.99,
      octave: 4,
      holePattern: [true, true, true, false, true, false],
    ),
    FluteNote(
      id: 'G4',
      name: 'G',
      solfege: 'Sol',
      frequency: 392.00,
      octave: 4,
      holePattern: [true, true, true, false, false, false],
    ),
    FluteNote(
      id: 'G#4',
      name: 'G#',
      altName: 'Ab',
      solfege: 'Si',
      frequency: 415.30,
      octave: 4,
      holePattern: [true, true, false, true, true, false],
    ),
    FluteNote(
      id: 'A4',
      name: 'A',
      solfege: 'La',
      frequency: 440.00,
      octave: 4,
      holePattern: [true, true, false, false, false, false],
    ),
    FluteNote(
      id: 'A#4',
      name: 'A#',
      altName: 'Bb',
      solfege: 'Li',
      frequency: 466.16,
      octave: 4,
      holePattern: [true, false, true, false, false, false],
    ),
    FluteNote(
      id: 'B4',
      name: 'B',
      solfege: 'Ti',
      frequency: 493.88,
      octave: 4,
      holePattern: [true, false, false, false, false, false],
    ),

    // Octave 5
    FluteNote(
      id: 'C5',
      name: 'C',
      solfege: 'Do',
      frequency: 523.25,
      octave: 5,
      holePattern: [false, true, false, false, false, false],
    ),
    FluteNote(
      id: 'C#5',
      name: 'C#',
      altName: 'Db',
      solfege: 'Di',
      frequency: 554.37,
      octave: 5,
      holePattern: [false, false, false, false, false, false],
    ),
    FluteNote(
      id: 'D5',
      name: 'D',
      solfege: 'Re',
      frequency: 587.33,
      octave: 5,
      holePattern: [false, true, true, true, true, true],
    ),
    FluteNote(
      id: 'D#5',
      name: 'D#',
      altName: 'Eb',
      solfege: 'Ri',
      frequency: 622.25,
      octave: 5,
      holePattern: [true, true, true, true, true, false],
    ),
    FluteNote(
      id: 'E5',
      name: 'E',
      solfege: 'Mi',
      frequency: 659.25,
      octave: 5,
      holePattern: [true, true, true, true, true, false],
    ),
    FluteNote(
      id: 'F5',
      name: 'F',
      solfege: 'Fa',
      frequency: 698.46,
      octave: 5,
      holePattern: [true, true, true, true, false, false],
    ),
    FluteNote(
      id: 'F#5',
      name: 'F#',
      altName: 'Gb',
      solfege: 'Fi',
      frequency: 739.99,
      octave: 5,
      holePattern: [true, true, true, false, true, false],
    ),
    FluteNote(
      id: 'G5',
      name: 'G',
      solfege: 'Sol',
      frequency: 783.99,
      octave: 5,
      holePattern: [true, true, true, false, false, false],
    ),
    FluteNote(
      id: 'A5',
      name: 'A',
      solfege: 'La',
      frequency: 880.00,
      octave: 5,
      holePattern: [true, true, false, false, false, false],
    ),
    FluteNote(
      id: 'B5',
      name: 'B',
      solfege: 'Ti',
      frequency: 987.77,
      octave: 5,
      holePattern: [true, false, false, false, false, false],
    ),
    FluteNote(
      id: 'C6',
      name: 'C',
      solfege: 'Do',
      frequency: 1046.50,
      octave: 6,
      holePattern: [false, true, false, false, false, false],
    ),
  ];

  /// Calculates the note from a given 6-hole fingering configuration and octave mode.
  static FluteNote findMatchingNote(List<bool> holes, {int octaveShift = 0}) {
    // Count closed holes from top down
    int closedCount = 0;
    for (int i = 0; i < holes.length; i++) {
      if (holes[i]) {
        closedCount++;
      }
    }

    // Determine target note based on covered holes
    final targetOctave = (4 + octaveShift).clamp(4, 6);

    // Simple natural scale fingering lookup
    if (closedCount == 6) {
      return standardNotes.firstWhere(
        (n) => n.name == 'D' && n.octave == targetOctave,
        orElse: () => standardNotes[1],
      );
    } else if (closedCount == 5) {
      return standardNotes.firstWhere(
        (n) => n.name == 'E' && n.octave == targetOctave,
        orElse: () => standardNotes[3],
      );
    } else if (closedCount == 4) {
      return standardNotes.firstWhere(
        (n) => n.name == 'F#' && n.octave == targetOctave,
        orElse: () => standardNotes[5],
      );
    } else if (closedCount == 3) {
      return standardNotes.firstWhere(
        (n) => n.name == 'G' && n.octave == targetOctave,
        orElse: () => standardNotes[6],
      );
    } else if (closedCount == 2) {
      return standardNotes.firstWhere(
        (n) => n.name == 'A' && n.octave == targetOctave,
        orElse: () => standardNotes[8],
      );
    } else if (closedCount == 1) {
      return standardNotes.firstWhere(
        (n) => n.name == 'B' && n.octave == targetOctave,
        orElse: () => standardNotes[10],
      );
    } else {
      // 0 closed holes = C# or overblown High C
      return standardNotes.firstWhere(
        (n) => (n.name == 'C#' || n.name == 'C') && n.octave == targetOctave,
        orElse: () => standardNotes[11],
      );
    }
  }

  /// Calculates frequency in Hz with microtonal pitch bending.
  double getShiftedFrequency(double semitoneOffset) {
    return frequency * math.pow(2.0, semitoneOffset / 12.0);
  }
}

/// A single step/note in a practice song.
class SongNoteStep {
  const SongNoteStep({
    required this.noteId,
    required this.durationMs,
    this.lyric,
  });

  final String noteId;
  final int durationMs;
  final String? lyric;
}

/// A structured song for guided play-along tutorial.
class FluteSong {
  const FluteSong({
    required this.id,
    required this.title,
    required this.artistOrOrigin,
    required this.difficulty,
    required this.steps,
    required this.description,
  });

  final String id;
  final String title;
  final String artistOrOrigin;
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final List<SongNoteStep> steps;
  final String description;

  int get totalDurationMs => steps.fold(0, (sum, step) => sum + step.durationMs);

  static const List<FluteSong> defaultSongs = [
    FluteSong(
      id: 'hot_cross_buns',
      title: 'Hot Cross Buns',
      artistOrOrigin: 'Traditional English',
      difficulty: 'Beginner',
      description: 'The classic beginner woodwind exercise using 3 simple notes (B, A, G).',
      steps: [
        SongNoteStep(noteId: 'B4', durationMs: 800, lyric: 'Hot'),
        SongNoteStep(noteId: 'A4', durationMs: 800, lyric: 'cross'),
        SongNoteStep(noteId: 'G4', durationMs: 1600, lyric: 'buns!'),
        SongNoteStep(noteId: 'B4', durationMs: 800, lyric: 'Hot'),
        SongNoteStep(noteId: 'A4', durationMs: 800, lyric: 'cross'),
        SongNoteStep(noteId: 'G4', durationMs: 1600, lyric: 'buns!'),
        SongNoteStep(noteId: 'G4', durationMs: 400, lyric: 'One'),
        SongNoteStep(noteId: 'G4', durationMs: 400, lyric: 'a'),
        SongNoteStep(noteId: 'G4', durationMs: 400, lyric: 'pen-'),
        SongNoteStep(noteId: 'G4', durationMs: 400, lyric: 'ny,'),
        SongNoteStep(noteId: 'A4', durationMs: 400, lyric: 'two'),
        SongNoteStep(noteId: 'A4', durationMs: 400, lyric: 'a'),
        SongNoteStep(noteId: 'A4', durationMs: 400, lyric: 'pen-'),
        SongNoteStep(noteId: 'A4', durationMs: 400, lyric: 'ny,'),
        SongNoteStep(noteId: 'B4', durationMs: 800, lyric: 'Hot'),
        SongNoteStep(noteId: 'A4', durationMs: 800, lyric: 'cross'),
        SongNoteStep(noteId: 'G4', durationMs: 1600, lyric: 'buns!'),
      ],
    ),
    FluteSong(
      id: 'ode_to_joy',
      title: 'Ode to Joy (Beethoven)',
      artistOrOrigin: 'Ludwig van Beethoven',
      difficulty: 'Beginner',
      description: 'Symphony No. 9 theme in D Major / G Major.',
      steps: [
        SongNoteStep(noteId: 'B4', durationMs: 600),
        SongNoteStep(noteId: 'B4', durationMs: 600),
        SongNoteStep(noteId: 'C5', durationMs: 600),
        SongNoteStep(noteId: 'D5', durationMs: 600),
        SongNoteStep(noteId: 'D5', durationMs: 600),
        SongNoteStep(noteId: 'C5', durationMs: 600),
        SongNoteStep(noteId: 'B4', durationMs: 600),
        SongNoteStep(noteId: 'A4', durationMs: 600),
        SongNoteStep(noteId: 'G4', durationMs: 600),
        SongNoteStep(noteId: 'G4', durationMs: 600),
        SongNoteStep(noteId: 'A4', durationMs: 600),
        SongNoteStep(noteId: 'B4', durationMs: 600),
        SongNoteStep(noteId: 'B4', durationMs: 900),
        SongNoteStep(noteId: 'A4', durationMs: 300),
        SongNoteStep(noteId: 'A4', durationMs: 1200),
      ],
    ),
    FluteSong(
      id: 'scarborough_fair',
      title: 'Scarborough Fair',
      artistOrOrigin: 'Traditional English Ballad',
      difficulty: 'Intermediate',
      description: 'Haunting Dorian melody with evocative modal phrasing.',
      steps: [
        SongNoteStep(noteId: 'D4', durationMs: 800, lyric: 'Are'),
        SongNoteStep(noteId: 'D4', durationMs: 800, lyric: 'you'),
        SongNoteStep(noteId: 'A4', durationMs: 800, lyric: 'go-'),
        SongNoteStep(noteId: 'A4', durationMs: 800, lyric: 'ing'),
        SongNoteStep(noteId: 'E4', durationMs: 800, lyric: 'to'),
        SongNoteStep(noteId: 'F4', durationMs: 400, lyric: 'Scar-'),
        SongNoteStep(noteId: 'E4', durationMs: 400, lyric: 'bor-'),
        SongNoteStep(noteId: 'D4', durationMs: 1600, lyric: 'ough Fair'),
        SongNoteStep(noteId: 'A4', durationMs: 800, lyric: 'Pars-'),
        SongNoteStep(noteId: 'C5', durationMs: 800, lyric: 'ley,'),
        SongNoteStep(noteId: 'D5', durationMs: 800, lyric: 'sage,'),
        SongNoteStep(noteId: 'C5', durationMs: 400, lyric: 'rose-'),
        SongNoteStep(noteId: 'B4', durationMs: 400, lyric: 'ma-'),
        SongNoteStep(noteId: 'A4', durationMs: 1600, lyric: 'ry and thyme'),
      ],
    ),
    FluteSong(
      id: 'greensleeves',
      title: 'Greensleeves',
      artistOrOrigin: 'Renaissance Folk',
      difficulty: 'Intermediate',
      description: 'Lyrical sixteenth-century melody celebrated across centuries.',
      steps: [
        SongNoteStep(noteId: 'A4', durationMs: 600),
        SongNoteStep(noteId: 'C5', durationMs: 1000),
        SongNoteStep(noteId: 'D5', durationMs: 500),
        SongNoteStep(noteId: 'E5', durationMs: 750),
        SongNoteStep(noteId: 'F5', durationMs: 250),
        SongNoteStep(noteId: 'E5', durationMs: 500),
        SongNoteStep(noteId: 'D5', durationMs: 1000),
        SongNoteStep(noteId: 'B4', durationMs: 500),
        SongNoteStep(noteId: 'G4', durationMs: 750),
        SongNoteStep(noteId: 'A4', durationMs: 250),
        SongNoteStep(noteId: 'B4', durationMs: 500),
        SongNoteStep(noteId: 'C5', durationMs: 1000),
        SongNoteStep(noteId: 'A4', durationMs: 500),
        SongNoteStep(noteId: 'A4', durationMs: 1500),
      ],
    ),
  ];
}

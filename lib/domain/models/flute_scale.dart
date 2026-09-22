import 'flute_note.dart';

/// Musical scale mode for flute practice and playing.
class FluteScale {
  const FluteScale({
    required this.id,
    required this.name,
    required this.description,
    required this.noteNames,
  });

  final String id;
  final String name;
  final String description;
  final List<String> noteNames;

  static const List<FluteScale> scales = [
    FluteScale(
      id: 'c_major',
      name: 'C Major',
      description: 'The natural diatonic scale (C, D, E, F, G, A, B).',
      noteNames: ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
    ),
    FluteScale(
      id: 'd_major',
      name: 'D Major (Tin Whistle Standard)',
      description: 'Standard key for Irish traditional music & whistles.',
      noteNames: ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
    ),
    FluteScale(
      id: 'g_major',
      name: 'G Major',
      description: 'One sharp (F#), melodic and open.',
      noteNames: ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
    ),
    FluteScale(
      id: 'a_minor',
      name: 'A Natural Minor',
      description: 'Soulful, contemplative minor scale.',
      noteNames: ['A', 'B', 'C', 'D', 'E', 'F', 'G'],
    ),
    FluteScale(
      id: 'pentatonic',
      name: 'Major Pentatonic',
      description: '5-note harmonic scale, perfect for free improvisation.',
      noteNames: ['C', 'D', 'E', 'G', 'A'],
    ),
    FluteScale(
      id: 'bansuri_raga',
      name: 'Raga Yaman (Kalyan Thaat)',
      description: 'Indian classical serene evening mood (Teevram Ma / F#).',
      noteNames: ['C', 'D', 'E', 'F#', 'G', 'A', 'B'],
    ),
  ];

  bool contains(FluteNote note) {
    return noteNames.contains(note.name);
  }
}

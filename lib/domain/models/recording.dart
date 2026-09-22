/// A timestamped note event recorded during live playing.
class RecordedNoteEvent {
  const RecordedNoteEvent({
    required this.noteId,
    required this.timestampMs,
    required this.durationMs,
    required this.intensity,
  });

  final String noteId;
  final int timestampMs;
  final int durationMs;
  final double intensity;

  Map<String, dynamic> toJson() => {
    'noteId': noteId,
    'timestampMs': timestampMs,
    'durationMs': durationMs,
    'intensity': intensity,
  };

  factory RecordedNoteEvent.fromJson(Map<String, dynamic> json) => RecordedNoteEvent(
    noteId: json['noteId'] as String,
    timestampMs: json['timestampMs'] as int,
    durationMs: json['durationMs'] as int,
    intensity: (json['intensity'] as num).toDouble(),
  );
}

/// A complete performance session recorded by the user.
class FluteRecording {
  const FluteRecording({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.events,
    required this.totalDurationMs,
    required this.fluteTypeName,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final List<RecordedNoteEvent> events;
  final int totalDurationMs;
  final String fluteTypeName;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'events': events.map((e) => e.toJson()).toList(),
    'totalDurationMs': totalDurationMs,
    'fluteTypeName': fluteTypeName,
  };

  factory FluteRecording.fromJson(Map<String, dynamic> json) => FluteRecording(
    id: json['id'] as String,
    title: json['title'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    events: (json['events'] as List<dynamic>)
        .map((e) => RecordedNoteEvent.fromJson(e as Map<String, dynamic>))
        .toList(),
    totalDurationMs: json['totalDurationMs'] as int,
    fluteTypeName: json['fluteTypeName'] as String? ?? 'Concert Flute',
  );
}

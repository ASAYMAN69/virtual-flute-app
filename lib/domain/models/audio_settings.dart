/// Flute Instrument Types with their distinctive sound profiles.
enum FluteType {
  concertFlute(
    name: 'Concert Flute (Silver)',
    description: 'Bright, pure, rich harmonic spectrum with airy chiff.',
    harmonicWeights: [1.0, 0.45, 0.20, 0.12, 0.05],
    breathiness: 0.25,
  ),
  bambooBansuri(
    name: 'Indian Bansuri (Bamboo)',
    description: 'Warm, resonant, deep breath character and organic vibrato.',
    harmonicWeights: [1.0, 0.60, 0.35, 0.18, 0.08],
    breathiness: 0.38,
  ),
  irishTinWhistle(
    name: 'Irish Tin Whistle (Pennywhistle)',
    description: 'Crisp, punchy, traditional Celtic tone.',
    harmonicWeights: [1.0, 0.70, 0.30, 0.15, 0.05],
    breathiness: 0.20,
  ),
  panFlute(
    name: 'Pan Flute (Zampona)',
    description: 'Airy, soft, evocative Andean wind sound.',
    harmonicWeights: [1.0, 0.30, 0.40, 0.10, 0.05],
    breathiness: 0.45,
  ),
  piccolo(
    name: 'Piccolo',
    description: 'High-pitched, piercing orchestral brilliance.',
    harmonicWeights: [1.0, 0.50, 0.25, 0.15, 0.08],
    breathiness: 0.15,
  );

  const FluteType({
    required this.name,
    required this.description,
    required this.harmonicWeights,
    required this.breathiness,
  });

  final String name;
  final String description;
  final List<double> harmonicWeights;
  final double breathiness;
}

/// Blowing triggering modes.
enum BlowMode {
  touchAndHold('Touch & Blow', 'Sound plays while touching the embouchure blow button.'),
  toggleContinuous('Continuous Breath', 'Tap once to keep breath flow active while fingering holes.'),
  autoBlow('Direct Hole Touch', 'Touching tone holes immediately produces sounds.');

  const BlowMode(this.label, this.description);
  final String label;
  final String description;
}

/// Audio settings domain configuration.
class AudioSettings {
  const AudioSettings({
    this.fluteType = FluteType.concertFlute,
    this.blowMode = BlowMode.touchAndHold,
    this.masterVolume = 0.85,
    this.vibratoSpeed = 5.5,
    this.vibratoDepth = 0.35,
    this.breathAirVolume = 0.30,
    this.reverbDecay = 0.40,
    this.octaveShift = 0,
    this.enableHapticFeedback = true,
  });

  final FluteType fluteType;
  final BlowMode blowMode;
  final double masterVolume;
  final double vibratoSpeed; // Hz (typically 4.5 - 6.5 Hz)
  final double vibratoDepth; // 0.0 - 1.0
  final double breathAirVolume; // 0.0 - 1.0
  final double reverbDecay; // 0.0 - 1.0
  final int octaveShift; // -1, 0, +1
  final bool enableHapticFeedback;

  AudioSettings copyWith({
    FluteType? fluteType,
    BlowMode? blowMode,
    double? masterVolume,
    double? vibratoSpeed,
    double? vibratoDepth,
    double? breathAirVolume,
    double? reverbDecay,
    int? octaveShift,
    bool? enableHapticFeedback,
  }) {
    return AudioSettings(
      fluteType: fluteType ?? this.fluteType,
      blowMode: blowMode ?? this.blowMode,
      masterVolume: masterVolume ?? this.masterVolume,
      vibratoSpeed: vibratoSpeed ?? this.vibratoSpeed,
      vibratoDepth: vibratoDepth ?? this.vibratoDepth,
      breathAirVolume: breathAirVolume ?? this.breathAirVolume,
      reverbDecay: reverbDecay ?? this.reverbDecay,
      octaveShift: octaveShift ?? this.octaveShift,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    );
  }
}

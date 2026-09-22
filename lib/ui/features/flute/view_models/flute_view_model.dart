import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:virtual_flute_app/data/repositories/flute_repository.dart';
import 'package:virtual_flute_app/data/repositories/song_repository.dart';
import 'package:virtual_flute_app/domain/models/audio_settings.dart';
import 'package:virtual_flute_app/domain/models/flute_note.dart';
import 'package:virtual_flute_app/domain/models/flute_scale.dart';
import 'package:virtual_flute_app/domain/models/recording.dart';

/// ViewModel managing flute instrument state, fingering inputs, and sound synthesis.
class FluteViewModel extends ChangeNotifier {
  FluteViewModel({
    required FluteRepository fluteRepository,
    required SongRepository songRepository,
  })  : _fluteRepository = fluteRepository,
        _songRepository = songRepository {
    _init();
  }

  final FluteRepository _fluteRepository;
  final SongRepository _songRepository;

  // Hole state: 6 holes from top (index 0) to bottom (index 5)
  // true = covered/closed, false = open
  List<bool> _holes = [false, false, false, false, false, false];
  List<bool> get holes => List.unmodifiable(_holes);

  AudioSettings _settings = const AudioSettings();
  AudioSettings get settings => _settings;

  FluteScale _selectedScale = FluteScale.scales.first;
  FluteScale get selectedScale => _selectedScale;

  FluteNote? _currentNote;
  FluteNote? get currentNote => _currentNote;

  bool _isBlowing = false;
  bool get isBlowing => _isBlowing;

  double _breathIntensity = 0.85;
  double get breathIntensity => _breathIntensity;

  // Recording state
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  DateTime? _recordingStartTime;
  final List<RecordedNoteEvent> _currentRecordingEvents = [];
  DateTime? _notePlayStartTime;

  void _init() {
    _updateCalculatedNote();
  }

  void _updateCalculatedNote() {
    final note = _fluteRepository.resolveNoteFromHoles(
      _holes,
      octaveShift: _settings.octaveShift,
    );
    _currentNote = note;
    notifyListeners();
  }

  /// Toggles a specific hole state (closed <-> open).
  void toggleHole(int index) {
    if (index < 0 || index >= _holes.length) return;
    _holes[index] = !_holes[index];
    _updateCalculatedNote();

    if (_shouldPlaySoundNow()) {
      _triggerCurrentSound();
    }
  }

  /// Explicitly sets hole state (e.g. for multi-touch or fingering guides).
  void setHole(int index, bool isClosed) {
    if (index < 0 || index >= _holes.length) return;
    if (_holes[index] == isClosed) return;
    _holes[index] = isClosed;
    _updateCalculatedNote();

    if (_shouldPlaySoundNow()) {
      _triggerCurrentSound();
    }
  }

  /// Sets all holes at once according to a target note's fingering pattern.
  void applyFingeringPattern(List<bool> pattern) {
    _holes = List.from(pattern);
    _updateCalculatedNote();

    if (_shouldPlaySoundNow()) {
      _triggerCurrentSound();
    }
  }

  /// Opens all holes.
  void openAllHoles() {
    _holes = [false, false, false, false, false, false];
    _updateCalculatedNote();
    if (_shouldPlaySoundNow()) {
      _triggerCurrentSound();
    }
  }

  /// Closes all holes.
  void closeAllHoles() {
    _holes = [true, true, true, true, true, true];
    _updateCalculatedNote();
    if (_shouldPlaySoundNow()) {
      _triggerCurrentSound();
    }
  }

  /// Handles touch/breath trigger on the embouchure mouthpiece.
  void onBreathStart({double intensity = 0.85}) {
    _isBlowing = true;
    _breathIntensity = intensity;
    _notePlayStartTime = DateTime.now();
    notifyListeners();
    _triggerCurrentSound();
  }

  /// Handles release of breath on the embouchure mouthpiece.
  void onBreathEnd() {
    if (_settings.blowMode != BlowMode.toggleContinuous) {
      _isBlowing = false;
      _fluteRepository.stopSound();
      _recordNoteEventIfActive();
      notifyListeners();
    }
  }

  /// Toggles continuous breath blowing.
  void toggleContinuousBlowing() {
    if (_isBlowing) {
      _isBlowing = false;
      _fluteRepository.stopSound();
      _recordNoteEventIfActive();
    } else {
      _isBlowing = true;
      _notePlayStartTime = DateTime.now();
      _triggerCurrentSound();
    }
    notifyListeners();
  }

  /// Sets breath blowing intensity dynamically.
  void setBreathIntensity(double intensity) {
    _breathIntensity = intensity.clamp(0.1, 1.0);
    notifyListeners();
    if (_isBlowing) {
      _triggerCurrentSound();
    }
  }

  /// Shifts the octave (-1, 0, +1).
  void setOctaveShift(int shift) {
    if (_settings.octaveShift == shift) return;
    _settings = _settings.copyWith(octaveShift: shift.clamp(-1, 1));
    _fluteRepository.onSettingsChanged();
    _updateCalculatedNote();
    if (_shouldPlaySoundNow()) {
      _triggerCurrentSound();
    }
  }

  /// Selects a musical scale mode.
  void setScale(FluteScale scale) {
    _selectedScale = scale;
    notifyListeners();
  }

  /// Updates audio settings (e.g. instrument preset, blow mode, etc.).
  void updateSettings(AudioSettings newSettings) {
    _settings = newSettings;
    _fluteRepository.onSettingsChanged();
    _updateCalculatedNote();
    notifyListeners();
  }

  bool _shouldPlaySoundNow() {
    if (_settings.blowMode == BlowMode.autoBlow) return true;
    return _isBlowing;
  }

  void _triggerCurrentSound() {
    final note = _currentNote;
    if (note == null) return;

    unawaited(
      _fluteRepository.playFluteNote(
        note,
        settings: _settings,
        intensity: _breathIntensity,
      ),
    );
  }

  // --- Recording Management ---

  void startRecording() {
    _isRecording = true;
    _recordingStartTime = DateTime.now();
    _currentRecordingEvents.clear();
    notifyListeners();
  }

  void _recordNoteEventIfActive() {
    if (!_isRecording || _recordingStartTime == null || _currentNote == null || _notePlayStartTime == null) {
      return;
    }

    final int timestamp = _notePlayStartTime!.difference(_recordingStartTime!).inMilliseconds;
    final int duration = DateTime.now().difference(_notePlayStartTime!).inMilliseconds;

    if (duration > 50) {
      _currentRecordingEvents.add(
        RecordedNoteEvent(
          noteId: _currentNote!.displayName,
          timestampMs: timestamp,
          durationMs: duration,
          intensity: _breathIntensity,
        ),
      );
    }
    _notePlayStartTime = null;
  }

  FluteRecording? stopRecording({String title = 'My Flute Melody'}) {
    if (!_isRecording || _recordingStartTime == null) return null;

    _recordNoteEventIfActive();
    _isRecording = false;

    final int totalDuration = DateTime.now().difference(_recordingStartTime!).inMilliseconds;
    final recording = FluteRecording(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      events: List.from(_currentRecordingEvents),
      totalDurationMs: totalDuration,
      fluteTypeName: _settings.fluteType.name,
    );

    _songRepository.saveRecording(recording);
    _currentRecordingEvents.clear();
    _recordingStartTime = null;
    notifyListeners();

    return recording;
  }

  @override
  void dispose() {
    _fluteRepository.stopSound();
    super.dispose();
  }
}

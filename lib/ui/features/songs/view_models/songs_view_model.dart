import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:virtual_flute_app/data/repositories/flute_repository.dart';
import 'package:virtual_flute_app/data/repositories/song_repository.dart';
import 'package:virtual_flute_app/domain/models/audio_settings.dart';
import 'package:virtual_flute_app/domain/models/flute_note.dart';
import 'package:virtual_flute_app/domain/models/flute_song.dart';

/// ViewModel managing song tutorials and play-along exercises.
class SongsViewModel extends ChangeNotifier {
  SongsViewModel({
    required SongRepository songRepository,
    required FluteRepository fluteRepository,
  })  : _songRepository = songRepository,
        _fluteRepository = fluteRepository;

  final SongRepository _songRepository;
  final FluteRepository _fluteRepository;

  List<FluteSong> get songs => _songRepository.getSongs();

  FluteSong? _activeSong;
  FluteSong? get activeSong => _activeSong;

  int _currentStepIndex = 0;
  int get currentStepIndex => _currentStepIndex;

  bool _isPlayingTutorial = false;
  bool get isPlayingTutorial => _isPlayingTutorial;

  int _score = 0;
  int get score => _score;

  Timer? _playbackTimer;

  SongNoteStep? get currentTargetStep {
    if (_activeSong == null || _currentStepIndex >= _activeSong!.steps.length) {
      return null;
    }
    return _activeSong!.steps[_currentStepIndex];
  }

  FluteNote? get currentTargetNote {
    final step = currentTargetStep;
    if (step == null) return null;
    return FluteNote.standardNotes.firstWhere(
      (n) => n.displayName == step.noteId || n.id == step.noteId,
      orElse: () => FluteNote.standardNotes.first,
    );
  }

  void selectSong(FluteSong song) {
    _activeSong = song;
    _currentStepIndex = 0;
    _score = 0;
    _stopTimer();
    notifyListeners();
  }

  void startSongPractice() {
    if (_activeSong == null) return;
    _currentStepIndex = 0;
    _score = 0;
    _isPlayingTutorial = true;
    notifyListeners();
    _scheduleNextTutorialStep();
  }

  void _scheduleNextTutorialStep() {
    _stopTimer();
    if (!_isPlayingTutorial || _activeSong == null) return;

    if (_currentStepIndex >= _activeSong!.steps.length) {
      _isPlayingTutorial = false;
      notifyListeners();
      return;
    }

    final step = _activeSong!.steps[_currentStepIndex];
    final note = currentTargetNote;

    // Automatically sound note in tutorial demo mode
    if (note != null) {
      unawaited(
        _fluteRepository.playFluteNote(
          note,
          settings: const AudioSettings(),
          durationSeconds: step.durationMs / 1000.0,
        ),
      );
    }

    _playbackTimer = Timer(Duration(milliseconds: step.durationMs), () {
      _currentStepIndex++;
      notifyListeners();
      _scheduleNextTutorialStep();
    });
  }

  void checkUserPlayedNote(FluteNote playedNote) {
    final target = currentTargetNote;
    if (target != null && (target.id == playedNote.id || target.displayName == playedNote.displayName)) {
      _score += 10;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_activeSong != null && _currentStepIndex < _activeSong!.steps.length - 1) {
      _currentStepIndex++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      notifyListeners();
    }
  }

  void stopPractice() {
    _isPlayingTutorial = false;
    _stopTimer();
    notifyListeners();
  }

  void _stopTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

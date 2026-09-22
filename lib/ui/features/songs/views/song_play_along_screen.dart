import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';
import 'package:virtual_flute_app/domain/models/flute_song.dart';
import 'package:virtual_flute_app/ui/features/flute/view_models/flute_view_model.dart';
import 'package:virtual_flute_app/ui/features/flute/views/widgets/flute_instrument_view.dart';
import 'package:virtual_flute_app/ui/features/songs/view_models/songs_view_model.dart';

/// Interactive play-along screen with real-time target note prompts and score.
class SongPlayAlongScreen extends StatelessWidget {
  const SongPlayAlongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songsViewModel = context.watch<SongsViewModel>();
    final fluteViewModel = context.watch<FluteViewModel>();
    final FluteSong? song = songsViewModel.activeSong;

    if (song == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice')),
        body: const Center(child: Text('No song selected')),
      );
    }

    final targetStep = songsViewModel.currentTargetStep;
    final targetNote = songsViewModel.currentTargetNote;

    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.goldAccent),
                ),
                child: Text(
                  'Score: ${songsViewModel.score}',
                  style: const TextStyle(
                    color: AppColors.goldAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top note sequence strip
            Container(
              height: 90,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: AppColors.woodwindSurface,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: song.steps.length,
                itemBuilder: (context, idx) {
                  final step = song.steps[idx];
                  final isCurrent = idx == songsViewModel.currentStepIndex;
                  final isPast = idx < songsViewModel.currentStepIndex;

                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.breathCyan
                          : isPast
                              ? AppColors.woodwindCard.withValues(alpha: 0.5)
                              : AppColors.woodwindCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrent ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          step.noteId,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? AppColors.woodwindDark : AppColors.textPrimary,
                          ),
                        ),
                        if (step.lyric != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            step.lyric!,
                            style: TextStyle(
                              fontSize: 11,
                              color: isCurrent ? AppColors.woodwindDark : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Target Prompt Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.woodwindCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TARGET NOTE',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          targetStep?.noteId ?? 'Complete!',
                          style: const TextStyle(
                            color: AppColors.goldAccent,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (targetNote != null)
                      FilledButton.tonal(
                        onPressed: () {
                          fluteViewModel.applyFingeringPattern(targetNote.holePattern);
                          songsViewModel.checkUserPlayedNote(targetNote);
                          songsViewModel.nextStep();
                        },
                        child: const Text('Apply Fingering & Advance'),
                      ),
                  ],
                ),
              ),
            ),

            // Middle: Virtual Flute showing target highlight
            Expanded(
              child: Center(
                child: FluteInstrumentView(
                  holes: fluteViewModel.holes,
                  fluteType: fluteViewModel.settings.fluteType,
                  targetHolePattern: targetNote?.holePattern,
                  isBlowing: fluteViewModel.isBlowing,
                  onHoleToggled: (index) {
                    fluteViewModel.toggleHole(index);
                    if (fluteViewModel.currentNote != null) {
                      songsViewModel.checkUserPlayedNote(fluteViewModel.currentNote!);
                    }
                  },
                ),
              ),
            ),

            // Bottom Navigation & Controls
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filledTonal(
                    onPressed: songsViewModel.previousStep,
                    icon: const Icon(Icons.skip_previous),
                    tooltip: 'Previous Step',
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      if (songsViewModel.isPlayingTutorial) {
                        songsViewModel.stopPractice();
                      } else {
                        songsViewModel.startSongPractice();
                      }
                    },
                    icon: Icon(
                      songsViewModel.isPlayingTutorial ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(
                      songsViewModel.isPlayingTutorial ? 'Pause Auto-Play' : 'Auto-Play Demo',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.breathCyan,
                      foregroundColor: AppColors.woodwindDark,
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: songsViewModel.nextStep,
                    icon: const Icon(Icons.skip_next),
                    tooltip: 'Next Step',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

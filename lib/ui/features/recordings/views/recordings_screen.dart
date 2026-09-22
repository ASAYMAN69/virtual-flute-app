import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/repositories/song_repository.dart';
import '../../../../domain/models/recording.dart';
import '../../flute/view_models/flute_view_model.dart';

/// Screen displaying user's saved flute performance recordings with accessible confirmations.
class RecordingsScreen extends StatelessWidget {
  const RecordingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songRepository = context.watch<SongRepository>();
    final fluteViewModel = context.watch<FluteViewModel>();
    final recordings = songRepository.getRecordings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recordings'),
      ),
      body: recordings.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mic_none,
                    size: 64,
                    color: AppColors.textMuted.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Recordings Yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the record button on the Flute screen\nto capture your playing session.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                final FluteRecording rec = recordings[index];
                final durationSec = (rec.totalDurationMs / 1000).toStringAsFixed(1);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.fluteHoleActive.withValues(alpha: 0.2),
                      child: const Icon(Icons.music_note, color: AppColors.fluteHoleActive),
                    ),
                    title: Text(
                      rec.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${rec.fluteTypeName} • $durationSec s • ${rec.events.length} notes',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: AppColors.breathCyan, size: 32),
                          tooltip: 'Play recording ${rec.title}',
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Playing "${rec.title}"...'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            for (final event in rec.events) {
                              await Future.delayed(Duration(milliseconds: event.durationMs));
                              fluteViewModel.setBreathIntensity(event.intensity);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.textSecondary),
                          tooltip: 'Delete recording ${rec.title}',
                          onPressed: () async {
                            final bool? confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Recording?'),
                                content: Text('Are you sure you want to delete "${rec.title}"? This cannot be undone.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.fluteHoleActive,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              songRepository.deleteRecording(rec.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

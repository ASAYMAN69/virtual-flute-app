import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';
import 'package:virtual_flute_app/domain/models/flute_song.dart';
import 'package:virtual_flute_app/ui/features/songs/view_models/songs_view_model.dart';
import 'package:virtual_flute_app/ui/features/songs/views/song_play_along_screen.dart';

/// Songs library screen with practice levels.
class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SongsViewModel>();
    final songs = viewModel.songs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Play-Along Songs'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final FluteSong song = songs[index];
          final (Color badgeBg, Color badgeFg) = switch (song.difficulty) {
            'Beginner' => (AppColors.jadeGreen.withValues(alpha: 0.2), AppColors.jadeGreen),
            'Intermediate' => (AppColors.goldAccent.withValues(alpha: 0.2), AppColors.goldAccent),
            _ => (AppColors.fluteHoleActive.withValues(alpha: 0.2), AppColors.fluteHoleActive),
          };

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                viewModel.selectSong(song);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SongPlayAlongScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            song.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: badgeFg),
                          ),
                          child: Text(
                            song.difficulty,
                            style: TextStyle(
                              color: badgeFg,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artistOrOrigin,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      song.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${song.steps.length} notes • ~${(song.totalDurationMs / 1000).toStringAsFixed(0)}s',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const Row(
                          children: [
                            Text(
                              'Tap to practice',
                              style: TextStyle(
                                color: AppColors.breathCyan,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.breathCyan),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_flute_app/domain/models/flute_note.dart';
import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';
import 'package:virtual_flute_app/ui/features/flute/view_models/flute_view_model.dart';

/// Comprehensive Fingering Guide Chart for Woodwind Flute with full VoiceOver/TalkBack support.
class FingeringGuideScreen extends StatelessWidget {
  const FingeringGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fluteViewModel = context.watch<FluteViewModel>();
    final notes = FluteNote.standardNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingering Chart & Notes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final bool isCurrent = fluteViewModel.currentNote?.id == note.id &&
              fluteViewModel.currentNote?.octave == note.octave;

          final String fingeringSummary = note.holePattern.asMap().entries.map((e) {
            return 'Hole ${e.key + 1} ${e.value ? "closed" : "open"}';
          }).join(', ');

          final String semanticCardLabel =
              '${note.displayName}, Solfège ${note.solfege}${note.altName != null ? ", also known as ${note.altName}${note.octave}" : ""}, '
              'Frequency ${note.frequency.toStringAsFixed(1)} Hertz. '
              'Fingering pattern: $fingeringSummary.';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: isCurrent
                ? AppColors.breathCyan.withValues(alpha: 0.15)
                : AppColors.woodwindCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isCurrent ? AppColors.breathCyan : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Semantics(
              label: semanticCardLabel,
              container: true,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Note Pitch badge
                    ExcludeSemantics(
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: isCurrent ? AppColors.breathCyan : AppColors.woodwindSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            note.displayName,
                            style: TextStyle(
                              color: isCurrent ? AppColors.woodwindDark : AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Solfège & Frequency Info
                    Expanded(
                      child: ExcludeSemantics(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  note.solfege,
                                  style: const TextStyle(
                                    color: AppColors.goldAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (note.altName != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${note.altName}${note.octave})',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${note.frequency.toStringAsFixed(1)} Hz',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 6 Visual Mini-Hole Indicators (Closed = Filled Red/Cyan, Open = Dark Circle)
                    ExcludeSemantics(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(note.holePattern.length, (holeIdx) {
                          final isCovered = note.holePattern[holeIdx];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCovered ? AppColors.fluteHoleActive : AppColors.fluteHoleOpen,
                              border: Border.all(
                                color: isCovered ? AppColors.goldAccent : AppColors.silverFluteDark,
                                width: 1,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Play / Try Button
                    IconButton.filledTonal(
                      icon: const Icon(Icons.play_arrow, size: 20),
                      tooltip: 'Set fingering and play ${note.displayName}',
                      onPressed: () {
                        fluteViewModel.applyFingeringPattern(note.holePattern);
                        fluteViewModel.onBreathStart();
                        Future<void>.delayed(const Duration(milliseconds: 600), () {
                          fluteViewModel.onBreathEnd();
                        });
                      },
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

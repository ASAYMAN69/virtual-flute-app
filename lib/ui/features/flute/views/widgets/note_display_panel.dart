import 'package:flutter/material.dart';
import 'package:virtual_flute_app/domain/models/flute_note.dart';
import 'package:virtual_flute_app/domain/models/flute_scale.dart';
import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';

/// Interactive HUD panel displaying currently sounded flute note, solfege, and frequency.
class NoteDisplayPanel extends StatelessWidget {
  const NoteDisplayPanel({
    super.key,
    required this.currentNote,
    required this.selectedScale,
    required this.isBlowing,
    required this.octaveShift,
  });

  final FluteNote? currentNote;
  final FluteScale selectedScale;
  final bool isBlowing;
  final int octaveShift;

  @override
  Widget build(BuildContext context) {
    final note = currentNote;
    final bool isInScale = note != null && selectedScale.contains(note);

    final String hudSemanticLabel = note != null
        ? 'Active Note: ${note.displayName}, Solfège ${note.solfege}, ${note.frequency.toStringAsFixed(1)} Hertz. Scale: ${selectedScale.name}, ${isInScale ? 'In Scale' : 'Accidental'}. Breath status: ${isBlowing ? 'Blowing' : 'Silent'}.'
        : 'Virtual Flute Idle. No note playing.';

    return MergeSemantics(
      child: Semantics(
        label: hudSemanticLabel,
        liveRegion: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.woodwindSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isBlowing
                  ? AppColors.breathCyan.withValues(alpha: 0.6)
                  : AppColors.woodwindCard,
              width: 1.5,
            ),
            boxShadow: [
              if (isBlowing)
                BoxShadow(
                  color: AppColors.breathCyan.withValues(alpha: 0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              // Left: Big Note Letter & Octave
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'NOTE PLAYING',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        note?.name ?? '--',
                        style: TextStyle(
                          color: isBlowing ? AppColors.breathCyan : AppColors.textPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        note != null ? '${note.octave}' : '',
                        style: const TextStyle(
                          color: AppColors.goldAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Center: Solfège & Frequency
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.woodwindCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      note?.solfege ?? '--',
                      style: const TextStyle(
                        color: AppColors.goldAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note != null ? '${note.frequency.toStringAsFixed(1)} Hz' : '0.0 Hz',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),

              // Right: Scale Match Indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedScale.name,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isInScale
                          ? AppColors.jadeGreen.withValues(alpha: 0.2)
                          : AppColors.fluteHoleActive.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isInScale ? AppColors.jadeGreen : AppColors.fluteHoleActive,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isInScale ? 'In Scale' : 'Accidental',
                      style: TextStyle(
                        color: isInScale ? AppColors.jadeGreen : AppColors.fluteHoleActive,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:virtual_flute_app/domain/models/audio_settings.dart';
import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';

/// Interactive breath control panel with embouchure button, octave selectors, and intensity slider.
class BreathControlPanel extends StatelessWidget {
  const BreathControlPanel({
    super.key,
    required this.isBlowing,
    required this.blowMode,
    required this.breathIntensity,
    required this.octaveShift,
    required this.onBreathStart,
    required this.onBreathEnd,
    required this.onToggleContinuous,
    required this.onIntensityChanged,
    required this.onOctaveChanged,
    required this.onOpenAll,
    required this.onCloseAll,
  });

  final bool isBlowing;
  final BlowMode blowMode;
  final double breathIntensity;
  final int octaveShift;
  final ValueChanged<double> onBreathStart;
  final VoidCallback onBreathEnd;
  final VoidCallback onToggleContinuous;
  final ValueChanged<double> onIntensityChanged;
  final ValueChanged<int> onOctaveChanged;
  final VoidCallback onOpenAll;
  final VoidCallback onCloseAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.woodwindSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.woodwindCard),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Octave Selectors & Quick Hole presets
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // Octave selector with 48x48dp target sizing
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Octave: ',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(width: 4),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: -1, label: Text('Low')),
                        ButtonSegment(value: 0, label: Text('Mid')),
                        ButtonSegment(value: 1, label: Text('High')),
                      ],
                      selected: {octaveShift},
                      onSelectionChanged: (newSelection) {
                        onOctaveChanged(newSelection.first);
                      },
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.breathCyan.withValues(alpha: 0.25);
                          }
                          return AppColors.woodwindCard;
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Action buttons
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      onPressed: onOpenAll,
                      icon: const Icon(Icons.radio_button_unchecked, size: 20),
                      tooltip: 'Open all tone holes',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.woodwindCard,
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      onPressed: onCloseAll,
                      icon: const Icon(Icons.circle, size: 20),
                      tooltip: 'Close all tone holes',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.woodwindCard,
                        foregroundColor: AppColors.fluteHoleActive,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 2: Big Embouchure Mouthpiece / Blow Action Area
          Row(
            children: [
              // Main Blow Touch Pad
              Expanded(
                child: Semantics(
                  button: true,
                  label: blowMode == BlowMode.toggleContinuous
                      ? 'Toggle continuous breath. Currently ${isBlowing ? 'active' : 'inactive'}'
                      : 'Hold to blow flute mouthpiece with breath stream',
                  child: GestureDetector(
                    onTapDown: (_) {
                      if (blowMode == BlowMode.toggleContinuous) {
                        onToggleContinuous();
                      } else {
                        onBreathStart(breathIntensity);
                      }
                    },
                    onTapUp: (_) {
                      if (blowMode != BlowMode.toggleContinuous) {
                        onBreathEnd();
                      }
                    },
                    onTapCancel: () {
                      if (blowMode != BlowMode.toggleContinuous) {
                        onBreathEnd();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isBlowing
                              ? [
                                  AppColors.breathCyan,
                                  const Color(0xFF0077B6),
                                ]
                              : [
                                  AppColors.woodwindCard,
                                  const Color(0xFF1E2638),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isBlowing ? AppColors.breathCyan : AppColors.silverFluteDark.withValues(alpha: 0.4),
                          width: isBlowing ? 2.5 : 1.5,
                        ),
                        boxShadow: isBlowing
                            ? [
                                BoxShadow(
                                  color: AppColors.breathCyan.withValues(alpha: 0.5),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isBlowing ? Icons.air : Icons.mode_fan_off_outlined,
                            color: isBlowing ? Colors.white : AppColors.breathCyan,
                            size: 26,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            blowMode == BlowMode.toggleContinuous
                                ? (isBlowing ? 'BREATH ACTIVE (TAP TO STOP)' : 'START BREATH FLOW')
                                : (isBlowing ? 'BLOWING...' : 'HOLD TO BLOW'),
                            style: TextStyle(
                              color: isBlowing ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 3: Breath Intensity Slider with Semantics
          Row(
            children: [
              const Icon(Icons.waves, color: AppColors.breathCyan, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Air Flow:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              Expanded(
                child: Semantics(
                  label: 'Air Flow Breath Intensity',
                  child: Slider(
                    value: breathIntensity,
                    min: 0.2,
                    max: 1.0,
                    divisions: 8,
                    semanticFormatterCallback: (val) => '${(val * 100).round()}% air flow intensity',
                    label: '${(breathIntensity * 100).toInt()}%',
                    onChanged: onIntensityChanged,
                  ),
                ),
              ),
              Text(
                '${(breathIntensity * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.breathCyan,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

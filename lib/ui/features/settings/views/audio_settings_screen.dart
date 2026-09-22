import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/audio_settings.dart';
import '../../flute/view_models/flute_view_model.dart';

/// Screen for customizing virtual flute acoustics, blowing triggers, and presets.
class AudioSettingsScreen extends StatelessWidget {
  const AudioSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fluteViewModel = context.watch<FluteViewModel>();
    final settings = fluteViewModel.settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrument & Audio Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Flute Type Selector
          const Text(
            'FLUTE TYPE & TIMBRE',
            style: TextStyle(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          for (final type in FluteType.values)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: settings.fluteType == type
                  ? AppColors.breathCyan.withValues(alpha: 0.15)
                  : AppColors.woodwindCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: settings.fluteType == type
                      ? AppColors.breathCyan
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: RadioListTile<FluteType>(
                value: type,
                groupValue: settings.fluteType,
                onChanged: (newType) {
                  if (newType != null) {
                    fluteViewModel.updateSettings(settings.copyWith(fluteType: newType));
                  }
                },
                title: Text(
                  type.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  type.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Section 2: Blowing Mode Trigger
          const Text(
            'BREATH TRIGGER METHOD',
            style: TextStyle(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          for (final mode in BlowMode.values)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: settings.blowMode == mode
                  ? AppColors.breathCyan.withValues(alpha: 0.15)
                  : AppColors.woodwindCard,
              child: RadioListTile<BlowMode>(
                value: mode,
                groupValue: settings.blowMode,
                onChanged: (newMode) {
                  if (newMode != null) {
                    fluteViewModel.updateSettings(settings.copyWith(blowMode: newMode));
                  }
                },
                title: Text(mode.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(mode.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ),
            ),

          const SizedBox(height: 20),

          // Section 3: Acoustics & Vibrato Controls
          const Text(
            'ACOUSTICS & MODULATION',
            style: TextStyle(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Master Volume
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Master Volume'),
                      Text('${(settings.masterVolume * 100).toInt()}%', style: const TextStyle(color: AppColors.breathCyan)),
                    ],
                  ),
                  Semantics(
                    label: 'Master Volume',
                    child: Slider(
                      value: settings.masterVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      semanticFormatterCallback: (val) => '${(val * 100).round()}% volume',
                      onChanged: (val) {
                        fluteViewModel.updateSettings(settings.copyWith(masterVolume: val));
                      },
                    ),
                  ),

                  const Divider(color: AppColors.woodwindSurface),

                  // Vibrato Depth
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Vibrato Depth'),
                      Text('${(settings.vibratoDepth * 100).toInt()}%', style: const TextStyle(color: AppColors.breathCyan)),
                    ],
                  ),
                  Semantics(
                    label: 'Vibrato Depth',
                    child: Slider(
                      value: settings.vibratoDepth,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      semanticFormatterCallback: (val) => '${(val * 100).round()}% vibrato depth',
                      onChanged: (val) {
                        fluteViewModel.updateSettings(settings.copyWith(vibratoDepth: val));
                      },
                    ),
                  ),

                  const Divider(color: AppColors.woodwindSurface),

                  // Breathiness / Air Noise
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Breath Chiff Air Amount'),
                      Text('${(settings.breathAirVolume * 100).toInt()}%', style: const TextStyle(color: AppColors.breathCyan)),
                    ],
                  ),
                  Semantics(
                    label: 'Breath Chiff Air Amount',
                    child: Slider(
                      value: settings.breathAirVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      semanticFormatterCallback: (val) => '${(val * 100).round()}% breath air amount',
                      onChanged: (val) {
                        fluteViewModel.updateSettings(settings.copyWith(breathAirVolume: val));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

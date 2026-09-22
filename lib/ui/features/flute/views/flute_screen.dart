import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';
import 'package:virtual_flute_app/domain/models/flute_scale.dart';
import 'package:virtual_flute_app/ui/features/flute/view_models/flute_view_model.dart';
import 'package:virtual_flute_app/ui/features/flute/views/widgets/breath_control_panel.dart';
import 'package:virtual_flute_app/ui/features/flute/views/widgets/flute_instrument_view.dart';
import 'package:virtual_flute_app/ui/features/flute/views/widgets/note_display_panel.dart';

/// Main interactive virtual flute playing screen.
class FluteScreen extends StatelessWidget {
  const FluteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FluteViewModel>();
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.music_note, color: AppColors.goldAccent),
            const SizedBox(width: 8),
            Text(viewModel.settings.fluteType.name),
          ],
        ),
        actions: [
          // Scale selector dropdown menu
          PopupMenuButton<FluteScale>(
            icon: const Icon(Icons.tune, color: AppColors.breathCyan),
            tooltip: 'Select Musical Scale',
            initialValue: viewModel.selectedScale,
            onSelected: (scale) => viewModel.setScale(scale),
            itemBuilder: (context) {
              return FluteScale.scales.map((scale) {
                return PopupMenuItem(
                  value: scale,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        scale.name,
                        style: TextStyle(
                          fontWeight: scale.id == viewModel.selectedScale.id
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: scale.id == viewModel.selectedScale.id
                              ? AppColors.breathCyan
                              : Colors.white,
                        ),
                      ),
                      Text(
                        scale.description,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),

          // Recording toggle action button
          IconButton(
            icon: Icon(
              viewModel.isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
              color: viewModel.isRecording ? AppColors.fluteHoleActive : AppColors.textSecondary,
            ),
            tooltip: viewModel.isRecording ? 'Stop Recording' : 'Start Recording',
            onPressed: () {
              if (viewModel.isRecording) {
                final recording = viewModel.stopRecording();
                if (recording != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Saved "${recording.title}" (${recording.events.length} notes)'),
                      backgroundColor: AppColors.jadeGreen,
                    ),
                  );
                }
              } else {
                viewModel.startRecording();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recording started... Play your melody!'),
                    backgroundColor: AppColors.fluteHoleActive,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isLandscape
            ? _buildLandscapeLayout(context, viewModel)
            : _buildPortraitLayout(context, viewModel),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, FluteViewModel viewModel) {
    return Column(
      children: [
        // Top HUD Note Status
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: NoteDisplayPanel(
            currentNote: viewModel.currentNote,
            selectedScale: viewModel.selectedScale,
            isBlowing: viewModel.isBlowing,
            octaveShift: viewModel.settings.octaveShift,
          ),
        ),

        // Middle: The Virtual Flute Body with Tone Holes
        Expanded(
          child: Center(
            child: FluteInstrumentView(
              holes: viewModel.holes,
              fluteType: viewModel.settings.fluteType,
              isBlowing: viewModel.isBlowing,
              onHoleToggled: (index) => viewModel.toggleHole(index),
              isLandscape: false,
            ),
          ),
        ),

        // Bottom: Breath Control & Air Flow Trigger
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: BreathControlPanel(
            isBlowing: viewModel.isBlowing,
            blowMode: viewModel.settings.blowMode,
            breathIntensity: viewModel.breathIntensity,
            octaveShift: viewModel.settings.octaveShift,
            onBreathStart: (intensity) => viewModel.onBreathStart(intensity: intensity),
            onBreathEnd: () => viewModel.onBreathEnd(),
            onToggleContinuous: () => viewModel.toggleContinuousBlowing(),
            onIntensityChanged: (val) => viewModel.setBreathIntensity(val),
            onOctaveChanged: (shift) => viewModel.setOctaveShift(shift),
            onOpenAll: () => viewModel.openAllHoles(),
            onCloseAll: () => viewModel.closeAllHoles(),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, FluteViewModel viewModel) {
    return Row(
      children: [
        // Left Column: Note Status & Breath Controls
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  NoteDisplayPanel(
                    currentNote: viewModel.currentNote,
                    selectedScale: viewModel.selectedScale,
                    isBlowing: viewModel.isBlowing,
                    octaveShift: viewModel.settings.octaveShift,
                  ),
                  const SizedBox(height: 12),
                  BreathControlPanel(
                    isBlowing: viewModel.isBlowing,
                    blowMode: viewModel.settings.blowMode,
                    breathIntensity: viewModel.breathIntensity,
                    octaveShift: viewModel.settings.octaveShift,
                    onBreathStart: (intensity) => viewModel.onBreathStart(intensity: intensity),
                    onBreathEnd: () => viewModel.onBreathEnd(),
                    onToggleContinuous: () => viewModel.toggleContinuousBlowing(),
                    onIntensityChanged: (val) => viewModel.setBreathIntensity(val),
                    onOctaveChanged: (shift) => viewModel.setOctaveShift(shift),
                    onOpenAll: () => viewModel.openAllHoles(),
                    onCloseAll: () => viewModel.closeAllHoles(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Right Column: Horizontal Flute Body
        Expanded(
          flex: 6,
          child: Center(
            child: FluteInstrumentView(
              holes: viewModel.holes,
              fluteType: viewModel.settings.fluteType,
              isBlowing: viewModel.isBlowing,
              onHoleToggled: (index) => viewModel.toggleHole(index),
              isLandscape: true,
            ),
          ),
        ),
      ],
    );
  }
}

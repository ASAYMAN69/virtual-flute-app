import 'package:flutter/material.dart';
import 'package:virtual_flute_app/domain/models/audio_settings.dart';
import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';
import 'package:virtual_flute_app/ui/features/flute/views/widgets/flute_hole_widget.dart';

/// Renders the virtual flute body with all 6 tone holes and embouchure mouthpiece.
class FluteInstrumentView extends StatelessWidget {
  const FluteInstrumentView({
    super.key,
    required this.holes,
    required this.fluteType,
    required this.onHoleToggled,
    this.targetHolePattern,
    this.isBlowing = false,
    this.isLandscape = false,
  });

  final List<bool> holes;
  final FluteType fluteType;
  final ValueChanged<int> onHoleToggled;
  final List<bool>? targetHolePattern;
  final bool isBlowing;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    // Custom body colors based on selected flute type
    final (Color bodyLight, Color bodyDark, Color trimColor) = switch (fluteType) {
      FluteType.bambooBansuri => (
          AppColors.bambooWarm,
          AppColors.bambooDark,
          const Color(0xFF5E3023),
        ),
      FluteType.irishTinWhistle => (
          const Color(0xFFC0C0C0),
          const Color(0xFF708090),
          const Color(0xFF2F4F4F),
        ),
      FluteType.panFlute => (
          const Color(0xFFDEB887),
          const Color(0xFF8B4513),
          const Color(0xFFD2691E),
        ),
      FluteType.piccolo => (
          const Color(0xFF2B2D42),
          const Color(0xFF1B1D28),
          AppColors.silverFluteLight,
        ),
      FluteType.concertFlute => (
          AppColors.silverFluteLight,
          AppColors.silverFluteDark,
          AppColors.goldAccent,
        ),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isLandscape) {
          return _buildHorizontalFlute(context, bodyLight, bodyDark, trimColor);
        } else {
          return _buildVerticalFlute(context, bodyLight, bodyDark, trimColor);
        }
      },
    );
  }

  Widget _buildVerticalFlute(
    BuildContext context,
    Color bodyLight,
    Color bodyDark,
    Color trimColor,
  ) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: 105,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                bodyDark,
                bodyLight,
                bodyLight,
                bodyDark,
              ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: isBlowing
                    ? AppColors.breathCyan.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.5),
                blurRadius: isBlowing ? 24 : 12,
                spreadRadius: isBlowing ? 3 : 1,
              ),
            ],
            border: Border.all(
              color: isBlowing ? AppColors.breathCyan : trimColor.withValues(alpha: 0.6),
              width: isBlowing ? 2.5 : 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Embouchure / Mouthpiece indicator on top of flute
              _buildEmbouchureMouthpiece(trimColor),
              const SizedBox(height: 10),
              Container(
                height: 3,
                width: 70,
                decoration: BoxDecoration(
                  color: trimColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6),
              // 6 Tone Holes (3 for left hand, 3 for right hand)
              for (int i = 0; i < 6; i++) ...[
                FluteHoleWidget(
                  index: i,
                  isClosed: holes[i],
                  isHighlighted: targetHolePattern != null && i < targetHolePattern!.length && targetHolePattern![i],
                  onTap: () => onHoleToggled(i),
                  holeLabel: 'Hole ${i + 1}',
                  diameter: 48.0,
                ),
                if (i == 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                      height: 2,
                      width: 50,
                      color: trimColor.withValues(alpha: 0.4),
                    ),
                  ),
              ],
              const SizedBox(height: 6),
              // Flute End Ring
              Container(
                height: 8,
                width: 80,
                decoration: BoxDecoration(
                  color: trimColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalFlute(
    BuildContext context,
    Color bodyLight,
    Color bodyDark,
    Color trimColor,
  ) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          height: 105,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                bodyDark,
                bodyLight,
                bodyLight,
                bodyDark,
              ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: isBlowing
                    ? AppColors.breathCyan.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.5),
                blurRadius: isBlowing ? 24 : 12,
                spreadRadius: isBlowing ? 3 : 1,
              ),
            ],
            border: Border.all(
              color: isBlowing ? AppColors.breathCyan : trimColor.withValues(alpha: 0.6),
              width: isBlowing ? 2.5 : 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEmbouchureMouthpiece(trimColor),
              const SizedBox(width: 10),
              Container(
                width: 3,
                height: 70,
                decoration: BoxDecoration(
                  color: trimColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              for (int i = 0; i < 6; i++) ...[
                FluteHoleWidget(
                  index: i,
                  isClosed: holes[i],
                  isHighlighted: targetHolePattern != null && i < targetHolePattern!.length && targetHolePattern![i],
                  onTap: () => onHoleToggled(i),
                  holeLabel: 'Hole ${i + 1}',
                  diameter: 48.0,
                ),
                if (i == 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: 2,
                      height: 50,
                      color: trimColor.withValues(alpha: 0.4),
                    ),
                  ),
              ],
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 80,
                decoration: BoxDecoration(
                  color: trimColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmbouchureMouthpiece(Color trimColor) {
    return Container(
      width: 44,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.woodwindDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: trimColor, width: 2),
        boxShadow: [
          if (isBlowing)
            BoxShadow(
              color: AppColors.breathCyan.withValues(alpha: 0.8),
              blurRadius: 10,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Center(
        child: Container(
          width: 28,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}

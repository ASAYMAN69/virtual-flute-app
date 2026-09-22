import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Interactive tone hole widget with tactile visual feedback and standard WCAG accessibility semantics.
class FluteHoleWidget extends StatelessWidget {
  const FluteHoleWidget({
    super.key,
    required this.index,
    required this.isClosed,
    required this.onTap,
    this.holeLabel,
    this.isHighlighted = false,
    this.diameter = 54.0,
  });

  final int index;
  final bool isClosed;
  final VoidCallback onTap;
  final String? holeLabel;
  final bool isHighlighted;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: holeLabel ?? 'Tone Hole ${index + 1}',
      value: isClosed ? 'Closed' : 'Open',
      hint: isClosed ? 'Double tap to open hole' : 'Double tap to close hole',
      button: true,
      toggled: isClosed,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isClosed
                        ? [
                            AppColors.fluteHoleActive,
                            AppColors.fluteHoleActive.withValues(alpha: 0.75),
                            const Color(0xFF9E2A2B),
                          ]
                        : [
                            AppColors.fluteHoleOpen,
                            const Color(0xFF1B202E),
                            const Color(0xFF0F131D),
                          ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                  border: Border.all(
                    color: isHighlighted
                        ? AppColors.goldAccent
                        : isClosed
                            ? AppColors.breathCyan
                            : AppColors.silverFluteDark.withValues(alpha: 0.6),
                    width: isHighlighted ? 3.5 : (isClosed ? 2.5 : 2.0),
                  ),
                  boxShadow: [
                    if (isClosed)
                      BoxShadow(
                        color: AppColors.fluteHoleActive.withValues(alpha: 0.5),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    if (isHighlighted)
                      BoxShadow(
                        color: AppColors.goldAccent.withValues(alpha: 0.6),
                        blurRadius: 16,
                        spreadRadius: 3,
                      ),
                  ],
                ),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 150),
                    scale: isClosed ? 1.0 : 0.6,
                    child: Container(
                      width: diameter * 0.45,
                      height: diameter * 0.45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isClosed
                            ? Colors.white.withValues(alpha: 0.9)
                            : AppColors.textMuted.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ExcludeSemantics(
                child: Text(
                  holeLabel ?? 'Hole ${index + 1}',
                  style: TextStyle(
                    color: isHighlighted
                        ? AppColors.goldAccent
                        : (isClosed ? AppColors.breathCyan : AppColors.textSecondary),
                    fontSize: 12,
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

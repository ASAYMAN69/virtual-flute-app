import 'package:flutter/material.dart';
import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';

/// App-wide ThemeData for Virtual Flute.
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.woodwindDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.breathCyan,
        secondary: AppColors.goldAccent,
        surface: AppColors.woodwindSurface,
        onSurface: AppColors.textPrimary,
        error: AppColors.fluteHoleActive,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.woodwindCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.woodwindDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.woodwindSurface,
        indicatorColor: AppColors.breathCyan.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.breathCyan,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          );
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.breathCyan,
        inactiveTrackColor: AppColors.woodwindCard,
        thumbColor: AppColors.goldAccent,
        overlayColor: AppColors.breathCyan.withValues(alpha: 0.15),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      ),
    );
  }
}

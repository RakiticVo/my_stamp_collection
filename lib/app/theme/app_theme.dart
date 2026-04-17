import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final ColorScheme scheme = const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    );

    final TextTheme baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.outlineVariant,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceContainer, width: 1),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      textTheme: baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: AppColors.onSurface),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: AppColors.onSurface),
        titleLarge: baseTextTheme.titleLarge?.copyWith(color: AppColors.onSurface),
      ),
    );
  }

  static ThemeData get dark {
    // For now, fallback to light theme or generate dark scheme.
    // The redesign is currently specified for light mode.
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true, 
      colorScheme: scheme,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
    );
  }
}

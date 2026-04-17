import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Core M3 Palette
  static const Color primary = Color(0xFF005F98);
  static const Color onPrimary = Color(0xFFECF3FF);
  static const Color primaryContainer = Color(0xFF2AA7FF);
  static const Color onPrimaryContainer = Color(0xFF00253F);

  static const Color secondary = Color(0xFFEFC900);
  static const Color onSecondary = Color(0xFF453900);
  static const Color secondaryContainer = Color(0xFFFFD709);
  static const Color onSecondaryContainer = Color(0xFF5B4B00);

  static const Color tertiary = Color(0xFFAB2D00);
  static const Color onTertiary = Color(0xFFFFEFEB);
  static const Color tertiaryContainer = Color(0xFFFF9475);
  static const Color onTertiaryContainer = Color(0xFF601500);
  static const Color tertiaryFixed = Color(0xFFFF9475);
  static const Color tertiaryFixedDim = Color(0xFFFF7D57);
  static const Color tertiaryDim = Color(0xFF962700);

  static const Color error = Color(0xFFB31B25);
  static const Color onError = Color(0xFFFFEFEE);
  static const Color errorContainer = Color(0xFFFB5151);
  static const Color onErrorContainer = Color(0xFF570008);

  // Surface and Backgrounds
  static const Color background = Color(0xFFF4F6FF);
  static const Color onBackground = Color(0xFF162F50);

  static const Color surface = Color(0xFFF4F6FF);
  static const Color onSurface = Color(0xFF162F50);
  static const Color onSurfaceVariant = Color(0xFF455C7F);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEBF1FF);
  static const Color surfaceContainer = Color(0xFFDEE9FF);
  static const Color surfaceContainerHigh = Color(0xFFD5E3FF);
  static const Color surfaceContainerHighest = Color(0xFFCBDEFF);

  // Outline
  static const Color outline = Color(0xFF61789C);
  static const Color outlineVariant = Color(0xFF97AED5);

  // Constants
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color success = Color(0xFF2E7D32);

  // Stamp Presets
  static const Color stampClassicFrame = Color(0xFFE1E3E8);
  static const Color stampClassicPaper = Color(0xFFF3F4F7);
  static const Color stampClassicEdge = Color(0xFF667085);

  static const Color stampHeritageFrame = Color(0xFFF9E0DB);
  static const Color stampHeritagePaper = Color(0xFFFFF2EE);
  static const Color stampHeritageEdge = Color(0xFF8D2F2F);

  static const Color stampModernFrame = Color(0xFFE9E0D3);
  static const Color stampModernPaper = Color(0xFFF8F1E8);
  static const Color stampModernEdge = Color(0xFF6E4E2D);

  // Stamp Palette Suggestions
  static const List<Color> stampPalette = [
    Color(0xFF6A9068),
    Color(0xFF97493D),
    Color(0xFF365D95),
    Color(0xFF7B5FA2),
    Color(0xFF8D7048),
    Color(0xFF2F7F73),
    Color(0xFF5A6574),
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientSoft = LinearGradient(
    colors: [primary, Color(0xFF66C2FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surfaceContainerLowest, surfaceContainerLow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

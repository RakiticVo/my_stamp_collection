import 'package:flutter/material.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_state.dart';

enum StampPerforationPattern { round, triangle, square, dotted, none }

class StampFrameStyle {
  const StampFrameStyle({
    required this.frameColor,
    required this.paperColor,
    required this.edgeColor,
    required this.framePadding,
    required this.imageInset,
    required this.toothPitch,
    required this.holeRadius,
    required this.pattern,
    this.outerShape = StampOuterShape.rectangle,
    this.edgeStrokeWidth = 1.2,
    this.horizontalNotchStretch = 1,
  });

  final Color frameColor;
  final Color paperColor;
  final Color edgeColor;
  final double framePadding;
  final double imageInset;
  final double toothPitch;
  final double holeRadius;
  final StampPerforationPattern pattern;
  final StampOuterShape outerShape;
  final double edgeStrokeWidth;
  final double horizontalNotchStretch;

  StampFrameStyle withColorOverride(Color? color) {
    if (color == null) {
      return this;
    }

    final HSLColor hsl = HSLColor.fromColor(color);
    final Color frame = hsl
        .withLightness((hsl.lightness + 0.18).clamp(0.0, 1.0))
        .toColor();
    final Color paper = hsl
        .withSaturation((hsl.saturation * 0.28).clamp(0.0, 1.0))
        .withLightness(0.90)
        .toColor();
    final Color edge = hsl
        .withLightness((hsl.lightness * 0.76).clamp(0.0, 1.0))
        .toColor();

    return StampFrameStyle(
      frameColor: frame,
      paperColor: paper,
      edgeColor: edge,
      framePadding: framePadding,
      imageInset: imageInset,
      toothPitch: toothPitch,
      holeRadius: holeRadius,
      pattern: pattern,
      outerShape: outerShape,
      edgeStrokeWidth: edgeStrokeWidth,
      horizontalNotchStretch: horizontalNotchStretch,
    );
  }

  StampFrameStyle withNotchWidthScale(double value) {
    final double normalized = value.clamp(0.6, 1.8);
    return StampFrameStyle(
      frameColor: frameColor,
      paperColor: paperColor,
      edgeColor: edgeColor,
      framePadding: framePadding,
      imageInset: imageInset,
      toothPitch: toothPitch * normalized,
      holeRadius: holeRadius * normalized,
      pattern: pattern,
      outerShape: outerShape,
      edgeStrokeWidth: edgeStrokeWidth,
      horizontalNotchStretch: horizontalNotchStretch,
    );
  }

  StampFrameStyle withHorizontalNotchStretch(double value) {
    final double normalized = value.clamp(1.0, 2.4);
    return StampFrameStyle(
      frameColor: frameColor,
      paperColor: paperColor,
      edgeColor: edgeColor,
      framePadding: framePadding,
      imageInset: imageInset,
      toothPitch: toothPitch,
      holeRadius: holeRadius,
      pattern: pattern,
      outerShape: outerShape,
      edgeStrokeWidth: edgeStrokeWidth,
      horizontalNotchStretch: normalized,
    );
  }

  StampFrameStyle withOuterShape(StampOuterShape shape) {
    return StampFrameStyle(
      frameColor: frameColor,
      paperColor: paperColor,
      edgeColor: edgeColor,
      framePadding: framePadding,
      imageInset: imageInset,
      toothPitch: toothPitch,
      holeRadius: holeRadius,
      pattern: pattern,
      outerShape: shape,
      edgeStrokeWidth: edgeStrokeWidth,
      horizontalNotchStretch: horizontalNotchStretch,
    );
  }

  factory StampFrameStyle.fromPreset(StampBorderPreset preset) {
    switch (preset) {
      case StampBorderPreset.classic:
        return const StampFrameStyle(
          frameColor: AppColors.stampClassicFrame,
          paperColor: AppColors.stampClassicPaper,
          edgeColor: AppColors.stampClassicEdge,
          framePadding: 10,
          imageInset: 8,
          toothPitch: 8.5,
          holeRadius: 3.2,
          pattern: StampPerforationPattern.round,
        );
      case StampBorderPreset.heritage:
        return const StampFrameStyle(
          frameColor: AppColors.stampHeritageFrame,
          paperColor: AppColors.stampHeritagePaper,
          edgeColor: AppColors.stampHeritageEdge,
          framePadding: 13,
          imageInset: 8,
          toothPitch: 10.0,
          holeRadius: 4.0,
          pattern: StampPerforationPattern.triangle,
          edgeStrokeWidth: 1.5,
        );
      case StampBorderPreset.modern:
        return const StampFrameStyle(
          frameColor: AppColors.stampModernFrame,
          paperColor: AppColors.stampModernPaper,
          edgeColor: AppColors.stampModernEdge,
          framePadding: 14,
          imageInset: 8,
          toothPitch: 18.0,
          holeRadius: 5.5,
          pattern: StampPerforationPattern.square,
          edgeStrokeWidth: 1.4,
        );
      case StampBorderPreset.victorian:
        return const StampFrameStyle(
          frameColor: Color(0xFF5D1212), // Deep Royal Burgundy
          paperColor: Color(0xFFFDF5E6), // Old Lace
          edgeColor: Color(0xFFDAA520), // Goldenrod
          framePadding: 16,
          imageInset: 10,
          toothPitch: 12.0,
          holeRadius: 5.0,
          pattern: StampPerforationPattern.triangle,
          edgeStrokeWidth: 2.0,
        );
      case StampBorderPreset.minimal:
        return const StampFrameStyle(
          frameColor: Color(0xFF333333), // Charcoal
          paperColor: Color(0xFFF9F9F9), // Nearly White
          edgeColor: Color(0xFF666666), // Medium Gray
          framePadding: 6,
          imageInset: 6,
          toothPitch: 8.0,
          holeRadius: 2.5,
          pattern: StampPerforationPattern.round,
          edgeStrokeWidth: 0.8,
        );
      case StampBorderPreset.dotted:
        return const StampFrameStyle(
          frameColor: Color(0xFFE1E3E8),
          paperColor: Color(0xFFF3F4F7),
          edgeColor: Color(0xFF99AABB),
          framePadding: 10,
          imageInset: 8,
          toothPitch: 5.0,
          holeRadius: 1.2,
          pattern: StampPerforationPattern.dotted,
          edgeStrokeWidth: 1.0,
        );
      case StampBorderPreset.plain:
        return const StampFrameStyle(
          frameColor: AppColors.surfaceContainerHigh,
          paperColor: AppColors.surfaceContainerLowest,
          edgeColor: AppColors.outline,
          framePadding: 6,
          imageInset: 4,
          toothPitch: 0, // Not used
          holeRadius: 0, // Not used
          pattern: StampPerforationPattern.none,
          edgeStrokeWidth: 1.5,
        );
    }
  }
}

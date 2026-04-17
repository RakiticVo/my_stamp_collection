import 'package:flutter/material.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_state.dart';
import 'stamp_clipper.dart';
import 'stamp_frame_style.dart';
import 'stamp_painters.dart';

export 'stamp_frame_style.dart';
export 'border_preset_panel.dart';

class StampBorderFrame extends StatelessWidget {
  const StampBorderFrame({
    super.key,
    required this.preset,
    required this.child,
    required this.notchWidthScale,
    required this.horizontalNotchStretch,
    required this.outerShape,
    this.colorOverride,
  });

  final StampBorderPreset preset;
  final Widget child;
  final double notchWidthScale;
  final double horizontalNotchStretch;
  final StampOuterShape outerShape;
  final Color? colorOverride;

  @override
  Widget build(BuildContext context) {
    final StampFrameStyle baseStyle = StampFrameStyle.fromPreset(preset);
    final StampFrameStyle style = baseStyle
        .withColorOverride(colorOverride)
        .withNotchWidthScale(notchWidthScale)
        .withHorizontalNotchStretch(horizontalNotchStretch)
        .withOuterShape(outerShape);

    final StampClipper clipper = StampClipper(style: style);

    return ClipPath(
      clipper: clipper,
      child: Stack(
        children: [
          CustomPaint(
            painter: StampEdgePainter(
              clipper: clipper,
              color: style.edgeColor,
              strokeWidth: style.edgeStrokeWidth,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(color: style.frameColor),
              child: Padding(
                padding: EdgeInsets.all(style.framePadding + 2.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: style.paperColor),
                  child: Padding(
                    // Keep image safely away from perforated cut so enlarged notches
                    // do not expose sharp background artifacts.
                    padding: EdgeInsets.all(
                      style.imageInset + (style.holeRadius * 0.4),
                    ),
                    child: ClipRect(child: child),
                  ),
                ),
              ),
            ),
          ),
          // Paper Texture Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.04,
                child: CustomPaint(painter: PaperGrainPainter()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

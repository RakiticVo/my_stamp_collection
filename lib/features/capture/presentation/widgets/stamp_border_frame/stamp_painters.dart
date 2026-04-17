import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import 'stamp_clipper.dart';

class StampEdgePainter extends CustomPainter {
  const StampEdgePainter({
    required this.clipper,
    required this.color,
    this.strokeWidth = 1.0,
  });

  final StampClipper clipper;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.miter
      ..isAntiAlias = true;

    canvas.drawPath(clipper.shapeForSize(size), paint);
  }

  @override
  bool shouldRepaint(covariant StampEdgePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      clipper.style != oldDelegate.clipper.style;
}

class PaperGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final math.Random random = math.Random(42);
    final Paint paint = Paint()..strokeWidth = 1.0;

    for (int i = 0; i < 1500; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final double alpha = random.nextDouble() * 0.3;
      paint.color = AppColors.black.withValues(alpha: alpha);
      canvas.drawPoints(PointMode.points, [Offset(x, y)], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

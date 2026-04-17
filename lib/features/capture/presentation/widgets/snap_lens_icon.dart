import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class SnapLensIcon extends StatelessWidget {
  const SnapLensIcon({
    super.key,
    this.size = 34,
    this.color = AppColors.white,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SnapLensPainter(color: color),
      ),
    );
  }
}

class _SnapLensPainter extends CustomPainter {
  const _SnapLensPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color.withValues(alpha: 0.96);

    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.16);

    final RRect body = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.24, w * 0.80, h * 0.58),
      Radius.circular(w * 0.14),
    );
    canvas.drawRRect(body, fill);
    canvas.drawRRect(body, stroke);

    final RRect topPlate = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.23, h * 0.12, w * 0.24, h * 0.16),
      Radius.circular(w * 0.06),
    );
    canvas.drawRRect(topPlate, stroke);

    final RRect viewfinder = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.58, h * 0.16, w * 0.17, h * 0.10),
      Radius.circular(w * 0.04),
    );
    canvas.drawRRect(viewfinder, stroke);

    final Offset c = Offset(w * 0.50, h * 0.53);
    final double r1 = w * 0.205;
    final double r2 = w * 0.115;
    canvas.drawCircle(c, r1, stroke);

    final Paint inner = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..color = color.withValues(alpha: 0.96);
    canvas.drawCircle(c, r2, inner);

    final Paint sparkle = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.96);
    canvas.drawCircle(Offset(c.dx + r2 * 0.35, c.dy - r2 * 0.35), w * 0.03, sparkle);

    final Path shutter = Path();
    const int blades = 5;
    for (int i = 0; i < blades; i++) {
      final double angle = -math.pi / 2 + i * (2 * math.pi / blades);
      final Offset p = Offset(
        c.dx + (w * 0.06) * math.cos(angle),
        c.dy + (w * 0.06) * math.sin(angle),
      );
      if (i == 0) {
        shutter.moveTo(p.dx, p.dy);
      } else {
        shutter.lineTo(p.dx, p.dy);
      }
    }
    shutter.close();
    canvas.drawPath(shutter, sparkle);
  }

  @override
  bool shouldRepaint(covariant _SnapLensPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

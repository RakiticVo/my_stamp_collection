import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_state.dart';
import 'stamp_frame_style.dart';

class StampClipper extends CustomClipper<Path> {
  const StampClipper({required this.style});

  final StampFrameStyle style;

  @override
  Path getClip(Size size) => shapeForSize(size);

  Path shapeForSize(Size size) {
    if (style.outerShape == StampOuterShape.circle) {
      return _buildCircleShape(size);
    }
    if (style.outerShape == StampOuterShape.hexagon) {
      return _buildHexagonShape(size);
    }
    if (style.outerShape == StampOuterShape.diamond) {
      return _buildDiamondShape(size);
    }
    if (style.outerShape == StampOuterShape.octagon) {
      return _buildOctagonShape(size);
    }
    if (style.outerShape == StampOuterShape.shield) {
      return _buildShieldShape(size);
    }

    // ── Rectangle outer shape ──
    if (style.pattern == StampPerforationPattern.none) {
      return Path()..addRect(Offset.zero & size);
    }
    
    if (style.pattern == StampPerforationPattern.square) {
      return _buildCrenellation(size);
    }

    if (style.pattern == StampPerforationPattern.triangle) {
      return _buildZigzag(size);
    }

    // Round and Dotted pattern rectangle: subtraction approach
    final Path base = Path()..addRect(Offset.zero & size);
    final Path holes = Path();

    final double radius = style.holeRadius;
    final double pitch = style.toothPitch;
    final double margin = radius * 0.75;
    final double availX = size.width - 2 * margin;
    final double availY = size.height - 2 * margin;

    final int countX = math.max(1, (availX / pitch).floor());
    final int countY = math.max(1, (availY / pitch).floor());
    final double pitchX = availX / countX;
    final double pitchY = availY / countY;

    for (int i = 0; i < countX; i++) {
      final double cx = margin + (i + 0.5) * pitchX;
      _addNotch(holes, cx, 0, radius, style.pattern, Axis.horizontal, pitchX);
      _addNotch(holes, cx, size.height, radius, style.pattern, Axis.horizontal, pitchX);
    }
    for (int i = 0; i < countY; i++) {
      final double cy = margin + (i + 0.5) * pitchY;
      _addNotch(holes, 0, cy, radius, style.pattern, Axis.vertical, pitchY);
      _addNotch(holes, size.width, cy, radius, style.pattern, Axis.vertical, pitchY);
    }

    return Path.combine(PathOperation.difference, base, holes);
  }

  Path _buildCircleShape(Size size) {
    final double radius = math.min(size.width, size.height) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    
    final Path base = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    
    if (style.pattern == StampPerforationPattern.none) {
      return base;
    }

    final double holeRadius = style.holeRadius;
    final double pitch = style.toothPitch;
    
    final double circumference = 2 * math.pi * radius;
    final int count = math.max(1, (circumference / pitch).floor());
    final double angleStep = (2 * math.pi) / count;
    
    final Path holes = Path();
    for (int i = 0; i < count; i++) {
        final double angle = i * angleStep;
        final double cx = center.dx + radius * math.cos(angle);
        final double cy = center.dy + radius * math.sin(angle);
        
        holes.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: holeRadius));
    }
    
    return Path.combine(PathOperation.difference, base, holes);
  }

  Path _buildHexagonShape(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    
    final double r = math.min(w, h) / 2;
    
    final Path base = Path();
    List<Offset> corners = [];
    for (int i = 0; i < 6; i++) {
       final double angle = 2 * math.pi / 6 * i - math.pi / 2;
       corners.add(Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)));
       if (i == 0) {
         base.moveTo(corners.last.dx, corners.last.dy);
       } else {
         base.lineTo(corners.last.dx, corners.last.dy);
       }
    }
    base.close();
    
    if (style.pattern == StampPerforationPattern.none) {
      return base;
    }

    final Path holes = Path();
    for (int i = 0; i < 6; i++) {
        final Offset p1 = corners[i];
        final Offset p2 = corners[(i + 1) % 6];
        final double dx = p2.dx - p1.dx;
        final double dy = p2.dy - p1.dy;
        final double len = math.sqrt(dx*dx + dy*dy);
        final int count = math.max(1, (len / style.toothPitch).floor());
        final double stepX = dx / count;
        final double stepY = dy / count;
        
        for (int j = 0; j <= count; j++) {
            holes.addOval(Rect.fromCircle(
                center: Offset(p1.dx + stepX * j, p1.dy + stepY * j),
                radius: style.holeRadius
            ));
        }
    }
    
    return Path.combine(PathOperation.difference, base, holes);
  }

  Path _buildDiamondShape(Size size) {
    final double w = size.width;
    final double h = size.height;
    final Path base = Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w / 2, h)
      ..lineTo(0, h / 2)
      ..close();

    if (style.pattern == StampPerforationPattern.none) return base;

    final List<Offset> corners = [
      Offset(w / 2, 0),
      Offset(w, h / 2),
      Offset(w / 2, h),
      Offset(0, h / 2),
    ];
    return _applyPerforationToPolygon(base, corners);
  }

  Path _buildOctagonShape(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = math.min(w, h) / 2;

    final Path base = Path();
    final List<Offset> corners = [];
    for (int i = 0; i < 8; i++) {
      final double angle = 2 * math.pi / 8 * i - math.pi / 8; // Offset for flat top/sides
      corners.add(Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)));
      if (i == 0) {
        base.moveTo(corners.last.dx, corners.last.dy);
      } else {
        base.lineTo(corners.last.dx, corners.last.dy);
      }
    }
    base.close();

    if (style.pattern == StampPerforationPattern.none) return base;

    return _applyPerforationToPolygon(base, corners);
  }

  Path _buildShieldShape(Size size) {
    final double w = size.width;
    final double h = size.height;
    
    // Shield shape is more organic, we'll approximate with curves
    final Path base = Path()
      ..moveTo(0, h * 0.1)
      ..lineTo(w, h * 0.1)
      ..lineTo(w, h * 0.6)
      ..quadraticBezierTo(w, h * 0.9, w / 2, h)
      ..quadraticBezierTo(0, h * 0.9, 0, h * 0.6)
      ..close();

    if (style.pattern == StampPerforationPattern.none) return base;
    
    // For shield, we'll extract some points along the path for perforation
    // Simplified: treat it as a polygon for hole placement
    final List<Offset> vertices = [
       Offset(0, h * 0.1),
       Offset(w, h * 0.1),
       Offset(w, h * 0.6),
       Offset(w * 0.85, h * 0.85),
       Offset(w / 2, h),
       Offset(w * 0.15, h * 0.85),
       Offset(0, h * 0.6),
    ];

    return _applyPerforationToPolygon(base, vertices);
  }

  Path _applyPerforationToPolygon(Path base, List<Offset> corners) {
    final Path holes = Path();
    for (int i = 0; i < corners.length; i++) {
      final Offset p1 = corners[i];
      final Offset p2 = corners[(i + 1) % corners.length];
      final double dx = p2.dx - p1.dx;
      final double dy = p2.dy - p1.dy;
      final double len = math.sqrt(dx * dx + dy * dy);
      final int count = math.max(1, (len / style.toothPitch).floor());
      final double stepX = dx / count;
      final double stepY = dy / count;

      for (int j = 0; j <= count; j++) {
        _addNotch(
          holes, 
          p1.dx + stepX * j, 
          p1.dy + stepY * j, 
          style.holeRadius, 
          style.pattern, 
          Axis.horizontal, // Approximation
          style.toothPitch,
        );
      }
    }
    return Path.combine(PathOperation.difference, base, holes);
  }



  /// Builds a continuous zigzag path for the Triangle border pattern.
  Path _buildZigzag(Size size) {
    // dNormal is the depth for standard edge teeth (as set by user).
    // dCorner is the specialized deeper indentation for corners (as requested).
    final double dNormal = style.holeRadius * 1.45;
    final double dCorner = style.holeRadius * 0.95;
    final double pitch = style.toothPitch;

    // cornerGap now scales with holeRadius (Width slider).
    final double cornerGap = style.holeRadius * 2.5;

    // Use dCorner for boundary calculations so zigzags fit between gaps.
    final double availX = size.width - 2 * dCorner - 2 * cornerGap;
    final double availY = size.height - 2 * dCorner - 2 * cornerGap;

    final int countX = math.max(0, (availX / pitch).floor());
    final int countY = math.max(0, (availY / pitch).floor());

    final double pitchX = countX > 0 ? availX / countX : 0;
    final double pitchY = countY > 0 ? availY / countY : 0;

    final Path p = Path();
    p.moveTo(dCorner, dCorner); // Deep prominent corner turning point

    // ── TOP EDGE ──
    p.lineTo(dCorner + cornerGap, dNormal); // Move to shallower edge depth
    for (int i = 0; i < countX; i++) {
      final double x = dCorner + cornerGap + i * pitchX;
      p.lineTo(x + pitchX / 2, 0); // Peak
      p.lineTo(x + pitchX, dNormal); // Valley
    }
    p.lineTo(
      size.width - dCorner,
      dCorner,
    ); // Deep prominent corner turning point

    // ── RIGHT EDGE ──
    p.lineTo(
      size.width - dNormal,
      dCorner + cornerGap,
    ); // Move to shallower edge depth
    for (int i = 0; i < countY; i++) {
      final double y = dCorner + cornerGap + i * pitchY;
      p.lineTo(size.width, y + pitchY / 2); // Peak
      p.lineTo(size.width - dNormal, y + pitchY); // Valley
    }
    p.lineTo(
      size.width - dCorner,
      size.height - dCorner,
    ); // Deep prominent corner turning point

    // ── BOTTOM EDGE ──
    p.lineTo(size.width - dCorner - cornerGap, size.height - dNormal);
    for (int i = countX - 1; i >= 0; i--) {
      final double x = dCorner + cornerGap + i * pitchX;
      p.lineTo(x + pitchX / 2, size.height); // Peak
      p.lineTo(x, size.height - dNormal); // Valley
    }
    p.lineTo(
      dCorner,
      size.height - dCorner,
    ); // Deep prominent corner turning point

    // ── LEFT EDGE ──
    p.lineTo(dNormal, size.height - dCorner - cornerGap);
    for (int i = countY - 1; i >= 0; i--) {
      final double y = dCorner + cornerGap + i * pitchY;
      p.lineTo(0, y + pitchY / 2); // Peak
      p.lineTo(dNormal, y); // Valley
    }

    p.close();
    return p;
  }

  /// Builds a continuous crenellation (battlement) path for the Square
  /// border pattern.  The teeth run uninterrupted around the entire
  /// perimeter, including through the corners.
  Path _buildCrenellation(Size size) {
    final double d = style.holeRadius; // notch depth
    final double pitch = style.toothPitch;
    const double toothFrac = 0.5;

    // Use a small margin/gap at corners to ensure symmetry
    final double cornerGap = style.holeRadius * 1.8;

    final double availX = size.width - 2 * cornerGap;
    final double availY = size.height - 2 * cornerGap;

    final int countX = math.max(1, (availX / pitch).floor());
    final int countY = math.max(1, (availY / pitch).floor());

    final double pitchX = availX / countX;
    final double pitchY = availY / countY;

    final Path p = Path();
    p.moveTo(0, 0); // Path boundary
    p.lineTo(size.width, 0);
    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    p.close();

    // Re-using subtraction approach for Square to match Round's stability if needed, 
    // but the user's "stable" version was continuous. 
    // Let's ensure the continuous path is perfectly symmetric.
    final Path border = Path();
    border.moveTo(0, 0);
    
    // TOP
    border.lineTo(cornerGap, 0);
    for (int i = 0; i < countX; i++) {
        final double x = cornerGap + i * pitchX;
        border.lineTo(x + pitchX * toothFrac * 0.5, 0);
        border.lineTo(x + pitchX * toothFrac * 0.5, d);
        border.lineTo(x + pitchX * (1 - toothFrac * 0.5), d);
        border.lineTo(x + pitchX * (1 - toothFrac * 0.5), 0);
    }
    border.lineTo(size.width, 0);

    // RIGHT
    border.lineTo(size.width, cornerGap);
    for (int i = 0; i < countY; i++) {
        final double y = cornerGap + i * pitchY;
        border.lineTo(size.width, y + pitchY * toothFrac * 0.5);
        border.lineTo(size.width - d, y + pitchY * toothFrac * 0.5);
        border.lineTo(size.width - d, y + pitchY * (1 - toothFrac * 0.5));
        border.lineTo(size.width, y + pitchY * (1 - toothFrac * 0.5));
    }
    border.lineTo(size.width, size.height);

    // BOTTOM
    border.lineTo(size.width - cornerGap, size.height);
    for (int i = countX - 1; i >= 0; i--) {
        final double x = cornerGap + i * pitchX;
        border.lineTo(x + pitchX * (1 - toothFrac * 0.5), size.height);
        border.lineTo(x + pitchX * (1 - toothFrac * 0.5), size.height - d);
        border.lineTo(x + pitchX * toothFrac * 0.5, size.height - d);
        border.lineTo(x + pitchX * toothFrac * 0.5, size.height);
    }
    border.lineTo(0, size.height);

    // LEFT
    border.lineTo(0, size.height - cornerGap);
    for (int i = countY - 1; i >= 0; i--) {
        final double y = cornerGap + i * pitchY;
        border.lineTo(0, y + pitchY * (1 - toothFrac * 0.5));
        border.lineTo(d, y + pitchY * (1 - toothFrac * 0.5));
        border.lineTo(d, y + pitchY * toothFrac * 0.5);
        border.lineTo(0, y + pitchY * toothFrac * 0.5);
    }
    border.close();
    
    return border;
  }

  void _addNotch(
    Path path,
    double x,
    double y,
    double radius,
    StampPerforationPattern pattern,
    Axis axis,
    double pitch,
  ) {
    if (pattern == StampPerforationPattern.round || 
        pattern == StampPerforationPattern.dotted) {
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
    }
  }

  @override
  bool shouldReclip(covariant StampClipper oldClipper) =>
      style != oldClipper.style;
}

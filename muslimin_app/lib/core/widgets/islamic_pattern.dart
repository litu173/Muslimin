import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Geometric girih-style lattice used behind dark headers (recreates the
/// tiled pattern of the Figma header). Pure vector, so it is crisp at any
/// density and costs nothing in app size.
class IslamicPattern extends StatelessWidget {
  const IslamicPattern({
    super.key,
    this.child,
    this.color = AppColors.ink,
    this.opacity = 0.07,
  });

  final Widget? child;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: CustomPaint(
      painter: _PatternPainter(color: color, opacity: opacity),
      child: child,
    ),
  );
}

class _PatternPainter extends CustomPainter {
  _PatternPainter({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.goldLight.withValues(alpha: opacity);
    final shade = Paint()..color = AppColors.inkDeep.withValues(alpha: 0.35);

    const tile = 72.0;
    for (var y = -tile / 2; y < size.height + tile; y += tile) {
      for (var x = 0.0; x < size.width + tile; x += tile) {
        final c = Offset(x, y);
        _star(canvas, c, tile * 0.42, shade, fill: true);
        _star(canvas, c, tile * 0.42, line);
        _star(canvas, c, tile * 0.22, line);
        canvas.drawCircle(c, tile * 0.08, line);
        // connectors between stars
        canvas.drawLine(
          c + Offset(tile * 0.42, 0),
          c + Offset(tile * 0.58, 0),
          line,
        );
        canvas.drawLine(
          c + Offset(0, tile * 0.42),
          c + Offset(0, tile * 0.58),
          line,
        );
      }
    }
  }

  /// 8-point star made of two overlapping squares.
  void _star(Canvas canvas, Offset c, double r, Paint p, {bool fill = false}) {
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final a = -math.pi / 2 + i * math.pi / 8;
      final rr = i.isEven ? r : r * 0.76;
      final pt = c + Offset(math.cos(a) * rr, math.sin(a) * rr);
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawPath(path, fill ? (Paint()..color = p.color) : p);
  }

  @override
  bool shouldRepaint(_PatternPainter old) =>
      old.color != color || old.opacity != opacity;
}

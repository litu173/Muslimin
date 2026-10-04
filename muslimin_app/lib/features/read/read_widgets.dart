import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';

/// Eight-point star (the ۞ motif of the masjid badge), used for journey
/// nodes and ayah numbers.
class StarShapeBorder extends ShapeBorder {
  const StarShapeBorder({this.side = BorderSide.none, this.inner = 0.82});

  final BorderSide side;

  /// Inner radius as a share of the outer radius.
  final double inner;

  static Path pathFor(Rect rect, double inner) {
    final c = rect.center;
    final r = rect.shortestSide / 2;
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final a = -math.pi / 2 + i * math.pi / 8;
      final rad = i.isEven ? r : r * inner;
      final p = Offset(c.dx + rad * math.cos(a), c.dy + rad * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      pathFor(rect.deflate(side.width), inner);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      pathFor(rect, inner);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0) return;
    canvas.drawPath(
      pathFor(rect.deflate(side.width / 2), inner),
      side.toPaint()..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  ShapeBorder scale(double t) =>
      StarShapeBorder(side: side.scale(t), inner: inner);
}

/// Small star with the ayah number inside.
class AyahNumber extends StatelessWidget {
  const AyahNumber(this.text, {super.key, this.size = 34});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: ShapeDecoration(
      color: AppColors.gold.withValues(alpha: 0.1),
      shape: StarShapeBorder(
        side: BorderSide(color: AppColors.gold, width: 1.3),
      ),
    ),
    child: Text(
      text,
      style: AppText.micro.copyWith(
        color: AppColors.gold,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    ),
  );
}

/// Dotted connector between two journey nodes (x in logical px, from the
/// left edge): an S-curve from (fromX, 0) to (toX, height).
class DottedConnector extends CustomPainter {
  DottedConnector({
    required this.fromX,
    required this.toX,
    required this.color,
  });

  final double fromX;
  final double toX;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(fromX, 0)
      ..cubicTo(
        fromX,
        size.height * 0.5,
        toX,
        size.height * 0.5,
        toX,
        size.height,
      );
    final paint = Paint()..color = color;
    for (final m in path.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 9) {
        final p = m.getTangentForOffset(d)!.position;
        canvas.drawCircle(p, 2.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DottedConnector old) =>
      old.fromX != fromX || old.toX != toX || old.color != color;
}

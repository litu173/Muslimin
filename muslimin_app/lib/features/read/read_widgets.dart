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

/// Where a surah was revealed, drawn as a tiny emblem: the Kaaba (with its
/// gold kiswah band) for Makkah, the green dome with its crescent for
/// Madinah.
class RevelationIcon extends StatelessWidget {
  const RevelationIcon({super.key, required this.makki, this.size = 20});

  final bool makki;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: makki ? const _KaabaPainter() : const _DomePainter(),
    ),
  );
}

class _KaabaPainter extends CustomPainter {
  const _KaabaPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    // Cube in light perspective: front face, side face and top.
    final front = Path()
      ..moveTo(w * 0.12, h * 0.36)
      ..lineTo(w * 0.62, h * 0.46)
      ..lineTo(w * 0.62, h * 0.94)
      ..lineTo(w * 0.12, h * 0.84)
      ..close();
    final side = Path()
      ..moveTo(w * 0.62, h * 0.46)
      ..lineTo(w * 0.9, h * 0.32)
      ..lineTo(w * 0.9, h * 0.8)
      ..lineTo(w * 0.62, h * 0.94)
      ..close();
    final top = Path()
      ..moveTo(w * 0.12, h * 0.36)
      ..lineTo(w * 0.4, h * 0.22)
      ..lineTo(w * 0.9, h * 0.32)
      ..lineTo(w * 0.62, h * 0.46)
      ..close();
    canvas.drawPath(top, Paint()..color = const Color(0xFF3A3A3A));
    canvas.drawPath(front, Paint()..color = const Color(0xFF151515));
    canvas.drawPath(side, Paint()..color = const Color(0xFF242424));
    // Gold band (hizam).
    final band = Paint()
      ..color = const Color(0xFFE2B33C)
      ..strokeWidth = h * 0.07
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(
      Offset(w * 0.12, h * 0.48),
      Offset(w * 0.62, h * 0.58),
      band,
    );
    canvas.drawLine(
      Offset(w * 0.62, h * 0.58),
      Offset(w * 0.9, h * 0.44),
      band,
    );
    // Door.
    canvas.drawRect(
      Rect.fromLTWH(w * 0.4, h * 0.66, w * 0.1, h * 0.2),
      Paint()..color = const Color(0xFFE2B33C),
    );
  }

  @override
  bool shouldRepaint(_KaabaPainter old) => false;
}

class _DomePainter extends CustomPainter {
  const _DomePainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    const green = Color(0xFF2E8B57);
    const greenDark = Color(0xFF1F6B42);
    // Drum.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.16, h * 0.62, w * 0.68, h * 0.3),
        Radius.circular(w * 0.04),
      ),
      Paint()..color = greenDark,
    );
    // Dome: onion shape.
    final dome = Path()
      ..moveTo(w * 0.14, h * 0.64)
      ..cubicTo(w * 0.1, h * 0.36, w * 0.36, h * 0.3, w * 0.5, h * 0.2)
      ..cubicTo(w * 0.64, h * 0.3, w * 0.9, h * 0.36, w * 0.86, h * 0.64)
      ..close();
    canvas.drawPath(
      dome,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4FB07A), green],
        ).createShader(Offset.zero & s),
    );
    // Finial + crescent.
    final gold = Paint()..color = const Color(0xFFE2B33C);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.48, h * 0.08, w * 0.04, h * 0.13),
      gold,
    );
    final c = Offset(w * 0.5, h * 0.08);
    final crescent = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: c, radius: w * 0.09)),
      Path()..addOval(
        Rect.fromCircle(
          center: c.translate(w * 0.04, -h * 0.02),
          radius: w * 0.08,
        ),
      ),
    );
    canvas.drawPath(crescent, gold);
  }

  @override
  bool shouldRepaint(_DomePainter old) => false;
}

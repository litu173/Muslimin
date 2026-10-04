import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The circular "Time left" ring of the home header.
class CountdownRing extends StatelessWidget {
  const CountdownRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 110,
  });

  /// 0..1 elapsed fraction of the current waqt.
  final double progress;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: TweenAnimationBuilder<double>(
      tween: Tween(end: 1 - progress),
      duration: const Duration(milliseconds: 600),
      builder: (_, remaining, c) =>
          CustomPaint(painter: _RingPainter(remaining), child: c),
      child: Center(child: child),
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.remaining);

  final double remaining;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 5.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = AppColors.inkDeep,
    );
    if (remaining <= 0) return;
    final sweep = math.pi * 2 * remaining.clamp(0, 1);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: math.pi * 2,
          transform: const GradientRotation(-math.pi / 2),
          colors: [AppColors.goldLight, AppColors.gold, Color(0x00BB8907)],
          stops: [0, remaining * 0.7, remaining],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.remaining != remaining;
}

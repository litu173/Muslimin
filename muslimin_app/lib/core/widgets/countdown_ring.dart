import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The circular "Time left" ring of the home header.
///
/// The countdown changes the progress every second by a hair. Animating each
/// of those steps (600 ms per second) kept the app drawing ~36 frames a
/// second for as long as Home was open, which made the phone's own UI
/// sluggish. Small steps now jump (one frame); only real jumps – a new
/// waqt, first load – are animated.
class CountdownRing extends StatefulWidget {
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
  State<CountdownRing> createState() => _CountdownRingState();
}

class _CountdownRingState extends State<CountdownRing>
    with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
    value: 0,
  )..forward();
  late final _curve = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
  double _from = 1;
  late double _to = 1 - widget.progress;

  double get _remaining => _from + (_to - _from) * _curve.value;

  @override
  void didUpdateWidget(CountdownRing old) {
    super.didUpdateWidget(old);
    final next = 1 - widget.progress;
    if (next == _to) return;
    if ((next - _remaining).abs() < 0.02) {
      // Per-second tick: just move, no animation frames.
      _from = _to = next;
      _anim.value = 1;
    } else {
      _from = _remaining;
      _to = next;
      _anim.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _curve.dispose();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: widget.size,
    child: CustomPaint(
      painter: _RingPainter(this),
      child: Center(child: widget.child),
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.ring) : super(repaint: ring._anim);

  final _CountdownRingState ring;

  @override
  void paint(Canvas canvas, Size size) {
    final remaining = ring._remaining;
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
  bool shouldRepaint(_RingPainter old) => true;
}

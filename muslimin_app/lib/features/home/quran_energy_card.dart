import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../l10n/app_localizations.dart';
import '../../state/quran.dart';

/// Which bottom tab is showing (0 Home · 1 Read · 2 More), so cards can
/// send the user to the Read tab.
class ShellTab extends Notifier<int> {
  @override
  int build() => 0;

  void go(int tab) => state = tab;
}

final shellTabProvider = NotifierProvider<ShellTab, int>(ShellTab.new);

/// "Daily Quran": a lantern that is dim until you read today, and fills with
/// light as you read – the more you read, the brighter it shines.
class QuranEnergyCard extends ConsumerStatefulWidget {
  const QuranEnergyCard({super.key});

  @override
  ConsumerState<QuranEnergyCard> createState() => _QuranEnergyCardState();
}

class _QuranEnergyCardState extends ConsumerState<QuranEnergyCard>
    with SingleTickerProviderStateMixin {
  late final _flicker = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _flicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final p = ref.watch(quranProgressProvider);
    final today = p.versesToday;
    final streak = p.streak;
    // 0…1 up to the goal, up to 2 beyond it (extra shine).
    final energy = (today / kDailyGoal).clamp(0.0, 2.0);
    final mood = today == 0
        ? t.energy0
        : energy < 0.5
        ? t.energy1
        : energy < 1
        ? t.energy2
        : energy < 2
        ? t.energy3
        : t.energy4;

    return TweenAnimationBuilder<double>(
      tween: Tween(end: energy),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, e, _) => ClipRRect(
        borderRadius: BorderRadius.circular(Radii.card),
        child: Material(
          color: AppColors.header,
          child: InkWell(
            onTap: () => ref.read(shellTabProvider.notifier).go(1),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Opacity(opacity: 0.6, child: IslamicPattern()),
                ),
                // Warm glow spreading from the lantern as energy rises.
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _flicker,
                    builder: (_, _) => DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(-0.72, 0),
                          radius:
                              0.35 +
                              0.55 * (e / 2) +
                              0.03 * math.sin(_flicker.value * 2 * math.pi),
                          colors: [
                            AppColors.goldLight.withValues(
                              alpha: (0.08 + 0.42 * e.clamp(0, 1.4)).clamp(
                                0,
                                0.6,
                              ),
                            ),
                            AppColors.goldLight.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.l,
                    Gap.l,
                    Gap.l,
                    Gap.l,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 78,
                        height: 110,
                        child: AnimatedBuilder(
                          animation: _flicker,
                          builder: (_, _) => CustomPaint(
                            painter: _LanternPainter(
                              energy: e,
                              flicker: _flicker.value,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Gap.l),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    t.dailyQuran,
                                    style: AppText.subtitle.copyWith(
                                      color: AppColors.onHeader,
                                    ),
                                  ),
                                ),
                                if (streak > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.goldLight.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Radii.pill,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.local_fire_department_rounded,
                                          size: 14,
                                          color: AppColors.goldLight,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          t.streakDays(f.digits(streak)),
                                          style: AppText.micro.copyWith(
                                            color: AppColors.goldLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mood,
                              style: AppText.caption.copyWith(
                                color: AppColors.onHeader.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                            ),
                            const SizedBox(height: Gap.m),
                            _EnergyBar(energy: e),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  t.versesToday(
                                    f.digits(today),
                                    f.digits(kDailyGoal),
                                  ),
                                  style: AppText.micro.copyWith(
                                    color: AppColors.goldLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  today >= kDailyGoal
                                      ? t.keepReading
                                      : t.readNow,
                                  style: AppText.caption.copyWith(
                                    color: AppColors.onHeader,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: AppColors.onHeader,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ten cells that light up one per ayah; past the goal they shimmer brighter.
class _EnergyBar extends StatelessWidget {
  const _EnergyBar({required this.energy});
  final double energy;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < kDailyGoal; i++) ...[
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: energy * kDailyGoal > i
                  ? null
                  : AppColors.onHeader.withValues(alpha: 0.12),
              gradient: energy * kDailyGoal > i
                  ? LinearGradient(
                      colors: energy >= 2
                          ? const [Color(0xFFFFF3C4), Color(0xFFFFC940)]
                          : energy >= 1
                          ? const [Color(0xFFFFE08A), Color(0xFFFFC940)]
                          : const [Color(0xFFFFD25E), Color(0xFFE2B33C)],
                    )
                  : null,
              boxShadow: energy >= 1
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFFC940).withValues(alpha: 0.45),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
        if (i < kDailyGoal - 1) const SizedBox(width: 3),
      ],
    ],
  );
}

/// A fanous (Ramadan lantern): gold frame, glass panes and a flame whose
/// light follows the reading energy.
class _LanternPainter extends CustomPainter {
  _LanternPainter({required this.energy, required this.flicker});

  final double energy;
  final double flicker;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    final cx = w / 2;
    final lit = energy.clamp(0.0, 1.0);
    const frame = Color(0xFFE2B33C);
    final framePaint = Paint()
      ..color = frame
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = frame;

    // Hanging ring and chain.
    canvas.drawCircle(Offset(cx, h * 0.04), w * 0.05, framePaint);
    canvas.drawLine(Offset(cx, h * 0.08), Offset(cx, h * 0.13), framePaint);
    // Dome cap.
    final cap = Path()
      ..moveTo(cx - w * 0.3, h * 0.27)
      ..quadraticBezierTo(cx - w * 0.28, h * 0.14, cx, h * 0.12)
      ..quadraticBezierTo(cx + w * 0.28, h * 0.14, cx + w * 0.3, h * 0.27)
      ..close();
    canvas.drawPath(cap, fill);
    // Glass body (hexagonal profile).
    final body = Path()
      ..moveTo(cx - w * 0.3, h * 0.29)
      ..lineTo(cx + w * 0.3, h * 0.29)
      ..lineTo(cx + w * 0.38, h * 0.52)
      ..lineTo(cx + w * 0.3, h * 0.8)
      ..lineTo(cx - w * 0.3, h * 0.8)
      ..lineTo(cx - w * 0.38, h * 0.52)
      ..close();
    // Glass glow – dark when empty, warm amber when full.
    final glass = Color.lerp(
      const Color(0xFF0E2724),
      const Color(0xFFFFD873),
      0.15 + 0.75 * lit,
    )!;
    canvas.drawPath(
      body,
      Paint()
        ..shader = RadialGradient(
          colors: [glass, Color.lerp(glass, const Color(0xFF0E2724), 0.55)!],
        ).createShader(Rect.fromLTWH(0, h * 0.29, w, h * 0.51)),
    );
    // Flame.
    final f = 1 + 0.06 * math.sin(flicker * 2 * math.pi * 2);
    final flameH = h * (0.1 + 0.16 * lit) * f;
    final fc = Offset(cx, h * 0.62);
    if (energy > 0) {
      canvas.drawCircle(
        fc.translate(0, -flameH * 0.3),
        flameH * (1.2 + energy * 0.5),
        Paint()
          ..color = const Color(0xFFFFE08A).withValues(alpha: 0.25 + 0.3 * lit)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 + 6 * lit),
      );
    }
    final flame = Path()
      ..moveTo(fc.dx, fc.dy - flameH)
      ..quadraticBezierTo(
        fc.dx + flameH * 0.55,
        fc.dy - flameH * 0.25,
        fc.dx,
        fc.dy + flameH * 0.15,
      )
      ..quadraticBezierTo(
        fc.dx - flameH * 0.55,
        fc.dy - flameH * 0.25,
        fc.dx,
        fc.dy - flameH,
      )
      ..close();
    canvas.drawPath(
      flame,
      Paint()
        ..color = energy == 0
            ? const Color(0xFF6B5A2A)
            : Color.lerp(
                const Color(0xFFE2932C),
                const Color(0xFFFFF3C4),
                lit,
              )!,
    );
    // Frame bars over the glass.
    canvas.drawPath(body, framePaint);
    canvas.drawLine(
      Offset(cx, h * 0.29),
      Offset(cx, h * 0.48),
      framePaint..strokeWidth = 1.2,
    );
    canvas.drawLine(
      Offset(cx - w * 0.38, h * 0.52),
      Offset(cx + w * 0.38, h * 0.52),
      framePaint,
    );
    // Base.
    final base = Path()
      ..moveTo(cx - w * 0.3, h * 0.82)
      ..lineTo(cx + w * 0.3, h * 0.82)
      ..lineTo(cx + w * 0.18, h * 0.92)
      ..lineTo(cx - w * 0.18, h * 0.92)
      ..close();
    canvas.drawPath(base, fill);
    canvas.drawCircle(Offset(cx, h * 0.96), w * 0.04, fill);
  }

  @override
  bool shouldRepaint(_LanternPainter old) =>
      old.energy != energy || old.flicker != flicker;
}

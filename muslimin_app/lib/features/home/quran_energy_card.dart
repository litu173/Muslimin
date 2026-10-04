import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/frosted_card.dart';
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
  /// One slow cycle drives the rays, the breathing glow and the motes.
  late final _t = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    _t.dispose();
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
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, e, _) => FrostedCard(
        onTap: () => ref.read(shellTabProvider.notifier).go(1),
        child: Stack(
          children: [
            // The lamp and its light spread over the left of the card.
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 150,
              // Own clip: blurred light must never spill past the card.
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(Radii.card),
                ),
                child: AnimatedBuilder(
                  animation: _t,
                  builder: (_, _) => CustomPaint(
                    painter: _MishkatPainter(
                      energy: e,
                      t: _t.value,
                      dark: AppColors.dark,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(118, Gap.l, Gap.l, Gap.l),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                t.dailyQuran,
                                style: AppText.subtitle,
                              ),
                            ),
                            if (streak > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.14),
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
                                      color: AppColors.gold,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      t.streakDays(f.digits(streak)),
                                      style: AppText.micro.copyWith(
                                        color: AppColors.gold,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mood,
                          style: AppText.caption.copyWith(
                            color: AppColors.muted,
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
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              today >= kDailyGoal ? t.keepReading : t.readNow,
                              style: AppText.caption.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 18,
                              color: AppColors.ink,
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
    );
  }
}

/// Ten cells that light up one per ayah.
class _EnergyBar extends StatelessWidget {
  const _EnergyBar({required this.energy});
  final double energy;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < kDailyGoal; i++) ...[
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: energy * kDailyGoal > i
                  ? null
                  : AppColors.ink.withValues(alpha: 0.1),
              gradient: energy * kDailyGoal > i
                  ? LinearGradient(
                      colors: energy >= 1
                          ? const [Color(0xFFE9B949), Color(0xFFC99A1E)]
                          : const [Color(0xFFD9A93A), Color(0xFFBB8907)],
                    )
                  : null,
            ),
          ),
        ),
        if (i < kDailyGoal - 1) const SizedBox(width: 3),
      ],
    ],
  );
}

/// A qindil – the hanging lamp of the masjid, recalling Ayat an-Nur ("a
/// lamp within glass, the glass as if it were a brilliant star"). Unlit
/// until you read; as you read, light rays turn slowly around it, the glass
/// breathes with light and motes of light drift upward.
class _MishkatPainter extends CustomPainter {
  _MishkatPainter({required this.energy, required this.t, required this.dark});

  final double energy;

  /// 0…1, one slow animation cycle.
  final double t;
  final bool dark;

  static const _gold = Color(0xFFD9A93A);
  static const _goldDeep = Color(0xFFA67B17);

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    // Pale light glows on the night card; on the cream card a warmer gold
    // is needed for the rays and motes to show.
    final light = dark ? const Color(0xFFFFE3A0) : const Color(0xFFEFB43A);
    final lit = energy.clamp(0.0, 1.0);
    final extra = (energy - 1).clamp(0.0, 1.0);
    final breathe = 0.5 + 0.5 * math.sin(t * 2 * math.pi * 3);
    final cx = w * 0.42;
    final lampH = h * 0.86;
    final top = h * 0.04;
    // Bowl geometry.
    final bowlTop = top + lampH * 0.42;
    final bowlBot = top + lampH * 0.86;
    final bowlW = w * 0.44;
    final c = Offset(cx, (bowlTop + bowlBot) / 2 + lampH * 0.02);

    // --- Light rays: long, soft, slowly turning (only when lit).
    if (lit > 0) {
      const rays = 14;
      final rot = t * 2 * math.pi;
      final reach = math.max(w, h) * (0.55 + 0.25 * lit + 0.15 * extra);
      for (var i = 0; i < rays; i++) {
        final a = rot + i * 2 * math.pi / rays;
        final flick = 0.75 + 0.25 * math.sin(t * 2 * math.pi * 2 + i * 1.7);
        final len = reach * flick;
        const spread = 0.07;
        final p = Path()
          ..moveTo(c.dx, c.dy)
          ..lineTo(
            c.dx + len * math.cos(a - spread),
            c.dy + len * math.sin(a - spread),
          )
          ..lineTo(
            c.dx + len * math.cos(a + spread),
            c.dy + len * math.sin(a + spread),
          )
          ..close();
        canvas.drawPath(
          p,
          Paint()
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
            ..shader = RadialGradient(
              colors: [
                light.withValues(alpha: (0.26 * lit + 0.1 * extra) * flick),
                light.withValues(alpha: 0),
              ],
            ).createShader(Rect.fromCircle(center: c, radius: len)),
        );
      }
      // Breathing halo.
      final hr = bowlW * (0.9 + 0.25 * breathe * lit + 0.3 * extra);
      canvas.drawCircle(
        c,
        hr,
        Paint()
          ..shader = RadialGradient(
            colors: [
              light.withValues(alpha: (0.32 + 0.12 * breathe) * lit),
              light.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: c, radius: hr)),
      );
    }

    final line = Paint()
      ..color = _goldDeep
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final fill = Paint()..color = _gold;

    // --- Ring and three chains to the rim.
    final ring = Offset(cx, top + 4);
    canvas.drawCircle(ring, 3.5, line);
    final rimY = bowlTop;
    final neckTop = top + lampH * 0.26;
    for (final dx in [-bowlW * 0.5, 0.0, bowlW * 0.5]) {
      final end = Offset(cx + dx * (dx == 0 ? 0 : 1), dx == 0 ? neckTop : rimY);
      canvas.drawLine(ring.translate(0, 3), end, line);
    }

    // --- Neck (flared) above the bowl.
    final neck = Path()
      ..moveTo(cx - bowlW * 0.16, neckTop)
      ..lineTo(cx + bowlW * 0.16, neckTop)
      ..quadraticBezierTo(cx + bowlW * 0.14, rimY - 2, cx + bowlW * 0.5, rimY)
      ..lineTo(cx - bowlW * 0.5, rimY)
      ..quadraticBezierTo(
        cx - bowlW * 0.14,
        rimY - 2,
        cx - bowlW * 0.16,
        neckTop,
      )
      ..close();

    // --- Bowl.
    final bowl = Path()
      ..moveTo(cx - bowlW * 0.5, rimY)
      ..lineTo(cx + bowlW * 0.5, rimY)
      ..cubicTo(
        cx + bowlW * 0.62,
        rimY + (bowlBot - rimY) * 0.45,
        cx + bowlW * 0.42,
        bowlBot,
        cx,
        bowlBot,
      )
      ..cubicTo(
        cx - bowlW * 0.42,
        bowlBot,
        cx - bowlW * 0.62,
        rimY + (bowlBot - rimY) * 0.45,
        cx - bowlW * 0.5,
        rimY,
      )
      ..close();

    final unlit = dark ? const Color(0xFF223834) : const Color(0xFFE6DCBF);
    final glow = Color.lerp(
      unlit,
      const Color(0xFFFFEBB8),
      (0.2 + 0.55 * lit + 0.12 * breathe * lit).clamp(0, 0.88),
    )!;
    final glassShader = RadialGradient(
      center: const Alignment(0, 0.25),
      radius: 0.8,
      colors: [glow, Color.lerp(glow, unlit, 0.6)!],
    ).createShader(Rect.fromLTRB(cx - bowlW, neckTop, cx + bowlW, bowlBot));
    canvas.drawPath(neck, Paint()..shader = glassShader);
    canvas.drawPath(bowl, Paint()..shader = glassShader);

    // Enamel band with dots around the bowl's shoulder.
    final bandY = rimY + (bowlBot - rimY) * 0.18;
    final band = Rect.fromLTRB(
      cx - bowlW * 0.56,
      bandY,
      cx + bowlW * 0.56,
      bandY + 5,
    );
    canvas.save();
    canvas.clipPath(bowl);
    canvas.drawRect(band, fill);
    for (var x = band.left + 4; x < band.right; x += 7) {
      canvas.drawCircle(
        Offset(x, band.center.dy),
        1,
        Paint()..color = const Color(0xFFFFF4D6),
      );
    }
    canvas.restore();

    // Star window ("as if it were a brilliant star").
    final sr = bowlW * 0.2;
    final sc = c.translate(0, 4);
    final star = Path();
    for (var i = 0; i < 16; i++) {
      final a = -math.pi / 2 + i * math.pi / 8;
      final r = i.isEven ? sr : sr * 0.72;
      final pt = Offset(sc.dx + r * math.cos(a), sc.dy + r * math.sin(a));
      i == 0 ? star.moveTo(pt.dx, pt.dy) : star.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(
      star..close(),
      Paint()
        ..color = _gold.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Flame in the star.
    if (energy > 0) {
      final fl =
          sr * (0.55 + 0.35 * lit) * (1 + 0.08 * math.sin(t * 2 * math.pi * 7));
      final flame = Path()
        ..moveTo(sc.dx, sc.dy - fl)
        ..quadraticBezierTo(
          sc.dx + fl * 0.5,
          sc.dy - fl * 0.15,
          sc.dx,
          sc.dy + fl * 0.3,
        )
        ..quadraticBezierTo(
          sc.dx - fl * 0.5,
          sc.dy - fl * 0.15,
          sc.dx,
          sc.dy - fl,
        )
        ..close();
      canvas.drawPath(
        flame,
        Paint()
          ..color = Color.lerp(
            const Color(0xFFE59A2F),
            const Color(0xFFFFF6DC),
            lit,
          )!,
      );
    } else {
      canvas.drawCircle(sc, 1.6, Paint()..color = const Color(0xFF8C7A4A));
    }

    // Outlines and foot.
    canvas.drawPath(neck, line);
    canvas.drawPath(bowl, line);
    canvas.drawLine(
      Offset(cx - bowlW * 0.5, rimY),
      Offset(cx + bowlW * 0.5, rimY),
      line..strokeWidth = 2,
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx - 5, bowlBot - 1)
        ..lineTo(cx + 5, bowlBot - 1)
        ..lineTo(cx, bowlBot + 8)
        ..close(),
      Paint()..color = _goldDeep,
    );
    canvas.drawCircle(Offset(cx, bowlBot + 10), 2, Paint()..color = _goldDeep);

    // --- Motes of light rising (more as you read more).
    if (lit > 0) {
      final motes = (5 + 10 * energy / 2).round();
      final r = math.Random(11);
      for (var i = 0; i < motes; i++) {
        final seed = r.nextDouble();
        final dx = (r.nextDouble() - 0.5) * w * 0.85;
        final size = 0.8 + r.nextDouble() * 1.6;
        final phase = (t * 4 + seed) % 1;
        final x = c.dx + dx + math.sin((phase * 2 + seed) * math.pi) * 5;
        final y = c.dy + h * 0.1 - phase * h * 0.95;
        final a = math.sin(phase * math.pi) * (0.3 + 0.4 * lit);
        canvas.drawCircle(
          Offset(x, y),
          size,
          Paint()
            ..color = light.withValues(alpha: a)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_MishkatPainter old) =>
      old.energy != energy || old.t != t || old.dark != dark;
}

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
                    painter: _QuranLightPainter(
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

/// An open Quran resting on a rehal (the crossed wooden stand, like the
/// Maktab icon). As you read, motes of light float up out of the book –
/// more of them the more you read.
class _QuranLightPainter extends CustomPainter {
  _QuranLightPainter({
    required this.energy,
    required this.t,
    required this.dark,
  });

  final double energy;

  /// 0…1, one slow animation cycle.
  final double t;
  final bool dark;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    final light = dark ? const Color(0xFFFFE3A0) : const Color(0xFFEFB43A);
    final lit = energy.clamp(0.0, 1.0);

    // Whole scene a little smaller, so the rehal sits inside the card.
    canvas.save();
    canvas.translate(w * 0.05, h * 0.02);
    canvas.scale(0.88);

    // Geometry: book centred low-left, rehal under it.
    final cx = w * 0.42;
    final bookW = w * 0.62;
    final spineTop = Offset(cx, h * 0.56);
    final spineBot = Offset(cx, h * 0.66);
    final source = spineTop.translate(0, -2); // where the light comes from

    // --- Rehal: two crossed boards (X) with a pivot pin.
    const wood = Color(0xFFB8862B);
    const woodDark = Color(0xFF8A611A);
    final boardW = w * 0.075;
    Path board(Offset a, Offset b) {
      final d = b - a;
      final n = Offset(-d.dy, d.dx) / d.distance * (boardW / 2);
      return Path()
        ..moveTo(a.dx + n.dx, a.dy + n.dy)
        ..lineTo(b.dx + n.dx, b.dy + n.dy)
        ..lineTo(b.dx - n.dx, b.dy - n.dy)
        ..lineTo(a.dx - n.dx, a.dy - n.dy)
        ..close();
    }

    final l1 = board(
      Offset(cx - bookW * 0.42, h * 0.6),
      Offset(cx + bookW * 0.34, h * 0.94),
    );
    final l2 = board(
      Offset(cx + bookW * 0.42, h * 0.6),
      Offset(cx - bookW * 0.34, h * 0.94),
    );
    final woodPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFD9A93A), wood, woodDark],
      ).createShader(Rect.fromLTWH(0, h * 0.58, w, h * 0.38));
    canvas.drawPath(l2, woodPaint);
    canvas.drawPath(
      l2,
      Paint()
        ..color = woodDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    canvas.drawPath(l1, woodPaint);
    canvas.drawPath(
      l1,
      Paint()
        ..color = woodDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    final pin = Offset(cx, h * 0.79);
    canvas.drawCircle(pin, w * 0.022, Paint()..color = const Color(0xFFFFF1CC));
    canvas.drawCircle(
      pin,
      w * 0.022,
      Paint()
        ..color = woodDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // --- Open book: green cover edges + two curved page blocks.
    const cover = Color(0xFF1F5F4E);
    final coverPath = Path()
      ..moveTo(spineBot.dx, spineBot.dy + 3)
      ..quadraticBezierTo(
        cx - bookW * 0.28,
        h * 0.62,
        cx - bookW * 0.5,
        h * 0.52,
      )
      ..lineTo(cx - bookW * 0.5, h * 0.555)
      ..quadraticBezierTo(
        cx - bookW * 0.28,
        h * 0.665,
        spineBot.dx,
        spineBot.dy + 7,
      )
      ..quadraticBezierTo(
        cx + bookW * 0.28,
        h * 0.665,
        cx + bookW * 0.5,
        h * 0.555,
      )
      ..lineTo(cx + bookW * 0.5, h * 0.52)
      ..quadraticBezierTo(
        cx + bookW * 0.28,
        h * 0.62,
        spineBot.dx,
        spineBot.dy + 3,
      )
      ..close();
    canvas.drawPath(coverPath, Paint()..color = cover);

    final pageColor = Color.lerp(
      dark ? const Color(0xFFE9DDB8) : const Color(0xFFFFF8E4),
      const Color(0xFFFFF4CF),
      lit,
    )!;
    Path pages(int side) {
      final sx = side.toDouble();
      return Path()
        ..moveTo(spineBot.dx, spineBot.dy)
        ..quadraticBezierTo(
          cx + sx * bookW * 0.26,
          h * 0.6,
          cx + sx * bookW * 0.48,
          h * 0.5,
        )
        ..lineTo(cx + sx * bookW * 0.46, h * 0.43)
        ..quadraticBezierTo(
          cx + sx * bookW * 0.24,
          h * 0.5,
          spineTop.dx,
          spineTop.dy,
        )
        ..close();
    }

    for (final side in [-1, 1]) {
      final p = pages(side);
      canvas.drawPath(
        p,
        Paint()
          ..shader =
              LinearGradient(
                begin: side < 0 ? Alignment.centerRight : Alignment.centerLeft,
                end: side < 0 ? Alignment.centerLeft : Alignment.centerRight,
                colors: [
                  pageColor,
                  Color.lerp(pageColor, const Color(0xFFD9C79A), 0.5)!,
                ],
              ).createShader(
                Rect.fromLTWH(cx - bookW / 2, h * 0.42, bookW, h * 0.26),
              ),
      );
      // Text lines on the page.
      final lines = Paint()
        ..color = const Color(0xFFB8862B).withValues(alpha: 0.45)
        ..strokeWidth = 0.9;
      for (var k = 1; k <= 4; k++) {
        final f = k / 5;
        final y0 =
            spineTop.dy + (h * 0.455 - spineTop.dy) * 0.15 + f * (h * 0.1);
        canvas.drawLine(
          Offset(cx + side * bookW * 0.07, y0 - h * 0.03 * (1 - f)),
          Offset(cx + side * bookW * 0.4, y0 - h * 0.085 * (1 - f) - h * 0.02),
          lines,
        );
      }
      canvas.drawPath(
        p,
        Paint()
          ..color = const Color(0xFFB8862B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
    // Spine highlight.
    canvas.drawLine(
      spineTop,
      spineBot,
      Paint()
        ..color = const Color(0xFFB8862B)
        ..strokeWidth = 1.2,
    );

    // --- Motes of light floating up out of the book.
    if (lit > 0) {
      final motes = (8 + 16 * energy / 2).round();
      final r = math.Random(5);
      for (var i = 0; i < motes; i++) {
        final seed = r.nextDouble();
        final drift = (r.nextDouble() - 0.5) * bookW * 1.3;
        final size = 0.8 + r.nextDouble() * 1.8;
        final speed = 3 + r.nextDouble() * 2;
        final phase = (t * speed + seed) % 1;
        // Start inside the open pages, spread out as they rise.
        final x =
            source.dx +
            (r.nextDouble() - 0.5) * bookW * 0.5 +
            drift * phase +
            math.sin((phase * 3 + seed) * math.pi) * 4;
        final y = source.dy - phase * h * 0.62;
        final a = math.sin(phase * math.pi) * (0.35 + 0.45 * lit);
        canvas.drawCircle(
          Offset(x, y),
          size * (1 - 0.4 * phase),
          Paint()
            ..color = light.withValues(alpha: a)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.1),
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_QuranLightPainter old) =>
      old.energy != energy || old.t != t || old.dark != dark;
}

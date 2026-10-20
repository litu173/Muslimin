import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/dhikr/dhikrs.dart';
import '../../data/models/prayer.dart';
import '../../l10n/app_localizations.dart';
import '../../services/prayer_time_service.dart' show WaqtStatus;
import '../../state/dhikr.dart';
import '../../state/providers.dart';

/// The salah whose dhikr is due now (0 = Fajr … 4 = Isha): the current
/// waqt, or the last one that has passed. Null before Fajr.
int? salahNow(WaqtStatus? w) {
  if (w == null) return null;
  final p = w.prayer == Prayer.jumuah ? Prayer.dhuhr : w.prayer;
  final i = PrayerX.daily.indexOf(p);
  if (w.isCurrent) return i;
  return i > 0 ? i - 1 : null;
}

String dhikrName(Fmt f, Dhikr d) => f.isBn ? d.nameBn : d.nameEn;

String _plan(L10n t, Fmt f, Dhikr d) =>
    '${t.dhikrPerDay(f.digits(d.perDay))} · '
    '${t.dhikrPerSalah(f.digits(d.perSalah))}';

/// Home: "Daily Dhikr" with today's card. "View All" opens the list.
class DhikrSection extends StatelessWidget {
  const DhikrSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    void open() => push(context, const DhikrScreen());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: t.dhikrTitle,
          subtitle: t.dhikrSub,
          action: t.viewAll,
          onAction: open,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.l),
          child: DhikrTodayCard(onTap: open),
        ),
      ],
    );
  }
}

/// Today at a glance: a ring for the day's parts and one mark per salah.
/// Three looks – not started (gold call to start), on the way, and done
/// for today (green). With [onSalah] the salah marks can be tapped.
class DhikrTodayCard extends ConsumerWidget {
  const DhikrTodayCard({super.key, this.onTap, this.onSalah});

  final VoidCallback? onTap;
  final void Function(int salah, bool done)? onSalah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final p = ref.watch(dhikrProgressProvider);
    final now = salahNow(ref.watch(waqtProvider));
    final day = dhikrDay(DateTime.now());
    final done = p.portionsOn(day);
    final total = DhikrProgress.portionsPerDay;
    final finished = p.fullDay(day);
    final started = done > 0;
    final streak = p.streak;
    final accent = finished ? AppColors.success : AppColors.gold;

    final (title, line) = finished
        ? (t.dhikrDoneToday, t.dhikrDoneTodaySub)
        : started
        ? (
            t.dhikrPartsDone(f.digits(done), f.digits(total)),
            t.dhikrCountToday(f.digits(p.countToday)),
          )
        : (t.dhikrNotStarted, t.dhikrNotStartedHint);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: finished
            ? Color.alphaBlend(
                AppColors.success.withValues(alpha: 0.10),
                AppColors.card,
              )
            : AppColors.card,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(
          color: finished
              ? AppColors.success.withValues(alpha: 0.5)
              : started
              ? Colors.transparent
              : AppColors.gold.withValues(alpha: 0.55),
          width: 1.2,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    DhikrRing(
                      value: done / total,
                      color: accent,
                      size: 56,
                      child: Icon(
                        finished ? Icons.check_rounded : Icons.spa_rounded,
                        color: accent,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: Gap.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppText.label.copyWith(
                              color: finished ? AppColors.success : null,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            line,
                            style: AppText.caption.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (streak > 0) ...[
                      const SizedBox(width: Gap.s),
                      _StreakPill(days: streak, color: accent),
                    ] else if (!started && onTap != null) ...[
                      const SizedBox(width: Gap.s),
                      Icon(Icons.chevron_right_rounded, color: AppColors.gold),
                    ],
                  ],
                ),
                const SizedBox(height: Gap.l),
                Row(
                  children: [
                    for (var i = 0; i < kPortions; i++)
                      Expanded(
                        child: _SalahMark(
                          label: f.prayer(PrayerX.daily[i]),
                          done: p.salahDone(day, i),
                          // Some dhikr of this salah done, not all.
                          partial:
                              !p.salahDone(day, i) &&
                              kDhikrs.any(
                                (d) => p.mask(day, d.id) & (1 << i) != 0,
                              ),
                          now: i == now && !finished,
                          color: accent,
                          onTap: onSalah == null
                              ? null
                              : () => onSalah!(i, !p.salahDone(day, i)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StreakPill extends StatelessWidget {
  const _StreakPill({required this.days, required this.color});

  final int days;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_rounded, size: 14, color: color),
          const SizedBox(width: 3),
          Text(
            t.streakDays(f.digits(days)),
            style: AppText.micro.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// One salah under the card: a circle (ticked when its part is done) and
/// the salah's name. The salah due now gets a gold ring.
class _SalahMark extends StatelessWidget {
  const _SalahMark({
    required this.label,
    required this.done,
    required this.partial,
    required this.now,
    required this.color,
    this.onTap,
  });

  final String label;
  final bool done;
  final bool partial;
  final bool now;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mark = Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? color
                : partial
                ? color.withValues(alpha: 0.18)
                : AppColors.pill,
            border: Border.all(
              color: now ? AppColors.gold : Colors.transparent,
              width: 2,
            ),
          ),
          child: done
              ? Icon(Icons.check_rounded, size: 18, color: AppColors.onGold)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.micro.copyWith(
            color: now || done ? AppColors.ink : AppColors.muted,
            fontWeight: now ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
    if (onTap == null) return mark;
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.button),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: mark,
      ),
    );
  }
}

/// A progress ring around an icon (0…1).
class DhikrRing extends StatelessWidget {
  const DhikrRing({
    super.key,
    required this.value,
    required this.color,
    required this.child,
    this.size = 48,
  });

  final double value;
  final Color color;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: value),
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOutCubic,
    builder: (_, v, child) => CustomPaint(
      painter: _RingPainter(v, color, color.withValues(alpha: 0.14)),
      child: SizedBox.square(
        dimension: size,
        child: Center(child: child),
      ),
    ),
    child: child,
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color, this.track);

  final double value;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size s) {
    final rect = (Offset.zero & s).deflate(3);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, p..color = track);
    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * value.clamp(0.0, 1.0),
        false,
        p..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color;
}

/// Five small dots: which of a dhikr's portions are done today.
class _PortionDots extends StatelessWidget {
  const _PortionDots({required this.mask, required this.color});

  final int mask;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < kPortions; i++)
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsetsDirectional.only(end: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: mask & (1 << i) != 0 ? color : AppColors.divider,
          ),
        ),
    ],
  );
}

// ------------------------------------------------------------------- list
/// Every daily dhikr, each with its target and today's portions.
class DhikrScreen extends ConsumerWidget {
  const DhikrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final p = ref.watch(dhikrProgressProvider);
    final notifier = ref.read(dhikrProgressProvider.notifier);
    return Scaffold(
      body: Column(
        children: [
          PageHeader(title: t.dhikrTitle, subtitle: t.dhikrSub, back: true),
          Expanded(
            child: RefreshList(
              onRefresh: () =>
                  Future<void>.delayed(const Duration(milliseconds: 500)),
              padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.xxl),
              children: [
                Text(
                  t.dhikrIntro,
                  style: AppText.body.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: Gap.l),
                DhikrTodayCard(onSalah: notifier.setSalah),
                Padding(
                  padding: const EdgeInsets.only(top: Gap.s, left: 4),
                  child: Text(
                    t.dhikrTapSalah,
                    style: AppText.micro.copyWith(color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: Gap.l),
                for (final d in kDhikrs) ...[
                  _DhikrTile(dhikr: d, mask: p.maskToday(d.id)),
                  const SizedBox(height: Gap.m),
                ],
                const SizedBox(height: Gap.s),
                Text(
                  t.dhikrCredit(f.digits(DhikrProgress.portionsPerDay)),
                  textAlign: TextAlign.center,
                  style: AppText.micro.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DhikrTile extends StatelessWidget {
  const _DhikrTile({required this.dhikr, required this.mask});

  final Dhikr dhikr;
  final int mask;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final done = mask == kAllPortions;
    final color = done ? AppColors.success : AppColors.gold;
    return AppCard(
      onTap: () => push(context, DhikrDetailScreen(dhikr: dhikr)),
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.m, Gap.m),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(
              done ? Icons.check_rounded : Icons.spa_outlined,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: Gap.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dhikrName(f, dhikr), style: AppText.label),
                Text(
                  _plan(t, f, dhikr),
                  style: AppText.micro.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 6),
                _PortionDots(mask: mask, color: color),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------- detail
/// One dhikr: its words and virtue, and today's plan – the day's target
/// split evenly over the five salah, each part marked done on its own or
/// all at once.
class DhikrDetailScreen extends ConsumerWidget {
  const DhikrDetailScreen({super.key, required this.dhikr});

  final Dhikr dhikr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final d = dhikr;
    final mask = ref.watch(
      dhikrProgressProvider.select((p) => p.maskToday(d.id)),
    );
    final notifier = ref.read(dhikrProgressProvider.notifier);
    final now = salahNow(ref.watch(waqtProvider));
    final all = mask == kAllPortions;
    final parts = DhikrProgress.bits(mask);
    // Bangla and English are written for the app; other languages show
    // English (Arabic: the dhikr itself only), like the duas.
    final meaning = f.isBn ? d.bn : (f.lang == 'ar' ? '' : d.en);
    final virtue = f.isBn ? d.virtueBn : d.virtueEn;
    final split = f.isBn ? d.splitBn : d.splitEn;

    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: dhikrName(f, d),
            subtitle: _plan(t, f, d),
            back: true,
          ),
          Expanded(
            child: RefreshList(
              onRefresh: () =>
                  Future<void>.delayed(const Duration(milliseconds: 500)),
              padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.xxl),
              children: [
                // ---- the words
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        d.ar,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: AppText.arabic,
                          fontSize: 24,
                          height: 2,
                          color: AppColors.ink,
                        ),
                      ),
                      if (!f.isBn && f.lang != 'ar') ...[
                        const SizedBox(height: Gap.s),
                        Text(
                          d.tr,
                          textDirection: TextDirection.ltr,
                          style: AppText.caption.copyWith(
                            color: AppColors.gold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (meaning.isNotEmpty) ...[
                        const SizedBox(height: Gap.s),
                        Text(
                          meaning,
                          textDirection: f.isBn || f.lang == 'en'
                              ? null
                              : TextDirection.ltr,
                          style: AppText.body.copyWith(height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: Gap.m),
                // ---- why
                AppCard(
                  color: Color.alphaBlend(
                    AppColors.gold.withValues(alpha: 0.10),
                    AppColors.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 18,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            t.dhikrVirtue,
                            style: AppText.label.copyWith(
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Gap.s),
                      Text(
                        virtue,
                        textDirection: f.isBn || f.lang == 'en'
                            ? null
                            : TextDirection.ltr,
                        style: AppText.body.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: Gap.s),
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 14,
                            color: AppColors.muted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              f.isBn ? d.refBn : d.refEn,
                              style: AppText.micro.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ---- today's plan
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, Gap.xl, 4, Gap.s),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(t.dhikrPlan, style: AppText.subtitle),
                      ),
                      Text(
                        t.dhikrPartsDone(f.digits(parts), f.digits(kPortions)),
                        style: AppText.caption.copyWith(
                          color: all ? AppColors.success : AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, Gap.m),
                  child: Text(
                    t.dhikrPlanBody(f.digits(d.perDay), f.digits(d.perSalah)),
                    style: AppText.caption.copyWith(color: AppColors.muted),
                  ),
                ),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: Gap.xs),
                  child: Column(
                    children: [
                      for (var i = 0; i < kPortions; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            indent: Gap.l,
                            endIndent: Gap.l,
                            color: AppColors.divider,
                          ),
                        _PortionRow(
                          salah: f.prayer(PrayerX.daily[i]),
                          count: f.digits(d.perSalah),
                          split: split,
                          done: mask & (1 << i) != 0,
                          now: i == now,
                          onTap: () => notifier.toggle(d.id, i),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: Gap.l),
                if (all)
                  Container(
                    padding: const EdgeInsets.all(Gap.m),
                    margin: const EdgeInsets.only(bottom: Gap.m),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(Radii.card),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: Gap.s),
                        Expanded(
                          child: Text(
                            t.dhikrOneDone(f.digits(d.perDay)),
                            style: AppText.label.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                AppButton(
                  all ? t.dhikrClearToday : t.dhikrMarkAll,
                  icon: all ? Icons.undo_rounded : Icons.done_all_rounded,
                  style: all ? AppButtonStyle.outlined : AppButtonStyle.filled,
                  expand: true,
                  onPressed: () => notifier.setAll(d.id, !all),
                ),
                const SizedBox(height: Gap.s),
                Text(
                  t.dhikrMarkAllHint,
                  textAlign: TextAlign.center,
                  style: AppText.micro.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "After Fajr · 20×" with a check to mark the part done.
class _PortionRow extends StatelessWidget {
  const _PortionRow({
    required this.salah,
    required this.count,
    required this.split,
    required this.done,
    required this.now,
    required this.onTap,
  });

  final String salah;
  final String count;
  final String? split;
  final bool done;
  final bool now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.m, Gap.m),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          t.dhikrAfterSalah(salah),
                          style: AppText.label,
                        ),
                      ),
                      if (now) ...[
                        const SizedBox(width: Gap.s),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.goldLight,
                            borderRadius: BorderRadius.circular(Radii.pill),
                          ),
                          child: Text(
                            t.nowLabel,
                            style: AppText.micro.copyWith(
                              color: AppColors.inkDeep,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    split == null
                        ? t.repeatTimes(count)
                        : '${t.repeatTimes(count)} · $split',
                    style: AppText.caption.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? AppColors.success : Colors.transparent,
                border: Border.all(
                  color: done ? AppColors.success : AppColors.divider,
                  width: 2,
                ),
              ),
              child: done
                  ? Icon(Icons.check_rounded, size: 18, color: AppColors.onGold)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

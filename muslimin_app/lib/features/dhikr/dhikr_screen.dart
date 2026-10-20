import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

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

String _plan(L10n t, Fmt f, Dhikr d) => d.afterSalah
    ? t.dhikrPerSalah(f.digits(d.perSalah))
    : '${t.dhikrPerDay(f.digits(d.perDay))} · '
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
    this.stroke = 4,
  });

  final double value;
  final Color color;
  final Widget child;
  final double size;
  final double stroke;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: value),
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOutCubic,
    builder: (_, v, child) => CustomPaint(
      painter: _RingPainter(v, color, color.withValues(alpha: 0.14), stroke),
      child: SizedBox.square(
        dimension: size,
        child: Center(child: child),
      ),
    ),
    child: child,
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color, this.track, this.stroke);

  final double value;
  final Color color;
  final Color track;
  final double stroke;

  @override
  void paint(Canvas canvas, Size s) {
    final rect = (Offset.zero & s).deflate(stroke / 2 + 1);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
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
/// Every dhikr in two groups – the daily targets, then after every salah –
/// each with today's five salah marks. The card on top only shows the
/// day's status; salah are checked off inside each dhikr.
class DhikrScreen extends ConsumerWidget {
  const DhikrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final p = ref.watch(dhikrProgressProvider);

    List<Widget> group(String title, String sub, bool afterSalah) => [
      Padding(
        padding: const EdgeInsets.fromLTRB(4, Gap.xl, 4, Gap.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.subtitle),
            const SizedBox(height: 2),
            Text(sub, style: AppText.caption.copyWith(color: AppColors.muted)),
          ],
        ),
      ),
      for (final d in kDhikrs)
        if (d.afterSalah == afterSalah) ...[
          _DhikrTile(dhikr: d, mask: p.maskToday(d.id)),
          const SizedBox(height: Gap.m),
        ],
    ];

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
                // Status only: each salah is checked off in its dhikr.
                const DhikrTodayCard(),
                ...group(t.dhikrDailyTitle, t.dhikrDailySub, false),
                ...group(t.dhikrAfterSalahTitle, t.dhikrAfterSalahSub, true),
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
      onTap: () => push(context, DhikrCounterScreen(dhikr: dhikr)),
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
            child: done
                ? Icon(Icons.check_rounded, color: color, size: 22)
                : Center(
                    child: Text(
                      f.digits(dhikr.perSalah),
                      style: AppText.label.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

// ---------------------------------------------------------------- counter
/// One dhikr as a tasbih counter: the words on top, a big ring with the
/// count in the middle – a tap anywhere around it counts one – and the five
/// salah below. A finished round checks off its salah; each salah can also
/// be checked by hand. Daily targets can be marked done all at once;
/// after-salah adhkar cannot (they belong after each salah).
class DhikrCounterScreen extends ConsumerStatefulWidget {
  const DhikrCounterScreen({super.key, required this.dhikr});

  final Dhikr dhikr;

  @override
  ConsumerState<DhikrCounterScreen> createState() => _DhikrCounterState();
}

class _DhikrCounterState extends ConsumerState<DhikrCounterScreen> {
  int _count = 0;

  /// The salah this round counts for (fixed once counting starts).
  int? _salah;

  /// The round has just been finished: the ring shows a tick until the
  /// next tap starts a new round.
  bool _finished = false;

  Dhikr get _d => widget.dhikr;

  /// Hisn al-Muslim's recitation, made on first play.
  AudioPlayer? _player;
  bool _playing = false;

  Future<void> _play() async {
    final player = _player ??= AudioPlayer()
      ..playerStateStream.listen((s) {
        if (s.processingState == ProcessingState.completed && mounted) {
          setState(() => _playing = false);
        }
      });
    if (_playing) {
      setState(() => _playing = false);
      await player.stop();
      return;
    }
    setState(() => _playing = true);
    try {
      await player.setUrl(_d.audio);
      await player.seek(Duration.zero);
      await player.play();
    } catch (_) {
      if (mounted) setState(() => _playing = false);
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  int get _mask => ref.read(dhikrProgressProvider).maskToday(widget.dhikr.id);

  /// The salah due now if it is still open, else the latest earlier open
  /// one, else a later one. Null when all five are done.
  int? _open(int mask) {
    final now = salahNow(ref.read(waqtProvider)) ?? 0;
    final order = [
      for (var i = now; i >= 0; i--) i,
      for (var i = now + 1; i < kPortions; i++) i,
    ];
    for (final i in order) {
      if (mask & (1 << i) == 0) return i;
    }
    return null;
  }

  void _tap() {
    // Only once the page is fully open and on top: the touch that opened
    // it, or one on a sheet above it, never counts.
    final route = ModalRoute.of(context);
    if (route != null &&
        (!route.isCurrent || !(route.animation?.isCompleted ?? true))) {
      return;
    }
    setState(() {
      if (_finished) {
        _finished = false;
        _count = 0;
        _salah = null;
      }
      if (_count == 0) _salah = _open(_mask);
      _count++;
      final s = _salah;
      if (s != null && _count >= _d.perSalah) {
        _finished = true;
        ref.read(dhikrProgressProvider.notifier).setPortion(_d.id, s, true);
      }
    });
    _finished ? HapticFeedback.heavyImpact() : HapticFeedback.selectionClick();
  }

  void _reset() => setState(() {
    _count = 0;
    _salah = null;
    _finished = false;
  });

  void _virtue() {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      builder: (ctx) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radii.sheet),
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          Gap.xl,
          Gap.m,
          Gap.xl,
          Gap.xxl + MediaQuery.paddingOf(ctx).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: Gap.l),
                decoration: BoxDecoration(
                  color: AppColors.muted.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
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
                  style: AppText.label.copyWith(color: AppColors.gold),
                ),
              ],
            ),
            const SizedBox(height: Gap.s),
            Text(
              f.isBn ? _d.virtueBn : _d.virtueEn,
              textDirection: f.isBn || f.lang == 'en'
                  ? null
                  : TextDirection.ltr,
              style: AppText.body.copyWith(height: 1.5),
            ),
            const SizedBox(height: Gap.m),
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
                    f.isBn ? _d.refBn : _d.refEn,
                    style: AppText.micro.copyWith(color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final d = _d;
    final mask = ref.watch(
      dhikrProgressProvider.select((p) => p.maskToday(d.id)),
    );
    ref.watch(waqtProvider);
    final notifier = ref.read(dhikrProgressProvider.notifier);
    // Before counting starts, the round goes to the open salah due now.
    final salah = _count == 0 && !_finished ? _open(mask) : _salah;
    final allDone = mask == kAllPortions;
    final green = _finished || (allDone && salah == null);
    final accent = green ? AppColors.success : AppColors.gold;
    String salahName(int i) => f.prayer(PrayerX.daily[i]);
    // Bangla and English are written for the app; other languages show
    // English (Arabic: the dhikr itself only), like the duas.
    final meaning = f.isBn ? d.bn : (f.lang == 'ar' ? '' : d.en);

    final label = _finished
        ? t.dhikrRoundDone(salahName(_salah!))
        : salah != null
        ? t.dhikrAfterSalah(salahName(salah))
        : t.dhikrAllSalahDone;

    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: dhikrName(f, d),
            subtitle: _plan(t, f, d),
            back: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: t.dhikrReset,
                  onPressed: _count == 0 ? null : _reset,
                  icon: const Icon(Icons.restart_alt_rounded),
                  color: AppColors.onHeader,
                  disabledColor: AppColors.onHeader.withValues(alpha: 0.35),
                ),
                IconButton(
                  tooltip: t.dhikrVirtue,
                  onPressed: _virtue,
                  icon: const Icon(Icons.info_outline_rounded),
                  color: AppColors.onHeader,
                ),
              ],
            ),
          ),
          // ---- the words (long ones scroll)
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, 0),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.26,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(44, Gap.l, 44, Gap.l),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            d.ar,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: AppText.arabic,
                              fontSize: d.ar.length > 60 ? 22 : 30,
                              height: 1.9,
                              color: AppColors.ink,
                            ),
                          ),
                          if (!f.isBn && f.lang != 'ar') ...[
                            const SizedBox(height: Gap.xs),
                            Text(
                              d.tr,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: AppText.caption.copyWith(
                                color: AppColors.gold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (meaning.isNotEmpty) ...[
                            const SizedBox(height: Gap.xs),
                            Text(
                              meaning,
                              textAlign: TextAlign.center,
                              textDirection: f.isBn || f.lang == 'en'
                                  ? null
                                  : TextDirection.ltr,
                              style: AppText.caption.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Listen: the recitation from Hisn al-Muslim.
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      tooltip: t.dhikrListen,
                      onPressed: _play,
                      icon: Icon(
                        _playing
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline_rounded,
                        color: AppColors.gold,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ---- the counter: a tap anywhere here counts one
          Expanded(
            // Raw pointer downs: every touch counts at once, however fast
            // (a tap recognizer can drop quick taps in a row).
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (_) => _tap(),
              // Full width: a tap beside the ring counts too.
              child: SizedBox(
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, c) {
                    final size = [
                      c.maxWidth * 0.68,
                      c.maxHeight - 76,
                      280.0,
                    ].reduce(math.min).clamp(120.0, 280.0);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: AppText.label.copyWith(
                            color: green ? AppColors.success : AppColors.ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: Gap.s),
                        DhikrRing(
                          value: salah == null && !_finished
                              ? 1
                              : _count / d.perSalah,
                          color: accent,
                          size: size,
                          stroke: 10,
                          child: Container(
                            width: size - 36,
                            height: size - 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent.withValues(alpha: 0.08),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_finished)
                                  Icon(
                                    Icons.check_rounded,
                                    color: accent,
                                    size: size * 0.32,
                                  )
                                else
                                  Text(
                                    f.digits(_count),
                                    style: AppText.headline.copyWith(
                                      fontSize: size * 0.28,
                                      height: 1.1,
                                      color: AppColors.ink,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                if (!_finished && salah != null)
                                  Text(
                                    t.dhikrOfTarget(f.digits(d.perSalah)),
                                    style: AppText.caption.copyWith(
                                      color: AppColors.muted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: Gap.s),
                        Text(
                          t.dhikrTapToCount,
                          style: AppText.micro.copyWith(color: AppColors.muted),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          // ---- today's five salah
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    padding: const EdgeInsets.fromLTRB(
                      Gap.s,
                      Gap.m,
                      Gap.s,
                      Gap.m,
                    ),
                    child: Column(
                      children: [
                        Text(
                          t.dhikrCheckSalah,
                          style: AppText.micro.copyWith(color: AppColors.muted),
                        ),
                        const SizedBox(height: Gap.s),
                        Row(
                          children: [
                            for (var i = 0; i < kPortions; i++)
                              Expanded(
                                child: _SalahMark(
                                  label: salahName(i),
                                  done: mask & (1 << i) != 0,
                                  partial: false,
                                  now: i == salah && !_finished,
                                  color: AppColors.success,
                                  onTap: () {
                                    if (i == _salah) _reset();
                                    notifier.toggle(d.id, i);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!d.afterSalah) ...[
                    const SizedBox(height: Gap.m),
                    AppButton(
                      allDone ? t.dhikrClearToday : t.dhikrMarkAll,
                      icon: allDone
                          ? Icons.undo_rounded
                          : Icons.done_all_rounded,
                      style: allDone
                          ? AppButtonStyle.outlined
                          : AppButtonStyle.filled,
                      expand: true,
                      onPressed: () {
                        _reset();
                        notifier.setAll(d.id, !allDone);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

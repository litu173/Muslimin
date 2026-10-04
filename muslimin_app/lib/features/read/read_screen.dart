import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/countdown_ring.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/refresh.dart';
import '../../data/quran/surahs.dart';
import '../../l10n/app_localizations.dart';
import '../../state/quran.dart';
import 'quiz_screen.dart';
import 'read_widgets.dart';
import 'surah_screen.dart';

/// Quran tab: recommended surahs, then the whole Quran in Mushaf order
/// (1 → 114) as a journey in phases, each ending with an optional quiz.
/// Every surah is open to read.
class ReadScreen extends ConsumerStatefulWidget {
  const ReadScreen({super.key});

  @override
  ConsumerState<ReadScreen> createState() => _ReadScreenState();
}

/// One row of the journey list.
sealed class _Item {}

class _PhaseItem extends _Item {
  _PhaseItem(this.phase);
  final QuranPhase phase;
}

class _SurahItem extends _Item {
  _SurahItem(this.surah, this.step);
  final Surah surah;

  /// Position on the winding path (all nodes, quizzes included).
  final int step;
}

class _QuizItem extends _Item {
  _QuizItem(this.phase, this.step);
  final QuranPhase phase;
  final int step;
}

final List<_Item> _items = () {
  final out = <_Item>[];
  var step = 0;
  for (final p in kPhases) {
    out.add(_PhaseItem(p));
    for (final s in p.surahs) {
      out.add(_SurahItem(s, step++));
    }
    out.add(_QuizItem(p, step++));
  }
  return out;
}();

/// Horizontal position (-1 … 1) of a node on the winding path.
double _wave(int step) => math.sin(step * math.pi / 3.2) * 0.62;

class _ReadScreenState extends ConsumerState<ReadScreen> {
  final _currentKey = GlobalKey();
  bool _scrolled = false;

  void _scrollToCurrent() {
    final ctx = _currentKey.currentContext;
    if (ctx == null) return;
    // Only scrolls when the current surah is off screen.
    Scrollable.ensureVisible(
      ctx,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void _open(Surah s, {int? ayah}) => push(
    context,
    SurahScreen(surah: s, startAyah: ayah),
  ).then((_) => _scrolled = false);

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(quranProgressProvider);
    if (!_scrolled) {
      _scrolled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
    }
    // Header stays fixed; the journey scrolls underneath it.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            _Header(progress: progress, onContinue: _open),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  PullToRefresh(
                    onRefresh: () async {
                      ref.invalidate(quranProgressProvider);
                      await Future<void>.delayed(
                        const Duration(milliseconds: 600),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: _SpecialSurahs(onOpen: (s, a) => _open(s, ayah: a)),
                  ),
                  const SliverToBoxAdapter(child: _RevelationLegend()),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 120),
                    sliver: SliverList.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, i) => switch (_items[i]) {
                        _PhaseItem(:final phase) => _PhaseHeader(
                          phase: phase,
                          progress: progress,
                        ),
                        _SurahItem(:final surah, :final step) => _SurahNode(
                          key: surah.id == progress.current?.id
                              ? _currentKey
                              : null,
                          surah: surah,
                          step: step,
                          progress: progress,
                          onOpen: () => _open(surah),
                        ),
                        _QuizItem(:final phase, :final step) => _QuizNode(
                          phase: phase,
                          step: step,
                          progress: progress,
                        ),
                      },
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

class _Header extends StatelessWidget {
  const _Header({required this.progress, required this.onContinue});

  final QuranProgress progress;
  final void Function(Surah) onContinue;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final done = progress.completed.length;
    final phases = kPhases.where(progress.phaseDone).length;
    final next = progress.current;
    final resume = progress.lastSurah != null && next?.id == progress.lastSurah;
    return IslamicPattern(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Gap.xl,
          MediaQuery.of(context).padding.top + Gap.s,
          Gap.xl,
          Gap.l,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.readQuran,
              style: AppText.headline.copyWith(color: AppColors.onHeader),
            ),
            const SizedBox(height: 2),
            Text(
              t.journeySub,
              style: AppText.caption.copyWith(
                color: AppColors.onHeader.withValues(alpha: 0.75),
              ),
            ),
            ...[
              const SizedBox(height: Gap.m),
              Row(
                children: [
                  CountdownRing(
                    size: 76,
                    progress: done / 114,
                    child: Text(
                      '${f.digits((done * 100 / 114).round())}%',
                      style: AppText.subtitle.copyWith(
                        color: AppColors.goldLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: Gap.xl),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.surahsProgress(f.digits(done)),
                          style: AppText.label.copyWith(
                            color: AppColors.onHeader,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _Stat(f.digits(progress.versesRead), t.versesRead),
                        _Stat(f.digits(phases), t.phasesDone),
                      ],
                    ),
                  ),
                ],
              ),
              if (next != null) ...[
                const SizedBox(height: Gap.m),
                AppButton(
                  resume
                      ? '${t.continueReading} · ${next.name(f.isBn)} · ${t.ayahOf(f.digits(progress.lastAyah), f.digits(next.verses))}'
                      : '${t.startReading} · ${next.name(f.isBn)}',
                  icon: Icons.menu_book_rounded,
                  expand: true,
                  onPressed: () => onContinue(next),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// Surahs the Sunnah encourages reading at particular times; the one that
/// fits right now (Friday, night, morning/evening) is highlighted.
class _SpecialSurahs extends StatelessWidget {
  const _SpecialSurahs({required this.onOpen});

  final void Function(Surah surah, int? ayah) onOpen;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final now = DateTime.now();
    final night = now.hour >= 18 || now.hour < 4;
    final friday = now.weekday == DateTime.friday;
    final dayParts =
        (now.hour >= 4 && now.hour < 11) || (now.hour >= 15 && now.hour < 19);
    // (name, when, surah, start ayah, icon, highlight label)
    final chips = <(String, String, int, int?, IconData, String?)>[
      (
        t.chipKahf,
        t.chipKahfWhen,
        18,
        null,
        Icons.wb_sunny_outlined,
        friday ? t.chipToday : null,
      ),
      (
        t.chipMulk,
        t.chipMulkWhen,
        67,
        null,
        Icons.nights_stay_outlined,
        night ? t.chipTonight : null,
      ),
      (
        t.chipSajdah,
        t.chipMulkWhen,
        32,
        null,
        Icons.bedtime_outlined,
        night ? t.chipTonight : null,
      ),
      (t.chipKursi, t.chipKursiWhen, 2, 255, Icons.shield_outlined, null),
      (
        t.chipBaqarahEnd,
        t.chipNight,
        2,
        285,
        Icons.auto_awesome_outlined,
        night ? t.chipTonight : null,
      ),
      (
        t.chipQuls,
        t.chipQulsWhen,
        112,
        null,
        Icons.brightness_6_outlined,
        dayParts ? t.chipToday : null,
      ),
      (
        t.chipYasin,
        t.chipAnytime,
        36,
        null,
        Icons.favorite_border_rounded,
        null,
      ),
    ]..sort((a, b) => (a.$6 == null ? 1 : 0) - (b.$6 == null ? 1 : 0));
    return Padding(
      padding: const EdgeInsets.only(top: Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.l),
            child: Text(t.specialSurahs, style: AppText.label),
          ),
          const SizedBox(height: Gap.s),
          SizedBox(
            height: 74,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Gap.l),
              itemCount: chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: Gap.s),
              itemBuilder: (_, i) {
                final c = chips[i];
                final hot = c.$6 != null;
                return Material(
                  color: hot
                      ? Color.alphaBlend(
                          AppColors.gold.withValues(alpha: 0.12),
                          AppColors.card,
                        )
                      : AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.card),
                    side: BorderSide(
                      color: hot ? AppColors.gold : AppColors.divider,
                      width: hot ? 1.4 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.card),
                    onTap: () => onOpen(kSurahs[c.$3 - 1], c.$4),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gold.withValues(alpha: 0.12),
                            ),
                            child: Icon(c.$5, color: AppColors.gold, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(c.$1, style: AppText.label),
                                  if (hot) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.gold,
                                        borderRadius: BorderRadius.circular(
                                          Radii.pill,
                                        ),
                                      ),
                                      child: Text(
                                        c.$6!,
                                        style: AppText.micro.copyWith(
                                          color: AppColors.onGold,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                c.$2,
                                style: AppText.micro.copyWith(
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Key for the Makkah / Madinah emblems on the journey.
class _RevelationLegend extends StatelessWidget {
  const _RevelationLegend();

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    Widget item(bool makki, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RevelationIcon(makki: makki, size: 18),
        const SizedBox(width: 6),
        Text(label, style: AppText.micro.copyWith(color: AppColors.muted)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, 0),
      child: Wrap(
        spacing: Gap.l,
        runSpacing: Gap.s,
        children: [
          item(true, t.revealedMakkah),
          item(false, t.revealedMadinah),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: '$value ',
          style: TextStyle(
            color: AppColors.goldLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(text: label),
      ],
    ),
    style: AppText.caption.copyWith(
      color: AppColors.onHeader.withValues(alpha: 0.8),
    ),
  );
}

class _PhaseHeader extends StatelessWidget {
  const _PhaseHeader({required this.phase, required this.progress});

  final QuranPhase phase;
  final QuranProgress progress;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final read = phase.surahs.where((s) => progress.completed.contains(s.id));
    return Opacity(
      opacity: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xxl, Gap.xl, Gap.s),
        child: Row(
          children: [
            Text(
              t.phaseN(f.digits(phase.index + 1)).toUpperCase(),
              style: AppText.caption.copyWith(
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(width: Gap.s),
            Expanded(
              child: Divider(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            const SizedBox(width: Gap.s),
            Text(
              '${f.digits(read.length)}/${f.digits(phase.surahs.length)} · ${t.versesN(f.digits(phase.verses))}',
              style: AppText.micro.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lays a node at its spot on the winding path, with the dotted connector
/// from the previous node and the label on the open side.
class _PathRow extends StatelessWidget {
  const _PathRow({
    required this.step,
    required this.node,
    required this.label,
    required this.lineColor,
    this.height = 132,
    this.nodeSize = 84,
  });

  final int step;
  final Widget node;
  final Widget label;
  final Color lineColor;
  final double height;
  final double nodeSize;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final w = c.maxWidth;
      final amp = (w - nodeSize) / 2 - Gap.xl;
      double xOf(int s) => w / 2 + _wave(s) * amp;
      final x = xOf(step);
      final prevX = xOf(step - 1);
      // Label beside the node, on the side with more room.
      final labelOnRight = x < w / 2 + 1;
      return SizedBox(
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (step > 0)
              Positioned.fill(
                bottom: height - 30,
                child: CustomPaint(
                  painter: DottedConnector(
                    fromX: prevX,
                    toX: x,
                    color: lineColor,
                  ),
                ),
              ),
            Positioned(
              left: x - nodeSize / 2,
              top: 30,
              width: nodeSize,
              height: nodeSize + 8,
              child: node,
            ),
            // Label vertically centred on the node, any height.
            Positioned(
              top: 30 + nodeSize / 2,
              left: labelOnRight ? x + nodeSize / 2 + Gap.m : Gap.l,
              right: labelOnRight ? Gap.l : w - (x - nodeSize / 2 - Gap.m),
              child: FractionalTranslation(
                translation: const Offset(0, -0.5),
                child: Align(
                  alignment: labelOnRight
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: label,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _SurahNode extends StatefulWidget {
  const _SurahNode({
    super.key,
    required this.surah,
    required this.step,
    required this.progress,
    required this.onOpen,
  });

  final Surah surah;
  final int step;
  final QuranProgress progress;
  final VoidCallback onOpen;

  @override
  State<_SurahNode> createState() => _SurahNodeState();
}

class _SurahNodeState extends State<_SurahNode>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  bool get _current => widget.progress.current?.id == widget.surah.id;

  @override
  void initState() {
    super.initState();
    if (_current) _pulse.repeat();
  }

  @override
  void didUpdateWidget(_SurahNode old) {
    super.didUpdateWidget(old);
    if (_current && !_pulse.isAnimating) _pulse.repeat();
    if (!_current && _pulse.isAnimating) _pulse.stop();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final s = widget.surah;
    final p = widget.progress;
    final done = p.completed.contains(s.id);
    final current = _current;

    final status = done
        ? t.completed
        : p.lastSurah == s.id
        ? t.ayahOf(f.digits(p.lastAyah), f.digits(s.verses))
        : t.versesN(f.digits(s.verses));

    final node = GestureDetector(
      onTap: widget.onOpen,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, child) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (current)
              Transform.scale(
                scale: 1 + 0.28 * _pulse.value,
                child: Opacity(
                  opacity: (1 - _pulse.value) * 0.6,
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: StarShapeBorder(
                        side: BorderSide(color: AppColors.gold, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            child!,
            // Makkah / Madinah emblem on the node's shoulder.
            Positioned(
              right: -2,
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.divider),
                ),
                child: RevelationIcon(makki: s.makki, size: 18),
              ),
            ),
          ],
        ),
        child: Container(
          decoration: ShapeDecoration(
            gradient: done
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.goldLight, AppColors.gold],
                  )
                : null,
            color: done ? null : AppColors.header,
            shape: StarShapeBorder(
              side: BorderSide(
                color: done ? AppColors.gold : AppColors.goldLight,
                width: !done ? 2 : 1.4,
              ),
            ),
            shadows: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(14),
          child: FittedBox(
            child: Text(
              s.nameAr,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppText.arabic,
                fontSize: 22,
                height: 1.3,
                color: done ? Colors.white : AppColors.goldLight,
              ),
            ),
          ),
        ),
      ),
    );

    final label = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (current)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
            child: Text(
              t.startHere,
              style: AppText.micro.copyWith(
                color: AppColors.onGold,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        Text(
          '${f.digits(s.id)}. ${s.name(f.isBn)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.label.copyWith(color: AppColors.ink),
        ),
        Text(
          '${s.meaning(f.isBn)} · ${s.makki ? t.makki : t.madani}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.micro.copyWith(color: AppColors.muted),
        ),
        Text(
          status,
          style: AppText.micro.copyWith(
            color: done ? AppColors.gold : AppColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return _PathRow(
      step: widget.step,
      node: node,
      label: label,
      lineColor: AppColors.gold.withValues(alpha: 0.7),
    );
  }
}

class _QuizNode extends StatelessWidget {
  const _QuizNode({
    required this.phase,
    required this.step,
    required this.progress,
  });

  final QuranPhase phase;
  final int step;
  final QuranProgress progress;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final best = progress.quizBest[phase.index];
    final stars = best == null
        ? 0
        : (best >= 90
              ? 3
              : best >= 60
              ? 2
              : 1);

    final node = GestureDetector(
      onTap: () => push(context, QuizScreen(phase: phase)),
      child: Center(
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.14),
              border: Border.all(color: AppColors.gold, width: 1.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: Icon(Icons.star_rounded, color: AppColors.gold),
            ),
          ),
        ),
      ),
    );

    final label = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.phaseQuiz(f.digits(phase.index + 1)),
          style: AppText.label.copyWith(color: AppColors.ink),
        ),
        Text(
          best == null ? t.quizOptional : t.bestScore(f.digits(best)),
          style: AppText.micro.copyWith(color: AppColors.muted),
        ),
        if (stars > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++)
                Icon(
                  i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 16,
                  color: AppColors.gold,
                ),
            ],
          ),
      ],
    );

    return _PathRow(
      step: step,
      node: node,
      label: label,
      nodeSize: 72,
      height: 112,
      lineColor: AppColors.gold.withValues(alpha: 0.7),
    );
  }
}

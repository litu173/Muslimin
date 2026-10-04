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

/// Read tab: the Quran as a journey. Al-Fatiha, then An-Nas back to
/// Al-Baqarah, grouped into phases; each surah opens after the previous one
/// is read, and every phase ends with an optional quiz.
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

  void _open(Surah s) =>
      push(context, SurahScreen(surah: s)).then((_) => _scrolled = false);

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
        ),
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
    final open = progress.isUnlocked(phase.surahs.first);
    final read = phase.surahs.where((s) => progress.completed.contains(s.id));
    return Opacity(
      opacity: open ? 1 : 0.55,
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
    final open = p.isUnlocked(s);
    final current = _current;

    final status = done
        ? t.completed
        : !open
        ? t.locked
        : p.lastSurah == s.id
        ? t.ayahOf(f.digits(p.lastAyah), f.digits(s.verses))
        : t.versesN(f.digits(s.verses));

    final node = GestureDetector(
      onTap: () {
        if (open) {
          widget.onOpen();
        } else {
          final i = kJourney.indexOf(s);
          toast(context, t.unlockHint(kJourney[i - 1].name(f.isBn)));
        }
      },
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
            color: done
                ? null
                : open
                ? AppColors.header
                : AppColors.card,
            shape: StarShapeBorder(
              side: BorderSide(
                color: done
                    ? AppColors.gold
                    : open
                    ? AppColors.goldLight
                    : AppColors.divider,
                width: open && !done ? 2 : 1.4,
              ),
            ),
            shadows: open
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(14),
          child: open
              ? FittedBox(
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
                )
              : Icon(Icons.lock_outline_rounded, color: AppColors.muted),
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
          style: AppText.label.copyWith(
            color: open ? AppColors.ink : AppColors.muted,
          ),
        ),
        Text(
          s.meaning(f.isBn),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.micro.copyWith(color: AppColors.muted),
        ),
        Text(
          status,
          style: AppText.micro.copyWith(
            color: done
                ? AppColors.gold
                : open
                ? AppColors.ink
                : AppColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return _PathRow(
      step: widget.step,
      node: node,
      label: label,
      lineColor: open
          ? AppColors.gold.withValues(alpha: 0.7)
          : AppColors.divider,
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
    final open = progress.phaseDone(phase);
    final best = progress.quizBest[phase.index];
    final stars = best == null
        ? 0
        : (best >= 90
              ? 3
              : best >= 60
              ? 2
              : 1);

    final node = GestureDetector(
      onTap: () => open
          ? push(context, QuizScreen(phase: phase))
          : toast(context, t.quizUnlockHint),
      child: Center(
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: open
                  ? AppColors.gold.withValues(alpha: 0.14)
                  : AppColors.card,
              border: Border.all(
                color: open ? AppColors.gold : AppColors.divider,
                width: 1.6,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: Icon(
                open ? Icons.star_rounded : Icons.lock_outline_rounded,
                color: open ? AppColors.gold : AppColors.muted,
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
        Text(
          t.phaseQuiz(f.digits(phase.index + 1)),
          style: AppText.label.copyWith(
            color: open ? AppColors.ink : AppColors.muted,
          ),
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
      lineColor: open
          ? AppColors.gold.withValues(alpha: 0.7)
          : AppColors.divider,
    );
  }
}

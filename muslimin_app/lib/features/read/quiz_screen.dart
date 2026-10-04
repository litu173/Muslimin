import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/quran/quran_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../state/quran.dart';
import 'read_widgets.dart';

/// Optional quiz at the end of a phase, generated from the surahs' own data.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.phase});

  final QuranPhase phase;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late final Future<List<QuizQuestion>> _quiz = _build();
  int _i = 0;
  int? _picked;
  int _correct = 0;
  bool _finished = false;

  Future<List<QuizQuestion>> _build() async {
    final f = Fmt.of(context);
    final t = L10n.of(context);
    final lang = f.isBn ? 'bn' : 'en';
    final repo = ref.read(quranRepositoryProvider);
    final ayahs = <int, List<Ayah>>{
      for (final s in widget.phase.surahs) s.id: await repo.surah(s.id, lang),
    };
    return buildQuiz(
      phase: widget.phase,
      ayahs: ayahs,
      bn: f.isBn,
      tx: QuizTexts(
        wordMeaning: t.quizWordMeaning,
        ayahMeaning: t.quizAyahMeaning,
        whichSurah: t.quizWhichSurah,
        revealedWhere: t.quizRevealed,
        makkah: t.makkah,
        madinah: t.madinah,
        howManyVerses: t.quizVerses,
        nameMeans: t.quizNameMeans,
        surahName: (s) => s.name(f.isBn),
        digits: f.digits,
      ),
    );
  }

  void _pick(QuizQuestion q, int i) {
    if (_picked != null) return;
    final ok = i == q.answer;
    ok ? HapticFeedback.lightImpact() : HapticFeedback.mediumImpact();
    setState(() {
      _picked = i;
      if (ok) _correct++;
    });
  }

  void _next(int total) {
    if (_i + 1 >= total) {
      final score = (_correct * 100 / total).round();
      ref
          .read(quranProgressProvider.notifier)
          .quizScore(widget.phase.index, score);
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _i++;
      _picked = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.phaseQuiz(f.digits(widget.phase.index + 1))),
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _quiz,
        builder: (context, snap) {
          if (snap.hasError) {
            return EmptyState(
              message: t.somethingWrong,
              icon: Icons.wifi_off_rounded,
            );
          }
          if (!snap.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Loader(),
                Text(
                  t.quizLoading,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
              ],
            );
          }
          final qs = snap.data!;
          if (_finished) return _Result(correct: _correct, total: qs.length);
          final q = qs[_i];
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Gap.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(end: (_i + 1) / qs.length),
                            duration: const Duration(milliseconds: 300),
                            builder: (_, v, _) => LinearProgressIndicator(
                              value: v,
                              minHeight: 6,
                              color: AppColors.gold,
                              backgroundColor: AppColors.gold.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Gap.m),
                      Text(
                        '${f.digits(_i + 1)}/${f.digits(qs.length)}',
                        style: AppText.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: Gap.l),
                  Expanded(
                    child: ListView(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _QuestionCard(key: ValueKey(_i), q: q),
                        ),
                        const SizedBox(height: Gap.l),
                        for (final (i, o) in q.options.indexed) ...[
                          _Option(
                            letter: String.fromCharCode(65 + i),
                            text: o,
                            state: _picked == null
                                ? _OptState.idle
                                : i == q.answer
                                ? _OptState.correct
                                : i == _picked
                                ? _OptState.wrong
                                : _OptState.dim,
                            onTap: () => _pick(q, i),
                          ),
                          const SizedBox(height: Gap.m),
                        ],
                      ],
                    ),
                  ),
                  if (_picked != null) ...[
                    _Feedback(ok: _picked == q.answer),
                    const SizedBox(height: Gap.m),
                  ],
                  AppButton(
                    t.continueBtn,
                    expand: true,
                    onPressed: _picked == null ? null : () => _next(qs.length),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({super.key, required this.q});
  final QuizQuestion q;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final kind = switch (q.kind) {
      QuizKind.vocabulary => t.kindVocabulary,
      QuizKind.meaning => t.kindMeaning,
      QuizKind.whichSurah => t.kindSurah,
      _ => t.kindFacts,
    };
    return AppCard(
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            kind,
            textAlign: TextAlign.center,
            style: AppText.micro.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: Gap.s),
          Text(q.prompt, textAlign: TextAlign.center, style: AppText.subtitle),
          if (q.arabic != null) ...[
            const SizedBox(height: Gap.m),
            Text(
              q.arabic!,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppText.arabic,
                fontSize: q.arabic!.length > 30 ? 24 : 36,
                height: 1.8,
                color: AppColors.gold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _OptState { idle, correct, wrong, dim }

class _Option extends StatelessWidget {
  const _Option({
    required this.letter,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String letter;
  final String text;
  final _OptState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg) = switch (state) {
      _OptState.correct => (
        AppColors.success.withValues(alpha: 0.12),
        AppColors.success,
        AppColors.success,
      ),
      _OptState.wrong => (
        AppColors.danger.withValues(alpha: 0.1),
        AppColors.danger,
        AppColors.danger,
      ),
      _ => (AppColors.card, AppColors.divider, AppColors.ink),
    };
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: state == _OptState.dim ? 0.55 : 1,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.card),
          side: BorderSide(color: border, width: 1.2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: fg.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(letter, style: AppText.label.copyWith(color: fg)),
                ),
                const SizedBox(width: Gap.m),
                Expanded(
                  child: Text(text, style: AppText.body.copyWith(color: fg)),
                ),
                if (state == _OptState.correct)
                  Icon(Icons.check_circle_rounded, color: AppColors.success),
                if (state == _OptState.wrong)
                  Icon(Icons.cancel_rounded, color: AppColors.danger),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.ok});
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final c = ok ? AppColors.success : AppColors.danger;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 250),
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - v)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(Gap.l),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Radii.card),
        ),
        child: Text(
          ok ? t.quizCorrect : t.quizWrong,
          style: AppText.label.copyWith(color: c),
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.correct, required this.total});
  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final score = (correct * 100 / total).round();
    final stars = score >= 90
        ? 3
        : score >= 60
        ? 2
        : 1;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Gap.xl),
        child: Column(
          children: [
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.3, end: 1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.goldLight, AppColors.gold],
                  ),
                  shape: const StarShapeBorder(),
                ),
                child: Text(
                  '${f.digits(score)}%',
                  style: AppText.headline.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: Gap.l),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++)
                  Icon(
                    i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppColors.gold,
                    size: 36,
                  ),
              ],
            ),
            const SizedBox(height: Gap.l),
            Text(t.quizScore(f.digits(score)), style: AppText.headline),
            const SizedBox(height: Gap.s),
            Text(
              t.quizDoneBody,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.muted),
            ),
            const Spacer(),
            AppButton(
              t.done,
              expand: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

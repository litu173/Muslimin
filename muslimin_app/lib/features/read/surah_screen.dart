import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/quran/quran_repository.dart';
import '../../data/quran/surahs.dart';
import '../../l10n/app_localizations.dart';
import '../../state/quran.dart';
import 'quiz_screen.dart';
import 'read_widgets.dart';

/// Reads one surah: Arabic, translation and (optionally) word-by-word.
/// The header stays fixed; the ayahs scroll underneath.
class SurahScreen extends ConsumerStatefulWidget {
  const SurahScreen({super.key, required this.surah});

  final Surah surah;

  @override
  ConsumerState<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends ConsumerState<SurahScreen> {
  late Future<List<Ayah>> _ayahs = _load();
  bool _words = false;
  int _seen = 0;

  String get _lang =>
      Localizations.localeOf(context).languageCode == 'bn' ? 'bn' : 'en';

  Future<List<Ayah>> _load({bool refresh = false}) => Future(
    () => ref
        .read(quranRepositoryProvider)
        .surah(widget.surah.id, _lang, refresh: refresh),
  );

  Future<void> _refresh() async {
    final f = _load(refresh: true);
    setState(() => _ayahs = f);
    try {
      await f;
    } catch (_) {}
  }

  void _seenAyah(int n) {
    if (n <= _seen) return;
    _seen = n;
    // After the frame: providers must not change while building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final p = ref.read(quranProgressProvider);
      if (!p.completed.contains(widget.surah.id)) {
        ref.read(quranProgressProvider.notifier).readUpTo(widget.surah.id, n);
      }
    });
  }

  Future<void> _complete() async {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final s = widget.surah;
    HapticFeedback.mediumImpact();
    ref.read(quranProgressProvider.notifier).complete(s.id);
    final progress = ref.read(quranProgressProvider);
    final i = kJourney.indexOf(s);
    final next = i + 1 < kJourney.length ? kJourney[i + 1] : null;
    final phase = phaseOf(s.id);
    final quiz = progress.phaseDone(phase);

    final action = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radii.sheet),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xl, Gap.xl, Gap.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.4, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: 84,
                height: 84,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.goldLight, AppColors.gold],
                  ),
                  shape: const StarShapeBorder(),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: Gap.l),
            Text(
              t.surahDone(s.name(f.isBn)),
              textAlign: TextAlign.center,
              style: AppText.subtitle,
            ),
            if (next != null) ...[
              const SizedBox(height: Gap.s),
              Text(
                t.nextUnlocked(next.name(f.isBn)),
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.muted),
              ),
            ],
            const SizedBox(height: Gap.xl),
            if (quiz) ...[
              AppButton(
                t.takeQuiz,
                icon: Icons.star_rounded,
                expand: true,
                onPressed: () => Navigator.pop(ctx, 'quiz'),
              ),
              const SizedBox(height: Gap.m),
            ],
            if (next != null)
              AppButton(
                '${t.nextSurah} · ${next.name(f.isBn)}',
                style: quiz ? AppButtonStyle.outlined : AppButtonStyle.filled,
                expand: true,
                onPressed: () => Navigator.pop(ctx, 'next'),
              ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'quiz') {
      pushReplacement(context, QuizScreen(phase: phase));
    } else if (action == 'next' && next != null) {
      pushReplacement(context, SurahScreen(surah: next));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final s = widget.surah;
    final done = ref.watch(
      quranProgressProvider.select((p) => p.completed.contains(s.id)),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            _SurahHeader(
              surah: s,
              words: _words,
              onWords: () => setState(() => _words = !_words),
            ),
            Expanded(
              child: FutureBuilder<List<Ayah>>(
                future: _ayahs,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return EmptyState(
                      message: t.somethingWrong,
                      icon: Icons.wifi_off_rounded,
                      action: AppButton(
                        t.retry,
                        dense: true,
                        onPressed: _refresh,
                      ),
                    );
                  }
                  if (!snap.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Loader(),
                        Text(
                          t.loadingSurah,
                          style: AppText.caption.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    );
                  }
                  final ayahs = snap.data!;
                  final bismillah = s.id != 1 && s.id != 9;
                  final extra = bismillah ? 1 : 0;
                  return CustomScrollView(
                    slivers: [
                      PullToRefresh(onRefresh: _refresh),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          Gap.l,
                          Gap.l,
                          Gap.l,
                          Gap.xxl,
                        ),
                        sliver: SliverList.separated(
                          itemCount: ayahs.length + extra + 1,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: Gap.m),
                          itemBuilder: (context, i) {
                            if (bismillah && i == 0) return const _Bismillah();
                            final k = i - extra;
                            if (k == ayahs.length) {
                              return _EndCard(
                                done: done,
                                onComplete: _complete,
                              );
                            }
                            _seenAyah(ayahs[k].number);
                            return _AyahCard(
                              ayah: ayahs[k],
                              words: _words,
                              number: f.digits(ayahs[k].number),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({
    required this.surah,
    required this.words,
    required this.onWords,
  });

  final Surah surah;
  final bool words;
  final VoidCallback onWords;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    return IslamicPattern(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: Gap.l,
        ),
        child: Column(
          children: [
            Row(
              children: [
                BackButton(color: AppColors.onHeader),
                Expanded(
                  child: Text(
                    '${f.digits(surah.id)}. ${surah.name(f.isBn)}',
                    style: AppText.subtitle.copyWith(color: AppColors.onHeader),
                  ),
                ),
                IconButton(
                  tooltip: t.wordByWord,
                  onPressed: onWords,
                  icon: Icon(
                    Icons.translate_rounded,
                    color: words ? AppColors.goldLight : AppColors.onHeader,
                  ),
                ),
              ],
            ),
            Text(
              surah.nameAr,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppText.arabic,
                fontSize: 34,
                height: 1.4,
                color: AppColors.goldLight,
              ),
            ),
            Text(
              '${surah.meaning(f.isBn)} · ${surah.makki ? t.makki : t.madani} · ${t.versesN(f.digits(surah.verses))}',
              style: AppText.caption.copyWith(
                color: AppColors.onHeader.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bismillah extends StatelessWidget {
  const _Bismillah();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Gap.s),
    child: Text(
      'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontFamily: AppText.arabic,
        fontSize: 26,
        height: 1.6,
        color: AppColors.gold,
      ),
    ),
  );
}

class _AyahCard extends StatelessWidget {
  const _AyahCard({
    required this.ayah,
    required this.words,
    required this.number,
  });

  final Ayah ayah;
  final bool words;
  final String number;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.l, Gap.l),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(alignment: Alignment.centerLeft, child: AyahNumber(number)),
        const SizedBox(height: Gap.s),
        Text(
          ayah.arabic,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: AppText.arabic,
            fontSize: 26,
            height: 2,
            color: AppColors.ink,
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.topCenter,
          child: words
              ? Padding(
                  padding: const EdgeInsets.only(top: Gap.m),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Wrap(
                      spacing: Gap.s,
                      runSpacing: Gap.s,
                      children: [
                        for (final w in ayah.words) _WordChip(word: w),
                      ],
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
        const SizedBox(height: Gap.m),
        Text(
          ayah.translation,
          style: AppText.body.copyWith(color: AppColors.muted, height: 1.55),
        ),
      ],
    ),
  );
}

class _WordChip extends StatelessWidget {
  const _WordChip({required this.word});
  final QuranWord word;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.gold.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(Radii.button),
      border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          word.arabic,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: AppText.arabic,
            fontSize: 20,
            height: 1.5,
            color: AppColors.gold,
          ),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(word.meaning, style: AppText.micro),
        ),
      ],
    ),
  );
}

class _EndCard extends StatelessWidget {
  const _EndCard({required this.done, required this.onComplete});

  final bool done;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: Gap.l),
      child: Column(
        children: [
          AppButton(
            done ? t.completed : t.completeSurah,
            icon: done ? Icons.check_circle_rounded : Icons.check_rounded,
            style: done ? AppButtonStyle.outlined : AppButtonStyle.filled,
            expand: true,
            onPressed: onComplete,
          ),
          const SizedBox(height: Gap.l),
          Text(
            t.quranSource,
            textAlign: TextAlign.center,
            style: AppText.micro.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/quran/quran_repository.dart';
import '../../data/quran/surahs.dart';
import '../../l10n/app_localizations.dart';
import '../../services/recitation_player.dart';
import '../../state/providers.dart';
import '../../state/quran.dart';
import 'quiz_screen.dart';
import 'read_widgets.dart';

/// Reads one surah: Mushaf text, translation, optional word-by-word, and a
/// verse-by-verse recitation player. Only the top bar stays fixed; the
/// surah title and the ayat scroll underneath it.
class SurahScreen extends ConsumerStatefulWidget {
  const SurahScreen({super.key, required this.surah, this.startAyah});

  final Surah surah;

  /// Opens at this ayah (e.g. Ayatul Kursi = 2:255).
  final int? startAyah;

  @override
  ConsumerState<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends ConsumerState<SurahScreen> {
  late Future<List<Ayah>> _ayahs = _load();
  final _scroll = ScrollController();
  final _list = ListController();
  bool _words = false;
  bool _jumped = false;
  DateTime _userScrolledAt = DateTime(2000);
  late final RecitationPlayer _player;

  Surah get _s => widget.surah;
  bool get _hasBismillah => _s.id != 1 && _s.id != 9;

  /// List index of ayah [n]: [(bismillah), ayah 1 …, end].
  int _indexOf(int n) => n - 1 + (_hasBismillah ? 1 : 0);

  String get _lang =>
      Localizations.localeOf(context).languageCode == 'bn' ? 'bn' : 'en';

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(prefsProvider);
    _player = RecitationPlayer(
      repo: ref.read(quranRepositoryProvider),
      surah: _s.id,
      verses: _s.verses,
      reciter: reciterById(prefs.reciter),
      onAyah: _onRecitedAyah,
      onFinished: () =>
          ref.read(quranProgressProvider.notifier).listened(_s.id),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<List<Ayah>> _load({bool refresh = false}) => Future(
    () =>
        ref.read(quranRepositoryProvider).surah(_s.id, _lang, refresh: refresh),
  );

  Future<void> _refresh() async {
    final f = _load(refresh: true);
    setState(() => _ayahs = f);
    try {
      await f;
    } catch (_) {}
  }

  void _markRead(int ayah) =>
      ref.read(quranProgressProvider.notifier).read(_s.id, ayah);

  /// Marks the ayat currently on screen as read.
  void _markVisible() {
    if (!mounted || !_list.isAttached) return;
    final r = _list.unobstructedVisibleRange;
    if (r == null) return;
    final first = _indexOf(1);
    for (var i = r.$1; i <= r.$2; i++) {
      final n = i - first + 1;
      if (n >= 1 && n <= _s.verses) _markRead(n);
    }
  }

  void _onRecitedAyah(int n) {
    _markRead(n);
    // Follow the reciter unless the user is browsing on their own.
    if (DateTime.now().difference(_userScrolledAt).inSeconds < 4) return;
    if (!_list.isAttached || !_scroll.hasClients) return;
    _list.animateToItem(
      index: _indexOf(n),
      scrollController: _scroll,
      alignment: 0.15,
      duration: (_) => const Duration(milliseconds: 450),
      curve: (_) => Curves.easeOutCubic,
    );
  }

  void _jumpToStart() {
    if (_jumped || widget.startAyah == null) return;
    _jumped = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_list.isAttached || !_scroll.hasClients) return;
      _list.jumpToItem(
        index: _indexOf(widget.startAyah!),
        scrollController: _scroll,
        alignment: 0.05,
      );
    });
  }

  /// Opens another surah in place of this one (arrows / surah picker).
  void _goTo(Surah s) {
    if (s.id == _s.id) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, _, _) => SurahScreen(surah: s),
        transitionsBuilder: (_, a, _, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
  }

  Future<void> _pickReciter() async {
    final t = L10n.of(context);
    final bn = Fmt.of(context).isBn;
    final r = await showModalBottomSheet<Reciter>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radii.sheet),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.s),
              child: Text(t.chooseReciter, style: AppText.subtitle),
            ),
            const SizedBox(height: Gap.s),
            for (final x in kReciters)
              ListTile(
                onTap: () => Navigator.pop(ctx, x),
                leading: _ReciterAvatar(reciter: x),
                title: Text(x.label(bn), style: AppText.label),
                trailing: x.id == _player.reciter.id
                    ? Icon(Icons.check_circle_rounded, color: AppColors.gold)
                    : null,
              ),
          ],
        ),
      ),
    );
    if (r == null) return;
    ref.read(prefsProvider).reciter = r.id;
    await _player.setReciter(r);
  }

  Future<void> _complete() async {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    HapticFeedback.mediumImpact();
    ref.read(quranProgressProvider.notifier).complete(_s.id);
    final progress = ref.read(quranProgressProvider);
    final i = kJourney.indexOf(_s);
    final next = i + 1 < kJourney.length ? kJourney[i + 1] : null;
    final phase = phaseOf(_s.id);
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
              t.surahDone(_s.name(f.isBn)),
              textAlign: TextAlign.center,
              style: AppText.subtitle,
            ),
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
    final done = ref.watch(
      quranProgressProvider.select((p) => p.completed.contains(_s.id)),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            _TopBar(
              surah: _s,
              words: _words,
              onWords: () => setState(() => _words = !_words),
              onGo: _goTo,
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
                  _jumpToStart();
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _markVisible(),
                  );
                  final extra = _hasBismillah ? 1 : 0;
                  return NotificationListener<ScrollNotification>(
                    onNotification: (n) {
                      if (n is ScrollStartNotification &&
                          n.dragDetails != null) {
                        _userScrolledAt = DateTime.now();
                      }
                      if (n is ScrollEndNotification) _markVisible();
                      return false;
                    },
                    child: ListenableBuilder(
                      listenable: _player,
                      builder: (context, _) => CustomScrollView(
                        controller: _scroll,
                        slivers: [
                          PullToRefresh(onRefresh: _refresh),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                              Gap.l,
                              Gap.l,
                              Gap.l,
                              Gap.xxl,
                            ),
                            sliver: SuperSliverList.builder(
                              listController: _list,
                              itemCount: ayahs.length + extra + 1,
                              itemBuilder: (context, i) {
                                final Widget child;
                                if (_hasBismillah && i == 0) {
                                  child = const _Bismillah();
                                } else if (i == ayahs.length + extra) {
                                  child = _EndCard(
                                    done: done,
                                    onComplete: _complete,
                                  );
                                } else {
                                  final a = ayahs[i - extra];
                                  child = _AyahCard(
                                    ayah: a,
                                    words: _words,
                                    number: f.digits(a.number),
                                    reciting:
                                        _player.started &&
                                        _player.ayah == a.number,
                                    playing: _player.playing,
                                    onPlay: () => _player.playFrom(a.number),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: Gap.m),
                                  child: child,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _PlayerBar(player: _player, surah: _s, onReciter: _pickReciter),
          ],
        ),
      ),
    );
  }
}

/// Fixed top: back, previous / next surah arrows around the surah's name
/// (tap the name to jump to any surah), the word-by-word toggle, and the
/// meaning · Makki/Madani · verses line under the name.
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.surah,
    required this.words,
    required this.onWords,
    required this.onGo,
  });

  final Surah surah;
  final bool words;
  final VoidCallback onWords;
  final ValueChanged<Surah> onGo;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final prev = surah.id > 1 ? kSurahs[surah.id - 2] : null;
    final next = surah.id < 114 ? kSurahs[surah.id] : null;
    // Surah arrows sit in gold rings so they read differently from Back.
    Widget arrow(IconData icon, Surah? to, String tip) {
      final c = to == null
          ? AppColors.onHeader.withValues(alpha: 0.25)
          : AppColors.goldLight;
      return Tooltip(
        message: tip,
        child: InkResponse(
          onTap: to == null ? null : () => onGo(to),
          radius: 22,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: c, width: 1.2),
            ),
            child: Icon(icon, size: 20, color: c),
          ),
        ),
      );
    }
    return IslamicPattern(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: Gap.s,
        ),
        child: Row(
          children: [
            BackButton(color: AppColors.onHeader),
            arrow(Icons.chevron_left_rounded, prev, t.previousSurah),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.button),
                onTap: () async {
                  final s = await showSurahPicker(context, surah);
                  if (s != null) onGo(s);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              '${f.digits(surah.id)}. ${surah.name(f.isBn)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.subtitle.copyWith(
                                color: AppColors.onHeader,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.expand_more_rounded,
                            size: 20,
                            color: AppColors.goldLight,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RevelationIcon(makki: surah.makki, size: 14),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${surah.meaning(f.isBn)} · ${surah.makki ? t.makki : t.madani} · ${t.versesN(f.digits(surah.verses))}',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.micro.copyWith(
                                color: AppColors.onHeader.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            arrow(Icons.chevron_right_rounded, next, t.nextSurah),
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
      ),
    );
  }
}

/// Bottom sheet listing all 114 surahs (searchable); returns the pick.
Future<Surah?> showSurahPicker(BuildContext context, Surah current) {
  return showModalBottomSheet<Surah>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _SurahPicker(current: current),
  );
}

class _SurahPicker extends StatefulWidget {
  const _SurahPicker({required this.current});
  final Surah current;

  @override
  State<_SurahPicker> createState() => _SurahPickerState();
}

class _SurahPickerState extends State<_SurahPicker> {
  final _search = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final q = _q.toLowerCase();
    final list = [
      for (final s in kSurahs)
        if (q.isEmpty ||
            '${s.id} ${f.digits(s.id)} ${s.nameEn} ${s.nameBn} ${s.nameAr} ${s.meaningEn} ${s.meaningBn}'
                .toLowerCase()
                .contains(q))
          s,
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, scroll) => Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radii.sheet),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: Gap.s),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.chooseSurah, style: AppText.subtitle),
                  const SizedBox(height: Gap.m),
                  AppSearchField(
                    controller: _search,
                    hint: t.surahSearchHint,
                    onChanged: (v) => setState(() => _q = v.trim()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scroll,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final s = list[i];
                  final current = s.id == widget.current.id;
                  return ListTile(
                    onTap: () => Navigator.pop(context, s),
                    selected: current,
                    selectedTileColor: AppColors.gold.withValues(alpha: 0.1),
                    leading: AyahNumber(f.digits(s.id), size: 38),
                    title: Text(s.name(f.isBn), style: AppText.label),
                    subtitle: Row(
                      children: [
                        RevelationIcon(makki: s.makki, size: 14),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${s.meaning(f.isBn)} · ${t.versesN(f.digits(s.verses))}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.micro.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      s.nameAr,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: AppText.arabic,
                        fontSize: 22,
                        color: AppColors.gold,
                      ),
                    ),
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

class _Bismillah extends StatelessWidget {
  const _Bismillah();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Gap.s),
    child: Text(
      kBismillah,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontFamily: AppText.arabic,
        fontSize: 28,
        height: 1.8,
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
    required this.reciting,
    required this.playing,
    required this.onPlay,
  });

  final Ayah ayah;
  final bool words;
  final String number;

  /// This ayah is the one the player is on.
  final bool reciting;
  final bool playing;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: reciting
            ? Color.alphaBlend(
                AppColors.gold.withValues(alpha: 0.09),
                AppColors.card,
              )
            : AppColors.card,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(
          color: reciting ? AppColors.gold : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: reciting
            ? [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.s, Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AyahNumber(number),
              if (reciting) ...[
                const SizedBox(width: Gap.s),
                _Equalizer(active: playing),
              ],
              const Spacer(),
              IconButton(
                tooltip: t.playAyah,
                onPressed: onPlay,
                icon: Icon(
                  Icons.play_circle_outline_rounded,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: Gap.s),
            child: Text(
              ayah.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppText.arabic,
                fontSize: 28,
                height: 2.1,
                color: AppColors.ink,
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topCenter,
            child: words
                ? Padding(
                    padding: const EdgeInsets.only(top: Gap.m, right: Gap.s),
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
          Padding(
            padding: const EdgeInsets.only(right: Gap.s),
            child: Text(
              ayah.translation,
              style: AppText.body.copyWith(
                color: AppColors.muted,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three gold bars that bounce while the ayah is being recited.
class _Equalizer extends StatefulWidget {
  const _Equalizer({required this.active});
  final bool active;

  @override
  State<_Equalizer> createState() => _EqualizerState();
}

class _EqualizerState extends State<_Equalizer>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat();
  }

  @override
  void didUpdateWidget(_Equalizer old) {
    super.didUpdateWidget(old);
    if (widget.active && !_c.isAnimating) _c.repeat();
    if (!widget.active && _c.isAnimating) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, _) => SizedBox(
      height: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < 3; i++)
            Container(
              margin: const EdgeInsets.only(right: 2),
              width: 3,
              height:
                  4 +
                  12 *
                      (0.5 + 0.5 * math.sin(_c.value * 2 * math.pi + i * 1.9))
                          .abs(),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
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
            fontSize: 22,
            height: 1.6,
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

class _ReciterAvatar extends StatelessWidget {
  const _ReciterAvatar({required this.reciter, this.size = 38});
  final Reciter reciter;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.header, AppColors.inkDeep],
      ),
      border: Border.all(color: AppColors.goldLight.withValues(alpha: 0.6)),
    ),
    child: Text(
      reciter.initials,
      style: AppText.caption.copyWith(
        color: AppColors.goldLight,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

/// Bottom player: reciter, ayah being recited, play/pause, previous/next and
/// the progress through the surah.
class _PlayerBar extends StatelessWidget {
  const _PlayerBar({
    required this.player,
    required this.surah,
    required this.onReciter,
  });

  final RecitationPlayer player;
  final Surah surah;
  final VoidCallback onReciter;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: AppColors.dark
                  ? const Color(0x66000000)
                  : const Color(0x14002828),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: player.started ? player.progress : 0,
                minHeight: 3,
                color: AppColors.gold,
                backgroundColor: AppColors.gold.withValues(alpha: 0.12),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.s, Gap.s),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(Radii.button),
                        onTap: onReciter,
                        child: Row(
                          children: [
                            _ReciterAvatar(reciter: player.reciter, size: 36),
                            const SizedBox(width: Gap.s),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    player.reciter.label(f.isBn),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.label,
                                  ),
                                  Text(
                                    player.error
                                        ? t.audioError
                                        : t.recitingAyah(
                                            f.digits(player.ayah),
                                            f.digits(surah.verses),
                                          ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.micro.copyWith(
                                      color: player.error
                                          ? AppColors.danger
                                          : AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.expand_more_rounded,
                              color: AppColors.muted,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: player.ayah > 1 ? player.previous : null,
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        color: AppColors.ink,
                      ),
                    ),
                    GestureDetector(
                      onTap: player.toggle,
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.goldLight, AppColors.gold],
                          ),
                        ),
                        child: player.loading
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                player.playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: player.ayah < surah.verses
                          ? player.next
                          : null,
                      icon: Icon(Icons.skip_next_rounded, color: AppColors.ink),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

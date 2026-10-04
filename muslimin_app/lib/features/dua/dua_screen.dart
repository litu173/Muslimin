import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import 'dua_data.dart';

final Future<List<DuaScene>> _scenes = loadDuaScenes();

String partName(L10n t, DayPart p) => switch (p) {
  DayPart.dawn => t.part_dawn,
  DayPart.morning => t.part_morning,
  DayPart.day => t.part_day,
  DayPart.evening => t.part_evening,
  DayPart.night => t.part_night,
};

String _partSub(L10n t, DayPart p) => switch (p) {
  DayPart.dawn => t.part_dawn_sub,
  DayPart.morning => t.part_morning_sub,
  DayPart.day => t.part_day_sub,
  DayPart.evening => t.part_evening_sub,
  DayPart.night => t.part_night_sub,
};

const _skies = {
  DayPart.dawn: [Color(0xFF2B3A67), Color(0xFFE88D72), Color(0xFFFFD39A)],
  DayPart.morning: [Color(0xFF7EC8E3), Color(0xFFBFE6F2), Color(0xFFFFF1C9)],
  DayPart.day: [Color(0xFF3FA7D6), Color(0xFF8ED1EE), Color(0xFFDDF3FB)],
  DayPart.evening: [Color(0xFF3B2A5C), Color(0xFFC0566B), Color(0xFFF7A35C)],
  DayPart.night: [Color(0xFF020B1A), Color(0xFF0C2234), Color(0xFF173A4A)],
};

bool _darkSky(DayPart p) => p != DayPart.morning && p != DayPart.day;

/// Arabic without harakat, lower-cased Latin – so "بسم الله" or "eat"
/// match the vowelled text and the meanings.
String _norm(String s) => s
    .toLowerCase()
    .replaceAll(RegExp('[ً-ٰٟۖ-ۭـ]'), '')
    .replaceAll(RegExp('[ٱأإآ]'), 'ا');

/// Every query word must start a word in the text ("eat" finds "eating",
/// not "great").
bool _hit(String text, String q) {
  final t = _norm(text);
  for (final w in q.split(RegExp(r'\s+')).where((w) => w.isNotEmpty)) {
    final re = RegExp(
      '(^|[^\\p{L}\\p{M}\\p{N}])${RegExp.escape(w)}',
      unicode: true,
    );
    if (!re.hasMatch(t)) return false;
  }
  return true;
}

bool _titleMatches(L10n t, DuaScene s, String q) =>
    _hit(sceneTitle(t, s.id), q);

bool _sceneMatches(L10n t, DuaScene s, String q) =>
    _hit('${sceneTitle(t, s.id)} ${sceneStory(t, s.id)}', q);

bool _duaMatches(Dua d, String q) =>
    _hit('${d.ar} ${d.tr} ${d.en} ${d.bn} ${d.n}', q);

/// Topics matching [q]: topic names first, then topics with matching duas
/// (keeping only those duas).
List<(DuaScene, List<Dua>)> _filter(L10n t, List<DuaScene> scenes, String q) {
  if (q.isEmpty) return [for (final s in scenes) (s, s.duas)];
  return [
    for (final s in scenes)
      if (_titleMatches(t, s, q)) (s, s.duas),
    for (final s in scenes)
      if (!_titleMatches(t, s, q))
        if (_sceneMatches(t, s, q))
          (s, s.duas)
        else if (s.duas.any((d) => _duaMatches(d, q)))
          (
            s,
            [
              for (final d in s.duas)
                if (_duaMatches(d, q)) d,
            ],
          ),
  ];
}

/// Plays one dua's recitation at a time; shared by a page's cards.
class _DuaAudio {
  final player = AudioPlayer();
  final playing = ValueNotifier<int?>(null);

  _DuaAudio() {
    player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) playing.value = null;
    });
  }

  Future<void> toggle(Dua d) async {
    if (playing.value == d.n) {
      await player.stop();
      playing.value = null;
      return;
    }
    playing.value = d.n;
    try {
      await player.setUrl(d.audio);
      await player.play();
    } catch (_) {
      playing.value = null;
    }
  }

  void dispose() {
    player.dispose();
    playing.dispose();
  }
}

/// Patterned header with title, subtitle and a search field.
class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.title,
    required this.subtitle,
    required this.controller,
    required this.onChanged,
    this.back = false,
    this.colors,
    this.lightSky = false,
  });

  final String title;
  final String subtitle;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool back;

  /// Sky gradient instead of the green pattern (part pages).
  final List<Color>? colors;

  /// Dark text on light (morning / day) skies.
  final bool lightSky;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final fg = lightSky ? const Color(0xFF0B2A33) : AppColors.onHeader;
    final content = Padding(
      padding: EdgeInsets.fromLTRB(
        back ? Gap.s : Gap.xl,
        MediaQuery.of(context).padding.top + (back ? 0 : Gap.s),
        Gap.l,
        Gap.l,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (back) BackButton(color: fg),
              Expanded(
                child: Text(title, style: AppText.headline.copyWith(color: fg)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: back ? Gap.l : 0, top: 2),
            child: Text(
              subtitle,
              style: AppText.caption.copyWith(
                color: fg.withValues(alpha: 0.85),
              ),
            ),
          ),
          const SizedBox(height: Gap.m),
          Padding(
            padding: EdgeInsets.only(left: back ? Gap.m : 0),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: AppText.body.copyWith(color: AppColors.ink),
              decoration: InputDecoration(
                hintText: t.duaSearchHint,
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.muted),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (_, v, _) => v.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.muted,
                          ),
                          onPressed: () {
                            controller.clear();
                            onChanged('');
                          },
                        ),
                ),
                filled: true,
                fillColor: AppColors.field,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.pill),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.pill),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: lightSky ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: colors == null
          ? IslamicPattern(child: content)
          : DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors![0], colors![1]],
                ),
              ),
              child: content,
            ),
    );
  }
}

/// Dua tab: five cards for the parts of the day, and a search across all
/// duas.
class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  final _search = TextEditingController();
  final _audio = _DuaAudio();
  String _q = '';

  @override
  void dispose() {
    _search.dispose();
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Scaffold(
      body: Column(
        children: [
          _SearchHeader(
            title: t.tabDua,
            subtitle: t.duaHeader,
            controller: _search,
            onChanged: (v) => setState(() => _q = _norm(v.trim())),
          ),
          Expanded(
            child: FutureBuilder<List<DuaScene>>(
              future: _scenes,
              builder: (context, snap) {
                if (!snap.hasData) return const Loader();
                final scenes = snap.data!;
                if (_q.isNotEmpty) {
                  return _SearchResults(
                    scenes: scenes,
                    q: _q,
                    raw: _search.text,
                    audio: _audio,
                  );
                }
                final now = partNow();
                return RefreshList(
                  onRefresh: () =>
                      Future<void>.delayed(const Duration(milliseconds: 500)),
                  padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, 120),
                  children: [
                    Text(
                      t.duaSub,
                      style: AppText.body.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: Gap.l),
                    for (final p in DayPart.values) ...[
                      _PartCard(
                        part: p,
                        isNow: p == now,
                        scenes: [
                          for (final s in scenes)
                            if (partOf[s.id] == p) s,
                        ],
                      ),
                      const SizedBox(height: Gap.m),
                    ],
                    const SizedBox(height: Gap.s),
                    Text(
                      t.duaCredit,
                      textAlign: TextAlign.center,
                      style: AppText.micro.copyWith(color: AppColors.muted),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A part of the day as a sky card: name, what it covers, topic and dua
/// counts, and the topic icons.
class _PartCard extends StatelessWidget {
  const _PartCard({
    required this.part,
    required this.isNow,
    required this.scenes,
  });

  final DayPart part;
  final bool isNow;
  final List<DuaScene> scenes;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final dark = _darkSky(part);
    final fg = dark ? Colors.white : AppColors.inkDeep;
    final duas = scenes.fold(0, (a, s) => a + s.duas.length);
    return Material(
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      elevation: isNow ? 6 : 1,
      shadowColor: isNow ? AppColors.gold : Colors.black26,
      child: InkWell(
        onTap: () => push(context, DuaPartScreen(part: part, scenes: scenes)),
        child: SizedBox(
          height: 132,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _skies[part]!,
                  ),
                ),
              ),
              CustomPaint(painter: SkyPainter(part)),
              if (isNow)
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Radii.card),
                    border: Border.all(color: AppColors.goldLight, width: 2),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(Gap.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          partName(t, part),
                          style: AppText.headline.copyWith(
                            color: fg,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Gap.s),
                        if (isNow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
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
                        const Spacer(),
                        Icon(Icons.chevron_right_rounded, color: fg),
                      ],
                    ),
                    Text(
                      _partSub(t, part),
                      style: AppText.caption.copyWith(
                        color: fg.withValues(alpha: 0.9),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(Radii.pill),
                          ),
                          child: Text(
                            t.duaPartCount(
                              f.digits(scenes.length),
                              f.digits(duas),
                            ),
                            style: AppText.micro.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

/// One part of the day: its topics as collapsible sections, with search.
class DuaPartScreen extends StatefulWidget {
  const DuaPartScreen({super.key, required this.part, required this.scenes});

  final DayPart part;
  final List<DuaScene> scenes;

  @override
  State<DuaPartScreen> createState() => _DuaPartScreenState();
}

class _DuaPartScreenState extends State<DuaPartScreen> {
  final _search = TextEditingController();
  final _audio = _DuaAudio();
  String _q = '';

  @override
  void dispose() {
    _search.dispose();
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final duas = widget.scenes.fold(0, (a, s) => a + s.duas.length);
    // While searching: topics whose name/story match show all their duas;
    // otherwise only matching duas are kept, and the sections open.
    final shown = _filter(t, widget.scenes, _q);
    return Scaffold(
      body: Column(
        children: [
          _SearchHeader(
            title: partName(t, widget.part),
            subtitle:
                '${_partSub(t, widget.part)} · ${t.duaPartCount(f.digits(widget.scenes.length), f.digits(duas))}',
            controller: _search,
            onChanged: (v) => setState(() => _q = _norm(v.trim())),
            back: true,
            colors: _skies[widget.part],
            lightSky: !_darkSky(widget.part),
          ),
          Expanded(
            child: shown.isEmpty
                ? EmptyState(
                    message: t.duaNoResults(_search.text.trim()),
                    icon: Icons.search_off_rounded,
                  )
                : RefreshList(
                    onRefresh: () =>
                        Future<void>.delayed(const Duration(milliseconds: 500)),
                    padding: const EdgeInsets.fromLTRB(
                      Gap.l,
                      Gap.l,
                      Gap.l,
                      Gap.xxl,
                    ),
                    children: [
                      for (final (s, list) in shown) ...[
                        _TopicTile(
                          key: ValueKey('${s.id}-${_q.isNotEmpty}'),
                          scene: s,
                          duas: list,
                          initiallyExpanded: _q.isNotEmpty,
                          audio: _audio,
                        ),
                        const SizedBox(height: Gap.m),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// A topic ("Eating", "Travel"…) that expands to show its duas.
class _TopicTile extends StatelessWidget {
  const _TopicTile({
    super.key,
    required this.scene,
    required this.duas,
    required this.initiallyExpanded,
    required this.audio,
  });

  final DuaScene scene;
  final List<Dua> duas;
  final bool initiallyExpanded;
  final _DuaAudio audio;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.m, Gap.s),
          childrenPadding: const EdgeInsets.fromLTRB(Gap.s, 0, Gap.s, Gap.s),
          iconColor: AppColors.gold,
          collapsedIconColor: AppColors.muted,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withValues(alpha: 0.12),
            ),
            child: Icon(
              sceneIcon[scene.id] ?? Icons.auto_awesome,
              color: AppColors.gold,
              size: 22,
            ),
          ),
          title: Text(sceneTitle(t, scene.id), style: AppText.label),
          subtitle: Text(
            '${sceneStory(t, scene.id)}\n${t.duaCount(duas.length)}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppText.micro.copyWith(color: AppColors.muted),
          ),
          children: [
            for (final d in duas)
              Padding(
                padding: const EdgeInsets.only(top: Gap.s),
                child: ValueListenableBuilder(
                  valueListenable: audio.playing,
                  builder: (_, playing, _) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(Radii.card),
                    ),
                    child: DuaCard(
                      dua: d,
                      playing: playing == d.n,
                      onPlay: () => audio.toggle(d),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Search across every part of the day, grouped by topic.
class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.scenes,
    required this.q,
    required this.raw,
    required this.audio,
  });

  final List<DuaScene> scenes;
  final String q;
  final String raw;
  final _DuaAudio audio;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final hits = _filter(t, scenes, q);
    if (hits.isEmpty) {
      return EmptyState(
        message: t.duaNoResults(raw.trim()),
        icon: Icons.search_off_rounded,
      );
    }
    final count = hits.fold(0, (a, h) => a + h.$2.length);
    return ListView(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, 120),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Text(
          t.duaResults(count),
          style: AppText.caption.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: Gap.m),
        for (final (s, list) in hits) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4),
            child: Text(
              partName(t, partOf[s.id] ?? DayPart.day).toUpperCase(),
              style: AppText.micro.copyWith(
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          _TopicTile(
            key: ValueKey('search-${s.id}'),
            scene: s,
            duas: list,
            initiallyExpanded: true,
            audio: audio,
          ),
          const SizedBox(height: Gap.m),
        ],
      ],
    );
  }
}

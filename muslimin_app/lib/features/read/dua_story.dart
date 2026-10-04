import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';

/// One dua from Hisn al-Muslim (see tool/build_duas.py).
class Dua {
  Dua.fromJson(Map<String, dynamic> j)
    : n = j['n'] as int,
      ar = j['ar'] as String,
      tr = j['tr'] as String,
      en = j['en'] as String,
      bn = j['bn'] as String,
      refBn = j['ref_bn'] as String,
      refEn = j['ref_en'] as String,
      repeat = (j['repeat'] as num?)?.toInt() ?? 1,
      audio = (j['audio'] as String).replaceFirst('http://', 'https://');

  final int n;
  final String ar;
  final String tr;
  final String en;
  final String bn;
  final String refBn;
  final String refEn;
  final int repeat;
  final String audio;
}

class DuaScene {
  DuaScene(this.id, this.duas);
  final String id;
  final List<Dua> duas;
}

enum DayPart { dawn, morning, day, evening, night }

const _partOf = {
  'wake': DayPart.dawn,
  'restroom': DayPart.dawn,
  'wudu': DayPart.dawn,
  'dress': DayPart.dawn,
  'athan': DayPart.dawn,
  'masjid': DayPart.dawn,
  'after_salah': DayPart.dawn,
  'morning': DayPart.morning,
  'eating': DayPart.morning,
  'leave_home': DayPart.morning,
  'travel': DayPart.morning,
  'meeting': DayPart.day,
  'good_news': DayPart.day,
  'hardship': DayPart.day,
  'patience': DayPart.day,
  'anger': DayPart.day,
  'pain': DayPart.day,
  'rain': DayPart.day,
  'home': DayPart.evening,
  'gathering': DayPart.evening,
  'forgiveness': DayPart.evening,
  'sleep': DayPart.night,
  'night': DayPart.night,
};

const _sceneIcon = {
  'wake': Icons.wb_twilight_rounded,
  'restroom': Icons.door_front_door_outlined,
  'wudu': Icons.water_drop_outlined,
  'dress': Icons.checkroom_rounded,
  'athan': Icons.campaign_outlined,
  'masjid': Icons.mosque_outlined,
  'after_salah': Icons.self_improvement_rounded,
  'morning': Icons.wb_sunny_outlined,
  'eating': Icons.restaurant_rounded,
  'leave_home': Icons.logout_rounded,
  'travel': Icons.directions_bus_outlined,
  'meeting': Icons.handshake_outlined,
  'good_news': Icons.celebration_outlined,
  'hardship': Icons.landscape_outlined,
  'patience': Icons.spa_outlined,
  'anger': Icons.local_fire_department_outlined,
  'pain': Icons.healing_outlined,
  'rain': Icons.water_outlined,
  'home': Icons.home_outlined,
  'gathering': Icons.groups_outlined,
  'forgiveness': Icons.volunteer_activism_outlined,
  'sleep': Icons.bedtime_outlined,
  'night': Icons.nights_stay_outlined,
};

DayPart _partNow() {
  final h = DateTime.now().hour;
  if (h >= 3 && h < 6) return DayPart.dawn;
  if (h >= 6 && h < 11) return DayPart.morning;
  if (h >= 11 && h < 17) return DayPart.day;
  if (h >= 17 && h < 20) return DayPart.evening;
  return DayPart.night;
}

Future<List<DuaScene>> _loadScenes() async {
  final raw = await rootBundle.loadString('assets/duas/duas.json');
  final j = jsonDecode(raw) as Map<String, dynamic>;
  return [
    for (final s in (j['scenes'] as List).cast<Map<String, dynamic>>())
      DuaScene(s['id'] as String, [
        for (final d in (s['duas'] as List).cast<Map<String, dynamic>>())
          Dua.fromJson(d),
      ]),
  ];
}

/// "A day with the remembrance of Allah": from waking up to sleeping, each
/// moment of the day with the duas taught for it, told as one story.
class DuaStory extends StatefulWidget {
  const DuaStory({super.key});

  @override
  State<DuaStory> createState() => _DuaStoryState();
}

class _DuaStoryState extends State<DuaStory> {
  late final Future<List<DuaScene>> _scenes = _loadScenes();
  final _player = AudioPlayer();
  final _scroll = ScrollController();
  final _list = ListController();
  int? _playing;
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed && mounted) {
        setState(() => _playing = null);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _play(Dua d) async {
    if (_playing == d.n) {
      await _player.stop();
      setState(() => _playing = null);
      return;
    }
    setState(() => _playing = d.n);
    try {
      await _player.setUrl(d.audio);
      await _player.play();
    } catch (_) {
      if (mounted) setState(() => _playing = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return FutureBuilder<List<DuaScene>>(
      future: _scenes,
      builder: (context, snap) {
        if (!snap.hasData) return const Loader();
        final scenes = snap.data!;
        final now = _partNow();
        final children = <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, 0),
            child: Text(
              t.duaSub,
              style: AppText.body.copyWith(color: AppColors.muted),
            ),
          ),
        ];
        DayPart? part;
        int? nowIndex;
        for (final (i, sc) in scenes.indexed) {
          final p = _partOf[sc.id] ?? DayPart.day;
          if (p != part) {
            part = p;
            if (p == now) nowIndex = children.length;
            children.add(_SkyBanner(part: p, isNow: p == now));
          }
          children.add(
            _SceneBlock(
              scene: sc,
              last: i == scenes.length - 1,
              playing: _playing,
              onPlay: _play,
            ),
          );
        }
        children.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.l, Gap.xl, 120),
            child: Text(
              t.duaCredit,
              textAlign: TextAlign.center,
              style: AppText.micro.copyWith(color: AppColors.muted),
            ),
          ),
        );
        // Open at the part of the day it is now.
        if (!_scrolled && nowIndex != null && now != DayPart.dawn) {
          _scrolled = true;
          final target = nowIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_list.isAttached || !_scroll.hasClients) return;
            _list.animateToItem(
              index: target,
              scrollController: _scroll,
              alignment: 0,
              duration: (_) => const Duration(milliseconds: 800),
              curve: (_) => Curves.easeOutCubic,
            );
          });
        }
        return CustomScrollView(
          controller: _scroll,
          slivers: [
            PullToRefresh(
              onRefresh: () =>
                  Future<void>.delayed(const Duration(milliseconds: 500)),
            ),
            SuperSliverList.list(listController: _list, children: children),
          ],
        );
      },
    );
  }
}

/// Sky for a part of the day: gradient, sun or moon at its height, stars at
/// night, and the part's name.
class _SkyBanner extends StatelessWidget {
  const _SkyBanner({required this.part, required this.isNow});

  final DayPart part;
  final bool isNow;

  static const _skies = {
    DayPart.dawn: [Color(0xFF2B3A67), Color(0xFFE88D72), Color(0xFFFFD39A)],
    DayPart.morning: [Color(0xFF7EC8E3), Color(0xFFBFE6F2), Color(0xFFFFF1C9)],
    DayPart.day: [Color(0xFF3FA7D6), Color(0xFF8ED1EE), Color(0xFFDDF3FB)],
    DayPart.evening: [Color(0xFF3B2A5C), Color(0xFFC0566B), Color(0xFFF7A35C)],
    DayPart.night: [Color(0xFF020B1A), Color(0xFF0C2234), Color(0xFF173A4A)],
  };

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final label = switch (part) {
      DayPart.dawn => t.part_dawn,
      DayPart.morning => t.part_morning,
      DayPart.day => t.part_day,
      DayPart.evening => t.part_evening,
      DayPart.night => t.part_night,
    };
    final dark =
        part == DayPart.night ||
        part == DayPart.dawn ||
        part == DayPart.evening;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.s),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.card),
        child: SizedBox(
          height: 96,
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
              CustomPaint(painter: _SkyPainter(part)),
              Padding(
                padding: const EdgeInsets.all(Gap.l),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppText.headline.copyWith(
                        color: dark ? Colors.white : AppColors.inkDeep,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (isNow)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkyPainter extends CustomPainter {
  _SkyPainter(this.part);
  final DayPart part;

  @override
  void paint(Canvas canvas, Size s) {
    final r = math.Random(part.index * 7 + 3);
    if (part == DayPart.night || part == DayPart.dawn) {
      final star = Paint()..color = Colors.white;
      for (var i = 0; i < (part == DayPart.night ? 28 : 10); i++) {
        star.color = Colors.white.withValues(alpha: 0.3 + r.nextDouble() * 0.6);
        canvas.drawCircle(
          Offset(r.nextDouble() * s.width, r.nextDouble() * s.height * 0.7),
          0.6 + r.nextDouble() * 1.2,
          star,
        );
      }
    }
    // Sun / moon position across the day.
    final (dx, dy) = switch (part) {
      DayPart.dawn => (0.82, 0.95),
      DayPart.morning => (0.78, 0.45),
      DayPart.day => (0.62, 0.22),
      DayPart.evening => (0.84, 0.9),
      DayPart.night => (0.8, 0.32),
    };
    final c = Offset(s.width * dx, s.height * dy);
    if (part == DayPart.night) {
      final moon = Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: c, radius: 16)),
        Path()
          ..addOval(Rect.fromCircle(center: c.translate(7, -4), radius: 14)),
      );
      canvas.drawPath(
        moon,
        Paint()
          ..color = const Color(0xFFFFE9A8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4),
      );
    } else {
      canvas.drawCircle(
        c,
        34,
        Paint()..color = const Color(0xFFFFE08A).withValues(alpha: 0.25),
      );
      canvas.drawCircle(
        c,
        18,
        Paint()
          ..color = const Color(0xFFFFD25E)
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3),
      );
    }
    // Skyline of minarets and domes along the bottom.
    final city = Paint()
      ..color = (part == DayPart.day || part == DayPart.morning)
          ? const Color(0x33002828)
          : const Color(0x66000000);
    final base = s.height;
    final path = Path()..moveTo(0, base);
    var x = 0.0;
    while (x < s.width) {
      final w = 18 + r.nextDouble() * 26;
      final h = 10 + r.nextDouble() * 16;
      path.lineTo(x, base - h);
      if (r.nextBool()) {
        path.quadraticBezierTo(x + w / 2, base - h - 14, x + w, base - h);
      } else {
        path.lineTo(x + w * 0.45, base - h);
        path.lineTo(x + w * 0.45, base - h - 20);
        path.lineTo(x + w * 0.55, base - h - 24);
        path.lineTo(x + w * 0.65, base - h - 20);
        path.lineTo(x + w * 0.65, base - h);
        path.lineTo(x + w, base - h);
      }
      x += w;
    }
    path
      ..lineTo(s.width, base)
      ..close();
    canvas.drawPath(path, city);
  }

  @override
  bool shouldRepaint(_SkyPainter old) => old.part != part;
}

/// A moment of the day on the timeline: icon on the gold rail, the story
/// line, and its duas.
class _SceneBlock extends StatelessWidget {
  const _SceneBlock({
    required this.scene,
    required this.last,
    required this.playing,
    required this.onPlay,
  });

  final DuaScene scene;
  final bool last;
  final int? playing;
  final void Function(Dua) onPlay;

  String _title(L10n t) => switch (scene.id) {
    'wake' => t.scene_wake,
    'restroom' => t.scene_restroom,
    'wudu' => t.scene_wudu,
    'dress' => t.scene_dress,
    'athan' => t.scene_athan,
    'masjid' => t.scene_masjid,
    'after_salah' => t.scene_after_salah,
    'morning' => t.scene_morning,
    'eating' => t.scene_eating,
    'leave_home' => t.scene_leave_home,
    'travel' => t.scene_travel,
    'meeting' => t.scene_meeting,
    'good_news' => t.scene_good_news,
    'hardship' => t.scene_hardship,
    'patience' => t.scene_patience,
    'anger' => t.scene_anger,
    'pain' => t.scene_pain,
    'rain' => t.scene_rain,
    'home' => t.scene_home,
    'gathering' => t.scene_gathering,
    'forgiveness' => t.scene_forgiveness,
    'sleep' => t.scene_sleep,
    _ => t.scene_night,
  };

  String _story(L10n t) => switch (scene.id) {
    'wake' => t.scene_wake_story,
    'restroom' => t.scene_restroom_story,
    'wudu' => t.scene_wudu_story,
    'dress' => t.scene_dress_story,
    'athan' => t.scene_athan_story,
    'masjid' => t.scene_masjid_story,
    'after_salah' => t.scene_after_salah_story,
    'morning' => t.scene_morning_story,
    'eating' => t.scene_eating_story,
    'leave_home' => t.scene_leave_home_story,
    'travel' => t.scene_travel_story,
    'meeting' => t.scene_meeting_story,
    'good_news' => t.scene_good_news_story,
    'hardship' => t.scene_hardship_story,
    'patience' => t.scene_patience_story,
    'anger' => t.scene_anger_story,
    'pain' => t.scene_pain_story,
    'rain' => t.scene_rain_story,
    'home' => t.scene_home_story,
    'gathering' => t.scene_gathering_story,
    'forgiveness' => t.scene_forgiveness_story,
    'sleep' => t.scene_sleep_story,
    _ => t.scene_night_story,
  };

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline rail.
          SizedBox(
            width: 56,
            child: Column(
              children: [
                const SizedBox(height: Gap.l),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card,
                    border: Border.all(color: AppColors.gold, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    _sceneIcon[scene.id] ?? Icons.auto_awesome,
                    size: 18,
                    color: AppColors.gold,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.gold.withValues(alpha: 0.6),
                          AppColors.gold.withValues(alpha: last ? 0 : 0.25),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, Gap.l, Gap.l, Gap.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_title(t), style: AppText.subtitle),
                  const SizedBox(height: 2),
                  Text(
                    _story(t),
                    style: AppText.body.copyWith(
                      color: AppColors.muted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: Gap.m),
                  for (final d in scene.duas) ...[
                    _DuaCard(
                      dua: d,
                      playing: playing == d.n,
                      onPlay: () => onPlay(d),
                    ),
                    const SizedBox(height: Gap.m),
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

class _DuaCard extends StatefulWidget {
  const _DuaCard({
    required this.dua,
    required this.playing,
    required this.onPlay,
  });

  final Dua dua;
  final bool playing;
  final VoidCallback onPlay;

  @override
  State<_DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<_DuaCard> {
  bool _source = false;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final d = widget.dua;
    final meaning = f.isBn && d.bn.isNotEmpty ? d.bn : d.en;
    final ref = f.isBn ? d.refBn : d.refEn;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(
          color: widget.playing ? AppColors.gold : Colors.transparent,
          width: 1.4,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.s, Gap.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (d.repeat > 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                  child: Text(
                    t.repeatTimes(f.digits(d.repeat)),
                    style: AppText.micro.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Spacer(),
              IconButton(
                onPressed: widget.onPlay,
                icon: Icon(
                  widget.playing
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_rounded,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: Gap.s),
            child: Text(
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
          ),
          if (!f.isBn && d.tr.isNotEmpty) ...[
            const SizedBox(height: Gap.s),
            Text(
              d.tr,
              style: AppText.caption.copyWith(
                color: AppColors.gold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: Gap.s),
          Padding(
            padding: const EdgeInsets.only(right: Gap.s),
            child: Text(meaning, style: AppText.body.copyWith(height: 1.5)),
          ),
          const SizedBox(height: Gap.s),
          InkWell(
            borderRadius: BorderRadius.circular(Radii.button),
            onTap: () => setState(() => _source = !_source),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 14,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      [
                        t.duaSource(f.digits(d.n)),
                        if (!f.isBn && ref.isNotEmpty) ref,
                      ].join(' · '),
                      style: AppText.micro.copyWith(color: AppColors.muted),
                    ),
                  ),
                  if (f.isBn && ref.isNotEmpty)
                    Icon(
                      _source
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: 18,
                      color: AppColors.muted,
                    ),
                ],
              ),
            ),
          ),
          if (_source && f.isBn && ref.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: Gap.s, top: 2),
              child: Text(
                ref,
                style: AppText.micro.copyWith(color: AppColors.muted),
              ),
            ),
        ],
      ),
    );
  }
}

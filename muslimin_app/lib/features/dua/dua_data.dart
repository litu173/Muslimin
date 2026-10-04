import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../l10n/app_localizations.dart';

/// One dua from Hisn al-Muslim (see tool/build_duas.py).
class Dua {
  Dua.fromJson(Map<String, dynamic> j)
    : n = j['n'] as int,
      // The book wraps hadith wording in (( )) – drop the marks for display.
      ar = (j['ar'] as String).replaceAll('((', '').replaceAll('))', '').trim(),
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

const partOf = {
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

const sceneIcon = {
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

DayPart partNow() {
  final h = DateTime.now().hour;
  if (h >= 3 && h < 6) return DayPart.dawn;
  if (h >= 6 && h < 11) return DayPart.morning;
  if (h >= 11 && h < 17) return DayPart.day;
  if (h >= 17 && h < 20) return DayPart.evening;
  return DayPart.night;
}

Future<List<DuaScene>> loadDuaScenes() async {
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
String sceneTitle(L10n t, String id) => switch (id) {
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

String sceneStory(L10n t, String id) => switch (id) {
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

class SkyPainter extends CustomPainter {
  SkyPainter(this.part);
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
  bool shouldRepaint(SkyPainter old) => old.part != part;
}

class DuaCard extends StatefulWidget {
  const DuaCard({
    super.key,
    required this.dua,
    required this.playing,
    required this.onPlay,
  });

  final Dua dua;
  final bool playing;
  final VoidCallback onPlay;

  @override
  State<DuaCard> createState() => DuaCardState();
}

class DuaCardState extends State<DuaCard> {
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

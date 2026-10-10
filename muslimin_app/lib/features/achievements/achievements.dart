import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/page_header.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/quran.dart';
import '../read/read_widgets.dart';

const _icons = <String, IconData>{
  'auto_stories': Icons.auto_stories_rounded,
  'menu_book': Icons.menu_book_rounded,
  'shield': Icons.shield_rounded,
  'local_fire_department': Icons.local_fire_department_rounded,
  'whatshot': Icons.whatshot_rounded,
  'brightness_7': Icons.brightness_7_rounded,
  'format_list_numbered': Icons.format_list_numbered_rounded,
  'military_tech': Icons.military_tech_rounded,
  'wb_sunny': Icons.wb_sunny_rounded,
  'nights_stay': Icons.nights_stay_rounded,
  'favorite': Icons.favorite_rounded,
  'headphones': Icons.headphones_rounded,
  'emoji_events': Icons.emoji_events_rounded,
  'star': Icons.star_rounded,
  'route': Icons.route_rounded,
  'workspace_premium': Icons.workspace_premium_rounded,
};

String achievementName(L10n t, String id) => switch (id) {
  'bismillah' => t.ach_bismillah,
  'fatiha' => t.ach_fatiha,
  'quls' => t.ach_quls,
  'streak3' => t.ach_streak3,
  'streak7' => t.ach_streak7,
  'streak30' => t.ach_streak30,
  'verses100' => t.ach_verses100,
  'verses1000' => t.ach_verses1000,
  'kahf' => t.ach_kahf,
  'mulk' => t.ach_mulk,
  'yasin' => t.ach_yasin,
  'listener' => t.ach_listener,
  'quiz100' => t.ach_quiz100,
  'juzamma' => t.ach_juzamma,
  'phases10' => t.ach_phases10,
  _ => t.ach_khatm,
};

String achievementDesc(L10n t, String id) => switch (id) {
  'bismillah' => t.ach_bismillah_desc,
  'fatiha' => t.ach_fatiha_desc,
  'quls' => t.ach_quls_desc,
  'streak3' => t.ach_streak3_desc,
  'streak7' => t.ach_streak7_desc,
  'streak30' => t.ach_streak30_desc,
  'verses100' => t.ach_verses100_desc,
  'verses1000' => t.ach_verses1000_desc,
  'kahf' => t.ach_kahf_desc,
  'mulk' => t.ach_mulk_desc,
  'yasin' => t.ach_yasin_desc,
  'listener' => t.ach_listener_desc,
  'quiz100' => t.ach_quiz100_desc,
  'juzamma' => t.ach_juzamma_desc,
  'phases10' => t.ach_phases10_desc,
  _ => t.ach_khatm_desc,
};

/// Shown when an achievement is earned.
void showAchievementToast(BuildContext context, String id) {
  final t = L10n.of(context);
  final a = kAchievements.firstWhere((x) => x.id == id);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.header,
      duration: const Duration(seconds: 4),
      content: Row(
        children: [
          AchievementMedal(achievement: a, earned: true, value: 1, size: 40),
          const SizedBox(width: Gap.m),
          Expanded(
            child: Text(
              t.achievementUnlocked(achievementName(t, id)),
              style: AppText.label.copyWith(color: AppColors.onHeader),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Eight-point-star medal. Earned: gold with a soft glow. In progress: grey
/// star with a gold progress ring around it.
class AchievementMedal extends StatelessWidget {
  const AchievementMedal({
    super.key,
    required this.achievement,
    required this.earned,
    required this.value,
    this.size = 64,
  });

  final Achievement achievement;
  final bool earned;

  /// Progress 0…1.
  final double value;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (!earned)
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(value, AppColors.gold, AppColors.divider),
          ),
        Container(
          width: size * (earned ? 1 : 0.78),
          height: size * (earned ? 1 : 0.78),
          decoration: ShapeDecoration(
            gradient: earned
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFE08A),
                      Color(0xFFE2B33C),
                      Color(0xFFBB8907),
                    ],
                  )
                : null,
            color: earned ? null : AppColors.pill,
            shape: StarShapeBorder(
              inner: 0.86,
              side: BorderSide(
                color: earned ? const Color(0xFFFFF3C4) : AppColors.divider,
                width: 1.2,
              ),
            ),
            shadows: earned
                ? [
                    BoxShadow(
                      color: const Color(0xFFE2B33C).withValues(alpha: 0.45),
                      blurRadius: size * 0.2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            _icons[achievement.icon] ?? Icons.star_rounded,
            size: size * (earned ? 0.42 : 0.34),
            color: earned ? Colors.white : AppColors.muted,
          ),
        ),
      ],
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color, this.track);
  final double value;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size s) {
    final rect = Offset.zero & s;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect.deflate(2), 0, 2 * math.pi, false, p..color = track);
    if (value > 0) {
      canvas.drawArc(
        rect.deflate(2),
        -math.pi / 2,
        2 * math.pi * value.clamp(0.0, 1.0),
        false,
        p..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}

/// Earned achievements first (newest first), then the closest to earning.
List<Achievement> _ordered(QuranProgress p) {
  final earned =
      kAchievements.where((a) => p.achievedAt.containsKey(a.id)).toList()
        ..sort((a, b) => p.achievedAt[b.id]!.compareTo(p.achievedAt[a.id]!));
  final rest =
      kAchievements.where((a) => !p.achievedAt.containsKey(a.id)).toList()
        ..sort(
          (a, b) =>
              (b.progress(p) / b.target).compareTo(a.progress(p) / a.target),
        );
  return [...earned, ...rest];
}

/// Card on the More page, under the profile card.
class AchievementsCard extends ConsumerWidget {
  const AchievementsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final p = ref.watch(quranProgressProvider);
    final list = _ordered(p).take(5).toList();
    final count = p.achievedAt.length;
    return AppCard(
      onTap: () => push(context, const AchievementsScreen()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: AppColors.gold),
              const SizedBox(width: Gap.s),
              Expanded(child: Text(t.achievements, style: AppText.subtitle)),
              Text(
                t.achievementsCount(
                  f.digits(count),
                  f.digits(kAchievements.length),
                ),
                style: AppText.caption.copyWith(color: AppColors.muted),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: Gap.m),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count / kAchievements.length,
              minHeight: 6,
              color: AppColors.gold,
              backgroundColor: AppColors.gold.withValues(alpha: 0.12),
            ),
          ),
          const SizedBox(height: Gap.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final a in list)
                Column(
                  children: [
                    AchievementMedal(
                      achievement: a,
                      earned: p.achievedAt.containsKey(a.id),
                      value: a.progress(p) / a.target,
                      size: 52,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 60,
                      child: Text(
                        achievementName(t, a.id),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.micro,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  void _details(BuildContext context, Achievement a, QuranProgress p) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final earnedAt = p.achievedAt[a.id];
    final done = a.progress(p).clamp(0, a.target);
    // Full-width sheet from the bottom edge (no side gaps, any screen).
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
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
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: Gap.l),
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.6, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: AchievementMedal(
                achievement: a,
                earned: earnedAt != null,
                value: done / a.target,
                size: 110,
              ),
            ),
            const SizedBox(height: Gap.l),
            Text(achievementName(t, a.id), style: AppText.headline),
            const SizedBox(height: 4),
            Text(
              achievementDesc(t, a.id),
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: Gap.l),
            Text(
              earnedAt != null
                  ? t.achievementEarned(f.date(DateTime.parse(earnedAt)))
                  : t.achievementLocked(f.digits(done), f.digits(a.target)),
              style: AppText.label.copyWith(
                color: earnedAt != null ? AppColors.gold : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final p = ref.watch(quranProgressProvider);
    final list = _ordered(p);
    return Scaffold(
      appBar: PatternAppBar(title: Text(t.achievements)),
      body: RefreshList(
        onRefresh: () =>
            Future<void>.delayed(const Duration(milliseconds: 500)),
        padding: const EdgeInsets.all(Gap.l),
        children: [
          Text(
            t.achievementsCount(
              f.digits(p.achievedAt.length),
              f.digits(kAchievements.length),
            ),
            style: AppText.label,
          ),
          const SizedBox(height: Gap.l),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: Gap.m,
            crossAxisSpacing: Gap.m,
            childAspectRatio: 0.72,
            children: [
              for (final a in list)
                Material(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(Radii.card),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.card),
                    onTap: () => _details(context, a, p),
                    child: Padding(
                      padding: const EdgeInsets.all(Gap.s),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AchievementMedal(
                            achievement: a,
                            earned: p.achievedAt.containsKey(a.id),
                            value: a.progress(p) / a.target,
                          ),
                          const SizedBox(height: Gap.s),
                          Text(
                            achievementName(t, a.id),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.achievedAt.containsKey(a.id)
                                ? f.date(DateTime.parse(p.achievedAt[a.id]!))
                                : '${f.digits(a.progress(p).clamp(0, a.target))}/${f.digits(a.target)}',
                            style: AppText.micro.copyWith(
                              color: p.achievedAt.containsKey(a.id)
                                  ? AppColors.gold
                                  : AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

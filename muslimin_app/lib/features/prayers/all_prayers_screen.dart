import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/page_header.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/frosted_card.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/prayer.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../more/settings_screen.dart';

/// "All Prayers": the day's waqt windows on the frosted slider card,
/// forbidden times on a white card, and the nafl prayers on the page.
class AllPrayersScreen extends ConsumerWidget {
  const AllPrayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final day = ref.watch(todayTimesProvider);
    final waqt = ref.watch(waqtProvider);
    final loc = ref.watch(locationProvider).value;
    final cream = AppColors.onHeader;

    bool isNow(Prayer p) =>
        waqt?.isCurrent == true &&
        (waqt!.prayer == p ||
            (waqt.prayer == Prayer.jumuah && p == Prayer.dhuhr));

    return Scaffold(
      appBar: PatternAppBar(
        toolbarHeight: 68,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.allPrayers, style: AppText.subtitle.copyWith(color: cream)),
            if (loc != null)
              Text(
                loc.label,
                style: AppText.caption.copyWith(
                  color: cream.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: day == null
          ? const Loader()
          : RefreshList(
              onRefresh: () => refreshAll(ref),
              padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.xxl),
              children: [
                // ---- prayer times (same surface as the Home ayah slider)
                FrostedCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Gap.s),
                    child: Column(
                      children: [
                        for (final e in day.windows.entries) ...[
                          _PrayerRow(
                            name: f.prayer(e.key),
                            time: f.range(e.value.start, e.value.end),
                            now: isNow(e.key) ? t.now : null,
                          ),
                          if (e.key != Prayer.isha)
                            Divider(
                              height: 1,
                              indent: Gap.l,
                              endIndent: Gap.l,
                              color: AppColors.gold.withValues(alpha: 0.25),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Gap.l),
                // ---- forbidden times
                AppCard(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.l,
                    Gap.m,
                    Gap.l,
                    Gap.s,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.block_rounded,
                            size: 20,
                            color: AppColors.danger,
                          ),
                          const SizedBox(width: Gap.s),
                          Expanded(
                            child: Text(
                              t.forbiddenTime,
                              style: AppText.subtitle,
                            ),
                          ),
                          Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: t.forbiddenInfo,
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.muted,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Gap.xs),
                      _lightRow(
                        t.morning,
                        f.range(
                          day.forbiddenMorning.start,
                          day.forbiddenMorning.end,
                        ),
                      ),
                      const Divider(height: 1),
                      _lightRow(
                        t.noon,
                        f.range(day.forbiddenNoon.start, day.forbiddenNoon.end),
                      ),
                      const Divider(height: 1),
                      _lightRow(
                        t.evening,
                        f.range(
                          day.forbiddenEvening.start,
                          day.forbiddenEvening.end,
                        ),
                      ),
                    ],
                  ),
                ),
                // ---- nafl, on the page itself
                const SizedBox(height: Gap.xxl),
                Text(t.naflPrayers, style: AppText.title),
                const SizedBox(height: Gap.l),
                _NaflBlock(
                  name: t.tahajjud,
                  time:
                      '${f.timeUpper(day.tahajjud.start)} - ${f.timeUpper(day.tahajjud.end)}',
                  hadith: [(t.tahajjudHadith, t.tahajjudSource)],
                ),
                Divider(height: 48, color: AppColors.divider),
                _NaflBlock(
                  name: t.duha,
                  time:
                      '${f.timeUpper(day.duha.start)} - ${f.timeUpper(day.duha.end)}',
                  hadith: [
                    (t.duhaHadith1, t.duhaSource1),
                    (t.duhaHadith2, t.duhaSource2),
                  ],
                ),
                const SizedBox(height: Gap.xxl),
                Text(
                  t.calcMethodNote,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
              ],
            ),
    );
  }

  Widget _lightRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(child: Text(label, style: AppText.body)),
        Text(value, style: AppText.label),
      ],
    ),
  );
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({required this.name, required this.time, this.now});

  final String name;
  final String time;

  /// "Now" label when this is the current waqt.
  final String? now;

  @override
  Widget build(BuildContext context) {
    final current = now != null;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Gap.s, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: Gap.m, vertical: 14),
      decoration: current
          ? BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(Radii.button),
            )
          : null,
      child: Row(
        children: [
          Text(
            name,
            style: AppText.subtitle.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (current) ...[
            const SizedBox(width: Gap.s),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
              child: Text(
                now!,
                style: AppText.micro.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const Spacer(),
          Text(
            time,
            style: AppText.subtitle.copyWith(
              color: current ? AppColors.gold : AppColors.ink,
              fontWeight: current ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _NaflBlock extends StatelessWidget {
  const _NaflBlock({
    required this.name,
    required this.time,
    required this.hadith,
  });

  final String name;
  final String time;
  final List<(String, String)> hadith;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: AppText.subtitle.copyWith(
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(time, style: AppText.label.copyWith(color: AppColors.gold)),
        ],
      ),
      for (final h in hadith) ...[
        const SizedBox(height: Gap.m),
        // Easy-to-read body size (was a 14 px caption).
        Text(
          h.$1,
          style: AppText.body.copyWith(
            fontSize: 17,
            height: 1.65,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: Gap.s),
        Text(
          '— ${h.$2}',
          style: AppText.caption.copyWith(color: AppColors.muted),
        ),
      ],
    ],
  );
}

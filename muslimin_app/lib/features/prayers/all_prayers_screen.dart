import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/prayer.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../more/settings_screen.dart';

/// Dark "All Prayers" screen: waqt windows, forbidden times and nafl prayers.
class AllPrayersScreen extends ConsumerWidget {
  const AllPrayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final day = ref.watch(todayTimesProvider);
    final waqt = ref.watch(waqtProvider);
    final loc = ref.watch(locationProvider).value;
    final cream = AppColors.cream;

    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(
        toolbarHeight: 68,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.allPrayers,
              style: AppText.subtitle.copyWith(color: cream, fontSize: 22),
            ),
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
          : ListView(
              children: [
                for (final e in day.windows.entries) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Gap.xl,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            f.prayer(e.key),
                            style: AppText.subtitle.copyWith(
                              color: cream,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (waqt?.isCurrent == true &&
                            (waqt!.prayer == e.key ||
                                (waqt.prayer == Prayer.jumuah &&
                                    e.key == Prayer.dhuhr)))
                          Text(
                            t.now,
                            style: AppText.subtitle.copyWith(
                              color: AppColors.goldLight,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          f.range(e.value.start, e.value.end),
                          style: AppText.subtitle.copyWith(color: cream),
                        ),
                      ],
                    ),
                  ),
                  if (e.key != Prayer.isha)
                    Divider(
                      color: cream.withValues(alpha: 0.12),
                      indent: Gap.xl,
                      endIndent: Gap.xl,
                    ),
                ],
                const SizedBox(height: Gap.s),
                // ---- forbidden times (cream panel)
                Container(
                  color: AppColors.cream,
                  padding: const EdgeInsets.fromLTRB(
                    Gap.xl,
                    Gap.l,
                    Gap.xl,
                    Gap.l,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(t.forbiddenTime, style: AppText.body),
                          ),
                          Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: t.forbiddenInfo,
                            child: const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.ink,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      _lightRow(
                        t.morning,
                        f.range(
                          day.forbiddenMorning.start,
                          day.forbiddenMorning.end,
                        ),
                      ),
                      const Divider(),
                      _lightRow(
                        t.noon,
                        f.range(day.forbiddenNoon.start, day.forbiddenNoon.end),
                      ),
                      const Divider(),
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
                // ---- nafl
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.xl,
                    Gap.xxl,
                    Gap.xl,
                    Gap.xxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.naflPrayers,
                        style: AppText.body.copyWith(color: cream),
                      ),
                      const SizedBox(height: Gap.l),
                      _NaflBlock(
                        name: t.tahajjud,
                        time:
                            '${f.timeUpper(day.tahajjud.start)} - ${f.timeUpper(day.tahajjud.end)}',
                        hadith: [(t.tahajjudHadith, t.tahajjudSource)],
                      ),
                      Divider(color: cream.withValues(alpha: 0.12), height: 40),
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
                        style: AppText.caption.copyWith(
                          color: cream.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _lightRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(child: Text(label, style: AppText.body)),
        Text(value, style: AppText.body),
      ],
    ),
  );
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
  Widget build(BuildContext context) {
    const cream = AppColors.cream;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppText.subtitle.copyWith(
                  color: AppColors.goldLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              time,
              style: AppText.subtitle.copyWith(color: AppColors.goldLight),
            ),
          ],
        ),
        for (final h in hadith) ...[
          const SizedBox(height: Gap.m),
          Text(
            h.$1,
            style: AppText.caption.copyWith(color: cream),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: Gap.s),
          Text(
            h.$2,
            style: AppText.caption.copyWith(
              color: cream.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }
}

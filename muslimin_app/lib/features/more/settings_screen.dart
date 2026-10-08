import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/languages.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/page_header.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _methods = {
    'karachi': 'University of Islamic Sciences, Karachi',
    'muslim_world_league': 'Muslim World League',
    'egyptian': 'Egyptian General Authority',
    'umm_al_qura': 'Umm al-Qura, Makkah',
    'dubai': 'Dubai',
    'qatar': 'Qatar',
    'kuwait': 'Kuwait',
    'singapore': 'Singapore',
    'north_america': 'ISNA (North America)',
    'turkey': 'Diyanet, Turkey',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);

    Widget section(String title, Widget child) => Padding(
      padding: const EdgeInsets.only(bottom: Gap.l),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.subtitle),
            const SizedBox(height: Gap.m),
            child,
          ],
        ),
      ),
    );

    Widget chips<T>(
      List<(T, String)> items,
      T selected,
      ValueChanged<T> onTap,
    ) => Wrap(
      spacing: Gap.s,
      runSpacing: Gap.s,
      children: [
        for (final i in items)
          AppChip(
            label: i.$2,
            selected: i.$1 == selected,
            idleColor: AppColors.chipIdle,
            idleTextColor: AppColors.ink,
            onTap: () => onTap(i.$1),
          ),
      ],
    );

    return Scaffold(
      appBar: PatternAppBar(title: Text(t.appSettings)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          section(
            t.language,
            chips(
              [for (final l in kAppLanguages) (l.code, l.nativeName)],
              s.locale.languageCode,
              (code) => n.setLocale(Locale(code)),
            ),
          ),
          section(
            t.appearance,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chips(
                  [
                    (ThemeMode.system, t.themeSystem),
                    (ThemeMode.light, t.themeLight),
                    (ThemeMode.dark, t.themeDark),
                  ],
                  s.themeMode,
                  n.setThemeMode,
                ),
                const SizedBox(height: Gap.s),
                Text(
                  t.appearanceHint,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
          section(
            t.defaultReminder,
            chips(
              [
                for (final m in [15, 30, 45]) (m, t.minsBefore(f.digits(m))),
              ],
              s.defaultReminder,
              n.setDefaultReminder,
            ),
          ),
          section(
            t.asrMethod,
            chips(
              [('hanafi', t.hanafi), ('shafi', t.shafi)],
              s.madhab,
              n.setMadhab,
            ),
          ),
          section(
            t.calcMethod,
            DropdownButton<String>(
              value: s.calcMethod,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              dropdownColor: AppColors.card,
              items: [
                for (final e in _methods.entries)
                  DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value, style: AppText.body),
                  ),
              ],
              onChanged: (v) => v == null ? null : n.setCalcMethod(v),
            ),
          ),
          section(
            t.hijriAdjust,
            chips(
              [
                for (final d in [-2, -1, 0, 1, 2])
                  (d, '${d > 0 ? '+' : ''}${f.digits(d)}'),
              ],
              s.hijriOffset,
              n.setHijriOffset,
            ),
          ),
        ],
      ),
    );
  }
}

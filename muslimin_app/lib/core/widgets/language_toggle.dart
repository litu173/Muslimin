import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../languages.dart';
import '../theme/app_text.dart';
import 'gold_sheet.dart';

/// Opens the language list; picks a new app language.
Future<void> pickLanguage(BuildContext context, WidgetRef ref) async {
  final t = L10n.of(context);
  final current = ref.read(settingsProvider).locale.languageCode;
  final code = await showGoldSheet<String>(
    context,
    icon: Icons.translate_rounded,
    title: t.language,
    selected: current,
    selectedLabel: '✓',
    options: [
      for (final l in kAppLanguages) GoldSheetOption(l.code, l.nativeName),
    ],
  );
  if (code != null) {
    ref.read(settingsProvider.notifier).setLocale(Locale(code));
  }
}

/// Pill showing the current language; tap to choose another. Used on
/// onboarding and the welcome screen so people can choose before signing in.
class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = languageOf(
      ref.watch(settingsProvider.select((s) => s.locale)).languageCode,
    );
    return Semantics(
      button: true,
      label: L10n.of(context).language,
      child: Material(
        color: Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: color)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => pickLanguage(context, ref),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.translate_rounded, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  lang.nativeName,
                  style: AppText.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.expand_more_rounded, size: 16, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

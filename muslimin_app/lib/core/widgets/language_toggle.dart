import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../theme/app_text.dart';

/// Pill that switches between Bangla and English. It shows the language you
/// would switch *to* ("বাংলা" while in English), like the website. Used on
/// onboarding and the welcome screen so people can choose before signing in.
class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bn =
        ref.watch(settingsProvider.select((s) => s.locale)).languageCode ==
        'bn';
    return Semantics(
      button: true,
      label: bn ? 'Switch to English' : 'বাংলায় দেখুন',
      child: Material(
        color: Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: color)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => ref
              .read(settingsProvider.notifier)
              .setLocale(Locale(bn ? 'en' : 'bn')),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 14, 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.translate_rounded, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  bn ? 'English' : 'বাংলা',
                  style: AppText.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                    // Each label in its own script's font.
                    fontFamily: bn ? AppText.latin : AppText.bangla,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

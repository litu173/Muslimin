import 'package:flutter/material.dart';

import '../theme/app_text.dart';

/// The "Muslimin" wordmark.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 42, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // The logo stays Latin in both languages (as in the Bangla Figma frames).
    return Text(
      'Muslimin',
      style: TextStyle(
        fontFamily: AppText.displayLatin,
        fontVariations: AppText.displayVariations,
        fontSize: size,
        height: 1.2,
        color: color,
      ),
    );
  }
}

/// Prayer name in the display face (gold "Duhr" on the home header).
class DisplayText extends StatelessWidget {
  const DisplayText(
    this.text, {
    super.key,
    this.size = 30,
    required this.color,
  });

  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bn = Localizations.localeOf(context).languageCode == 'bn';
    return Text(
      text,
      style: TextStyle(
        fontFamily: bn ? AppText.displayBangla : AppText.displayLatin,
        fontFamilyFallback: const [AppText.displayLatin, AppText.bangla],
        fontVariations: bn ? null : AppText.displayVariations,

        fontSize: size,
        height: 1.15,
        color: color,
      ),
    );
  }
}

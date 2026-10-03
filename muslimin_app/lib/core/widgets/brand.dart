import 'dart:math' as math;

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

/// Small "BETA" tag shown next to the wordmark during the public beta.
class BetaBadge extends StatelessWidget {
  const BetaBadge({super.key, this.color = const Color(0xFFFFC940)});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      'BETA',
      style: TextStyle(
        fontFamily: AppText.latin,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color,
        height: 1.2,
      ),
    ),
  );
}

/// The splash wordmark: letters rise in one after another on a wave, then a
/// gentle ripple runs through the word. Driven by [progress] (0..1).
class WavyWordmark extends StatelessWidget {
  const WavyWordmark({
    super.key,
    required this.progress,
    this.text = 'Muslimin',
    this.size = 46,
    this.color = Colors.white,
  });

  final double progress;
  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final letters = text.characters.toList();
    final n = letters.length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < n; i++)
          Builder(
            builder: (_) {
              // Entrance: each letter starts a little after the previous one.
              const entrySpan = 0.55;
              final start = i / n * (1 - entrySpan) * 0.9;
              final t = ((progress - start) / entrySpan).clamp(0.0, 1.0);
              final eased = Curves.easeOutBack.transform(t);
              // Ripple after all letters have landed.
              final ripplePhase = ((progress - 0.62) / 0.38).clamp(0.0, 1.0);
              final ripple = ripplePhase == 0 || ripplePhase == 1
                  ? 0.0
                  : math.sin((ripplePhase * 2 - i / n) * math.pi * 2) *
                        (1 - ripplePhase) *
                        size *
                        0.12;
              return Opacity(
                opacity: Curves.easeOut.transform(t),
                child: Transform.translate(
                  offset: Offset(0, (1 - eased) * size * 0.7 + ripple),
                  child: Text(
                    letters[i],
                    style: TextStyle(
                      fontFamily: AppText.displayLatin,
                      fontVariations: AppText.displayVariations,
                      fontSize: size,
                      height: 1.2,
                      color: color,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

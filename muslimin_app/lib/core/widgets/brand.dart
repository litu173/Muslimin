import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/prayer.dart';
import '../theme/app_text.dart';
import 'logo_paths.dart';

/// The "Muslimin" wordmark – the logo artwork (assets/brand/logo.svg).
/// [size] is the visual height of the letters.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 42, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/brand/logo.svg',
    height: size * 1.15,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    semanticsLabel: 'Muslimin',
  );
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
    final lang = Localizations.localeOf(context).languageCode;
    final bn = lang == 'bn';
    // Urdu's Nastaliq rises and falls far beyond the line: draw it a bit
    // smaller with room above and below, so it never overlaps what follows.
    final nastaliq = lang == 'ur';
    return Text(
      text,
      style: TextStyle(
        fontFamily: bn ? AppText.displayBangla : AppText.displayLatin,
        fontFamilyFallback: const [AppText.displayLatin, AppText.bangla],
        fontVariations: bn ? null : AppText.displayVariations,

        fontSize: nastaliq ? size * 0.78 : size,
        height: nastaliq ? 1.75 : 1.15,
        leadingDistribution: TextLeadingDistribution.even,
        color: color,
      ),
    );
  }
}

/// Prayer name as the hand-lettered artwork (assets/prayers/*.svg) in
/// English; Bangla keeps the Galada display face via [DisplayText].
/// [size] matches the [DisplayText] font size it replaces.
class PrayerNameArt extends StatelessWidget {
  const PrayerNameArt({
    super.key,
    required this.prayer,
    required this.label,
    this.size = 46,
    required this.color,
  });

  final Prayer prayer;

  /// Localized name (used for Bangla and as the semantics label).
  final String label;
  final double size;
  final Color color;

  // Every artwork shares one coordinate system: letters start at y = 0, the
  // baseline sits at y ≈ 34.5 and descenders reach y ≈ 50. Drawing them all at
  // the same scale keeps cap height and baseline identical across prayers.
  static const _width = {
    Prayer.fajr: 67.0,
    Prayer.dhuhr: 95.0,
    Prayer.asr: 72.0,
    Prayer.maghrib: 162.0,
    Prayer.isha: 86.0,
    Prayer.jumuah: 143.0,
  };
  static const _height = {
    Prayer.fajr: 47.0,
    Prayer.dhuhr: 50.0,
    Prayer.asr: 42.0,
    Prayer.maghrib: 50.0,
    Prayer.isha: 38.0,
    Prayer.jumuah: 46.0,
  };

  @override
  Widget build(BuildContext context) {
    // The lettering artwork spells the English names.
    if (Localizations.localeOf(context).languageCode != 'en') {
      return DisplayText(label, size: size, color: color);
    }
    final scale = size / 42;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: _width[prayer]! * scale,
        // Up to just below the baseline; descenders (g, j) hang over the gap.
        height: 42 * scale,
        // minHeight 0: shorter artworks (Isha) must not inherit the box's
        // tight height, or the layout is invalid and nothing is drawn.
        child: OverflowBox(
          alignment: Alignment.topLeft,
          minHeight: 0,
          maxHeight: _height[prayer]! * scale,
          child: SvgPicture.asset(
            'assets/prayers/${prayer == Prayer.jumuah ? 'jumah' : prayer.name}.svg',
            width: _width[prayer]! * scale,
            height: _height[prayer]! * scale,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            semanticsLabel: label,
          ),
        ),
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
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color,
        height: 1.2,
      ),
    ),
  );
}

/// The splash wordmark: each letter of the logo rises in on a wave, one
/// after another, then stays still. Driven by [progress] (0..1).
class WavyWordmark extends StatelessWidget {
  const WavyWordmark({
    super.key,
    required this.progress,
    this.size = 46,
    this.color = Colors.white,
  });

  final double progress;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final h = size * 1.15;
    final w = h * kLogoViewBox.width / kLogoViewBox.height;
    const n = 8;
    final hex =
        '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          for (var i = 0; i < n; i++)
            Builder(
              builder: (_) {
                const entrySpan = 0.55;
                final start = i / n * (1 - entrySpan) * 0.9;
                final t = ((progress - start) / entrySpan).clamp(0.0, 1.0);
                final eased = Curves.easeOutBack.transform(t);
                return Positioned.fill(
                  child: Opacity(
                    opacity: Curves.easeOut.transform(t),
                    child: Transform.translate(
                      offset: Offset(0, (1 - eased) * h * 0.6),
                      child: SvgPicture.string(
                        '<svg viewBox="0 0 ${kLogoViewBox.width} ${kLogoViewBox.height}" '
                        'xmlns="http://www.w3.org/2000/svg"><path d="${kLogoLetterPaths[i]}" fill="$hex"/></svg>',
                        width: w,
                        height: h,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

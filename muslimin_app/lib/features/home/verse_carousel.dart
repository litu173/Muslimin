import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';

/// Teal ayah banner. Rebuilt in code (instead of the flat image in Figma)
/// so it is crisp, translatable and can rotate between several ayat.
class VerseCarousel extends StatefulWidget {
  const VerseCarousel({super.key});

  @override
  State<VerseCarousel> createState() => _VerseCarouselState();
}

class _VerseCarouselState extends State<VerseCarousel> {
  final _controller = PageController();
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!_controller.hasClients) return;
      _controller.animateToPage(
        (_index + 1) % 3,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final verses = [
      (t.verse1Ar, t.verse1, t.verse1Ref),
      (t.verse2Ar, t.verse2, t.verse2Ref),
      (t.verse3Ar, t.verse3, t.verse3Ref),
    ];
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: verses.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.l),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(Radii.card),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Gap.xl,
                  vertical: Gap.m,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      verses[i].$1,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        fontFamily: AppText.arabic,
                        fontSize: 20,
                        color: AppColors.ink,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      verses[i].$2,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: AppText.subtitle.copyWith(
                        color: AppColors.ink,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      verses[i].$3,
                      style: AppText.micro.copyWith(
                        color: AppColors.ink.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Gap.m),
        Dots(count: verses.length, index: _index),
      ],
    );
  }
}

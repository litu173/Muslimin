import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';

/// Ayah slider on Home. Loops endlessly in both directions (auto-advances
/// every 8 s, and swiping past the last ayah wraps to the first).
class VerseCarousel extends StatefulWidget {
  const VerseCarousel({super.key});

  @override
  State<VerseCarousel> createState() => _VerseCarouselState();
}

class _VerseCarouselState extends State<VerseCarousel> {
  static const _count = 3;

  /// Start far from page 0 so the user can swipe backwards forever too.
  static const _startPage = _count * 1000;

  final _controller = PageController(initialPage: _startPage);
  int _page = _startPage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!_controller.hasClients) return;
      _controller.nextPage(
        duration: const Duration(milliseconds: 600),
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
          height: 184,
          child: NotificationListener<ScrollStartNotification>(
            // A manual swipe resets the auto-advance countdown.
            onNotification: (n) {
              if (n.dragDetails != null) _restartTimer();
              return false;
            },
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) {
                final v = verses[i % _count];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Gap.l),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(Radii.card),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.25),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Gap.xl,
                      vertical: Gap.m,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Long ayat scale down to stay on one line.
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            v.$1,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppText.arabic,
                              fontSize: 24,
                              color: AppColors.gold,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          v.$2,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: AppText.subtitle.copyWith(
                            color: AppColors.ink,
                            fontSize: 17,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          v.$3,
                          style: AppText.micro.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: Gap.m),
        Dots(count: _count, index: _page % _count),
      ],
    );
  }
}

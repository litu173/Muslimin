import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/frosted_card.dart';
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

  late final _lifecycle = AppLifecycleListener(
    onResume: _restartTimer,
    onHide: () => _timer?.cancel(),
  );
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Paused while another tab is shown (see Shell's TickerMode).
    _visible = TickerMode.valuesOf(context).enabled;
    _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (!_visible) return;
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!_controller.hasClients || !_onScreen()) return;
      _controller.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  /// Slides only while the slider is actually in view – it sits at the
  /// bottom of Home, and sliding off-screen would still cost frames.
  bool _onScreen() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return false;
    final top = box.localToGlobal(Offset.zero).dy;
    final screen = MediaQuery.sizeOf(context).height;
    return top < screen && top + box.size.height > 0;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
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
                  child: _VerseCard(arabic: v.$1, text: v.$2, ref: v.$3),
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

/// Ayah card: unlike the plain white cards, a warm gold-to-mint gradient with
/// the header pattern showing through frosted glass.
class _VerseCard extends StatelessWidget {
  const _VerseCard({
    required this.arabic,
    required this.text,
    required this.ref,
  });

  final String arabic;
  final String text;
  final String ref;

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.dark;
    return FrostedCard(
      child: SizedBox.expand(
        child: Padding(
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
                  arabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppText.arabic,
                    fontSize: 24,
                    color: dark ? AppColors.goldLight : AppColors.gold,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: AppText.subtitle.copyWith(
                  color: AppColors.ink,
                  fontSize: 17,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Text(ref, style: AppText.micro.copyWith(color: AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}

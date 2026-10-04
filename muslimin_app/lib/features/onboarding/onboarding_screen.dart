import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/countdown_ring.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/surfaces.dart';
import '../../core/utils/format.dart';
import '../../data/models/prayer.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../auth/welcome_screen.dart';
import '../permissions/permission_gate.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  void _finish() {
    ref.read(prefsProvider).onboardingDone = true;
    pushReplacement(context, const AuthGate(child: PermissionGate()));
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final pages = <(Widget, String, String)>[
      (
        Image.asset('assets/images/onboard_mosque.png', height: 220),
        t.onb1Title,
        t.onb1Body,
      ),
      (
        Image.asset('assets/images/onboard_megaphone.png', height: 220),
        t.onb2Title,
        t.onb2Body,
      ),
      (const _PrayerIllustration(), t.onb3Title, t.onb3Body),
    ];
    final last = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: SheetCard(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _page,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => OnboardingPage(
                    illustration: pages[i].$1,
                    title: pages[i].$2,
                    body: pages[i].$3,
                  ),
                ),
              ),
              Dots(count: pages.length, index: _index),
              const SizedBox(height: Gap.xxl),
              Padding(
                padding: const EdgeInsets.fromLTRB(Gap.xl, 0, Gap.xl, Gap.xl),
                child: last
                    ? AppButton(t.getStarted, onPressed: _finish, expand: true)
                    : ButtonPair(
                        secondary: AppButton(
                          t.skip,
                          style: AppButtonStyle.outlined,
                          onPressed: _finish,
                        ),
                        primary: AppButton(
                          t.next,
                          onPressed: () => _page.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Illustration + centred title/body. Reused by the permission screen.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.illustration,
    required this.title,
    required this.body,
  });

  final Widget illustration;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: c.maxHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 220, child: Center(child: illustration)),
              const SizedBox(height: Gap.xxl * 2),
              Text(title, style: AppText.headline, textAlign: TextAlign.center),
              const SizedBox(height: Gap.m),
              Text(body, style: AppText.body, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Third onboarding illustration, built from the app's own pieces: the
/// patterned header and countdown ring.
class _PrayerIllustration extends StatelessWidget {
  const _PrayerIllustration();

  @override
  Widget build(BuildContext context) {
    final f = Fmt.of(context);
    return ClipOval(
      child: SizedBox.square(
        dimension: 210,
        child: IslamicPattern(
          child: Center(
            child: CountdownRing(
              size: 160,
              progress: 0.35,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrayerNameArt(
                    prayer: Prayer.dhuhr,
                    label: f.prayer(Prayer.dhuhr),
                    size: 34,
                    color: AppColors.goldLight,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    f.digits('03:50:31'),
                    style: AppText.subtitle.copyWith(color: AppColors.onHeader),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

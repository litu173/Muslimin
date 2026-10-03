import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
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
    pushReplacement(context, const PermissionGate());
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final pages = [
      ('assets/images/onboard_mosque.png', t.onb1Title, t.onb1Body),
      ('assets/images/onboard_megaphone.png', t.onb2Title, t.onb2Body),
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
                    image: pages[i].$1,
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
    required this.image,
    required this.title,
    required this.body,
  });

  final String image;
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
              Image.asset(image, height: 220, fit: BoxFit.contain),
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

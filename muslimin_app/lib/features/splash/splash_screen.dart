import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../../core/config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand.dart';
import '../../l10n/app_localizations.dart';
import '../../services/notification_service.dart';
import '../../state/providers.dart';
import '../auth/welcome_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../permissions/permission_gate.dart';

/// Splash sequence (Figma: two OOBE frames):
///  1. the masjid-window photo fades in with a slow zoom,
///  2. "Muslimin" rises in letter by letter on a wave, then ripples,
///  3. the motto fades up,
///  4. we move on to onboarding (first launch) or the app.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final _image = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  late final _logo = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    await _image.forward(); // 1. image alone
    if (!mounted) return;
    await _logo.forward(); // 2–3. wavy logo + motto
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) _next();
  }

  Future<void> _next() async {
    final prefs = ref.read(prefsProvider);
    final payload = await NotificationService.instance.launchPayload();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => prefs.onboardingDone
            ? const AuthGate(child: PermissionGate())
            : const OnboardingScreen(),
        transitionsBuilder: (_, a, _, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
    if (payload != null) openNotificationPayload(payload);
  }

  @override
  void dispose() {
    _image.dispose();
    _logo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.inkDeep,
        body: GestureDetector(
          // Tap to skip once the logo is visible.
          onTap: () {
            if (_image.isCompleted) _next();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: _image,
                builder: (_, child) {
                  final v = Curves.easeOut.transform(_image.value);
                  return Opacity(
                    opacity: v,
                    child: Transform.scale(
                      scale: 1.08 - 0.08 * v,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/splash_bg.jpg',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.3, -0.4),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.25),
                child: AnimatedBuilder(
                  animation: _logo,
                  builder: (_, _) {
                    final motto = Curves.easeOut.transform(
                      ((_logo.value - 0.55) / 0.35).clamp(0.0, 1.0),
                    );
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WavyWordmark(progress: _logo.value),
                        const SizedBox(height: 12),
                        Opacity(
                          opacity: motto,
                          child: Transform.translate(
                            offset: Offset(0, 10 * (1 - motto)),
                            child: Column(
                              children: [
                                Text(
                                  t.tagline,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                  ),
                                ),
                                if (kBeta) ...[
                                  const SizedBox(height: 14),
                                  const BetaBadge(),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand.dart';
import '../../l10n/app_localizations.dart';
import '../../services/notification_service.dart';
import '../../state/providers.dart';
import '../onboarding/onboarding_screen.dart';
import '../permissions/permission_gate.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1600), _next);
  }

  Future<void> _next() async {
    if (!mounted) return;
    final prefs = ref.read(prefsProvider);
    final payload = await NotificationService.instance.launchPayload();
    if (!mounted) return;
    pushReplacement(
      context,
      prefs.onboardingDone ? const PermissionGate() : const OnboardingScreen(),
    );
    if (payload != null) openNotificationPayload(payload);
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.inkDeep,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/splash_bg.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.3, -0.4),
            ),
            Align(
              alignment: const Alignment(0, 0.25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Wordmark(size: 46),
                  const SizedBox(height: 12),
                  Text(
                    t.tagline,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

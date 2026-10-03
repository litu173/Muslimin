import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config.dart';
import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'auth_screens.dart';

/// Shows [child] once someone is signed in; otherwise the Welcome screen.
/// Signing out anywhere brings the user straight back here.
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _guest = false;

  @override
  Widget build(BuildContext context) {
    if (!kRequireAccount && _guest) return widget.child;
    final auth = ref.watch(authProvider);
    if (auth.isLoading && !auth.hasValue) {
      return const Scaffold(backgroundColor: AppColors.ink, body: Loader());
    }
    if (auth.value != null) return widget.child;
    return WelcomeScreen(onGuest: () => setState(() => _guest = true));
  }
}

/// Welcome: Google, create account or sign in (guest only if allowed).
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key, required this.onGuest});

  final VoidCallback onGuest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: IslamicPattern(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Gap.xl),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Image.asset('assets/images/onboard_mosque.png', height: 170),
                  const SizedBox(height: Gap.xl),
                  const Wordmark(size: 46),
                  if (kBeta) ...[const SizedBox(height: 8), const BetaBadge()],
                  const SizedBox(height: Gap.xl),
                  Text(
                    t.welcomeTitle,
                    style: AppText.headline.copyWith(
                      color: AppColors.goldLight,
                    ),
                  ),
                  const SizedBox(height: Gap.s),
                  Text(
                    t.welcomeBody,
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(color: AppColors.cream),
                  ),
                  const Spacer(flex: 3),
                  // The gate rebuilds by itself once signed in.
                  GoogleSignInButton(dark: true, onSignedIn: () {}),
                  const SizedBox(height: Gap.m),
                  AppButton(
                    t.createAccount,
                    expand: true,
                    onPressed: () => push(context, const SignUpScreen()),
                  ),
                  const SizedBox(height: Gap.m),
                  AppButton(
                    t.signIn,
                    style: AppButtonStyle.darkOutlined,
                    expand: true,
                    onPressed: () => push(context, const SignInScreen()),
                  ),
                  if (!kRequireAccount) ...[
                    const SizedBox(height: Gap.s),
                    TextButton(
                      onPressed: onGuest,
                      child: Text(
                        t.continueAsGuest,
                        style: AppText.label.copyWith(
                          color: AppColors.cream,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

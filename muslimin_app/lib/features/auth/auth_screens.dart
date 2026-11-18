import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'auth_errors.dart';

/// Opens sign-in; resolves to true once the user is signed in.
Future<bool> requireSignIn(BuildContext context, WidgetRef ref) async {
  if (ref.read(backendProvider).currentUser != null) return true;
  final ok = await push<bool>(context, const SignInScreen());
  return ok == true;
}

/// Shared frame for the auth forms (same card as the registration screens).
class _AuthFrame extends StatelessWidget {
  const _AuthFrame({
    required this.title,
    required this.body,
    required this.children,
  });

  final String title;
  final String body;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SheetCard(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.s, Gap.xl, Gap.xl),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: Icon(Icons.arrow_back_rounded, color: AppColors.ink),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: Gap.s),
            Text(title, style: AppText.headline),
            const SizedBox(height: Gap.s),
            Text(body, style: AppText.body),
            ...children,
          ],
        ),
      ),
    ),
  );
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  // Google sign-in only: no passwords to forget or leak, and the email is
  // already verified by Google.
  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return _AuthFrame(
      title: t.signIn,
      body: t.signInBody,
      children: [
        const SizedBox(height: Gap.m),
        GoogleSignInButton(onSignedIn: () => Navigator.pop(context, true)),
      ],
    );
  }
}

/// "Continue with Google" – white pill with the Google mark. Pops/finishes
/// with `true` on success; shows a friendly error otherwise.
class GoogleSignInButton extends ConsumerStatefulWidget {
  const GoogleSignInButton({
    super.key,
    required this.onSignedIn,
    this.dark = false,
  });

  final VoidCallback onSignedIn;

  /// On dark backgrounds (Welcome) the button gets no border.
  final bool dark;

  @override
  ConsumerState<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends ConsumerState<GoogleSignInButton> {
  bool _busy = false;

  Future<void> _go() async {
    final t = L10n.of(context);
    setState(() => _busy = true);
    try {
      final u = await ref.read(backendProvider).signInWithGoogle();
      if (u == null || !mounted) return;
      toast(context, t.welcomeUser(u.displayName));
      widget.onSignedIn();
    } catch (e) {
      if (mounted) toast(context, authErrorText(t, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.button),
          side: widget.dark
              ? BorderSide.none
              : BorderSide(color: AppColors.divider),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.button),
          onTap: _busy ? null : _go,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _busy
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : SvgPicture.asset(
                        'assets/icons/google.svg',
                        width: 18,
                        height: 18,
                      ),
                const SizedBox(width: Gap.m),
                // Google's button is always white with dark text.
                Text(
                  t.continueWithGoogle,
                  style: AppText.label.copyWith(color: const Color(0xFF1F1F1F)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

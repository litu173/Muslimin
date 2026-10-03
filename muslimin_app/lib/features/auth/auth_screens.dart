import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/islamic_pattern.dart';
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

/// Shown once after onboarding: create account, sign in, or browse as guest.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    Future<void> go(Widget page) async {
      final ok = await push<bool>(context, page);
      if (ok == true) onDone();
    }

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
                  const Wordmark(size: 44),
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
                  AppButton(
                    t.createAccount,
                    expand: true,
                    onPressed: () => go(const SignUpScreen()),
                  ),
                  const SizedBox(height: Gap.m),
                  AppButton(
                    t.signIn,
                    style: AppButtonStyle.darkOutlined,
                    expand: true,
                    onPressed: () => go(const SignInScreen()),
                  ),
                  const SizedBox(height: Gap.s),
                  TextButton(
                    onPressed: onDone,
                    child: Text(
                      t.continueAsGuest,
                      style: AppText.label.copyWith(
                        color: AppColors.cream,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.ink,
                ),
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

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    this.validator,
    this.action,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction? action;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FieldLabel(widget.label),
      TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        validator: widget.validator,
        textInputAction: widget.action ?? TextInputAction.next,
        autofillHints: const [AutofillHints.password],
        style: AppText.label,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.muted,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
    ],
  );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) => text == null
      ? const SizedBox(height: Gap.l)
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: Gap.m),
          child: Text(
            text!,
            style: AppText.caption.copyWith(color: AppColors.danger),
          ),
        );
}

class _SwitchLink extends StatelessWidget {
  const _SwitchLink({
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Gap.l),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: AppText.body),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: AppText.label.copyWith(color: AppColors.gold),
          ),
        ),
      ],
    ),
  );
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = L10n.of(context);
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final u = await ref
          .read(backendProvider)
          .signIn(email: _email.text, password: _password.text);
      if (!mounted) return;
      toast(context, t.welcomeUser(u.displayName));
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorText(t, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final demo = ref.read(backendProvider).isDemo;
    return Form(
      key: _form,
      child: AutofillGroup(
        child: _AuthFrame(
          title: t.signIn,
          body: t.signInBody,
          children: [
            AppTextField(
              label: t.email,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => validateEmail(t, v),
            ),
            _PasswordField(
              label: t.password,
              controller: _password,
              validator: (v) => (v ?? '').isEmpty ? t.required : null,
              action: TextInputAction.done,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => push(
                  context,
                  ForgotPasswordScreen(initialEmail: _email.text),
                ),
                child: Text(
                  t.forgotPassword,
                  style: AppText.caption.copyWith(color: AppColors.gold),
                ),
              ),
            ),
            _ErrorText(_error),
            AppButton(
              t.signIn,
              expand: true,
              loading: _busy,
              onPressed: _submit,
            ),
            if (demo) ...[
              const SizedBox(height: Gap.m),
              Text(
                'Demo: demo@muslimin.app / demo1234 · admin@muslimin.app / admin1234',
                style: AppText.caption.copyWith(color: AppColors.gold),
                textAlign: TextAlign.center,
              ),
            ],
            _SwitchLink(
              question: t.noAccount,
              action: t.createAccount,
              onTap: () async {
                final ok = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                );
                if (ok == true && context.mounted) Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final t = L10n.of(context);
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final u = await ref
          .read(backendProvider)
          .signUp(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          );
      if (!mounted) return;
      toast(context, t.accountCreated(u.email));
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorText(t, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Form(
      key: _form,
      child: AutofillGroup(
        child: _AuthFrame(
          title: t.createAccount,
          body: t.signUpBody,
          children: [
            AppTextField(
              label: t.fullName,
              controller: _name,
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? t.nameRequired : null,
            ),
            AppTextField(
              label: t.email,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => validateEmail(t, v),
            ),
            _PasswordField(
              label: t.password,
              controller: _password,
              validator: (v) => validatePassword(t, v),
            ),
            _PasswordField(
              label: t.confirmPassword,
              controller: _confirm,
              action: TextInputAction.done,
              validator: (v) =>
                  v == _password.text ? null : t.passwordsDontMatch,
            ),
            _ErrorText(_error),
            AppButton(
              t.createAccount,
              expand: true,
              loading: _busy,
              onPressed: _submit,
            ),
            _SwitchLink(
              question: t.haveAccount,
              action: t.signIn,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail);
  bool _busy = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = L10n.of(context);
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(backendProvider).sendPasswordReset(_email.text);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorText(t, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Form(
      key: _form,
      child: _AuthFrame(
        title: t.resetPassword,
        body: t.resetBody,
        children: [
          AppTextField(
            label: t.email,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => validateEmail(t, v),
          ),
          if (_sent)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Gap.l),
              child: AppCard(
                color: AppColors.cream,
                child: Row(
                  children: [
                    const Icon(
                      Icons.mark_email_read_outlined,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: Gap.m),
                    Expanded(
                      child: Text(
                        t.resetSent(_email.text.trim()),
                        style: AppText.body,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            _ErrorText(_error),
          AppButton(
            _sent ? t.backToSignIn : t.sendResetLink,
            expand: true,
            loading: _busy,
            onPressed: _sent ? () => Navigator.pop(context) : _submit,
          ),
        ],
      ),
    );
  }
}

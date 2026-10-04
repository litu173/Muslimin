import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/app_user.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../more/followed_masjids_screen.dart';
import '../more/manage_masjids_screen.dart';
import 'auth_errors.dart';

/// Account details, email verification, password change, sign out, delete.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _name = TextEditingController();
  bool _savingName = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _name.text = ref.read(backendProvider).currentUser?.name ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() f, {String? success}) async {
    final t = L10n.of(context);
    try {
      await f();
      if (mounted && success != null) toast(context, success);
    } catch (e) {
      if (mounted) toast(context, authErrorText(t, e));
    }
  }

  Future<String?> _askPassword({
    required String title,
    required String body,
    required String action,
  }) {
    final t = L10n.of(context);
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: Text(title, style: AppText.subtitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body, style: AppText.body),
            const SizedBox(height: Gap.m),
            TextField(
              controller: c,
              obscureText: true,
              decoration: InputDecoration(hintText: t.password),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: Text(t.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(d, c.text),
            child: Text(
              action,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    ).whenComplete(c.dispose);
  }

  Future<void> _changePassword() async {
    final t = L10n.of(context);
    final current = TextEditingController();
    final next = TextEditingController();
    final form = GlobalKey<FormState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: Text(t.changePassword, style: AppText.subtitle),
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: current,
                obscureText: true,
                decoration: InputDecoration(hintText: t.currentPassword),
                validator: (v) => (v ?? '').isEmpty ? t.required : null,
              ),
              const SizedBox(height: Gap.m),
              TextFormField(
                controller: next,
                obscureText: true,
                decoration: InputDecoration(hintText: t.newPassword),
                validator: (v) => validatePassword(t, v),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              if (form.currentState!.validate()) Navigator.pop(d, true);
            },
            child: Text(t.update),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _run(
        () => ref
            .read(backendProvider)
            .changePassword(
              currentPassword: current.text,
              newPassword: next.text,
            ),
        success: t.passwordChanged,
      );
    }
    current.dispose();
    next.dispose();
  }

  Future<void> _delete() async {
    final t = L10n.of(context);
    final user = ref.read(backendProvider).currentUser;
    String? pw;
    if (user?.hasPassword ?? true) {
      pw = await _askPassword(
        title: t.deleteAccount,
        body: t.deleteAccountBody,
        action: t.delete,
      );
      if (pw == null || pw.isEmpty || !mounted) return;
    } else {
      final ok = await showDialog<bool>(
        context: context,
        builder: (d) => AlertDialog(
          backgroundColor: AppColors.cream,
          title: Text(t.deleteAccount, style: AppText.subtitle),
          content: Text(t.deleteAccountBody, style: AppText.body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: Text(t.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(d, true),
              child: Text(
                t.delete,
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }
    try {
      await ref.read(backendProvider).deleteAccount(password: pw);
      if (!mounted) return;
      toast(context, t.accountDeleted);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) toast(context, authErrorText(t, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.profile)),
        body: const Loader(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.profile)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          _Header(user: user),
          const SizedBox(height: Gap.l),
          if (!user.emailVerified)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.l),
              child: AppCard(
                color: AppColors.goldLight.withValues(alpha: 0.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.mark_email_unread_outlined,
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: Gap.s),
                        Text(t.emailNotVerified, style: AppText.label),
                      ],
                    ),
                    const SizedBox(height: Gap.m),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            t.resendVerification,
                            style: AppButtonStyle.outlined,
                            dense: true,
                            onPressed: () => _run(
                              () => ref
                                  .read(backendProvider)
                                  .sendEmailVerification(),
                              success: t.verificationSent(user.email),
                            ),
                          ),
                        ),
                        const SizedBox(width: Gap.m),
                        AppButton(
                          t.iVerified,
                          dense: true,
                          loading: _checking,
                          onPressed: () async {
                            setState(() => _checking = true);
                            await _run(
                              () => ref.read(backendProvider).reloadUser(),
                            );
                            if (mounted) setState(() => _checking = false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          AppCard(
            padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(label: t.fullName, controller: _name),
                const SizedBox(height: Gap.m),
                AppButton(
                  t.save,
                  dense: true,
                  pill: true,
                  loading: _savingName,
                  onPressed: () async {
                    setState(() => _savingName = true);
                    await _run(
                      () => ref.read(backendProvider).updateName(_name.text),
                      success: t.updated,
                    );
                    if (mounted) setState(() => _savingName = false);
                  },
                ),
                const SizedBox(height: Gap.l),
                const Divider(),
                _Row(label: t.email, value: user.email),
                _Row(
                  label: t.phoneNumber,
                  value: user.hasPhone ? f.digits(user.phone) : t.notVerified,
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.l),
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.l,
              vertical: Gap.xs,
            ),
            child: Column(
              children: [
                _Action(
                  icon: Icons.favorite_border_rounded,

                  label: t.followedMasjids,

                  onTap: () => push(context, const FollowedMasjidsScreen()),
                ),
                const Divider(),
                _Action(
                  icon: Icons.mosque_outlined,

                  label: t.manageMasjids,

                  onTap: () => push(context, const ManageMasjidsScreen()),
                ),
                const Divider(),
                if (user.hasPassword) ...[
                  _Action(
                    icon: Icons.lock_reset_rounded,
                    label: t.changePassword,
                    onTap: _changePassword,
                  ),
                  const Divider(),
                ],
                _Action(
                  icon: Icons.logout_rounded,
                  label: t.signOut,
                  onTap: () async {
                    await ref.read(backendProvider).signOut();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                const Divider(),
                _Action(
                  icon: Icons.delete_outline_rounded,
                  label: t.deleteAccount,
                  onTap: _delete,
                  danger: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return AppCard(
      color: AppColors.ink,
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.gold,
            child: Text(
              user.displayName.characters.first.toUpperCase(),
              style: AppText.title.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: Gap.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: AppText.subtitle.copyWith(color: AppColors.cream),
                ),
                Text(
                  user.email,
                  style: AppText.caption.copyWith(
                    color: AppColors.cream.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      user.emailVerified
                          ? Icons.verified_rounded
                          : Icons.error_outline_rounded,
                      size: 14,
                      color: user.emailVerified
                          ? AppColors.teal
                          : AppColors.goldLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user.emailVerified ? t.emailVerified : t.emailNotVerified,
                      style: AppText.micro.copyWith(color: AppColors.cream),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Gap.m),
    child: Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: AppText.caption.copyWith(color: AppColors.muted),
          ),
        ),
        Expanded(child: Text(value, style: AppText.label)),
      ],
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(
            icon,
            color: danger ? AppColors.danger : AppColors.gold,
            size: 22,
          ),
          const SizedBox(width: Gap.l),
          Expanded(
            child: Text(
              label,
              style: AppText.body.copyWith(
                color: danger ? AppColors.danger : AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

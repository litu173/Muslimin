import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../admin/admin_panel_screen.dart';
import '../auth/auth_screens.dart';
import '../auth/profile_screen.dart';
import '../home/home_screen.dart';
import '../home/location_bar.dart';
import 'about_screen.dart';
import 'faq_screen.dart';
import 'followed_masjids_screen.dart';
import 'manage_masjids_screen.dart';
import 'settings_screen.dart';

/// Public download page – update once the website is live.
const kShareUrl = 'https://muslimin.app';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  bool _bannerClosed = false;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final user = ref.watch(authProvider).value;
    final mine = ref.watch(myMasjidsProvider).value ?? const <Masjid>[];
    // Signed-out users already see the "For masjid authorities" card.
    final showBanner =
        user != null &&
        mine.isEmpty &&
        !_bannerClosed &&
        !ref.read(prefsProvider).authorityBannerHidden;

    return Scaffold(
      body: SafeArea(
        child: RefreshList(
          onRefresh: () => refreshAll(ref),
          padding: const EdgeInsets.fromLTRB(0, Gap.s, 0, Gap.xxl),
          children: [
            // Same insets as on Home, so the bell does not jump when
            // switching tabs.
            const Padding(
              padding: EdgeInsets.fromLTRB(Gap.l, 0, Gap.s, 0),
              child: LocationBar(),
            ),
            const SizedBox(height: Gap.l),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AccountCard(),
                  const SizedBox(height: Gap.l),
                  if (showBanner) ...[
                    AuthorityBanner(
                      showDontShow: true,
                      onClose: () => setState(() => _bannerClosed = true),
                    ),
                    const SizedBox(height: Gap.xl),
                  ],
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Gap.l,
                      vertical: Gap.xs,
                    ),
                    child: Column(
                      children: [
                        _MenuRow(
                          icon: Icons.favorite_border_rounded,
                          label: t.followedMasjids,
                          onTap: () =>
                              push(context, const FollowedMasjidsScreen()),
                        ),
                        const Divider(),
                        _MenuRow(
                          icon: Icons.mosque_outlined,
                          label: t.manageMasjids,
                          onTap: () =>
                              push(context, const ManageMasjidsScreen()),
                        ),
                        const Divider(),
                        _MenuRow(
                          icon: Icons.settings_outlined,
                          label: t.appSettings,
                          onTap: () => push(context, const SettingsScreen()),
                        ),
                        const Divider(),
                        _MenuRow(
                          icon: Icons.help_outline_rounded,
                          label: t.faq,
                          onTap: () => push(context, const FaqScreen()),
                        ),
                        const Divider(),
                        _MenuRow(
                          icon: Icons.info_outline_rounded,
                          label: t.aboutApp,
                          onTap: () => push(context, const AboutScreen()),
                        ),
                        if (user?.isSuperAdmin ?? false) ...[
                          const Divider(),
                          _MenuRow(
                            icon: Icons.verified_user_outlined,
                            label: t.adminPanel,
                            onTap: () =>
                                push(context, const AdminPanelScreen()),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: Gap.xxl * 2),
                  _ShareCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 22),
          const SizedBox(width: Gap.l),
          Expanded(child: Text(label, style: AppText.body)),
          Icon(Icons.chevron_right_rounded, color: AppColors.ink),
        ],
      ),
    ),
  );
}

class _ShareCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.card),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.card, AppColors.card.withValues(alpha: 0)],
        ),
      ),
      padding: const EdgeInsets.all(Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.shareApp, style: AppText.subtitle),
          const SizedBox(height: 4),
          Text(t.shareAppBody, style: AppText.body),
          const SizedBox(height: Gap.l),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              t.share,
              icon: Icons.share_outlined,
              pill: true,
              onPressed: () => SharePlus.instance.share(
                ShareParams(text: t.shareText(kShareUrl)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.signInPrompt, style: AppText.subtitle),
            const SizedBox(height: 4),
            Text(t.signInPromptBody, style: AppText.body),
            const SizedBox(height: Gap.l),
            ButtonPair(
              secondary: AppButton(
                t.signIn,
                style: AppButtonStyle.outlined,
                onPressed: () => push(context, const SignInScreen()),
              ),
              primary: AppButton(
                t.createAccount,
                onPressed: () => push(context, const SignUpScreen()),
              ),
            ),
          ],
        ),
      );
    }
    return AppCard(
      onTap: () => push(context, const ProfileScreen()),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.header,
            child: Text(
              user.displayName.characters.first.toUpperCase(),
              style: AppText.subtitle.copyWith(color: AppColors.goldLight),
            ),
          ),
          const SizedBox(width: Gap.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName, style: AppText.subtitle),
                Text(
                  user.email,
                  style: AppText.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!user.emailVerified)
            Icon(Icons.error_outline_rounded, color: AppColors.gold, size: 20),
          Icon(Icons.chevron_right_rounded, color: AppColors.ink),
        ],
      ),
    );
  }
}

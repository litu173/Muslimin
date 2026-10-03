import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../admin/admin_panel_screen.dart';
import '../auth/auth_screens.dart';
import '../auth/profile_screen.dart';
import '../home/home_screen.dart';
import '../home/location_bar.dart';
import '../masjid/masjid_screen.dart';
import '../registration/registration_flow.dart';
import 'about_screen.dart';
import 'faq_screen.dart';
import 'followed_masjids_screen.dart';
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.xxl),
          children: [
            const LocationBar(),
            const SizedBox(height: Gap.l),
            _AccountCard(),
            const SizedBox(height: Gap.l),
            if (showBanner) ...[
              AuthorityBanner(
                showDontShow: true,
                onClose: () => setState(() => _bannerClosed = true),
              ),
              const SizedBox(height: Gap.xl),
            ],
            for (final m in mine) ...[
              _MyMasjidCard(masjid: m),
              const SizedBox(height: Gap.m),
            ],
            if (mine.isNotEmpty) const SizedBox(height: Gap.s),
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

                    onTap: () => push(context, const FollowedMasjidsScreen()),
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
                  if (!showBanner) ...[
                    const Divider(),
                    _MenuRow(
                      icon: Icons.add_business_outlined,
                      label: t.registerMasjid,
                      onTap: () => startRegistration(context, ref),
                    ),
                  ],
                  if (user?.isSuperAdmin ?? false) ...[
                    const Divider(),
                    _MenuRow(
                      icon: Icons.verified_user_outlined,
                      label: t.adminPanel,
                      onTap: () => push(context, const AdminPanelScreen()),
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
    );
  }
}

class _MyMasjidCard extends StatelessWidget {
  const _MyMasjidCard({required this.masjid});

  final Masjid masjid;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final (label, color) = switch (masjid.status) {
      MasjidStatus.approved => (t.statusApproved, Colors.white),
      MasjidStatus.pending => (t.statusPending, AppColors.ink),
      MasjidStatus.rejected => (t.statusRejected, AppColors.danger),
      MasjidStatus.suspended => (t.statusSuspended, AppColors.danger),
    };
    return Material(
      color: AppColors.gold,
      borderRadius: BorderRadius.circular(Radii.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.card),
        onTap: () =>
            push(context, MasjidScreen(masjidId: masjid.id, initial: masjid)),
        child: Padding(
          padding: const EdgeInsets.all(Gap.l),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            masjid.displayName(
                              Localizations.localeOf(context).languageCode ==
                                  'bn',
                            ),
                            style: AppText.subtitle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: Gap.s),
                        if (masjid.status != MasjidStatus.approved)
                          StatusPill(label: label, color: color),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      masjid.fullAddress,
                      style: AppText.body.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
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
          const Icon(Icons.chevron_right_rounded, color: AppColors.ink),
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
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.card, Color(0x00FFFDF5)],
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
            backgroundColor: AppColors.ink,
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
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.gold,
              size: 20,
            ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.ink),
        ],
      ),
    );
  }
}

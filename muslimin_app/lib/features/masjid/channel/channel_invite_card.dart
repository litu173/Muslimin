import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/frosted_card.dart';
import '../../../data/models/masjid.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/channel.dart';
import '../../../state/providers.dart';

/// Ibn Majah 224.
const _hadith = 'طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ';

/// Masjid Home tab: invitation to join the masjid's channel – learning the
/// Fard ʿAyn under an Alim, and staying in touch with the Imam and Khatib.
/// Once joined it becomes a short "Open channel" card.
class ChannelInviteCard extends ConsumerStatefulWidget {
  const ChannelInviteCard({
    super.key,
    required this.masjid,
    required this.onOpen,
  });

  final Masjid masjid;

  /// Switches the masjid page to its Channel tab.
  final VoidCallback onOpen;

  @override
  ConsumerState<ChannelInviteCard> createState() => _ChannelInviteCardState();
}

class _ChannelInviteCardState extends ConsumerState<ChannelInviteCard> {
  bool _joining = false;

  Future<void> _join() async {
    final t = L10n.of(context);
    setState(() => _joining = true);
    try {
      await ref.read(channelActionsProvider).join(widget.masjid);
      if (mounted) toast(context, t.channelJoined);
    } catch (_) {
      if (mounted) toast(context, t.somethingWrong);
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final role = ref.watch(channelRoleProvider(widget.masjid));
    final signedIn = ref.watch(authProvider).value != null;

    if (role != null) {
      return FrostedCard(
        onTap: widget.onOpen,
        child: Padding(
          padding: const EdgeInsets.all(Gap.l),
          child: Row(
            children: [
              _Icon(),
              const SizedBox(width: Gap.m),
              Expanded(child: Text(t.joinedChannel, style: AppText.label)),
              Text(
                t.openChannel,
                style: AppText.label.copyWith(color: AppColors.gold),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.gold),
            ],
          ),
        ),
      );
    }

    return FrostedCard(
      child: Padding(
        padding: const EdgeInsets.all(Gap.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Icon(),
                const SizedBox(width: Gap.m),
                Expanded(
                  child: Text(t.channelInviteTitle, style: AppText.subtitle),
                ),
              ],
            ),
            const SizedBox(height: Gap.l),
            Center(
              child: Text(
                _hadith,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppText.arabic,
                  fontSize: 24,
                  height: 1.6,
                  color: AppColors.gold,
                ),
              ),
            ),
            Text(
              t.channelInviteHadith,
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: Gap.l),
            Text(t.channelInviteBody, style: AppText.body),
            const SizedBox(height: Gap.l),
            signedIn
                ? AppButton(
                    t.joinChannel,
                    icon: Icons.group_add_rounded,
                    onPressed: _joining ? null : _join,
                    loading: _joining,
                    expand: true,
                  )
                : Text(
                    t.signInToJoin,
                    style: AppText.caption.copyWith(color: AppColors.muted),
                  ),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.gold.withValues(alpha: 0.16),
    ),
    child: Icon(Icons.forum_rounded, color: AppColors.gold, size: 22),
  );
}

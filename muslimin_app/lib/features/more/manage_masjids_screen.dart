import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../masjid/masjid_screen.dart';
import '../registration/registration_flow.dart';

/// The masjids this account registered (any status), with a fixed
/// "Register a Masjid" button at the bottom.
class ManageMasjidsScreen extends ConsumerWidget {
  const ManageMasjidsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final mine = ref.watch(myMasjidsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.manageMasjids)),
      body: mine.when(
        loading: () => const Loader(),
        error: (_, _) => EmptyState(message: t.somethingWrong),
        data: (list) => list.isEmpty
            ? EmptyState(message: t.noMyMasjids, hint: t.noMyMasjidsHint)
            : ListView.separated(
                padding: const EdgeInsets.all(Gap.l),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: Gap.m),
                itemBuilder: (_, i) => MyMasjidCard(masjid: list[i]),
              ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.l),
          child: AppButton(
            t.registerMasjid,
            icon: Icons.add_rounded,
            expand: true,
            onPressed: () => startRegistration(context, ref),
          ),
        ),
      ),
    );
  }
}

class MyMasjidCard extends StatelessWidget {
  const MyMasjidCard({super.key, required this.masjid});

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

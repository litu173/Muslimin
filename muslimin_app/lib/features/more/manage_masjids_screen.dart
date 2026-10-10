import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/page_header.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../core/widgets/thana_picker.dart';
import '../../services/thana_service.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../masjid/masjid_screen.dart';
import '../registration/registration_flow.dart';

/// The masjids this account manages (any status) – searchable, by thana –
/// with a fixed "Register a Masjid" button at the bottom. The admin owns
/// thousands, so they start in their own thana.
class ManageMasjidsScreen extends ConsumerStatefulWidget {
  const ManageMasjidsScreen({super.key});

  @override
  ConsumerState<ManageMasjidsScreen> createState() =>
      _ManageMasjidsScreenState();
}

class _ManageMasjidsScreenState extends ConsumerState<ManageMasjidsScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _q = '';

  /// null = not chosen yet (admin: own thana, others: all areas).
  Thana? _thana;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final user = ref.watch(authProvider).value;
    final admin = user?.isSuperAdmin ?? false;
    final mine = ref.watch(myThanaProvider).value;
    final thana = _thana ?? (admin ? mine : null) ?? allThanas;
    final all = thana == allThanas;

    final AsyncValue<List<Masjid>> list = _q.length >= 2
        ? ref.watch(searchMyMasjidsProvider(_q))
        : all
        ? ref.watch(myMasjidsProvider)
        : ref.watch(myMasjidsInProvider(thana));

    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: t.manageMasjids,
            subtitle: all ? t.allAreas : thana.label,
            back: true,
            bottom: Row(
              children: [
                ThanaButton(
                  label: all ? t.allAreas : thana.name,
                  onTap: () async {
                    final p = await pickThana(
                      context,
                      mine: mine,
                      current: thana,
                      allLabel: t.allAreas,
                    );
                    if (p != null) setState(() => _thana = p);
                  },
                ),
                const SizedBox(width: Gap.s),
                Expanded(
                  child: AppSearchField(
                    controller: _search,
                    hint: t.searchMasjid,
                    iconRight: true,
                    onChanged: (v) {
                      _debounce?.cancel();
                      _debounce = Timer(
                        const Duration(milliseconds: 400),
                        () => setState(() => _q = v.trim().toLowerCase()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: list.when(
              loading: () => const Loader(),
              error: (_, _) => EmptyState(message: t.somethingWrong),
              data: (list) => list.isEmpty
                  ? EmptyState(message: t.noMyMasjids, hint: t.noMyMasjidsHint)
                  : RefreshList.separated(
                      onRefresh: () => refreshAll(ref),
                      padding: const EdgeInsets.all(Gap.l),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: Gap.m),
                      itemBuilder: (_, i) => MyMasjidCard(masjid: list[i]),
                    ),
            ),
          ),
        ],
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
      MasjidStatus.approved => (t.statusApproved, AppColors.success),
      MasjidStatus.pending => (t.statusPending, AppColors.gold),
      MasjidStatus.rejected => (t.statusRejected, AppColors.danger),
      MasjidStatus.suspended => (t.statusSuspended, AppColors.danger),
    };
    final bn = Localizations.localeOf(context).languageCode == 'bn';
    return AppCard(
      padding: const EdgeInsets.all(Gap.l),
      onTap: () =>
          push(context, MasjidScreen(masjidId: masjid.id, initial: masjid)),
      child: Row(
        children: [
          const MasjidBadge(),
          const SizedBox(width: Gap.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(masjid.displayName(bn), style: AppText.subtitle),
                const SizedBox(height: 2),
                Text(
                  masjid.fullAddress,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: Gap.s),
                StatusPill(label: label, color: color),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

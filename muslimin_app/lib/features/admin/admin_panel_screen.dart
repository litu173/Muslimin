import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../masjid/masjid_screen.dart';

/// Super-admin review queue. Only users whose `users/{uid}.role` is
/// `superAdmin` see the entry point, and Firestore rules enforce it.
/// Works on phones and – with `flutter build web` – on a desktop browser.
class AdminPanelScreen extends ConsumerWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final pending = ref
        .watch(masjidsByStatusProvider(MasjidStatus.pending))
        .value
        ?.length;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.adminPanel),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.goldLight,
            unselectedLabelColor: AppColors.cream,
            indicatorColor: AppColors.goldLight,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                text: pending == null || pending == 0
                    ? t.adminPending
                    : '${t.adminPending} (${Fmt.of(context).digits(pending)})',
              ),
              Tab(text: t.adminApproved),
              Tab(text: t.adminRejected),
              Tab(text: t.statusSuspended),
            ],
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: const TabBarView(
              children: [
                _Queue(status: MasjidStatus.pending),
                _Queue(status: MasjidStatus.approved),
                _Queue(status: MasjidStatus.rejected),
                _Queue(status: MasjidStatus.suspended),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Queue extends ConsumerWidget {
  const _Queue({required this.status});

  final MasjidStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    return ref
        .watch(masjidsByStatusProvider(status))
        .when(
          loading: () => const Loader(),
          error: (e, _) => EmptyState(message: '${t.somethingWrong}\n$e'),
          data: (list) => list.isEmpty
              ? EmptyState(message: t.nothingHere, icon: Icons.inbox_outlined)
              : ListView.separated(
                  padding: const EdgeInsets.all(Gap.l),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _ReviewCard(masjid: list[i]),
                ),
        );
  }
}

class _ReviewCard extends ConsumerStatefulWidget {
  const _ReviewCard({required this.masjid});

  final Masjid masjid;

  @override
  ConsumerState<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends ConsumerState<_ReviewCard> {
  bool _busy = false;

  Future<void> _set(MasjidStatus s, {String? reason}) async {
    final t = L10n.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(backendProvider)
          .setStatus(widget.masjid.id, s, reason: reason);
      if (mounted) {
        toast(
          context,
          s == MasjidStatus.approved ? t.approvedToast : t.rejectedToast,
        );
      }
    } catch (e) {
      if (mounted) toast(context, t.somethingWrong);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reject() async {
    final t = L10n.of(context);
    final c = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: Text(t.reject, style: AppText.subtitle),
        content: AppTextField(
          label: t.rejectReason,
          controller: c,
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: Text(t.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(d, c.text.trim()),
            child: Text(t.reject),
          ),
        ],
      ),
    );
    c.dispose();
    if (reason != null && reason.isNotEmpty) {
      await _set(MasjidStatus.rejected, reason: reason);
    }
  }

  String _role(L10n t, SubmitterRole r) => switch (r) {
    SubmitterRole.committee => t.roleCommittee,
    SubmitterRole.imam => t.roleImam,
    SubmitterRole.khatib => t.roleKhatib,
    SubmitterRole.muazzin => t.roleMuazzin,
    SubmitterRole.khadem => t.roleKhadem,
  };

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final m = widget.masjid;

    Widget kv(String k, String v, {VoidCallback? onTap}) => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                k,
                style: AppText.caption.copyWith(color: AppColors.muted),
              ),
            ),
            Expanded(
              child: Text(
                v,
                style: AppText.label.copyWith(
                  color: onTap == null ? AppColors.ink : AppColors.gold,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () =>
                push(context, MasjidScreen(masjidId: m.id, initial: m)),
            child: Row(
              children: [
                const MasjidBadge(size: 36),
                const SizedBox(width: Gap.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name, style: AppText.subtitle),
                      if (m.nameBn.isNotEmpty)
                        Text(m.nameBn, style: AppText.body),
                      Text(m.fullAddress, style: AppText.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.m),
          const Divider(),
          kv(
            t.phone,
            m.phoneVerified
                ? m.ownerPhone
                : '${m.ownerPhone}  (${t.notVerified})',
            onTap: () => launchUrl(Uri.parse('tel:${m.ownerPhone}')),
          ),
          kv(t.nid, m.nid),
          kv(t.role, _role(t, m.submitterRole)),
          kv(
            t.location,
            '${m.lat.toStringAsFixed(5)}, ${m.lng.toStringAsFixed(5)}  (±${m.locationAccuracyM.round()} m)',
            onTap: () => launchUrl(
              Uri.parse('https://maps.google.com/?q=${m.lat},${m.lng}'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          if (m.createdAt != null)
            kv(
              t.submittedOn,
              '${f.date(m.createdAt!)} ${f.timePeriod(m.createdAt!)}',
            ),
          if (m.rejectionReason != null && m.status == MasjidStatus.rejected)
            kv(t.rejectReason, m.rejectionReason!),
          const SizedBox(height: Gap.l),
          if (m.status == MasjidStatus.pending) ...[
            Text(
              t.verifiedChecklist,
              style: AppText.caption.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: Gap.m),
            ButtonPair(
              secondary: AppButton(
                t.reject,
                style: AppButtonStyle.outlined,
                onPressed: _busy ? null : _reject,
              ),
              primary: AppButton(
                t.approve,
                loading: _busy,
                onPressed: () => _set(MasjidStatus.approved),
              ),
            ),
          ] else if (m.status == MasjidStatus.approved)
            AppButton(
              t.suspend,
              style: AppButtonStyle.outlined,
              expand: true,
              loading: _busy,
              onPressed: () =>
                  _set(MasjidStatus.suspended, reason: 'Suspended by admin'),
            )
          else
            AppButton(
              t.restore,
              expand: true,
              loading: _busy,
              onPressed: () => _set(MasjidStatus.approved),
            ),
        ],
      ),
    );
  }
}

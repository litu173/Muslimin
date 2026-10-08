import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/gold_sheet.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/surfaces.dart';
import '../../../data/models/channel.dart';
import '../../../data/models/masjid.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/channel.dart';
import '../../../state/providers.dart';
import 'channel_tab.dart';

/// Channel admins: everyone who joined, with their role. Tap a member to
/// make them an editor or admin, back to member, or remove them.
class ChannelMembersScreen extends ConsumerWidget {
  const ChannelMembersScreen({super.key, required this.masjid});

  final Masjid masjid;

  /// Sentinel for "remove" in the role sheet.
  static const _remove = -1;

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    ChannelMember m,
  ) async {
    final t = L10n.of(context);
    final picked = await showGoldSheet<int>(
      context,
      icon: Icons.manage_accounts_rounded,
      title: m.name,
      subtitle: t.role,
      selected: m.role.index,
      selectedLabel: t.selected,
      options: [
        for (final r in ChannelRole.values)
          GoldSheetOption(r.index, '${roleName(t, r)} · ${_desc(t, r)}'),
        GoldSheetOption(_remove, t.removeMember),
      ],
    );
    if (picked == null || picked == m.role.index) return;
    final backend = ref.read(backendProvider);
    try {
      if (picked == _remove) {
        await backend.removeChannelMember(masjid.id, m.uid);
      } else {
        await backend.setChannelRole(
          masjid.id,
          m.uid,
          ChannelRole.values[picked],
        );
      }
    } catch (_) {
      if (context.mounted) toast(context, t.somethingWrong);
    }
  }

  static String _desc(L10n t, ChannelRole r) => switch (r) {
    ChannelRole.member => t.roleMemberDesc,
    ChannelRole.editor => t.roleEditorDesc,
    ChannelRole.admin => t.roleAdminDesc,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final uid = ref.watch(authProvider).value?.uid;
    final members = ref.watch(channelMembersProvider(masjid.id));
    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: t.members,
            subtitle: masjid.displayName(f.isBn),
            back: true,
          ),
          Expanded(
            child: members.when(
              loading: () => const Loader(),
              error: (_, _) => EmptyState(message: t.somethingWrong),
              data: (list) => list.isEmpty
                  ? EmptyState(message: t.noMembers, icon: Icons.group_outlined)
                  : ListView.separated(
                      padding: const EdgeInsets.all(Gap.l),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final m = list[i];
                        final me = m.uid == uid;
                        return AppCard(
                          onTap: me ? null : () => _edit(context, ref, m),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.gold.withValues(
                                  alpha: 0.15,
                                ),
                                child: Text(
                                  m.name.isEmpty
                                      ? '?'
                                      : m.name.characters.first.toUpperCase(),
                                  style: AppText.label.copyWith(
                                    color: AppColors.gold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Gap.m),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      me ? '${m.name} (${t.you})' : m.name,
                                      style: AppText.label,
                                    ),
                                    Text(
                                      _desc(t, m.role),
                                      style: AppText.micro.copyWith(
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                roleName(t, m.role),
                                style: AppText.caption.copyWith(
                                  color: m.role == ChannelRole.member
                                      ? AppColors.muted
                                      : AppColors.gold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (!me)
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.muted,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

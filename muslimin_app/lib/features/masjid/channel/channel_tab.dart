import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/refresh.dart';
import '../../../core/widgets/surfaces.dart';
import '../../../data/models/channel.dart';
import '../../../data/models/masjid.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/channel.dart';
import '../../../state/providers.dart';
import 'channel_invite_card.dart';
import 'channel_members_screen.dart';

String roleName(L10n t, ChannelRole r) => switch (r) {
  ChannelRole.member => t.roleMember,
  ChannelRole.editor => t.roleEditor,
  ChannelRole.admin => t.roleAdmin,
};

/// Masjid page → Channel. Non-members see the invitation; members read the
/// messages (newest at the bottom); editors and admins also write.
class MasjidChannelTab extends ConsumerWidget {
  const MasjidChannelTab({super.key, required this.masjid});

  final Masjid masjid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(channelRoleProvider(masjid));
    if (role == null) {
      return RefreshList(
        onRefresh: () => refreshAll(ref),
        padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.xxl),
        children: [ChannelInviteCard(masjid: masjid, onOpen: () {})],
      );
    }
    return Column(
      children: [
        _Bar(masjid: masjid, role: role),
        Expanded(
          child: _Messages(masjid: masjid, role: role),
        ),
        if (role.canPost) _Composer(masjid: masjid, role: role),
      ],
    );
  }
}

/// Members (admins) or Leave (members), and who posts here.
class _Bar extends ConsumerWidget {
  const _Bar({required this.masjid, required this.role});

  final Masjid masjid;
  final ChannelRole role;

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final t = L10n.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        content: Text(t.leaveChannelQ, style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(t.leave),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(channelActionsProvider).leave(masjid.id);
    } catch (_) {
      if (context.mounted) toast(context, t.somethingWrong);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final member = ref.watch(channelMembershipProvider(masjid.id)).value;
    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.s, Gap.s),
      child: Row(
        children: [
          Icon(Icons.forum_rounded, size: 18, color: AppColors.gold),
          const SizedBox(width: Gap.s),
          Expanded(
            child: Text(
              role.canPost ? roleName(t, role) : t.channelReadOnly,
              style: AppText.caption.copyWith(color: AppColors.muted),
            ),
          ),
          if (role.canManage)
            TextButton.icon(
              onPressed: () =>
                  push(context, ChannelMembersScreen(masjid: masjid)),
              icon: const Icon(Icons.group_rounded, size: 18),
              label: Text(t.members),
            ),
          // The owner is always an admin – nothing to leave.
          if (member != null)
            IconButton(
              tooltip: t.leaveChannel,
              onPressed: () => _leave(context, ref),
              icon: Icon(Icons.logout_rounded, color: AppColors.muted),
            ),
        ],
      ),
    );
  }
}

class _Messages extends ConsumerWidget {
  const _Messages({required this.masjid, required this.role});

  final Masjid masjid;
  final ChannelRole role;

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ChannelMessage m,
  ) async {
    final t = L10n.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        content: Text(t.deleteMessageQ, style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(backendProvider).deleteChannelMessage(masjid.id, m.id);
    } catch (_) {
      if (context.mounted) toast(context, t.somethingWrong);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final uid = ref.watch(authProvider).value?.uid;
    return ref
        .watch(channelMessagesProvider(masjid.id))
        .when(
          loading: () => const Loader(),
          error: (_, _) => EmptyState(message: t.somethingWrong),
          data: (list) => list.isEmpty
              ? EmptyState(
                  message: role.canPost ? t.channelEmptyAdmin : t.channelEmpty,
                  icon: Icons.forum_outlined,
                )
              : ListView.separated(
                  // Newest at the bottom, like a chat.
                  reverse: true,
                  padding: const EdgeInsets.all(Gap.l),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: Gap.m),
                  itemBuilder: (_, i) {
                    final m = list[i];
                    final mine = m.authorUid == uid;
                    return _Bubble(
                      message: m,
                      mine: mine,
                      onDelete: role.canManage || mine
                          ? () => _delete(context, ref, m)
                          : null,
                    );
                  },
                ),
        );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine, this.onDelete});

  final ChannelMessage message;
  final bool mine;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final now = DateTime.now();
    final sameDay =
        now.year == message.createdAt.year &&
        now.month == message.createdAt.month &&
        now.day == message.createdAt.day;
    return GestureDetector(
      onLongPress: onDelete == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onDelete!();
            },
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.l, Gap.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    mine ? t.you : message.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(color: AppColors.gold),
                  ),
                ),
                const SizedBox(width: Gap.s),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                  child: Text(
                    roleName(t, message.authorRole),
                    style: AppText.micro.copyWith(color: AppColors.gold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Gap.xs),
            SelectableText(message.text, style: AppText.body),
            const SizedBox(height: Gap.xs),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                sameDay
                    ? f.timePeriod(message.createdAt)
                    : '${f.date(message.createdAt)} · '
                          '${f.timePeriod(message.createdAt)}',
                style: AppText.micro.copyWith(color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends ConsumerStatefulWidget {
  const _Composer({required this.masjid, required this.role});

  final Masjid masjid;
  final ChannelRole role;

  @override
  ConsumerState<_Composer> createState() => _ComposerState();
}

class _ComposerState extends ConsumerState<_Composer> {
  final _text = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _text.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(backendProvider)
          .postChannelMessage(widget.masjid, text, widget.role);
      _text.clear();
    } catch (_) {
      if (mounted) toast(context, L10n.of(context).somethingWrong);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Container(
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(
        Gap.l,
        Gap.s,
        Gap.s,
        Gap.s + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _text,
              minLines: 1,
              maxLines: 5,
              maxLength: kMaxChannelMessage,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: t.messageHint,
                counterText: '',
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: Gap.s),
          IconButton.filled(
            tooltip: t.send,
            onPressed: _sending ? null : _send,
            style: IconButton.styleFrom(backgroundColor: AppColors.gold),
            icon: _sending
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../core/widgets/page_header.dart';
import '../../data/models/channel.dart';
import '../../data/models/notice.dart';
import '../../l10n/app_localizations.dart';
import '../../state/channel.dart';
import '../../state/follows.dart';
import '../../state/providers.dart';
import '../masjid/masjid_screen.dart';
import '../notices/notice_card.dart' show showNoticeDetails;

/// Inbox: notices from followed masjids and messages from joined channels,
/// newest first, all in one style. Unread ones are marked until opened.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final ids = ref.watch(followsProvider).keys;
    final notices = ref.watch(noticesProvider(noticeKey(ids)));
    final messages = ref.watch(channelInboxProvider);
    final read = ref.watch(inboxReadProvider.notifier);
    ref.watch(inboxReadProvider);
    final items = <(DateTime, Object)>[
      for (final n in notices.value ?? const <Notice>[]) (n.createdAt, n),
      for (final m in messages) (m.createdAt, m),
    ]..sort((a, b) => b.$1.compareTo(a.$1));
    final unread = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: PatternAppBar(
        title: Text(t.notifications),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: read.markAllRead,
              child: Text(
                t.markAllRead,
                style: AppText.label.copyWith(color: AppColors.goldLight),
              ),
            ),
        ],
      ),
      body: notices.isLoading && items.isEmpty
          ? const Loader()
          : items.isEmpty
          ? EmptyState(
              message: t.noNotifications,
              icon: Icons.notifications_none_rounded,
            )
          : RefreshList.separated(
              onRefresh: () => refreshAll(ref),
              padding: const EdgeInsets.all(Gap.l),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => switch (items[i].$2) {
                final Notice n => InboxTile(
                  icon: Icons.campaign_rounded,
                  kind: t.notice,
                  title:
                      n.category == NoticeCategory.janaza &&
                          (n.personName?.isNotEmpty ?? false)
                      ? t.janazaOf(n.personName!)
                      : n.title,
                  masjid: n.masjidName,
                  at: n.createdAt,
                  unread: read.isUnread(n.id, n.createdAt),
                  onTap: () {
                    read.markRead(n.id);
                    showNoticeDetails(context, n);
                  },
                ),
                final ChannelMessage m => InboxTile(
                  icon: Icons.forum_rounded,
                  kind: t.channelMessages,
                  title: m.text.isNotEmpty
                      ? m.text
                      : '📎 ${m.attachment?.name ?? ''}',
                  masjid: '${m.masjidName} · ${m.authorName}',
                  at: m.createdAt,
                  unread: read.isUnread(m.id, m.createdAt),
                  onTap: () {
                    read.markRead(m.id);
                    push(context, MasjidScreen(masjidId: m.masjidId));
                  },
                ),
                _ => const SizedBox.shrink(),
              },
            ),
    );
  }
}

/// One inbox row – the same for notices and channel messages: a round
/// icon, what it is and when, the text, the masjid; unread ones tinted
/// with a dot.
class InboxTile extends StatelessWidget {
  const InboxTile({
    super.key,
    required this.icon,
    required this.kind,
    required this.title,
    required this.masjid,
    required this.at,
    required this.unread,
    required this.onTap,
  });

  final IconData icon;
  final String kind;
  final String title;
  final String masjid;
  final DateTime at;
  final bool unread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final f = Fmt.of(context);
    return AppCard(
      onTap: onTap,
      color: unread
          ? Color.alphaBlend(
              AppColors.gold.withValues(alpha: 0.10),
              AppColors.card,
            )
          : null,
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.l, Gap.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withValues(alpha: 0.14),
            ),
            child: Icon(icon, size: 20, color: AppColors.gold),
          ),
          const SizedBox(width: Gap.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        kind,
                        style: AppText.micro.copyWith(color: AppColors.gold),
                      ),
                    ),
                    Text(
                      '${f.date(at)} · ${f.timePeriod(at)}',
                      style: AppText.micro.copyWith(color: AppColors.muted),
                    ),
                    if (unread) ...[
                      const SizedBox(width: Gap.s),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: unread
                      ? AppText.label
                      : AppText.body.copyWith(color: AppColors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  masjid,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

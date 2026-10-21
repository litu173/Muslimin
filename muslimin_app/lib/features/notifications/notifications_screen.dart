import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/announcement.dart';
import '../../data/models/inbox_message.dart';
import '../../state/update.dart';
import '../more/about_screen.dart';
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
    final news = ref.watch(announcementsProvider).value ?? const [];
    final read = ref.watch(inboxReadProvider.notifier);
    ref.watch(inboxReadProvider);
    final inbox = ref.watch(myInboxProvider).value ?? const [];
    final items = <(DateTime, Object)>[
      for (final n in notices.value ?? const <Notice>[]) (n.createdAt, n),
      for (final m in messages) (m.createdAt, m),
      for (final a in news) (a.createdAt, a),
      for (final m in inbox) (m.createdAt, m),
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
              // A tap opens a card to its full text (and marks it read); its
              // link goes to the page it is about.
              itemBuilder: (_, i) => switch (items[i].$2) {
                final Notice n => InboxTile(
                  key: ValueKey('n${n.id}'),
                  icon: Icons.campaign_rounded,
                  kind: t.notice,
                  title:
                      n.category == NoticeCategory.janaza &&
                          (n.personName?.isNotEmpty ?? false)
                      ? t.janazaOf(n.personName!)
                      : n.title,
                  body: n.details,
                  masjid: n.masjidName,
                  at: n.createdAt,
                  unread: read.isUnread(n.id, n.createdAt),
                  onRead: () => read.markRead(n.id),
                  openLabel: t.openNotice,
                  onOpen: () => showNoticeDetails(context, n),
                ),
                final ChannelMessage m => InboxTile(
                  key: ValueKey('c${m.id}'),
                  icon: Icons.forum_rounded,
                  kind: t.channelMessages,
                  title: m.text.isNotEmpty
                      ? m.text
                      : '📎 ${m.attachment?.name ?? ''}',
                  masjid: '${m.masjidName} · ${m.authorName}',
                  at: m.createdAt,
                  unread: read.isUnread(m.id, m.createdAt),
                  onRead: () => read.markRead(m.id),
                  openLabel: t.openChannel,
                  onOpen: () =>
                      push(context, MasjidScreen(masjidId: m.masjidId)),
                ),
                final Announcement a => InboxTile(
                  key: ValueKey('a${a.id}'),
                  icon: a.isUpdate
                      ? Icons.system_update_rounded
                      : Icons.newspaper_rounded,
                  kind: a.isUpdate ? t.appUpdate : t.appNews,
                  title: a.title,
                  body: a.body,
                  masjid: 'Muslimin',
                  at: a.createdAt,
                  unread: read.isUnread(a.id, a.createdAt),
                  onRead: () => read.markRead(a.id),
                  openLabel: a.isUpdate ? t.openAbout : null,
                  onOpen: a.isUpdate
                      ? () => push(context, const AboutScreen())
                      : null,
                ),
                final InboxMessage m => InboxTile(
                  key: ValueKey('i${m.id}'),
                  icon: Icons.mark_email_unread_rounded,
                  kind: t.inboxMessage,
                  title: m.title,
                  body: m.body,
                  masjid: 'Muslimin',
                  at: m.createdAt,
                  unread: read.isUnread(m.id, m.createdAt),
                  onRead: () => read.markRead(m.id),
                  openLabel: switch (m.linkType) {
                    'masjid' => t.openMasjid,
                    'about' => t.openAbout,
                    _ => null,
                  },
                  onOpen: switch (m.linkType) {
                    'masjid' => () => push(
                      context,
                      MasjidScreen(masjidId: m.linkId),
                    ),
                    'about' => () => push(context, const AboutScreen()),
                    _ => null,
                  },
                ),
                _ => const SizedBox.shrink(),
              },
            ),
    );
  }
}

/// One inbox row – the same for every kind: a round icon, what it is and
/// when, the text, where it is from; unread ones tinted with a dot. A tap
/// opens it to the full text with a link to its page, and marks it read.
class InboxTile extends StatefulWidget {
  const InboxTile({
    super.key,
    required this.icon,
    required this.kind,
    required this.title,
    required this.masjid,
    required this.at,
    required this.unread,
    required this.onRead,
    this.body = '',
    this.openLabel,
    this.onOpen,
  });

  final IconData icon;
  final String kind;
  final String title;

  /// The full message under the title (may be empty).
  final String body;

  /// Where it is from: the masjid (and author), or Muslimin.
  final String masjid;
  final DateTime at;
  final bool unread;
  final VoidCallback onRead;

  /// The link shown when open ("Open masjid") and where it goes.
  final String? openLabel;
  final VoidCallback? onOpen;

  @override
  State<InboxTile> createState() => _InboxTileState();
}

class _InboxTileState extends State<InboxTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final f = Fmt.of(context);
    final w = widget;
    return AppCard(
      onTap: () {
        w.onRead();
        setState(() => _open = !_open);
      },
      color: w.unread
          ? Color.alphaBlend(
              AppColors.gold.withValues(alpha: 0.10),
              AppColors.card,
            )
          : null,
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.l, Gap.m),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
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
              child: Icon(w.icon, size: 20, color: AppColors.gold),
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
                          w.kind,
                          style: AppText.micro.copyWith(color: AppColors.gold),
                        ),
                      ),
                      Text(
                        '${f.date(w.at)} · ${f.timePeriod(w.at)}',
                        style: AppText.micro.copyWith(color: AppColors.muted),
                      ),
                      if (w.unread) ...[
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
                    w.title,
                    maxLines: _open ? null : 2,
                    overflow: _open ? null : TextOverflow.ellipsis,
                    style: w.unread
                        ? AppText.label
                        : AppText.body.copyWith(color: AppColors.ink),
                  ),
                  if (w.body.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      w.body,
                      maxLines: _open ? null : 2,
                      overflow: _open ? null : TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: AppColors.ink),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          w.masjid,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      Icon(
                        _open
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        size: 18,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                  if (_open && w.onOpen != null) ...[
                    const SizedBox(height: Gap.s),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: w.onOpen,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.gold,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: Text(w.openLabel ?? '', style: AppText.label),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

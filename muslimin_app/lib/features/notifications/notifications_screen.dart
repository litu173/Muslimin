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
import '../notices/notice_card.dart';

/// Inbox: notices from followed masjids and messages from joined channels,
/// newest first.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Opening the page clears the bell's number.
    Future.microtask(() => ref.read(inboxOpenedProvider.notifier).markRead());
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final ids = ref.watch(followsProvider).keys;
    final notices = ref.watch(noticesProvider(noticeKey(ids)));
    final messages = ref.watch(channelInboxProvider);
    final items = <(DateTime, Object)>[
      for (final n in notices.value ?? const <Notice>[]) (n.createdAt, n),
      for (final m in messages) (m.createdAt, m),
    ]..sort((a, b) => b.$1.compareTo(a.$1));

    return Scaffold(
      appBar: PatternAppBar(title: Text(t.notifications)),
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
                final Notice n => NoticeCard(notice: n),
                final ChannelMessage m => ChannelMessageTile(message: m),
                _ => const SizedBox.shrink(),
              },
            ),
    );
  }
}

/// A channel message in the inbox; opens the masjid page.
class ChannelMessageTile extends StatelessWidget {
  const ChannelMessageTile({super.key, required this.message});

  final ChannelMessage message;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    return AppCard(
      onTap: () => push(context, MasjidScreen(masjidId: message.masjidId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.forum_rounded, size: 16, color: AppColors.gold),
              const SizedBox(width: Gap.xs),
              Text(
                t.channelMessages,
                style: AppText.micro.copyWith(color: AppColors.gold),
              ),
              const Spacer(),
              Text(
                '${f.date(message.createdAt)} · '
                '${f.timePeriod(message.createdAt)}',
                style: AppText.micro.copyWith(color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: Gap.xs),
          Text(
            '${message.masjidName} · ${message.authorName}',
            style: AppText.label,
          ),
          const SizedBox(height: 2),
          Text(
            message.text,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: AppText.body,
          ),
        ],
      ),
    );
  }
}

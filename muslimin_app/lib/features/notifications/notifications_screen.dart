import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../core/widgets/page_header.dart';
import '../../l10n/app_localizations.dart';
import '../../state/follows.dart';
import '../../state/providers.dart';
import '../notices/notice_card.dart';

/// Inbox of notices from followed masjids.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final ids = ref.watch(followsProvider).keys;
    final notices = ref.watch(noticesProvider(noticeKey(ids)));
    return Scaffold(
      appBar: PatternAppBar(title: Text(t.notifications)),
      body: ids.isEmpty
          ? EmptyState(
              message: t.noNotifications,
              icon: Icons.notifications_none_rounded,
            )
          : notices.when(
              loading: () => const Loader(),
              error: (_, _) => EmptyState(message: t.somethingWrong),
              data: (list) => list.isEmpty
                  ? EmptyState(
                      message: t.noNotices,
                      icon: Icons.campaign_outlined,
                    )
                  : RefreshList.separated(
                      onRefresh: () => refreshAll(ref),
                      padding: const EdgeInsets.all(Gap.l),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => NoticeCard(notice: list[i]),
                    ),
            ),
    );
  }
}

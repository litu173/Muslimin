import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../core/widgets/swipe_tabs.dart';
import '../../data/models/notice.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'notice_card.dart';

/// Notice tab: notices from nearby masjids, with search, category chips and
/// swipe-to-switch category.
class NoticesScreen extends ConsumerStatefulWidget {
  const NoticesScreen({super.key});

  @override
  ConsumerState<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends ConsumerState<NoticesScreen> {
  static const _tabs = <NoticeCategory?>[null, ...NoticeFilterBar.order];

  final _search = TextEditingController();
  NoticeCategory? _filter;
  String _q = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(Fmt f, Notice n) {
    if (_q.isEmpty) return true;
    final text = [
      n.title,
      n.details,
      n.masjidName,
      f.category(n.category),
      n.personName ?? '',
      n.address ?? '',
    ].join(' ').toLowerCase();
    return _q
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .every(text.contains);
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final notices = ref.watch(nearbyNoticesProvider);
    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: t.tabNotices,
            subtitle: t.noticesSub,
            bottom: AppSearchField(
              controller: _search,
              hint: t.noticeSearchHint,
              onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
            ),
          ),
          const SizedBox(height: Gap.m),
          NoticeFilterBar(
            selected: _filter,
            onChanged: (c) => setState(() => _filter = c),
          ),
          Expanded(
            child: SwipeTabs(
              index: _tabs.indexOf(_filter),
              count: _tabs.length,
              onChanged: (i) => setState(() => _filter = _tabs[i]),
              child: notices.when(
                loading: () => const Loader(),
                error: (_, _) => EmptyState(message: t.somethingWrong),
                data: (all) {
                  final list = [
                    for (final n in all)
                      if ((_filter == null || n.category == _filter) &&
                          _matches(f, n))
                        n,
                  ];
                  if (list.isEmpty) {
                    return RefreshList(
                      onRefresh: () => refreshAll(ref),
                      padding: const EdgeInsets.all(Gap.l),
                      children: [
                        EmptyState(
                          inCard: true,
                          message: t.noNotices,
                          icon: Icons.campaign_outlined,
                        ),
                      ],
                    );
                  }
                  return RefreshList.separated(
                    onRefresh: () => refreshAll(ref),
                    padding: const EdgeInsets.fromLTRB(
                      Gap.l,
                      Gap.m,
                      Gap.l,
                      Gap.xxl,
                    ),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => NoticeCard(notice: list[i]),
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

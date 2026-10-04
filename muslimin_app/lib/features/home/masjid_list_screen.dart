import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/page_header.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'masjid_card.dart';

/// "View All" – every verified masjid within 5 km, searchable.
class MasjidListScreen extends ConsumerStatefulWidget {
  const MasjidListScreen({super.key});

  @override
  ConsumerState<MasjidListScreen> createState() => _MasjidListScreenState();
}

class _MasjidListScreenState extends ConsumerState<MasjidListScreen> {
  final _search = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final masjids = ref.watch(nearbyMasjidsProvider);
    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: t.nearbyMasjids,
            back: true,
            bottom: AppSearchField(
              controller: _search,
              hint: t.searchMasjid,
              onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
            ),
          ),
          const SizedBox(height: Gap.l),
          Expanded(
            child: masjids.when(
              loading: () => const Loader(),
              error: (_, _) => EmptyState(message: t.somethingWrong),
              data: (all) {
                final list = _q.isEmpty
                    ? all
                    : all
                          .where(
                            (m) =>
                                m.name.toLowerCase().contains(_q) ||
                                m.nameBn.contains(_q) ||
                                m.fullAddress.toLowerCase().contains(_q),
                          )
                          .toList();
                if (list.isEmpty) {
                  return EmptyState(
                    message: t.noMasjidNearby,
                    hint: t.noMasjidNearbyHint,
                  );
                }
                return RefreshList.separated(
                  onRefresh: () => refreshAll(ref),
                  padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.xxl),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => MasjidCard(masjid: list[i], index: i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

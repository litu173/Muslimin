import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
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
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final masjids = ref.watch(nearbyMasjidsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.nearbyMasjids)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: TextField(
              onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: t.searchMasjid,
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.ink),
              ),
            ),
          ),
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

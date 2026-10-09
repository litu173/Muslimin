import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/page_header.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import 'masjid_card.dart';

/// "View All" – every verified masjid, nearest first, searchable.
class MasjidListScreen extends ConsumerStatefulWidget {
  const MasjidListScreen({super.key});

  @override
  ConsumerState<MasjidListScreen> createState() => _MasjidListScreenState();
}

class _MasjidListScreenState extends ConsumerState<MasjidListScreen> {
  final _search = TextEditingController();
  String _q = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final masjids = ref.watch(allMasjidsProvider);
    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: t.allMasjids,
            subtitle: t.nearestFirst,
            back: true,
            bottom: AppSearchField(
              controller: _search,
              hint: t.searchMasjid,
              // Each country-wide search is a database query: wait until
              // the typing pauses.
              onChanged: (v) {
                _debounce?.cancel();
                _debounce = Timer(
                  const Duration(milliseconds: 400),
                  () => setState(() => _q = v.trim().toLowerCase()),
                );
              },
            ),
          ),
          const SizedBox(height: Gap.l),
          Expanded(
            child: masjids.when(
              loading: () => const Loader(),
              error: (_, _) => EmptyState(message: t.somethingWrong),
              data: (all) {
                final local = _q.isEmpty
                    ? all
                    : all
                          .where(
                            (m) =>
                                m.name.toLowerCase().contains(_q) ||
                                m.nameBn.contains(_q) ||
                                m.fullAddress.toLowerCase().contains(_q),
                          )
                          .toList();
                // Beyond the area around you: names across the country.
                final far = _q.length < 3
                    ? const <Masjid>[]
                    : ref.watch(searchMasjidsProvider(_q)).value ?? const [];
                final seen = {for (final m in local) m.id};
                final list = [
                  ...local,
                  for (final m in far)
                    if (!seen.contains(m.id)) m,
                ];
                if (list.isEmpty) {
                  return EmptyState(
                    message: t.noMasjidNearby,
                    hint: t.noMasjidNearbyHint,
                  );
                }
                return RefreshList.separated(
                  onRefresh: () async {
                    ref.invalidate(allMasjidsProvider);
                    await refreshAll(ref);
                  },
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

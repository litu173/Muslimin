import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../core/widgets/thana_picker.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../masjid/suggest_masjid.dart';
import 'masjid_card.dart';

/// "All Masjids": the masjids of one thana / upazila – the user's own by
/// default, or any other picked from the list – nearest first, searchable.
/// Picking a thana only changes this list, not the user's location.
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

  Future<void> _pickThana() async {
    final picked = await pickThana(
      context,
      mine: ref.read(myThanaProvider).value,
      current: ref.read(pickedThanaProvider),
    );
    if (picked == null) return;
    final mine = ref.read(myThanaProvider).value;
    ref.read(pickedThanaProvider.notifier).pick(picked == mine ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final masjids = ref.watch(thanaMasjidsProvider);
    final mine = ref.watch(myThanaProvider).value;
    final shown = ref.watch(pickedThanaProvider) ?? mine;
    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: t.allMasjids,
            subtitle: shown == null
                ? t.locating
                : '${shown.label} · ${t.nearestFirst}',
            back: true,
            bottom: Row(
              children: [
                ThanaButton(
                  label: shown?.name ?? t.chooseThana,
                  onTap: _pickThana,
                ),
                const SizedBox(width: Gap.s),
                Expanded(
                  child: AppSearchField(
                    controller: _search,
                    hint: t.searchMasjid,
                    iconRight: true,
                    // Each country-wide search is a database query: wait
                    // until the typing pauses.
                    onChanged: (v) {
                      _debounce?.cancel();
                      _debounce = Timer(
                        const Duration(milliseconds: 400),
                        () => setState(() => _q = v.trim().toLowerCase()),
                      );
                    },
                  ),
                ),
              ],
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
                // Not in this thana: names across the country.
                final far = _q.length < 3
                    ? const <Masjid>[]
                    : ref.watch(searchMasjidsProvider(_q)).value ?? const [];
                final seen = {for (final m in local) m.id};
                final list = [
                  ...local,
                  for (final m in far)
                    if (!seen.contains(m.id)) m,
                ];
                return RefreshList.separated(
                  onRefresh: () async {
                    ref.invalidate(myThanaMasjidsProvider);
                    await refreshAll(ref);
                  },
                  padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.xxl),
                  // The last item asks for masjids that are missing.
                  itemCount: list.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => i < list.length
                      ? MasjidCard(masjid: list[i], index: i)
                      : _MissingCard(empty: list.isEmpty),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// End of the list: "Masjid missing? Add it."
class _MissingCard extends ConsumerWidget {
  const _MissingCard({required this.empty});

  final bool empty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            empty ? t.noMasjidInThana : t.missingMasjidTitle,
            style: AppText.label,
          ),
          const SizedBox(height: 4),
          Text(t.missingMasjidBody, style: AppText.caption),
          const SizedBox(height: Gap.m),
          AppButton(
            t.addMissingMasjid,
            icon: Icons.add_location_alt_outlined,
            pill: true,
            dense: true,
            onPressed: () => suggestMasjid(context, ref),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../core/widgets/thana_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../services/places.dart';
import '../../services/thana_service.dart';
import '../../state/providers.dart';
import 'masjid_card.dart';

/// Masjids with a place for women to pray: nearest first by default, or
/// those of a picked thana; searchable by name or address. Every masjid
/// marked by its owner / admin is read once and filtered on the phone.
class WomenSpaceScreen extends ConsumerStatefulWidget {
  const WomenSpaceScreen({super.key});

  @override
  ConsumerState<WomenSpaceScreen> createState() => _WomenSpaceScreenState();
}

class _WomenSpaceScreenState extends ConsumerState<WomenSpaceScreen> {
  final _search = TextEditingController();
  String _q = '';

  /// Null = nearest to me (any thana). Only this page follows it.
  Thana? _picked;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _pickThana() async {
    final picked = await pickThana(
      context,
      mine: ref.read(myThanaProvider).value,
      current: _picked ?? nearestThana,
      nearest: true,
    );
    if (picked == null) return;
    setState(() => _picked = picked == nearestThana ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final masjids = ref.watch(womenSpaceMasjidsProvider);
    final loc = ref.watch(locationProvider).value;
    final list = (masjids.value ?? const []).where((m) {
      if (_picked != null &&
          (m.district != _picked!.district || m.thana != _picked!.name)) {
        return false;
      }
      if (_q.isEmpty) return true;
      return m.name.toLowerCase().contains(_q) ||
          m.nameBn.contains(_q) ||
          m.fullAddress.toLowerCase().contains(_q);
    }).toList();
    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: masjids.value == null
                ? t.womenFinderTitle
                : '${t.womenFinderTitle} (${f.digits(list.length)})',
            subtitle: _picked != null
                ? '${_picked!.label} · ${t.nearestFirst}'
                : loc == null
                ? t.locating
                : '${loc.label} · ${t.nearestFirst}',
            back: true,
            bottom: Row(
              children: [
                ThanaButton(
                  label: _picked == null
                      ? t.nearestOption
                      : Places.of(_picked!.name),
                  onTap: _pickThana,
                ),
                const SizedBox(width: Gap.s),
                Expanded(
                  child: AppSearchField(
                    controller: _search,
                    hint: t.searchMasjid,
                    iconRight: true,
                    // Filters the list already on the phone – no query.
                    onChanged: (v) =>
                        setState(() => _q = v.trim().toLowerCase()),
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
              data: (_) => list.isEmpty
                  ? EmptyState(
                      message: t.womenFinderEmpty,
                      hint: t.womenFinderEmptyHint,
                      icon: Icons.woman_rounded,
                    )
                  : RefreshList.separated(
                      onRefresh: () async {
                        ref.invalidate(womenSpaceMasjidsProvider);
                        await refreshAll(ref);
                      },
                      padding: const EdgeInsets.fromLTRB(
                        Gap.l,
                        0,
                        Gap.l,
                        Gap.xxl,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          MasjidCard(masjid: list[i], index: i),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

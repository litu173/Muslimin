import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../services/thana_service.dart';
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
    final picked = await showModalBottomSheet<Thana>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      builder: (_) => _ThanaSheet(
        mine: ref.read(myThanaProvider).value,
        current: ref.read(pickedThanaProvider),
      ),
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
                _ThanaButton(
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
                    ref.invalidate(thanaMasjidsProvider);
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

/// White pill on the header: "New Market ▾".
class _ThanaButton extends StatelessWidget {
  const _ThanaButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.sizeOf(context).width * 0.42,
    ),
    child: Material(
      color: AppColors.field,
      shape: StadiumBorder(side: BorderSide(color: AppColors.divider)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 11, 8, 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.place_outlined, size: 18, color: AppColors.gold),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(color: AppColors.ink),
                ),
              ),
              Icon(Icons.arrow_drop_down_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    ),
  );
}

/// All thanas / upazilas, searchable; the user's own first.
class _ThanaSheet extends StatefulWidget {
  const _ThanaSheet({required this.mine, required this.current});

  final Thana? mine;
  final Thana? current;

  @override
  State<_ThanaSheet> createState() => _ThanaSheetState();
}

class _ThanaSheetState extends State<_ThanaSheet> {
  final _q = TextEditingController();
  List<Thana> _all = const [];

  @override
  void initState() {
    super.initState();
    ThanaService.load().then((s) {
      if (mounted) setState(() => _all = s.all);
    });
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final q = _q.text.trim().toLowerCase();
    final list = q.isEmpty
        ? _all
        : _all
              .where(
                (a) =>
                    a.name.toLowerCase().contains(q) ||
                    a.district.toLowerCase().contains(q),
              )
              .toList();
    final selected = widget.current ?? widget.mine;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (_, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.chooseThana, style: AppText.subtitle),
                Text(
                  t.chooseThanaHint,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: Gap.m),
                AppSearchField(
                  controller: _q,
                  hint: t.searchThana,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: scroll,
              children: [
                if (widget.mine != null && q.isEmpty)
                  ListTile(
                    leading: Icon(
                      Icons.my_location_rounded,
                      color: AppColors.gold,
                    ),
                    title: Text(widget.mine!.name, style: AppText.label),
                    subtitle: Text(
                      t.myThana,
                      style: AppText.micro.copyWith(color: AppColors.muted),
                    ),
                    trailing: selected == widget.mine
                        ? Icon(Icons.check_rounded, color: AppColors.gold)
                        : null,
                    onTap: () => Navigator.pop(context, widget.mine),
                  ),
                for (final a in list)
                  ListTile(
                    dense: true,
                    title: Text(a.name, style: AppText.body),
                    subtitle: Text(
                      a.district,
                      style: AppText.micro.copyWith(color: AppColors.muted),
                    ),
                    trailing: a == selected
                        ? Icon(Icons.check_rounded, color: AppColors.gold)
                        : null,
                    onTap: () => Navigator.pop(context, a),
                  ),
              ],
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

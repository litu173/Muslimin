import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/bd_districts.dart';
import '../../data/models/hm.dart';
import '../../data/models/volunteer.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../../state/volunteer.dart';
import '../masjid/masjid_screen.dart';
import '../masjid/volunteer.dart';

/// Admin → Report: how far the country's masjids are covered, and where
/// volunteers are needed.
class AdminReportTab extends ConsumerStatefulWidget {
  const AdminReportTab({super.key});

  @override
  ConsumerState<AdminReportTab> createState() => _AdminReportTabState();
}

class _AdminReportTabState extends ConsumerState<AdminReportTab> {
  /// District coverage costs two counts per district – loaded on request.
  List<DistrictCoverage>? _districts;
  bool _loadingDistricts = false;

  Future<void> _loadDistricts() async {
    setState(() => _loadingDistricts = true);
    try {
      final list = await ref.read(backendProvider).districtCoverage([
        for (final d in bdDistricts) d.$1,
      ]);
      // Fewest times filled in (as a share) first: where help is needed.
      list.sort((a, b) {
        double share(DistrictCoverage c) =>
            c.masjids == 0 ? 1 : c.withTimes / c.masjids;
        return share(a).compareTo(share(b));
      });
      setState(() => _districts = list);
    } catch (_) {
      if (mounted) toast(context, L10n.of(context).somethingWrong);
    } finally {
      if (mounted) setState(() => _loadingDistricts = false);
    }
  }

  void _share(AdminStats s) {
    final t = L10n.of(context);
    final pct = s.masjids == 0 ? 0 : (s.withTimes * 100 / s.masjids).round();
    final lines = [
      'Muslimin – ${t.adminReport} (${DateTime.now().toString().substring(0, 10)})',
      '${t.statMasjids}: ${s.masjids}',
      '${t.statWithTimes}: ${s.withTimes} ($pct%)',
      '${t.statVolunteers}: ${s.editors}',
      '${t.statOpenReports}: ${s.openReports}',
      '${t.statPending}: ${s.pending}',
      if (_districts != null) ...[
        '',
        t.coverageTitle,
        for (final d in _districts!)
          '${d.district}: ${d.withTimes}/${d.masjids}',
      ],
    ];
    SharePlus.instance.share(ShareParams(text: lines.join('\n')));
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final stats = ref.watch(adminStatsProvider);
    return RefreshList(
      onRefresh: () async {
        ref.invalidate(adminStatsProvider);
        if (_districts != null) await _loadDistricts();
      },
      padding: const EdgeInsets.all(Gap.l),
      children: [
        stats.when(
          loading: () => const Loader(),
          error: (e, _) => LoadError(
            error: e,
            onRetry: () => ref.invalidate(adminStatsProvider),
          ),
          data: (s) {
            final pct = s.masjids == 0 ? 0.0 : s.withTimes / s.masjids;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.statWithTimes, style: AppText.caption),
                      const SizedBox(height: 4),
                      Text(
                        '${f.digits(s.withTimes)} / ${f.digits(s.masjids)}'
                        '  ·  ${f.digits((pct * 100).round())}%',
                        style: AppText.title,
                      ),
                      const SizedBox(height: Gap.s),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Radii.pill),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 8,
                          color: AppColors.gold,
                          backgroundColor: AppColors.gold.withValues(
                            alpha: 0.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Stat(t.statMasjids, f.digits(s.masjids)),
                    const SizedBox(width: 10),
                    _Stat(t.statVolunteers, f.digits(s.editors)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Stat(
                      t.statOpenReports,
                      f.digits(s.openReports),
                      alert: s.openReports > 0,
                    ),
                    const SizedBox(width: 10),
                    _Stat(t.statPending, f.digits(s.pending)),
                  ],
                ),
                const SizedBox(height: Gap.l),
                AppButton(
                  t.shareReport,
                  icon: Icons.ios_share_rounded,
                  style: AppButtonStyle.outlined,
                  expand: true,
                  onPressed: () => _share(s),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: Gap.xl),
        Text(t.coverageTitle, style: AppText.subtitle),
        const SizedBox(height: Gap.s),
        if (_districts == null)
          AppButton(
            _loadingDistricts ? t.loading : t.coverageLoad,
            expand: true,
            onPressed: _loadingDistricts ? null : _loadDistricts,
          )
        else
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.l,
              vertical: Gap.s,
            ),
            child: Column(
              children: [
                for (final d in _districts!)
                  if (d.masjids > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(d.district, style: AppText.body),
                          ),
                          SizedBox(
                            width: 90,
                            child: LinearProgressIndicator(
                              value: d.withTimes / d.masjids,
                              color: AppColors.gold,
                              backgroundColor: AppColors.gold.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          const SizedBox(width: Gap.m),
                          SizedBox(
                            width: 80,
                            child: Text(
                              '${f.digits(d.withTimes)}/${f.digits(d.masjids)}',
                              textAlign: TextAlign.end,
                              style: AppText.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, {this.alert = false});

  final String label;
  final String value;
  final bool alert;

  @override
  Widget build(BuildContext context) => Expanded(
    child: AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.caption),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppText.title.copyWith(
              color: alert ? AppColors.danger : null,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Admin → Problems: open reports from users, newest first.
class AdminProblemsTab extends ConsumerWidget {
  const AdminProblemsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final now = ref.watch(minuteProvider);
    return ref
        .watch(openReportsProvider)
        .when(
          loading: () => const Loader(),
          error: (e, _) => LoadError(
            error: e,
            onRetry: () => ref.invalidate(openReportsProvider),
          ),
          data: (list) {
            if (list.isEmpty) {
              return EmptyState(
                message: t.nothingHere,
                icon: Icons.verified_outlined,
              );
            }
            // How many people reported each masjid.
            final perMasjid = <String, int>{};
            for (final r in list) {
              perMasjid[r.masjidId] = (perMasjid[r.masjidId] ?? 0) + 1;
            }
            return RefreshList.separated(
              onRefresh: () async => ref.invalidate(openReportsProvider),
              padding: const EdgeInsets.all(Gap.l),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final r = list[i];
                final n = perMasjid[r.masjidId]!;
                return AppCard(
                  onTap: () =>
                      push(context, MasjidScreen(masjidId: r.masjidId)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(r.masjidName, style: AppText.label),
                          ),
                          if (n > 1)
                            StatusPill(
                              label: '×${f.digits(n)}',
                              color: AppColors.danger,
                            ),
                        ],
                      ),
                      Text(
                        r.district,
                        style: AppText.micro.copyWith(color: AppColors.muted),
                      ),
                      const SizedBox(height: Gap.s),
                      StatusPill(
                        label: reportReasonLabel(t, r.reason),
                        color: AppColors.gold,
                      ),
                      if (r.note.isNotEmpty) ...[
                        const SizedBox(height: Gap.s),
                        Text(r.note, style: AppText.body),
                      ],
                      const SizedBox(height: Gap.s),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${r.userName} · '
                              '${r.createdAt == null ? '' : f.relativeDays(r.createdAt!, now)}',
                              style: AppText.micro.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await ref
                                    .read(backendProvider)
                                    .resolveReport(r.id);
                              } catch (_) {
                                if (context.mounted) {
                                  toast(context, t.somethingWrong);
                                }
                              }
                            },
                            child: Text(t.resolve),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
  }
}

/// Admin → Edits: the latest changes by volunteers and owners, with undo.
class AdminEditsTab extends ConsumerWidget {
  const AdminEditsTab({super.key});

  String _field(L10n t, String f) => switch (f) {
    'jamat' => t.jamatTime,
    'staff' => t.editFieldStaff,
    'maktab' => t.editFieldMaktab,
    'location' => t.editFieldLocation,
    _ => f,
  };

  /// "Fajr 5:30 → 5:45, Isha — → 8:00" for jamat edits.
  String _diff(Fmt f, MasjidEdit e) {
    if (e.field != 'jamat') return '';
    final keys = {...e.before.keys, ...e.after.keys};
    return [
      for (final k in keys)
        if (e.before[k] != e.after[k])
          '$k ${_hm(f, e.before[k])} → ${_hm(f, e.after[k])}',
    ].join(', ');
  }

  String _hm(Fmt f, Object? v) {
    final hm = HM.tryParse(v);
    return hm == null ? '—' : f.hm(hm);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final now = ref.watch(minuteProvider);
    return ref
        .watch(recentEditsProvider)
        .when(
          loading: () => const Loader(),
          error: (e, _) => LoadError(
            error: e,
            onRetry: () => ref.invalidate(recentEditsProvider),
          ),
          data: (list) => list.isEmpty
              ? EmptyState(message: t.nothingHere, icon: Icons.history_rounded)
              : RefreshList.separated(
                  onRefresh: () async => ref.invalidate(recentEditsProvider),
                  padding: const EdgeInsets.all(Gap.l),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final e = list[i];
                    final diff = _diff(f, e);
                    return AppCard(
                      onTap: () =>
                          push(context, MasjidScreen(masjidId: e.masjidId)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.masjidName, style: AppText.label),
                          Text(
                            '${_field(t, e.field)} · ${e.name} · '
                            '${e.at == null ? '' : f.relativeDays(e.at!, now)}',
                            style: AppText.micro.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                          if (diff.isNotEmpty) ...[
                            const SizedBox(height: Gap.s),
                            Text(diff, style: AppText.caption),
                          ],
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton.icon(
                              icon: const Icon(Icons.undo_rounded, size: 18),
                              label: Text(t.revert),
                              onPressed: () async {
                                try {
                                  await ref.read(backendProvider).revertEdit(e);
                                  if (context.mounted) {
                                    toast(context, t.reverted);
                                  }
                                } catch (_) {
                                  if (context.mounted) {
                                    toast(context, t.somethingWrong);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
  }
}

/// Admin → New masjids: masjids users found missing and pinned on the map.
class AdminSuggestionsTab extends ConsumerWidget {
  const AdminSuggestionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final now = ref.watch(minuteProvider);
    return ref
        .watch(openSuggestionsProvider)
        .when(
          loading: () => const Loader(),
          error: (e, _) => LoadError(
            error: e,
            onRetry: () => ref.invalidate(openSuggestionsProvider),
          ),
          data: (list) => list.isEmpty
              ? EmptyState(message: t.nothingHere, icon: Icons.mosque_outlined)
              : RefreshList.separated(
                  onRefresh: () async =>
                      ref.invalidate(openSuggestionsProvider),
                  padding: const EdgeInsets.all(Gap.l),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final s = list[i];
                    Future<void> act(Future<void> Function() a) async {
                      try {
                        await a();
                      } catch (_) {
                        if (context.mounted) toast(context, t.somethingWrong);
                      }
                    }

                    return AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name, style: AppText.label),
                          if (s.nameBn.isNotEmpty)
                            Text(s.nameBn, style: AppText.caption),
                          Text(
                            '${s.thana}, ${s.district}',
                            style: AppText.micro.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: Gap.s),
                          Text(
                            '${s.userName} · '
                            '${s.createdAt == null ? '' : f.relativeDays(s.createdAt!, now)}',
                            style: AppText.micro.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.map_outlined, size: 18),
                                label: Text(t.seeOnMap),
                                onPressed: () => launchUrl(
                                  Uri.parse(
                                    'https://www.openstreetmap.org/?mlat=${s.lat}&mlon=${s.lng}#map=19/${s.lat}/${s.lng}',
                                  ),
                                  mode: LaunchMode.externalApplication,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => act(
                                  () => ref
                                      .read(backendProvider)
                                      .rejectSuggestion(s.id),
                                ),
                                child: Text(
                                  t.reject,
                                  style: TextStyle(color: AppColors.danger),
                                ),
                              ),
                              TextButton(
                                onPressed: () => act(
                                  () => ref
                                      .read(backendProvider)
                                      .approveSuggestion(s),
                                ),
                                child: Text(t.approve),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
  }
}

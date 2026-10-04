import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/gold_sheet.dart';
import '../../../core/widgets/refresh.dart';
import '../../../core/widgets/surfaces.dart';
import '../../../data/models/hm.dart';
import '../../../data/models/masjid.dart';
import '../../../data/models/prayer.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/follows.dart';
import '../../../state/providers.dart';
import '../time_board_scan.dart';

Future<HM?> pickTime(BuildContext context, HM? initial) async {
  final r = await showTimePicker(
    context: context,
    initialTime: initial == null
        ? const TimeOfDay(hour: 12, minute: 0)
        : TimeOfDay(hour: initial.hour, minute: initial.minute),
  );
  return r == null ? null : HM(r.hour, r.minute);
}

class MasjidHomeTab extends ConsumerStatefulWidget {
  const MasjidHomeTab({super.key, required this.masjid, required this.canEdit});

  final Masjid masjid;
  final bool canEdit;

  @override
  ConsumerState<MasjidHomeTab> createState() => _MasjidHomeTabState();
}

class _MasjidHomeTabState extends ConsumerState<MasjidHomeTab> {
  bool _editJamat = false;
  bool _editMaktab = false;

  @override
  Widget build(BuildContext context) {
    return RefreshList(
      onRefresh: () => refreshAll(ref),
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.xxl),
      children: [
        _editJamat
            ? _JamatEditor(
                masjid: widget.masjid,
                onDone: () => setState(() => _editJamat = false),
              )
            : _JamatCard(
                masjid: widget.masjid,
                canEdit: widget.canEdit,
                onEdit: () => setState(() => _editJamat = true),
              ),
        const SizedBox(height: 10),
        if (_editMaktab)
          _MaktabEditor(
            masjid: widget.masjid,
            onDone: () => setState(() => _editMaktab = false),
          )
        else if (!widget.masjid.maktab.isEmpty || widget.canEdit)
          _MaktabCard(
            masjid: widget.masjid,
            canEdit: widget.canEdit,
            onEdit: () => setState(() => _editMaktab = true),
          ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Image.asset(icon, width: 24, height: 24),
      const SizedBox(width: Gap.m),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.body),
            if (subtitle != null) Text(subtitle!, style: AppText.micro),
          ],
        ),
      ),
      ?trailing,
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.now = false,
    this.nowLabel,
  });

  final String label;
  final Widget value;
  final bool now;
  final String? nowLabel;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 11),
    child: Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 96),
          child: Text(label, style: AppText.label),
        ),
        if (now)
          Text(nowLabel!, style: AppText.label.copyWith(color: AppColors.gold)),
        const Spacer(),
        value,
      ],
    ),
  );
}

class _JamatCard extends ConsumerWidget {
  const _JamatCard({
    required this.masjid,
    required this.canEdit,
    required this.onEdit,
  });

  final Masjid masjid;
  final bool canEdit;
  final VoidCallback onEdit;

  Future<void> _reminderSheet(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final picked = await showGoldSheet<int>(
      context,
      icon: Icons.notifications_none_rounded,
      title: t.jamatReminder,
      subtitle: t.notifyBefore,
      selected: current,
      selectedLabel: t.selected,
      options: [
        for (final m in const [15, 30, 45])
          GoldSheetOption(m, t.minsBefore(f.digits(m))),
        if (current > 0) GoldSheetOption(0, t.reminderOff),
      ],
    );
    if (picked == null) return;
    await ref.read(followsProvider.notifier).setReminder(masjid, picked);
    if (context.mounted && picked > 0) {
      toast(context, t.reminderSet(f.digits(picked)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final waqt = ref.watch(waqtProvider);
    final reminder = ref.watch(followsProvider)[masjid.id]?.reminder ?? 0;
    final now = ref.watch(minuteProvider);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xl, Gap.xl, Gap.m),
      child: Column(
        children: [
          _CardHeader(
            icon: 'assets/images/kaaba.png',
            title: t.jamatTime,
            subtitle: masjid.jamatUpdatedAt == null
                ? null
                : t.lastUpdated(f.relativeDays(masjid.jamatUpdatedAt!, now)),
            trailing: canEdit
                ? AppButton(t.edit, onPressed: onEdit, dense: true, pill: true)
                : CircleIconButton(
                    icon: reminder > 0
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined,
                    active: reminder > 0,
                    tooltip: t.jamatReminder,
                    onTap: () => _reminderSheet(context, ref, reminder),
                  ),
          ),
          const SizedBox(height: Gap.s),
          for (final p in Prayer.values) ...[
            _Row(
              label: f.prayer(p),
              now: waqt?.isCurrent == true && waqt!.prayer == p,
              nowLabel: t.now,
              value: Text(
                masjid.jamat[p] == null ? '—' : f.hm(masjid.jamat[p]!),
                style: AppText.label,
              ),
            ),
            if (p != Prayer.jumuah) const Divider(),
          ],
        ],
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({
    required this.text,
    required this.onTap,
    this.highlight = false,
  });

  final String text;
  final VoidCallback onTap;

  /// Gold outline for a value filled in from a scanned photo.
  final bool highlight;

  @override
  Widget build(BuildContext context) => Material(
    color: highlight ? AppColors.gold.withValues(alpha: 0.12) : AppColors.pill,
    shape: StadiumBorder(
      side: highlight
          ? BorderSide(color: AppColors.gold, width: 1.2)
          : BorderSide.none,
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(Radii.pill),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        alignment: Alignment.center,
        child: Text(text, style: AppText.label),
      ),
    ),
  );
}

class _JamatEditor extends ConsumerStatefulWidget {
  const _JamatEditor({required this.masjid, required this.onDone});

  final Masjid masjid;
  final VoidCallback onDone;

  @override
  ConsumerState<_JamatEditor> createState() => _JamatEditorState();
}

class _JamatEditorState extends ConsumerState<_JamatEditor> {
  late final Map<Prayer, HM> _jamat = {...widget.masjid.jamat};
  bool _saving = false;

  /// Prayers whose time came from a scanned photo (highlighted for review).
  final _fromPhoto = <Prayer>{};

  Future<void> _scan() async {
    final read = await scanTimeBoard(context);
    if (read == null || !mounted) return;
    setState(() {
      _jamat.addAll(read);
      _fromPhoto
        ..clear()
        ..addAll(read.keys);
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(backendProvider).updateJamat(widget.masjid.id, _jamat);
      if (mounted) toast(context, L10n.of(context).updated);
      widget.onDone();
    } catch (_) {
      if (mounted) toast(context, L10n.of(context).somethingWrong);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final now = ref.watch(minuteProvider);
    return AppCard(
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        children: [
          _CardHeader(
            icon: 'assets/images/kaaba.png',
            title: t.jamatTime,
            subtitle: widget.masjid.jamatUpdatedAt == null
                ? null
                : t.lastUpdated(
                    f.relativeDays(widget.masjid.jamatUpdatedAt!, now),
                  ),
            trailing: CircleIconButton(
              icon: Icons.photo_camera_outlined,
              active: true,
              tooltip: t.scanBoard,
              onTap: _scan,
            ),
          ),
          const SizedBox(height: Gap.m),
          // Two ways to update: scan the board, or tap each time below.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _fromPhoto.isEmpty
                ? InkWell(
                    key: const ValueKey('hint'),
                    borderRadius: BorderRadius.circular(Radii.button),
                    onTap: _scan,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Gap.m),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(Radii.button),
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.gold,
                            size: 20,
                          ),
                          const SizedBox(width: Gap.s),
                          Expanded(
                            child: Text(
                              t.scanBoardHint,
                              style: AppText.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    key: const ValueKey('review'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(Gap.m),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Radii.button),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: Gap.s),
                        Expanded(
                          child: Text(t.scanReview, style: AppText.caption),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: Gap.s),
          for (final p in Prayer.values) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: Text(f.prayer(p), style: AppText.label)),
                  if (_fromPhoto.contains(p))
                    Padding(
                      padding: const EdgeInsets.only(right: Gap.s),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: AppColors.gold,
                      ),
                    ),
                  _TimePill(
                    text: _jamat[p] == null ? t.tapToSet : f.hm(_jamat[p]!),
                    highlight: _fromPhoto.contains(p),
                    onTap: () async {
                      final v = await pickTime(context, _jamat[p]);
                      if (v != null) {
                        setState(() {
                          _jamat[p] = v;
                          _fromPhoto.remove(p);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            if (p != Prayer.jumuah) const Divider(),
          ],
          const SizedBox(height: Gap.l),
          ButtonPair(
            secondary: AppButton(
              t.cancel,
              style: AppButtonStyle.outlined,
              pill: true,
              onPressed: widget.onDone,
            ),
            primary: AppButton(
              t.update,
              pill: true,
              loading: _saving,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }
}

String maktabDaysLabel(Fmt f, List<int> days) {
  if (days.isEmpty) return '';
  final idx = days.map(Fmt.satFirstIndex).toList()..sort();
  final contiguous = idx.last - idx.first == idx.length - 1;
  if (contiguous && idx.length > 2) {
    return f.t.dayRange(f.weekdaysLong[idx.first], f.weekdaysLong[idx.last]);
  }
  return idx.map((i) => f.weekdaysShort[i]).join(', ');
}

class _MaktabCard extends StatelessWidget {
  const _MaktabCard({
    required this.masjid,
    required this.canEdit,
    required this.onEdit,
  });

  final Masjid masjid;
  final bool canEdit;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final m = masjid.maktab;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xl, Gap.xl, Gap.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: 'assets/images/maktab.png',
            title: t.maktabTime,
            trailing: canEdit
                ? AppButton(t.edit, onPressed: onEdit, dense: true, pill: true)
                : null,
          ),
          if (m.days.isNotEmpty) ...[
            const SizedBox(height: Gap.l),
            Text(
              maktabDaysLabel(f, m.days),
              style: AppText.label.copyWith(color: AppColors.gold),
            ),
          ],
          const SizedBox(height: Gap.s),
          if (m.morning != null)
            _Row(
              label: t.morning,
              value: Text(f.hmRange(m.morning!), style: AppText.label),
            ),
          if (m.morning != null && m.evening != null) const Divider(),
          if (m.evening != null)
            _Row(
              label: t.evening,
              value: Text(f.hmRange(m.evening!), style: AppText.label),
            ),
          if (m.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.s),
              child: Text(t.notAdded, style: AppText.caption),
            ),
        ],
      ),
    );
  }
}

class _MaktabEditor extends ConsumerStatefulWidget {
  const _MaktabEditor({required this.masjid, required this.onDone});

  final Masjid masjid;
  final VoidCallback onDone;

  @override
  ConsumerState<_MaktabEditor> createState() => _MaktabEditorState();
}

class _MaktabEditorState extends ConsumerState<_MaktabEditor> {
  late final Set<int> _days = {...widget.masjid.maktab.days};
  late HMRange? _morning = widget.masjid.maktab.morning;
  late HMRange? _evening = widget.masjid.maktab.evening;
  late bool _showMorning = _morning != null || _evening == null;
  late bool _showEvening = _evening != null;
  bool _saving = false;

  Future<HMRange?> _pickRange(HMRange? current) async {
    final s = await pickTime(context, current?.start);
    if (s == null || !mounted) return null;
    final e = await pickTime(
      context,
      current?.end ?? HM((s.hour + 1) % 24, s.minute),
    );
    return e == null ? null : HMRange(s, e);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(backendProvider)
          .updateMaktab(
            widget.masjid.id,
            Maktab(
              days: _days.toList()..sort(),
              morning: _showMorning ? _morning : null,
              evening: _showEvening ? _evening : null,
            ),
          );
      if (mounted) toast(context, L10n.of(context).updated);
      widget.onDone();
    } catch (_) {
      if (mounted) toast(context, L10n.of(context).somethingWrong);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);

    Widget rangeRow(
      String label,
      HMRange? value,
      ValueChanged<HMRange> onSet,
      VoidCallback onRemove,
    ) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppText.label)),
          _TimePill(
            text: value == null ? t.tapToSet : f.hmRange(value),
            onTap: () async {
              final r = await _pickRange(value);
              if (r != null) setState(() => onSet(r));
            },
          ),
          IconButton(
            tooltip: t.removeSession,
            onPressed: () => setState(onRemove),
            icon: Icon(Icons.delete_outline_rounded, color: AppColors.danger),
          ),
        ],
      ),
    );

    Widget addButton(String label, VoidCallback onTap) => TextButton.icon(
      onPressed: () => setState(onTap),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: Text(t.addSession(label)),
    );

    return AppCard(
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(icon: 'assets/images/maktab.png', title: t.maktabTime),
          const SizedBox(height: Gap.l),
          Wrap(
            spacing: 6,
            runSpacing: 8,
            children: [
              for (var i = 0; i < 7; i++)
                AppChip(
                  dense: true,
                  label: f.weekdaysShort[i],
                  // Unselected days in light grey so they read as tappable.
                  idleColor: AppColors.chipIdle,
                  idleTextColor: AppColors.muted,
                  selected: _days.contains(Fmt.weekdayFromSatFirst(i)),
                  onTap: () => setState(() {
                    final wd = Fmt.weekdayFromSatFirst(i);
                    _days.contains(wd) ? _days.remove(wd) : _days.add(wd);
                  }),
                ),
            ],
          ),
          const SizedBox(height: Gap.m),
          if (_showMorning)
            rangeRow(t.morning, _morning, (r) => _morning = r, () {
              _morning = null;
              _showMorning = false;
            }),
          if (_showMorning && _showEvening) const Divider(),
          if (_showEvening)
            rangeRow(t.evening, _evening, (r) => _evening = r, () {
              _evening = null;
              _showEvening = false;
            }),
          if (!_showMorning || !_showEvening)
            Wrap(
              children: [
                if (!_showMorning)
                  addButton(t.morning, () => _showMorning = true),
                if (!_showEvening)
                  addButton(t.evening, () => _showEvening = true),
              ],
            ),
          const SizedBox(height: Gap.l),
          ButtonPair(
            secondary: AppButton(
              t.cancel,
              style: AppButtonStyle.outlined,
              pill: true,
              onPressed: widget.onDone,
            ),
            primary: AppButton(
              t.update,
              pill: true,
              loading: _saving,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }
}

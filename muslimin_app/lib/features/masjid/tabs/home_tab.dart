import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/gold_sheet.dart';
import '../../../core/widgets/surfaces.dart';
import '../../../data/models/hm.dart';
import '../../../data/models/masjid.dart';
import '../../../data/models/prayer.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/follows.dart';
import '../../../state/providers.dart';
import '../masjid_screen.dart';

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
    ref.listen(masjidEditRequestProvider, (_, next) {
      if (next.$1 == 0 && widget.canEdit) setState(() => _editJamat = true);
    });
    return ListView(
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
  const _TimePill({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.pill,
    borderRadius: BorderRadius.circular(Radii.pill),
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
          ),
          const SizedBox(height: Gap.s),
          for (final p in Prayer.values) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: Text(f.prayer(p), style: AppText.label)),
                  _TimePill(
                    text: _jamat[p] == null ? t.tapToSet : f.hm(_jamat[p]!),
                    onTap: () async {
                      final v = await pickTime(context, _jamat[p]);
                      if (v != null) setState(() => _jamat[p] = v);
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
              morning: _morning,
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
        ],
      ),
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
                  selected: _days.contains(Fmt.weekdayFromSatFirst(i)),
                  onTap: () => setState(() {
                    final wd = Fmt.weekdayFromSatFirst(i);
                    _days.contains(wd) ? _days.remove(wd) : _days.add(wd);
                  }),
                ),
            ],
          ),
          const SizedBox(height: Gap.m),
          rangeRow(t.morning, _morning, (r) => _morning = r),
          if (_showEvening) ...[
            const Divider(),
            rangeRow(t.evening, _evening, (r) => _evening = r),
          ],
          const SizedBox(height: Gap.l),
          ButtonPair(
            secondary: _showEvening
                ? AppButton(
                    t.cancel,
                    style: AppButtonStyle.outlined,
                    pill: true,
                    onPressed: widget.onDone,
                  )
                : AppButton(
                    t.addNew,
                    style: AppButtonStyle.outlined,
                    pill: true,
                    onPressed: () => setState(() => _showEvening = true),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/backend/backend.dart';
import '../../data/models/masjid.dart';
import '../../data/models/volunteer.dart';
import '../../l10n/app_localizations.dart';
import '../../state/follows.dart';
import '../../state/providers.dart';
import '../../state/volunteer.dart';

/// "640 m", "1.4 km" (Fmt.distance says "away" and skips short ones).
String meters(Fmt f, double m) => m < 1000
    ? '${f.digits(m.round())} m'
    : '${f.digits((m / 1000).toStringAsFixed(1))} km';

/// "I want to update jamat time": checks the user is near the masjid, then
/// makes them a volunteer editor. Returns true when they now can edit.
Future<bool> volunteerToEdit(
  BuildContext context,
  WidgetRef ref,
  Masjid masjid,
) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.card,
    isScrollControlled: true,
    builder: (_) => _VolunteerSheet(masjid: masjid),
  );
  return ok ?? false;
}

class _VolunteerSheet extends ConsumerStatefulWidget {
  const _VolunteerSheet({required this.masjid});

  final Masjid masjid;

  @override
  ConsumerState<_VolunteerSheet> createState() => _VolunteerSheetState();
}

class _VolunteerSheetState extends ConsumerState<_VolunteerSheet> {
  bool _checking = false;
  String? _problem;

  Future<void> _check() async {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final km = f.digits((kEditorRadiusM / 1000).toStringAsFixed(0));
    setState(() {
      _checking = true;
      _problem = null;
    });
    try {
      // A fresh, precise fix – not the location saved at app start.
      final here = await ref
          .read(locationServiceProvider)
          .current(precise: true);
      if (here.approximate) {
        setState(() => _problem = t.volunteerApprox);
        return;
      }
      final m = widget.masjid;
      final d = distanceMeters(here.lat, here.lng, m.lat, m.lng);
      if (d > kEditorRadiusM) {
        setState(() => _problem = t.volunteerTooFar(meters(f, d), km));
        return;
      }
      await ref.read(backendProvider).becomeEditor(m, here.lat, here.lng);
      // They will want to come back to it.
      if (!ref.read(followsProvider).containsKey(m.id)) {
        await ref.read(followsProvider.notifier).follow(m);
      }
      if (!mounted) return;
      toast(context, t.volunteerWelcome);
      Navigator.pop(context, true);
    } on BackendException catch (e) {
      setState(
        () => _problem = e.code == 'too-far'
            ? t.volunteerTooFar('', km)
            : t.somethingWrong,
      );
    } catch (e) {
      setState(
        () => _problem = '$e'.contains('permission-denied')
            ? t.volunteerBlocked
            : t.somethingWrong,
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final km = f.digits((kEditorRadiusM / 1000).toStringAsFixed(0));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xl, Gap.xl, Gap.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.volunteer_activism_rounded,
              size: 40,
              color: AppColors.gold,
            ),
            const SizedBox(height: Gap.m),
            Text(
              t.volunteerCheckTitle,
              textAlign: TextAlign.center,
              style: AppText.subtitle,
            ),
            const SizedBox(height: Gap.s),
            Text(
              t.volunteerCheckBody(km),
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.muted),
            ),
            if (_problem != null) ...[
              const SizedBox(height: Gap.l),
              Container(
                padding: const EdgeInsets.all(Gap.m),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Radii.button),
                ),
                child: Text(
                  _problem!,
                  style: AppText.caption.copyWith(color: AppColors.danger),
                ),
              ),
            ],
            const SizedBox(height: Gap.xl),
            AppButton(
              _checking ? t.volunteerChecking : t.volunteerCheckButton,
              icon: Icons.my_location_rounded,
              expand: true,
              onPressed: _checking ? null : _check,
            ),
          ],
        ),
      ),
    );
  }
}

String reportReasonLabel(L10n t, ReportReason r) => switch (r) {
  ReportReason.wrongTime => t.reportWrongTime,
  ReportReason.wrongLocation => t.reportWrongLocation,
  ReportReason.wrongInfo => t.reportWrongInfo,
  ReportReason.closed => t.reportClosed,
  ReportReason.duplicate => t.reportDuplicate,
  ReportReason.other => t.reportOther,
};

/// "Report a problem": wrong time, wrong place… for the admin to check.
Future<void> reportProblem(BuildContext context, Masjid masjid) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      builder: (_) => _ReportSheet(masjid: masjid),
    );

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.masjid});

  final Masjid masjid;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  ReportReason _reason = ReportReason.wrongTime;
  final _note = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final t = L10n.of(context);
    setState(() => _sending = true);
    try {
      await ref
          .read(backendProvider)
          .reportMasjid(widget.masjid, _reason, _note.text);
      if (!mounted) return;
      toast(context, t.reportThanks);
      Navigator.pop(context);
    } catch (_) {
      if (mounted) toast(context, t.somethingWrong);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xl, Gap.xl, Gap.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.reportTitle, style: AppText.subtitle),
              Text(
                widget.masjid.name,
                style: AppText.caption.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: Gap.s),
              RadioGroup<ReportReason>(
                groupValue: _reason,
                onChanged: (v) => setState(() => _reason = v!),
                child: Column(
                  children: [
                    for (final r in ReportReason.values)
                      RadioListTile<ReportReason>(
                        value: r,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.gold,
                        title: Text(
                          reportReasonLabel(t, r),
                          style: AppText.body,
                        ),
                      ),
                  ],
                ),
              ),
              TextField(
                controller: _note,
                maxLength: 500,
                minLines: 2,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: t.reportNote),
              ),
              const SizedBox(height: Gap.m),
              AppButton(
                t.reportSend,
                expand: true,
                onPressed: _sending ? null : _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// On the masjid's Home tab, for people who can't edit it yet: asks
/// neighbours to fill in (or keep up) the jamat times.
class VolunteerCard extends ConsumerWidget {
  const VolunteerCard({
    super.key,
    required this.masjid,
    required this.onEditor,
  });

  final Masjid masjid;

  /// Called once the user became an editor (opens the time editor).
  final VoidCallback onEditor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final empty = masjid.jamat.isEmpty;
    return Container(
      decoration: BoxDecoration(
        color: empty ? AppColors.gold.withValues(alpha: 0.12) : AppColors.card,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.all(Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.volunteer_activism_rounded, color: AppColors.gold),
              const SizedBox(width: Gap.s),
              Expanded(
                child: Text(
                  empty ? t.volunteerTitleEmpty : t.volunteerTitle,
                  style: AppText.label,
                ),
              ),
            ],
          ),
          const SizedBox(height: Gap.xs),
          Text(
            empty ? t.volunteerBodyEmpty : t.volunteerBody,
            style: AppText.caption,
          ),
          const SizedBox(height: Gap.m),
          AppButton(
            t.volunteerButton,
            icon: Icons.edit_calendar_rounded,
            pill: true,
            dense: true,
            style: empty ? AppButtonStyle.filled : AppButtonStyle.outlined,
            onPressed: () async {
              if (ref.read(authProvider).value == null) {
                toast(context, t.signInFirst);
                return;
              }
              if (await volunteerToEdit(context, ref, masjid)) onEditor();
            },
          ),
        ],
      ),
    );
  }
}

/// About tab, for the masjid's owner and the admin: who volunteers here.
class EditorsSection extends ConsumerWidget {
  const EditorsSection({super.key, required this.masjid});

  final Masjid masjid;

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    MasjidEditor e,
  ) async {
    final t = L10n.of(context);
    final block = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.card,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_remove_outlined),
              title: Text(t.removeEditor),
              onTap: () => Navigator.pop(ctx, false),
            ),
            ListTile(
              leading: Icon(Icons.block_rounded, color: AppColors.danger),
              title: Text(
                t.removeAndBlock,
                style: TextStyle(color: AppColors.danger),
              ),
              onTap: () => Navigator.pop(ctx, true),
            ),
          ],
        ),
      ),
    );
    if (block == null) return;
    try {
      await ref
          .read(backendProvider)
          .removeEditor(masjid.id, e.uid, block: block);
    } catch (_) {
      if (context.mounted) toast(context, t.somethingWrong);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final editors = ref.watch(masjidEditorsProvider(masjid.id)).value ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, Gap.l, 0, Gap.m),
          child: Text(t.volunteers, style: AppText.body),
        ),
        if (editors.isEmpty)
          AppCard(child: Text(t.noVolunteers, style: AppText.caption))
        else
          for (final e in editors) ...[
            InfoTile(
              leading: Icon(
                Icons.person_outline_rounded,
                color: AppColors.gold,
              ),
              title: e.name.isEmpty ? '—' : e.name,
              line: t.editorDistance(meters(f, e.distanceM)),
              trailing: IconButton(
                tooltip: t.removeEditor,
                icon: Icon(Icons.more_vert_rounded, color: AppColors.muted),
                onPressed: () => _remove(context, ref, e),
              ),
            ),
            const SizedBox(height: Gap.s),
          ],
      ],
    );
  }
}

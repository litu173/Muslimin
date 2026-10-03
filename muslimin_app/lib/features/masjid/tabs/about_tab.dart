import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/islamic_pattern.dart';
import '../../../core/widgets/surfaces.dart';
import '../../../data/models/masjid.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/providers.dart';
import '../masjid_screen.dart';

/// Arched window glyph used for staff members (Figma: lattice window).
class ArchIcon extends StatelessWidget {
  const ArchIcon({super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(14),
      bottom: Radius.circular(2),
    ),
    child: const SizedBox(width: 28, height: 36, child: IslamicPattern()),
  );
}

class MasjidAboutTab extends ConsumerStatefulWidget {
  const MasjidAboutTab({
    super.key,
    required this.masjid,
    required this.canEdit,
  });

  final Masjid masjid;
  final bool canEdit;

  @override
  ConsumerState<MasjidAboutTab> createState() => _MasjidAboutTabState();
}

class _MasjidAboutTabState extends ConsumerState<MasjidAboutTab> {
  bool _editing = false;

  String _roleLabel(L10n t, StaffRole r) => switch (r) {
    StaffRole.khatib => t.khatib,
    StaffRole.imam => t.imam,
    StaffRole.muazzin => t.muazzin,
  };

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return _StaffEditor(
        masjid: widget.masjid,
        onDone: () => setState(() => _editing = false),
      );
    }

    final t = L10n.of(context);
    final f = Fmt.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.xxl),
            children: [
              for (final r in StaffRole.values) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, Gap.l, 0, Gap.m),
                  child: Text(_roleLabel(t, r), style: AppText.body),
                ),
                if (widget.masjid.staff[r] case final s? when !s.isEmpty)
                  InfoTile(
                    leading: const ArchIcon(),
                    title: s.name,
                    line: s.phone.isEmpty ? null : t.contact(f.digits(s.phone)),
                    onTap: s.phone.isEmpty
                        ? null
                        : () => launchUrl(Uri.parse('tel:${s.phone}')),
                  )
                else
                  InfoTile(leading: const ArchIcon(), title: t.notAdded),
              ],
              const SizedBox(height: Gap.l),
              AppCard(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: Gap.m),
                    Expanded(
                      child: Text(
                        widget.masjid.fullAddress,
                        style: AppText.body,
                      ),
                    ),
                    TextButton(
                      onPressed: () => openDirections(widget.masjid),
                      child: Text(t.directions),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.canEdit)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.s, Gap.xl, Gap.l),
              child: AppButton(
                t.edit,
                expand: true,
                onPressed: () => setState(() => _editing = true),
              ),
            ),
          ),
      ],
    );
  }
}

class _StaffEditor extends ConsumerStatefulWidget {
  const _StaffEditor({required this.masjid, required this.onDone});

  final Masjid masjid;
  final VoidCallback onDone;

  @override
  ConsumerState<_StaffEditor> createState() => _StaffEditorState();
}

class _StaffEditorState extends ConsumerState<_StaffEditor> {
  late final _names = {
    for (final r in StaffRole.values)
      r: TextEditingController(text: widget.masjid.staff[r]?.name ?? ''),
  };
  late final _phones = {
    for (final r in StaffRole.values)
      r: TextEditingController(text: widget.masjid.staff[r]?.phone ?? ''),
  };
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [..._names.values, ..._phones.values]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(backendProvider).updateStaff(widget.masjid.id, {
        for (final r in StaffRole.values)
          if (_names[r]!.text.trim().isNotEmpty)
            r: StaffMember(
              name: _names[r]!.text.trim(),
              phone: _phones[r]!.text.trim(),
            ),
      });
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
    final labels = {
      StaffRole.khatib: t.khatibName,
      StaffRole.imam: t.imamName,
      StaffRole.muazzin: t.muazzinName,
    };
    return ListView(
      padding: const EdgeInsets.all(Gap.l),
      children: [
        for (final r in StaffRole.values) ...[
          AppCard(
            color: AppColors.card,
            padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.l),
            child: Column(
              children: [
                AppTextField(label: labels[r]!, controller: _names[r]!),
                AppTextField(
                  label: t.contactNumber,
                  controller: _phones[r]!,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: Gap.s),
        ButtonPair(
          secondary: AppButton(
            t.cancel,
            style: AppButtonStyle.outlined,
            onPressed: widget.onDone,
          ),
          primary: AppButton(t.update, loading: _saving, onPressed: _save),
        ),
      ],
    );
  }
}

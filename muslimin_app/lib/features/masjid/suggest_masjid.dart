import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../core/widgets/buttons.dart';
import '../../data/models/volunteer.dart';
import '../../l10n/app_localizations.dart';
import '../../services/thana_service.dart';
import '../../state/providers.dart';
import '../registration/map_picker_screen.dart';
import 'masjid_screen.dart';
import 'volunteer.dart' show meters;

/// "Masjid missing? Add it": pin it on the map (near you), give its name;
/// the admin approves it and the one who added it becomes its editor.
Future<void> suggestMasjid(BuildContext context, WidgetRef ref) async {
  final t = L10n.of(context);
  final user = ref.read(authProvider).value;
  if (user == null) {
    toast(context, t.signInFirst);
    return;
  }
  final here = ref.read(locationProvider).value;
  final pin = await pickOnMap(context, initial: here);
  if (pin == null || !context.mounted) return;

  // Only masjids around the user – people add the ones they know.
  if (here != null) {
    final d = distanceMeters(here.lat, here.lng, pin.lat, pin.lng);
    if (d > kEditorRadiusM) {
      final f = Fmt.of(context);
      toast(
        context,
        t.volunteerTooFar(
          meters(f, d),
          f.digits((kEditorRadiusM / 1000).toStringAsFixed(0)),
        ),
      );
      return;
    }
  }

  // Already in the app?
  final near = await ref
      .read(backendProvider)
      .masjidsNear(pin.lat, pin.lng, 50);
  if (!context.mounted) return;
  if (near.isNotEmpty) {
    final open = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        content: Text(t.alreadyListed(near.first.name), style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(t.addAnyway),
          ),
          TextButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(t.openIt),
          ),
        ],
      ),
    );
    if (!context.mounted || open == null) return;
    if (open) {
      push(context, MasjidScreen(masjidId: near.first.id, initial: near.first));
      return;
    }
  }

  final thana = (await ThanaService.load()).at(pin.lat, pin.lng);
  if (!context.mounted) return;
  if (thana == null) {
    toast(context, t.somethingWrong);
    return;
  }
  // The map's place name, when the pin was put on a masjid.
  final picked = pin.label;
  final looksLikeMasjid = RegExp(
    r'masjid|mosque|mosjid|মসজিদ',
    caseSensitive: false,
  ).hasMatch(picked);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    builder: (_) => _NameSheet(
      initialName: looksLikeMasjid ? picked : '',
      onSend: (name, nameBn) => ref
          .read(backendProvider)
          .suggestMasjid(
            MasjidSuggestion(
              id: '',
              name: name,
              nameBn: nameBn,
              lat: pin.lat,
              lng: pin.lng,
              district: thana.district,
              thana: thana.name,
              uid: user.uid,
              userName: user.displayName,
            ),
          ),
      area: thana.label,
    ),
  );
}

class _NameSheet extends StatefulWidget {
  const _NameSheet({
    required this.initialName,
    required this.onSend,
    required this.area,
  });

  final String initialName;
  final Future<void> Function(String name, String nameBn) onSend;
  final String area;

  @override
  State<_NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<_NameSheet> {
  late final _name = TextEditingController(text: widget.initialName);
  final _bn = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _bn.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final t = L10n.of(context);
    final name = _name.text.trim();
    if (name.length < 3) {
      toast(context, t.suggestNameShort);
      return;
    }
    setState(() => _sending = true);
    try {
      await widget.onSend(name, _bn.text.trim());
      if (!mounted) return;
      toast(context, t.suggestThanks);
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xl, Gap.xl, Gap.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.addMissingMasjid, style: AppText.subtitle),
              Text(
                widget.area,
                style: AppText.caption.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: Gap.l),
              TextField(
                controller: _name,
                maxLength: 80,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: t.masjidName),
              ),
              TextField(
                controller: _bn,
                maxLength: 80,
                decoration: InputDecoration(labelText: t.masjidNameBn),
              ),
              const SizedBox(height: Gap.s),
              Text(
                t.suggestReviewNote,
                style: AppText.micro.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: Gap.l),
              AppButton(
                t.send,
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

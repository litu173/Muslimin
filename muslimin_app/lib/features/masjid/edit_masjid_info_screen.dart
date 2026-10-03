import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/bd_districts.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

/// Owner/admin edit of the details entered at registration. Location, NID,
/// phone and status stay locked (they are what the admin verified).
class EditMasjidInfoScreen extends ConsumerStatefulWidget {
  const EditMasjidInfoScreen({super.key, required this.masjid});

  final Masjid masjid;

  @override
  ConsumerState<EditMasjidInfoScreen> createState() =>
      _EditMasjidInfoScreenState();
}

class _EditMasjidInfoScreenState extends ConsumerState<EditMasjidInfoScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.masjid.name);
  late final _nameBn = TextEditingController(text: widget.masjid.nameBn);
  late final _thana = TextEditingController(text: widget.masjid.thana);
  late final _address = TextEditingController(text: widget.masjid.address);
  late String? _district =
      bdDistricts.any((d) => d.$1 == widget.masjid.district)
      ? widget.masjid.district
      : null;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _nameBn, _thana, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final t = L10n.of(context);
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(backendProvider)
          .updateInfo(
            widget.masjid.id,
            name: _name.text.trim(),
            nameBn: _nameBn.text.trim(),
            district: _district ?? '',
            thana: _thana.text.trim(),
            address: _address.text.trim(),
          );
      if (!mounted) return;
      toast(context, t.updated);
      Navigator.pop(context);
    } catch (_) {
      if (mounted) toast(context, t.somethingWrong);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final bn = Fmt.of(context).isBn;
    String? req(String? v) =>
        (v == null || v.trim().isEmpty) ? t.required : null;
    return Scaffold(
      body: SafeArea(
        child: SheetCard(
          child: Form(
            key: _form,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      Gap.xl,
                      Gap.xxl,
                      Gap.xl,
                      Gap.l,
                    ),
                    children: [
                      Text(t.editMasjidInfo, style: AppText.headline),
                      const SizedBox(height: Gap.s),
                      Text(t.editMasjidInfoBody, style: AppText.body),
                      AppTextField(
                        label: t.masjidName,
                        controller: _name,
                        validator: (v) => (v == null || v.trim().length < 3)
                            ? t.required
                            : null,
                      ),
                      AppTextField(label: t.masjidNameBn, controller: _nameBn),
                      AppDropdown<String>(
                        label: t.district,
                        value: _district,
                        hint: t.select,
                        items: [for (final d in bdDistricts) d.$1],
                        itemLabel: (en) => bn
                            ? bdDistricts.firstWhere((d) => d.$1 == en).$2
                            : en,
                        validator: (v) => v == null ? t.required : null,
                        onChanged: (v) => setState(() => _district = v),
                      ),
                      AppTextField(
                        label: t.thana,
                        controller: _thana,
                        validator: req,
                      ),
                      AppTextField(
                        label: t.address,
                        controller: _address,
                        validator: req,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(Gap.xl, 0, Gap.xl, Gap.xl),
                  child: ButtonPair(
                    secondary: AppButton(
                      t.cancel,
                      style: AppButtonStyle.outlined,
                      onPressed: () => Navigator.pop(context),
                    ),
                    primary: AppButton(
                      t.update,
                      loading: _saving,
                      onPressed: _save,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

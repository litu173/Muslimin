import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/hm.dart';
import '../../data/models/masjid.dart';
import '../../data/models/notice.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../masjid/tabs/home_tab.dart' show pickTime;

/// "Janaza Notice" form from the Figma, generalised to every category.
class NoticeFormScreen extends ConsumerStatefulWidget {
  const NoticeFormScreen({
    super.key,
    required this.masjid,
    required this.category,
  });

  final Masjid masjid;
  final NoticeCategory category;

  @override
  ConsumerState<NoticeFormScreen> createState() => _NoticeFormScreenState();
}

class _NoticeFormScreenState extends ConsumerState<NoticeFormScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _details = TextEditingController();
  final _person = TextEditingController();
  final _father = TextEditingController();
  late final _address = TextEditingController(text: widget.masjid.address);
  DateTime? _date;
  DateTime? _diedOn;
  HM? _time;
  bool _saving = false;
  bool _submitted = false;

  bool get _janaza => widget.category == NoticeCategory.janaza;
  bool get _needsTime => const {
    NoticeCategory.janaza,
    NoticeCategory.mahfil,
    NoticeCategory.general,
    NoticeCategory.talim,
    NoticeCategory.tafsir,
  }.contains(widget.category);

  @override
  void dispose() {
    for (final c in [_title, _details, _person, _father, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<DateTime?> _pickDate(DateTime? initial, {bool past = false}) =>
      showDatePicker(
        context: context,
        initialDate: initial ?? DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: past ? 365 : 1)),
        lastDate: DateTime.now().add(Duration(days: past ? 0 : 365)),
      );

  Future<void> _post() async {
    final t = L10n.of(context);
    setState(() => _submitted = true);
    final valid = _form.currentState!.validate();
    if (!valid || (_janaza && (_date == null || _time == null))) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(backendProvider)
          .postNotice(
            Notice(
              id: '',
              masjidId: widget.masjid.id,
              masjidName: widget.masjid.name,
              category: widget.category,
              title: _janaza
                  ? t.janazaOf(_person.text.trim())
                  : _title.text.trim(),
              details: _details.text.trim(),
              date: _date,
              time: _time?.toStorage(),
              personName: _janaza ? _person.text.trim() : null,
              fatherName: _janaza ? _father.text.trim() : null,
              diedOn: _diedOn,
              address: _janaza ? _address.text.trim() : null,
              createdAt: DateTime.now(),
            ),
          );
      if (!mounted) return;
      toast(context, t.noticePosted);
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
    final f = Fmt.of(context);
    String? req(String? v) =>
        (v == null || v.trim().isEmpty) ? t.required : null;
    final dateLabel = switch (widget.category) {
      NoticeCategory.janaza => t.janazaDate,
      NoticeCategory.recruitment => t.deadlineLabel,
      NoticeCategory.quran ||
      NoticeCategory.talim ||
      NoticeCategory.tafsir => t.startingDateLabel,
      _ => t.date,
    };

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
                      Text(
                        _janaza
                            ? t.janazaNotice
                            : t.noticeFormTitle(f.category(widget.category)),
                        style: AppText.headline,
                      ),
                      const SizedBox(height: Gap.s),
                      Text(t.enterCarefully, style: AppText.body),
                      if (_janaza) ...[
                        AppTextField(
                          label: t.personName,
                          controller: _person,
                          validator: req,
                        ),
                        AppTextField(label: t.fathersName, controller: _father),
                        PickerField(
                          label: t.diedOn,
                          value: _diedOn == null ? null : f.date(_diedOn!),
                          placeholder: t.select,
                          icon: Icons.calendar_month_outlined,
                          onTap: () async {
                            final d = await _pickDate(_diedOn, past: true);
                            if (d != null) setState(() => _diedOn = d);
                          },
                        ),
                        AppTextField(label: t.address, controller: _address),
                      ] else ...[
                        AppTextField(
                          label: t.noticeTitle,
                          controller: _title,
                          validator: req,
                        ),
                        AppTextField(
                          label: t.noticeDetails,
                          controller: _details,
                          maxLines: 4,
                        ),
                      ],
                      if (_needsTime)
                        PickerField(
                          label: _janaza ? t.janazaTime : t.time,
                          value: _time == null ? null : f.hmPeriod(_time!),
                          placeholder: t.select,
                          icon: Icons.schedule_rounded,
                          error: _submitted && _janaza && _time == null
                              ? t.required
                              : null,
                          onTap: () async {
                            final v = await pickTime(context, _time);
                            if (v != null) setState(() => _time = v);
                          },
                        ),
                      PickerField(
                        label: dateLabel,
                        value: _date == null ? null : f.date(_date!),
                        placeholder: t.select,
                        icon: Icons.calendar_month_outlined,
                        error: _submitted && _janaza && _date == null
                            ? t.required
                            : null,
                        onTap: () async {
                          final d = await _pickDate(_date);
                          if (d != null) setState(() => _date = d);
                        },
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
                      t.post,
                      loading: _saving,
                      onPressed: _post,
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

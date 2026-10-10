import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config.dart';
import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/backend/backend.dart';
import '../../data/bd_districts.dart';
import '../../services/thana_service.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import 'location_field.dart';
import 'map_picker_screen.dart';
import '../../services/location_service.dart';
import '../../state/providers.dart';
import '../auth/auth_screens.dart';
import '../auth/auth_errors.dart';
import 'otp_boxes.dart';

/// Entry point used by "View Details" on the authority banner and by
/// More → Register a Masjid.
void startRegistration(BuildContext context, WidgetRef ref) =>
    push(context, const RegistrationFlow());

enum _Step { rules, phone, otp, details, identity, done }

/// The full rule-set a masjid authority goes through:
///  1. Confirms the four eligibility statements (incl. being inside the masjid).
///  2. Signs in to (or creates) their Muslimin account and verifies their
///     phone number with an OTP – the phone is linked to the account.
///  3. Enters masjid details and captures GPS from inside the masjid
///     (accuracy must be ≤ 50 m; duplicates within 40 m are blocked).
///  4. Gives NID + role and accepts the Terms.
///  5. Profile is saved as **pending** – invisible until an admin approves.
class RegistrationFlow extends ConsumerStatefulWidget {
  const RegistrationFlow({super.key});

  @override
  ConsumerState<RegistrationFlow> createState() => _RegistrationFlowState();
}

class _RegistrationFlowState extends ConsumerState<RegistrationFlow> {
  _Step _step = _Step.rules;

  // rules
  final _rules = List.filled(4, false);
  // phone/otp
  final _phone = TextEditingController();
  String? _verificationId;
  String? _phoneError;
  String? _otpError;
  int _resendIn = 0;
  Timer? _resendTimer;
  final _otpKey = GlobalKey<OtpBoxesState>();
  // details
  final _detailsForm = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _nameBn = TextEditingController();
  final _thana = TextEditingController();
  final _address = TextEditingController();
  String? _district;
  UserLocation? _fix;
  bool _locating = false;
  String? _locError;
  // identity
  final _identityForm = GlobalKey<FormState>();
  final _nid = TextEditingController();
  SubmitterRole? _role;
  bool _agreed = false;
  String? _termsError;

  bool _busy = false;

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in [_phone, _name, _nameBn, _thana, _address, _nid]) {
      c.dispose();
    }
    super.dispose();
  }

  void _go(_Step s) => setState(() => _step = s);

  void _back() {
    switch (_step) {
      case _Step.rules:
      case _Step.done:
        Navigator.pop(context);
      case _Step.phone:
        _go(_Step.rules);
      case _Step.otp:
        _go(_Step.phone);
      case _Step.details:
        _go(_Step.rules);
      case _Step.identity:
        _go(_Step.details);
    }
  }

  /// After the rules: make sure there is an account, then a verified phone.
  Future<void> _rulesNext() async {
    final t = L10n.of(context);
    if (!await requireSignIn(context, ref)) {
      if (mounted) toast(context, t.signInToRegister);
      return;
    }
    final user = ref.read(backendProvider).currentUser;
    _go(
      user != null && (user.hasPhone || !kRequirePhoneOtp)
          ? _Step.details
          : _Step.phone,
    );
  }

  // ------------------------------------------------------------- phone/otp
  String? get _e164 {
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');
    final local = digits.startsWith('880') ? digits.substring(2) : digits;
    return RegExp(r'^01[3-9]\d{8}$').hasMatch(local) ? '+88$local' : null;
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendIn = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _resendIn <= 1) {
        t.cancel();
        if (mounted) setState(() => _resendIn = 0);
        return;
      }
      setState(() => _resendIn--);
    });
  }

  Future<void> _sendOtp() async {
    final t = L10n.of(context);
    final phone = _e164;
    if (phone == null) {
      setState(() => _phoneError = t.invalidPhone);
      return;
    }
    setState(() {
      _phoneError = null;
      _busy = true;
    });
    try {
      final id = await ref.read(backendProvider).sendOtp(phone);
      _verificationId = id;
      if (id == 'auto') {
        // Android auto-verified the SMS – already signed in.
        _go(_Step.details);
      } else {
        _startResendTimer();
        _go(_Step.otp);
      }
    } on BackendException catch (e) {
      setState(() => _phoneError = authErrorText(t, e));
    } catch (_) {
      setState(() => _phoneError = t.somethingWrong);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify(String code) async {
    final t = L10n.of(context);
    if (code.length < 6 || _verificationId == null) return;
    setState(() {
      _otpError = null;
      _busy = true;
    });
    try {
      await ref.read(backendProvider).verifyOtp(_verificationId!, code);
      unawaited(ref.read(pushProvider).registerToken());
      _go(_Step.details);
    } on BackendException catch (e) {
      setState(() => _otpError = authErrorText(t, e));
      _otpKey.currentState?.clear();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // --------------------------------------------------------------- details
  Future<void> _loadLocation() async {
    setState(() {
      _locating = true;
      _locError = null;
    });
    try {
      final fix = await ref.read(locationServiceProvider).preciseFix();
      setState(() => _fix = fix);
      _fillArea(fix.lat, fix.lng);
    } catch (_) {
      if (mounted) setState(() => _locError = L10n.of(context).somethingWrong);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  /// Location chosen on the map – a masjid tapped there also fills in the
  /// English or Bangla name if it is still empty.
  /// District and thana from the masjid's position (still editable).
  Future<void> _fillArea(double lat, double lng) async {
    final area = (await ThanaService.load()).at(lat, lng);
    if (area == null || !mounted) return;
    setState(() {
      _district = area.district;
      _thana.text = area.name;
    });
  }

  Future<void> _pickOnMap() async {
    final picked = await pickOnMap(context, initial: _fix);
    if (picked == null || !mounted) return;
    setState(() {
      _fix = picked;
      _fillArea(picked.lat, picked.lng);
      _locError = null;
      final label = picked.label;
      if (label.isNotEmpty && !label.contains(',')) {
        final field = RegExp('[ঀ-৿]').hasMatch(label) ? _nameBn : _name;
        if (field.text.trim().isEmpty) field.text = label;
      }
    });
  }

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9ঀ-৿]'), '')
      .replaceAll('masjid', '')
      .replaceAll('mosque', '')
      .replaceAll('jame', '');

  Future<void> _detailsNext() async {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final ok = _detailsForm.currentState!.validate();
    if (_fix == null) {
      setState(() => _locError = t.loadLocationFirst);
      return;
    }
    // The accuracy rule only applies to a GPS fix taken at the masjid.
    if (!_fix!.fromMap && _fix!.accuracy > kRequiredAccuracyM) {
      setState(
        () => _locError = t.accuracyTooLow(f.digits(_fix!.accuracy.round())),
      );
      return;
    }
    if (!ok) return;
    setState(() => _busy = true);
    try {
      final near = await ref
          .read(backendProvider)
          .masjidsNear(_fix!.lat, _fix!.lng, kDuplicateRadiusM);
      final me = _norm(_name.text);
      final dup = near.where((m) {
        final other = _norm(m.name);
        return other.isNotEmpty &&
            me.isNotEmpty &&
            (other.contains(me) || me.contains(other));
      }).firstOrNull;
      if (dup != null) {
        if (mounted) setState(() => _locError = t.duplicateFound(dup.name));
        return;
      }
      _go(_Step.identity);
    } catch (_) {
      _go(
        _Step.identity,
      ); // duplicate check is best-effort; the admin re-checks.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // -------------------------------------------------------------- identity
  Future<void> _create() async {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final ok = _identityForm.currentState!.validate();
    setState(() => _termsError = _agreed ? null : t.mustAgreeTerms);
    if (!ok || !_agreed) return;
    final user = ref.read(backendProvider).currentUser;
    if (user == null || (kRequirePhoneOtp && !user.hasPhone)) {
      _go(_Step.rules);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(backendProvider)
          .createMasjid(
            Masjid(
              id: '',
              name: _name.text.trim(),
              nameBn: _nameBn.text.trim(),
              address: _address.text.trim(),
              district: _district ?? '',
              thana: _thana.text.trim(),
              lat: _fix!.lat,
              lng: _fix!.lng,
              status: MasjidStatus.pending,
              ownerUid: user.uid,
              ownerPhone: user.hasPhone ? user.phone : _e164 ?? '',
              phoneVerified: user.hasPhone,
              nid: _nid.text.trim(),
              submitterRole: _role!,
              locationAccuracyM: _fix!.fromMap ? 0 : _fix!.accuracy,
              locationSource: _fix!.fromMap ? 'map' : 'gps',
            ),
          );
      _go(_Step.done);
    } on BackendException catch (e) {
      if (mounted) {
        toast(
          context,
          e.code == 'limit'
              ? t.limitReached(f.digits(kMaxMasjidsPerUser))
              : (e.message ?? t.somethingWrong),
        );
      }
    } catch (_) {
      if (mounted) toast(context, t.somethingWrong);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ------------------------------------------------------------------- UI
  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final (Widget body, Widget? actions) = switch (_step) {
      _Step.rules => (
        _rulesBody(t),
        _pair(
          t.cancel,
          () => Navigator.pop(context),
          t.next,
          _rules.every((r) => r) ? _rulesNext : null,
        ),
      ),
      _Step.phone => (_phoneBody(t), null),
      _Step.otp => (_otpBody(t), null),
      _Step.details => (
        _detailsBody(t),
        _pair(t.cancel, () => Navigator.pop(context), t.next, _detailsNext),
      ),
      _Step.identity => (
        _identityBody(t),
        _pair(t.cancel, _back, t.create, _create),
      ),
      _Step.done => (
        _doneBody(t),
        Padding(
          padding: const EdgeInsets.fromLTRB(Gap.xl, 0, Gap.xl, Gap.xl),
          child: AppButton(
            t.backToHome,
            expand: true,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    };

    return PopScope(
      canPop: _step == _Step.rules || _step == _Step.done,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        body: SafeArea(
          child: SheetCard(
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(key: ValueKey(_step), child: body),
                  ),
                ),
                ?actions,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pair(String a, VoidCallback onA, String b, VoidCallback? onB) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.s, Gap.xl, Gap.xl),
        child: ButtonPair(
          secondary: AppButton(
            a,
            style: AppButtonStyle.outlined,
            onPressed: _busy ? null : onA,
          ),
          primary: AppButton(b, loading: _busy, onPressed: onB),
        ),
      );

  Widget _illustrated({
    required String image,
    required String title,
    required List<Widget> children,
  }) => ListView(
    padding: const EdgeInsets.fromLTRB(Gap.xl, 50, Gap.xl, Gap.xl),
    children: [
      Center(child: Image.asset(image, width: 200, height: 200)),
      const SizedBox(height: 50),
      Text(title, style: AppText.headline),
      const SizedBox(height: Gap.m),
      ...children,
    ],
  );

  Widget _rulesBody(L10n t) => _illustrated(
    image: 'assets/images/auth_book.png',
    title: t.userAuth,
    children: [
      Text(t.userAuthBody, style: AppText.body),
      const SizedBox(height: Gap.l),
      for (final (i, rule) in [t.rule1, t.rule2, t.rule3, t.rule4].indexed)
        InkWell(
          onTap: () => setState(() => _rules[i] = !_rules[i]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TickCircle(checked: _rules[i]),
                const SizedBox(width: Gap.s + 2),
                Expanded(child: Text(rule, style: AppText.body)),
              ],
            ),
          ),
        ),
      const Divider(),
      // "Select all" (last in the list) toggles every statement at once.
      InkWell(
        onTap: () {
          final all = !_rules.every((r) => r);
          setState(() => _rules.fillRange(0, _rules.length, all));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              TickCircle(checked: _rules.every((r) => r)),
              const SizedBox(width: Gap.s + 2),
              Text(t.selectAll, style: AppText.label),
            ],
          ),
        ),
      ),
      if (!_rules.every((r) => r))
        Padding(
          padding: const EdgeInsets.only(top: Gap.s),
          child: Text(
            t.agreeAll,
            style: AppText.caption.copyWith(color: AppColors.muted),
          ),
        ),
    ],
  );

  Widget _phoneBody(L10n t) => _illustrated(
    image: 'assets/images/auth_otp.png',
    title: t.registration,
    children: [
      Text(t.verifyPhoneToContinue, style: AppText.body),
      const SizedBox(height: Gap.s),
      FieldLabel(t.yourMobile),
      TextField(
        controller: _phone,
        keyboardType: TextInputType.phone,
        autofillHints: const [AutofillHints.telephoneNumberNational],
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
        style: AppText.label,
        decoration: InputDecoration(
          hintText: '01XXXXXXXXX',
          errorText: _phoneError,
        ),
        onSubmitted: (_) => _sendOtp(),
      ),
      const SizedBox(height: Gap.l),
      Text(t.otpWillBeSent, style: AppText.caption),
      if (ref.read(backendProvider).isDemo) ...[
        const SizedBox(height: Gap.s),
        Text(
          t.demoOtpHint,
          style: AppText.caption.copyWith(color: AppColors.gold),
        ),
      ],
      const SizedBox(height: Gap.xxl),
      AppButton(t.getOtp, expand: true, loading: _busy, onPressed: _sendOtp),
    ],
  );

  Widget _otpBody(L10n t) {
    final f = Fmt.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(Gap.xl, 50, Gap.xl, Gap.xl),
      children: [
        Text(t.verification, style: AppText.headline),
        const SizedBox(height: Gap.s),
        Text(t.typeOtp, style: AppText.body),
        const SizedBox(height: Gap.xl),
        Text(t.otp, style: AppText.label),
        const SizedBox(height: Gap.m),
        OtpBoxes(key: _otpKey, length: 6, onCompleted: _verify),
        if (_otpError != null) ...[
          const SizedBox(height: Gap.s),
          Text(
            _otpError!,
            style: AppText.caption.copyWith(color: AppColors.danger),
          ),
        ],
        const SizedBox(height: Gap.xl),
        Row(
          children: [
            Text(t.didntGetOtp, style: AppText.caption),
            const SizedBox(width: Gap.l),
            _resendIn > 0
                ? Text(
                    t.resendIn(f.digits(_resendIn)),
                    style: AppText.caption.copyWith(color: AppColors.muted),
                  )
                : InkWell(
                    onTap: _busy ? null : _sendOtp,
                    child: Text(
                      t.resendCode,
                      style: AppText.caption.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: Gap.xxl),
        AppButton(
          t.verify,
          expand: true,
          loading: _busy,
          onPressed: () => _verify(_otpKey.currentState?.code ?? ''),
        ),
      ],
    );
  }

  Widget _detailsBody(L10n t) {
    final f = Fmt.of(context);
    final bn = f.isBn;
    String? req(String? v) =>
        (v == null || v.trim().isEmpty) ? t.required : null;
    return Form(
      key: _detailsForm,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xxl, Gap.xl, Gap.xl),
        children: [
          Text(t.createMasjidProfile, style: AppText.headline),
          const SizedBox(height: Gap.s),
          Text(t.stayInside, style: AppText.body),
          AppTextField(
            label: t.masjidName,
            controller: _name,
            validator: (v) =>
                (v == null || v.trim().length < 3) ? t.required : null,
          ),
          AppTextField(
            label: t.masjidNameBn,
            controller: _nameBn,
            hint: 'যেমন: বায়তুল মোকাররম',
          ),
          AppDropdown<String>(
            label: t.district,
            value: _district,
            hint: t.select,
            items: [for (final d in bdDistricts) d.$1],
            itemLabel: (en) =>
                bn ? bdDistricts.firstWhere((d) => d.$1 == en).$2 : en,
            validator: (v) => v == null ? t.required : null,
            onChanged: (v) => setState(() {
              _district = v;
              _thana.clear();
            }),
          ),
          ThanaDropdown(
            label: t.thana,
            district: _district,
            value: _thana.text,
            hint: t.select,
            validator: (v) => v == null ? t.required : null,
            onChanged: (v) => setState(() => _thana.text = v ?? ''),
          ),
          AppTextField(label: t.address, controller: _address, validator: req),
          LocationField(
            fix: _fix,
            loading: _locating,
            error: _locError,
            onUseGps: _loadLocation,
            onPickMap: _pickOnMap,
          ),
        ],
      ),
    );
  }

  Widget _identityBody(L10n t) {
    final roles = {
      SubmitterRole.committee: t.roleCommittee,
      SubmitterRole.imam: t.roleImam,
      SubmitterRole.khatib: t.roleKhatib,
      SubmitterRole.muazzin: t.roleMuazzin,
      SubmitterRole.khadem: t.roleKhadem,
    };
    return Form(
      key: _identityForm,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xxl, Gap.xl, Gap.xl),
        children: [
          Text(t.createMasjidProfile, style: AppText.headline),
          const SizedBox(height: Gap.s),
          Text(t.stayInside, style: AppText.body),
          FieldLabel(t.masjidName),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(Radii.field),
            ),
            child: Text(
              [
                _name.text,
                _nameBn.text,
              ].where((s) => s.trim().isNotEmpty).join(' · '),
              style: AppText.label,
            ),
          ),
          if (!(ref.read(backendProvider).currentUser?.hasPhone ?? false)) ...[
            FieldLabel(t.yourMobile),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              style: AppText.label,
              decoration: const InputDecoration(hintText: '01XXXXXXXXX'),
              validator: (_) => _e164 == null ? t.invalidPhone : null,
            ),
          ],
          AppTextField(
            label: t.nidNumber,
            controller: _nid,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(17),
            ],
            validator: (v) =>
                RegExp(r'^(\d{10}|\d{13}|\d{17})$').hasMatch(v ?? '')
                ? null
                : t.invalidNid,
          ),
          AppDropdown<SubmitterRole>(
            label: t.yourRole,
            value: _role,
            hint: t.select,
            items: roles.keys.toList(),
            itemLabel: (r) => roles[r]!,
            validator: (v) => v == null ? t.required : null,
            onChanged: (v) => setState(() => _role = v),
          ),
          const SizedBox(height: Gap.xxl),
          InkWell(
            onTap: () => setState(() => _agreed = !_agreed),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TickCircle(checked: _agreed),
                const SizedBox(width: Gap.s + 2),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: AppText.body,
                      children: [
                        TextSpan(text: t.agreeTermsPrefix),
                        TextSpan(
                          text: t.termsAndConditions,
                          style: TextStyle(color: AppColors.gold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => showTerms(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_termsError != null)
            Padding(
              padding: const EdgeInsets.only(top: Gap.s, left: 34),
              child: Text(
                _termsError!,
                style: AppText.caption.copyWith(color: AppColors.danger),
              ),
            ),
        ],
      ),
    );
  }

  Widget _doneBody(L10n t) => _illustrated(
    image: 'assets/images/onboard_mosque.png',
    title: t.submittedTitle,
    children: [Text(t.submittedBody, style: AppText.body)],
  );
}

Future<void> showTerms(BuildContext context) {
  final t = L10n.of(context);
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
      ),
      padding: const EdgeInsets.all(Gap.xl),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.termsAndConditions, style: AppText.headline),
            const SizedBox(height: Gap.l),
            Text(t.termsBody, style: AppText.body.copyWith(height: 1.6)),
            const SizedBox(height: Gap.xl),
            AppButton(
              t.close,
              expand: true,
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    ),
  );
}

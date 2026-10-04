import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../shell/shell.dart';

/// Location AND notifications are mandatory. This gate sits in front of the
/// app on every launch: if either is missing (or GPS is off) the user sees
/// this screen; once both are granted it disappears and shows [Shell].
class PermissionGate extends ConsumerStatefulWidget {
  const PermissionGate({super.key});

  @override
  ConsumerState<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends ConsumerState<PermissionGate>
    with WidgetsBindingObserver {
  PermissionStatus? _location;
  PermissionStatus? _notification;
  bool _gpsOn = true;
  bool _checked = false;

  bool get _allGood =>
      _location?.isGranted == true &&
      _notification?.isGranted == true &&
      _gpsOn;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    final loc = await Permission.locationWhenInUse.status;
    final notif = await Permission.notification.status;
    final gps = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;
    final wasGood = _allGood;
    setState(() {
      _location = loc;
      _notification = notif;
      _gpsOn = gps;
      _checked = true;
    });
    if (_allGood && !wasGood) {
      ref.invalidate(locationProvider);
      ref.read(pushProvider).registerToken();
    }
  }

  Future<void> _request(Permission p) async {
    final status = await p.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }
    await p.request();
    await _check();
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) return const Scaffold(body: Loader());
    if (_allGood) return const Shell();

    final t = L10n.of(context);
    final locBlocked = _location?.isPermanentlyDenied == true;
    final notifBlocked = _notification?.isPermanentlyDenied == true;

    return Scaffold(
      body: SafeArea(
        child: SheetCard(
          child: ListView(
            padding: const EdgeInsets.all(Gap.xl),
            children: [
              const SizedBox(height: Gap.xxl),
              Center(
                child: Image.asset(
                  'assets/images/onboard_mosque.png',
                  height: 160,
                ),
              ),
              const SizedBox(height: Gap.xxl),
              Text(t.permTitle, style: AppText.headline),
              const SizedBox(height: Gap.s),
              Text(t.permBody, style: AppText.body),
              const SizedBox(height: Gap.xxl),
              _PermissionRow(
                icon: Icons.location_on_outlined,
                title: t.permLocation,
                body: !_gpsOn && _location?.isGranted == true
                    ? t.permLocationServiceOff
                    : t.permLocationBody,
                granted: _location?.isGranted == true && _gpsOn,
                actionLabel: locBlocked ? t.permOpenSettings : t.permAllow,
                onAction: () async {
                  if (_location?.isGranted == true && !_gpsOn) {
                    await Geolocator.openLocationSettings();
                  } else {
                    await _request(Permission.locationWhenInUse);
                  }
                },
                grantedLabel: t.permGranted,
              ),
              const SizedBox(height: Gap.m),
              _PermissionRow(
                icon: Icons.notifications_none_rounded,
                title: t.permNotification,
                body: t.permNotificationBody,
                granted: _notification?.isGranted == true,
                actionLabel: notifBlocked ? t.permOpenSettings : t.permAllow,
                onAction: () => _request(Permission.notification),
                grantedLabel: t.permGranted,
              ),
              if (locBlocked || notifBlocked) ...[
                const SizedBox(height: Gap.l),
                Text(
                  t.permDeniedForever,
                  style: AppText.caption.copyWith(color: AppColors.danger),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.granted,
    required this.actionLabel,
    required this.onAction,
    required this.grantedLabel,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool granted;
  final String actionLabel;
  final VoidCallback onAction;
  final String grantedLabel;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.cream,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.gold),
        ),
        const SizedBox(width: Gap.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.subtitle),
              const SizedBox(height: 2),
              Text(body, style: AppText.caption),
            ],
          ),
        ),
        const SizedBox(width: Gap.s),
        granted
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    grantedLabel,
                    style: AppText.caption.copyWith(color: AppColors.success),
                  ),
                ],
              )
            : AppButton(
                actionLabel,
                onPressed: onAction,
                dense: true,
                pill: true,
              ),
      ],
    ),
  );
}

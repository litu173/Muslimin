import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../l10n/app_localizations.dart';
import '../../state/channel.dart';
import '../../state/providers.dart';
import '../notifications/notifications_screen.dart';

/// "Your Location / Dilu Road, Dhaka ⟳" with the notifications bell – shared
/// by Home and More. On Home the Hijri/Gregorian date sits underneath,
/// aligned with the location text.
class LocationBar extends ConsumerStatefulWidget {
  const LocationBar({super.key, this.showDate = false});

  final bool showDate;

  @override
  ConsumerState<LocationBar> createState() => _LocationBarState();
}

class _LocationBarState extends ConsumerState<LocationBar>
    with SingleTickerProviderStateMixin {
  static const _iconWidth = 24.0;

  /// Turns the ⟳ while the location is being found again – only after a
  /// tap, never on its own.
  late final _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  /// Spins at least 2.5 s (or until the new fix arrives, if later), then
  /// finishes its turn and rests.
  Future<void> _refresh() async {
    if (_spin.isAnimating) return;
    _spin.repeat();
    await Future.wait([
      ref.read(locationProvider.notifier).refresh().catchError((_) {}),
      Future<void>.delayed(const Duration(milliseconds: 2500)),
    ]);
    if (!mounted) return;
    await _spin.animateTo(1);
    _spin.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    final showDate = widget.showDate;
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final loc = ref.watch(locationProvider);
    final now = ref.watch(minuteProvider);
    final hijriOffset = ref.watch(
      settingsProvider.select((s) => s.hijriOffset),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.button),
            onTap: _refresh,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Gap.s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: SizedBox(
                      width: _iconWidth,
                      child: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: Gap.s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.yourLocation, style: AppText.caption),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                loc.value?.label ?? t.locating,
                                style: AppText.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            RotationTransition(
                              turns: _spin,
                              child: Icon(
                                Icons.refresh_rounded,
                                size: 16,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                        // Approximate location is kilometres off: say so.
                        if (loc.value?.approximate ?? false)
                          GestureDetector(
                            onTap: Geolocator.openAppSettings,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                t.approxLocation,
                                style: AppText.caption.copyWith(
                                  color: AppColors.danger,
                                ),
                              ),
                            ),
                          ),
                        if (showDate) ...[
                          const SizedBox(height: 4),
                          Text(
                            f.headerDate(now, hijriOffset),
                            style: AppText.caption.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final unread = ref.watch(unreadCountProvider);
            return IconButton(
              tooltip: t.notifications,
              onPressed: () => push(context, const NotificationsScreen()),
              icon: Badge(
                isLabelVisible: unread > 0,
                backgroundColor: AppColors.danger,
                label: Text(unread > 99 ? '99+' : f.digits(unread)),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.ink,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

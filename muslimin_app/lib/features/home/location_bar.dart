import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../notifications/notifications_screen.dart';

/// "Your Location / Dilu Road, Dhaka ⟳" with the notifications bell – shared
/// by Home and More. On Home the Hijri/Gregorian date sits underneath,
/// aligned with the location text.
class LocationBar extends ConsumerWidget {
  const LocationBar({super.key, this.showDate = false});

  final bool showDate;

  static const _iconWidth = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onTap: () => ref.read(locationProvider.notifier).refresh(),
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
                            Icon(
                              Icons.refresh_rounded,
                              size: 16,
                              color: AppColors.ink,
                            ),
                          ],
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
        IconButton(
          tooltip: t.notifications,
          onPressed: () => push(context, const NotificationsScreen()),
          icon: Icon(Icons.notifications_none_rounded, color: AppColors.ink),
        ),
      ],
    );
  }
}

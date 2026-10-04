import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../masjid/follow_badge.dart';
import '../masjid/masjid_screen.dart';

/// "Diluroad Chhata Masjid · 1:15 pm · 5 min walk"
class MasjidCard extends ConsumerWidget {
  const MasjidCard({super.key, required this.masjid, required this.index});

  final Masjid masjid;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final now = ref.watch(minuteProvider);
    final loc = ref.watch(locationProvider).value;
    final next = masjid.nextJamat(now);

    String meta = '';
    if (loc != null) {
      final d = distanceMeters(loc.lat, loc.lng, masjid.lat, masjid.lng);
      meta = d < 2500 ? t.minWalk(f.digits(walkMinutes(d))) : f.distance(d);
    }

    return InfoTile(
      leading: FollowBadge(masjidId: masjid.id),
      title: masjid.displayName(f.isBn),
      line: next == null
          ? t.jamatNotSet
          : t.jamatLine(f.prayer(next.prayer), f.timeUpper(next.at)),
      meta: meta,
      onTap: () =>
          push(context, MasjidScreen(masjidId: masjid.id, initial: masjid)),
    );
  }
}

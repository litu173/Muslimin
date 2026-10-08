import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../dua/dua_data.dart';
import '../dua/dua_screen.dart';
import 'quran_energy_card.dart';

/// Home: the duas for the current part of the day, as the same sky card the
/// Dua tab shows. "View All" opens the Dua tab.
class NowDuaSection extends ConsumerWidget {
  const NowDuaSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    return FutureBuilder(
      future: duaScenes,
      builder: (context, snap) {
        final scenes = snap.data;
        if (scenes == null) return const SizedBox.shrink();
        final now = partNow();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: t.duaForNow,
              subtitle: t.duaForNowSub,
              action: t.viewAll,
              onAction: () => ref.read(shellTabProvider.notifier).go(2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.l),
              child: DuaPartCard(
                part: now,
                isNow: true,
                scenes: [
                  for (final s in scenes)
                    if (partOf[s.id] == now) s,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

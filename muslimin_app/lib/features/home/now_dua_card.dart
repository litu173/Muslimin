import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../dua/dua_data.dart';
import '../dua/dua_screen.dart';

/// Home: the duas for the current part of the day, as the same sky card the
/// Dua tab shows, titled "Night duas" etc.
class NowDuaSection extends ConsumerWidget {
  const NowDuaSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: duaScenes,
      builder: (context, snap) {
        final scenes = snap.data;
        if (scenes == null) return const SizedBox.shrink();
        final now = partNow();
        // No section title: the card says "Night duas", and the Dua tab
        // is one tap away in the bottom bar.
        return Padding(
          padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, 0),
          child: DuaPartCard(
            part: now,
            isNow: true,
            home: true,
            scenes: [
              for (final s in scenes)
                if (partOf[s.id] == now) s,
            ],
          ),
        );
      },
    );
  }
}

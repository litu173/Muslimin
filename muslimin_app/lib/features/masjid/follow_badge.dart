import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/surfaces.dart';
import '../../state/follows.dart';

/// Masjid star badge that shows the follow state at a glance:
/// gold = followed, green = not followed.
class FollowBadge extends ConsumerWidget {
  const FollowBadge({super.key, required this.masjidId, this.size = 40});

  final String masjidId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followed = ref.watch(
      followsProvider.select((s) => s.containsKey(masjidId)),
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: MasjidBadge(
        key: ValueKey(followed),
        size: size,
        color: followed ? AppColors.gold : AppColors.tealDark,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/follows.dart';
import '../../state/providers.dart';
import '../home/masjid_card.dart';

/// Masjids the user follows (synced to their account).
class FollowedMasjidsScreen extends ConsumerWidget {
  const FollowedMasjidsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final follows = ref.watch(followsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.followedMasjids)),
      body: follows.isEmpty
          ? EmptyState(message: t.noFollowed, hint: t.noFollowedHint)
          : RefreshList(
              onRefresh: () => refreshAll(ref),
              padding: const EdgeInsets.all(Gap.l),
              children: [
                for (final (i, e) in follows.entries.indexed) ...[
                  ref
                      .watch(masjidProvider(e.key))
                      .when(
                        data: (m) => m == null
                            ? const SizedBox.shrink()
                            : Stack(
                                children: [
                                  MasjidCard(masjid: m, index: i),
                                  if (e.value.reminder > 0)
                                    Positioned(
                                      right: Gap.m,
                                      top: Gap.m,
                                      child: StatusPill(
                                        label: t.reminderBadge(
                                          f.digits(e.value.reminder),
                                        ),
                                        color: AppColors.gold,
                                      ),
                                    ),
                                ],
                              ),
                        loading: () => const Loader(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
    );
  }
}

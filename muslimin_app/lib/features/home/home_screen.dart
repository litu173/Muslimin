import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/countdown_ring.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/notice.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../notices/notice_card.dart';
import '../notifications/notifications_screen.dart';
import '../prayers/all_prayers_screen.dart';
import '../registration/registration_flow.dart';
import 'masjid_card.dart';
import 'masjid_list_screen.dart';
import 'verse_carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  NoticeCategory? _filter;
  bool _bannerClosed = false;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final settings = ref.watch(settingsProvider);
    final now = ref.watch(minuteProvider);
    final loc = ref.watch(locationProvider);
    final masjids = ref.watch(nearbyMasjidsProvider);
    final notices = ref.watch(nearbyNoticesProvider);
    final showBanner =
        !_bannerClosed && !ref.read(prefsProvider).authorityBannerHidden;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.gold,
          onRefresh: () => ref.read(locationProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              // ---- date bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.xl,
                    Gap.s,
                    Gap.s,
                    Gap.s,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          f.headerDate(now, settings.hijriOffset),
                          style: AppText.caption,
                        ),
                      ),
                      IconButton(
                        tooltip: t.notifications,
                        onPressed: () =>
                            push(context, const NotificationsScreen()),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: PrayerHeader()),

              // ---- authority banner
              if (showBanner)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, 0),
                    child: AuthorityBanner(
                      onClose: () => setState(() => _bannerClosed = true),
                    ),
                  ),
                ),

              // ---- nearest masjids
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: t.nearestMasjid,
                  subtitle: loc.value?.label ?? t.locating,
                  action: t.viewAll,
                  onAction: () => push(context, const MasjidListScreen()),
                ),
              ),
              ...masjids.when(
                loading: () => [const SliverToBoxAdapter(child: Loader())],
                error: (e, _) => [
                  SliverToBoxAdapter(
                    child: EmptyState(
                      message: t.somethingWrong,
                      icon: Icons.wifi_off_rounded,
                      action: AppButton(
                        t.retry,
                        onPressed: () => ref.invalidate(nearbyMasjidsProvider),
                        dense: true,
                      ),
                    ),
                  ),
                ],
                data: (list) => list.isEmpty
                    ? [
                        SliverToBoxAdapter(
                          child: EmptyState(
                            message: t.noMasjidNearby,
                            hint: t.noMasjidNearbyHint,
                          ),
                        ),
                      ]
                    : [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Gap.l,
                          ),
                          sliver: SliverList.separated(
                            itemCount: list.length.clamp(0, 3),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) =>
                                MasjidCard(masjid: list[i], index: i),
                          ),
                        ),
                      ],
              ),

              const SliverToBoxAdapter(child: SizedBox(height: Gap.xl)),
              const SliverToBoxAdapter(child: VerseCarousel()),

              // ---- notices
              SliverToBoxAdapter(child: SectionHeader(title: t.notice)),
              SliverToBoxAdapter(
                child: NoticeFilterBar(
                  selected: _filter,
                  onChanged: (c) => setState(() => _filter = c),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: Gap.l)),
              ...notices.when(
                loading: () => [const SliverToBoxAdapter(child: Loader())],
                error: (_, _) => [
                  SliverToBoxAdapter(
                    child: EmptyState(message: t.somethingWrong),
                  ),
                ],
                data: (all) {
                  final list = _filter == null
                      ? all
                      : all.where((n) => n.category == _filter).toList();
                  if (list.isEmpty) {
                    return [
                      SliverToBoxAdapter(
                        child: EmptyState(
                          message: t.noNotices,
                          icon: Icons.campaign_outlined,
                        ),
                      ),
                    ];
                  }
                  return [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: Gap.l),
                      sliver: SliverList.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => NoticeCard(notice: list[i]),
                      ),
                    ),
                  ];
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: Gap.xxl)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dark patterned header: current waqt + countdown ring.
class PrayerHeader extends ConsumerWidget {
  const PrayerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final waqt = ref.watch(waqtProvider);
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    return SizedBox(
      height: 178,
      child: IslamicPattern(
        child: waqt == null
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.goldLight),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DisplayText(
                            f.prayer(waqt.prayer),
                            color: AppColors.goldLight,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            f.range(waqt.window.start, waqt.window.end),
                            style: AppText.subtitle.copyWith(
                              color: AppColors.cream,
                            ),
                          ),
                          const SizedBox(height: Gap.s),
                          InkWell(
                            onTap: () =>
                                push(context, const AllPrayersScreen()),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    t.allPrayers,
                                    style: AppText.caption.copyWith(
                                      color: AppColors.teal,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.teal,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CountdownRing(
                      progress: waqt.progress(now),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            waqt.isCurrent ? t.timeLeft : t.startsIn,
                            style: AppText.caption.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            f.countdown(waqt.remaining(now)),
                            style: AppText.subtitle.copyWith(
                              color: AppColors.goldLight,
                              fontSize: 18,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Gold "Masjid Authorities" call-to-action.
class AuthorityBanner extends ConsumerWidget {
  const AuthorityBanner({super.key, this.onClose, this.showDontShow = false});

  final VoidCallback? onClose;
  final bool showDontShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  t.authorityTitle,
                  style: AppText.subtitle.copyWith(color: Colors.white),
                ),
              ),
              if (onClose != null)
                InkWell(
                  onTap: onClose,
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            t.authorityBody,
            style: AppText.body.copyWith(color: Colors.white),
          ),
          const SizedBox(height: Gap.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showDontShow) ...[
                Expanded(
                  child: _OutlineWhite(
                    label: t.dontShowAgain,
                    onTap: () {
                      ref.read(prefsProvider).authorityBannerHidden = true;
                      onClose?.call();
                    },
                  ),
                ),
                const SizedBox(width: Gap.l),
              ],
              AppButton(
                t.viewDetails,
                style: AppButtonStyle.light,
                pill: true,
                onPressed: () => startRegistration(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutlineWhite extends StatelessWidget {
  const _OutlineWhite({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      textStyle: AppText.label,
    ),
    child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
  );
}

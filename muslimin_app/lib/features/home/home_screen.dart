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
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';
import '../prayers/all_prayers_screen.dart';
import '../registration/registration_flow.dart';
import 'location_bar.dart';
import 'masjid_card.dart';
import 'masjid_list_screen.dart';
import 'now_dua_card.dart';
import 'quran_energy_card.dart';
import 'verse_carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _bannerClosed = false;

  /// Entrance: body sections slide up and fade in, one after another.
  late final _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  /// Wraps the [i]-th body section in the staggered slide-up entrance.
  Widget _in(int i, Widget child) {
    final start = (i * 0.09).clamp(0.0, 0.6);
    final a = CurvedAnimation(
      parent: _intro,
      curve: Interval(start, start + 0.4, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: a,
      child: child,
      builder: (_, child) => Opacity(
        opacity: a.value,
        child: Transform.translate(
          offset: Offset(0, 48 * (1 - a.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final loc = ref.watch(locationProvider);
    final masjids = ref.watch(nearbyMasjidsProvider);
    // Only for users who have not registered a masjid yet.
    final mine = ref.watch(myMasjidsProvider);
    final showBanner =
        !_bannerClosed &&
        !ref.read(prefsProvider).authorityBannerHidden &&
        mine.hasValue &&
        mine.value!.isEmpty;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            PullToRefresh(onRefresh: () => refreshAll(ref)),
            // ---- location + date
            SliverToBoxAdapter(
              child: _in(
                0,
                const Padding(
                  padding: EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.s, Gap.s),
                  child: LocationBar(showDate: true),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _in(1, const PrayerHeader())),
            // Daily Quran reading: the lantern fills as you read.
            SliverToBoxAdapter(
              child: _in(
                2,
                const Padding(
                  padding: EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, 0),
                  child: QuranEnergyCard(),
                ),
              ),
            ),

            // ---- authority banner
            if (showBanner)
              SliverToBoxAdapter(
                child: _in(
                  2,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, 0),
                    child: AuthorityBanner(
                      showDontShow: true,
                      onClose: () => setState(() => _bannerClosed = true),
                    ),
                  ),
                ),
              ),

            // ---- nearest masjids
            SliverToBoxAdapter(
              child: _in(
                3,
                SectionHeader(
                  title: t.nearestMasjid,
                  subtitle: loc.value?.label ?? t.locating,
                  action: t.viewAll,
                  onAction: () => push(context, const MasjidListScreen()),
                ),
              ),
            ),
            ...masjids.when(
              loading: () => [const SliverToBoxAdapter(child: Loader())],
              error: (e, _) => [
                SliverToBoxAdapter(
                  child: EmptyState(
                    inCard: true,
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
                          inCard: true,
                          message: t.noMasjidNearby,
                          hint: t.noMasjidNearbyHint,
                        ),
                      ),
                    ]
                  : [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: Gap.l),
                        sliver: SliverList.separated(
                          itemCount: list.length.clamp(0, 3),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) =>
                              _in(4 + i, MasjidCard(masjid: list[i], index: i)),
                        ),
                      ),
                    ],
            ),

            // ---- duas for this part of the day
            const SliverToBoxAdapter(child: SizedBox(height: Gap.l)),
            SliverToBoxAdapter(child: _in(7, const NowDuaSection())),

            const SliverToBoxAdapter(child: SizedBox(height: Gap.xl)),
            SliverToBoxAdapter(child: _in(8, const VerseCarousel())),

            const SliverToBoxAdapter(child: SizedBox(height: Gap.xxl)),
          ],
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

    return SizedBox(
      height: 204,
      child: IslamicPattern(
        child: waqt == null
            ? Center(
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
                          PrayerNameArt(
                            prayer: waqt.prayer,
                            label: f.prayer(waqt.prayer),
                            size: 46,
                            color: AppColors.goldLight,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            f.range(waqt.window.start, waqt.window.end),
                            style: AppText.title.copyWith(
                              color: AppColors.onHeader,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
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
                                  Icon(
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
                    // Only the ring ticks every second – the rest of the
                    // header (pattern, prayer art) stays untouched.
                    Consumer(
                      builder: (context, ref, _) {
                        final now =
                            ref.watch(clockProvider).value ?? DateTime.now();
                        return RepaintBoundary(
                          child: CountdownRing(
                            size: 136,
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
                                    fontSize: 24,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
        color: AppColors.goldSurface,
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
                const SizedBox(width: Gap.m),
              ],
              AppButton(
                t.registerMasjid,
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

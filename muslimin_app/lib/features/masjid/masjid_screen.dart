import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/follows.dart';
import '../../state/providers.dart';
import 'edit_masjid_info_screen.dart';
import 'follow_badge.dart';
import 'tabs/about_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/live_tab.dart';
import 'tabs/notice_tab.dart';

Future<void> openDirections(Masjid m) => launchUrl(
  Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=${m.lat},${m.lng}',
  ),
  mode: LaunchMode.externalApplication,
);

class MasjidScreen extends ConsumerStatefulWidget {
  const MasjidScreen({super.key, required this.masjidId, this.initial});

  final String masjidId;
  final Masjid? initial;

  @override
  ConsumerState<MasjidScreen> createState() => _MasjidScreenState();
}

class _MasjidScreenState extends ConsumerState<MasjidScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final async = ref.watch(masjidProvider(widget.masjidId));
    final masjid = async.value ?? widget.initial;
    final user = ref.watch(authProvider).value;

    if (masjid == null) {
      return Scaffold(
        appBar: AppBar(),
        body: async.isLoading
            ? const Loader()
            : EmptyState(message: t.somethingWrong),
      );
    }
    final isOwner = user != null && user.uid == masjid.ownerUid;
    final canEdit = isOwner || (user?.isSuperAdmin ?? false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, _) => [
            PullToRefresh(onRefresh: () => refreshAll(ref)),
            SliverToBoxAdapter(
              child: _Header(masjid: masjid, canEdit: canEdit, tabs: _tabs),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(_tabs, t),
            ),
          ],
          body: Column(
            children: [
              if (isOwner && masjid.status != MasjidStatus.approved)
                _StatusBanner(masjid: masjid),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    MasjidHomeTab(masjid: masjid, canEdit: canEdit),
                    MasjidNoticeTab(
                      masjid: masjid,
                      canEdit:
                          canEdit && masjid.status == MasjidStatus.approved,
                    ),
                    MasjidLiveTab(masjid: masjid, canEdit: canEdit),
                    MasjidAboutTab(masjid: masjid, canEdit: canEdit),
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

class _Header extends ConsumerWidget {
  const _Header({
    required this.masjid,
    required this.canEdit,
    required this.tabs,
  });

  final Masjid masjid;
  final bool canEdit;
  final TabController tabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final loc = ref.watch(locationProvider).value;
    final following = ref.watch(followsProvider).containsKey(masjid.id);
    String? walk;
    if (loc != null) {
      final d = distanceMeters(loc.lat, loc.lng, masjid.lat, masjid.lng);
      walk = d < 2500 ? t.minWalk(f.digits(walkMinutes(d))) : f.distance(d);
    }

    // Same patterned dark green as the Home prayer header.
    return IslamicPattern(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BackButton(color: AppColors.onHeader),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: AppColors.onHeader,
                  ),
                  color: AppColors.card,
                  onSelected: (v) {
                    if (v == 'share') {
                      SharePlus.instance.share(
                        ShareParams(
                          text:
                              '${masjid.name}\n${masjid.fullAddress}\nhttps://maps.google.com/?q=${masjid.lat},${masjid.lng}',
                        ),
                      );
                    } else if (v == 'dir') {
                      openDirections(masjid);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'share', child: Text(t.share)),
                    PopupMenuItem(value: 'dir', child: Text(t.directions)),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.s, Gap.xl, Gap.xl),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FollowBadge(masjidId: masjid.id),
                  const SizedBox(width: Gap.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          masjid.displayName(f.isBn),
                          style: AppText.title.copyWith(
                            color: AppColors.onHeader,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          masjid.fullAddress,
                          style: AppText.body.copyWith(
                            color: AppColors.onHeader,
                          ),
                        ),
                        if (walk != null && walk.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            walk,
                            style: AppText.caption.copyWith(
                              color: AppColors.onHeader.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                        const SizedBox(height: Gap.m),
                        Wrap(
                          spacing: Gap.s,
                          runSpacing: Gap.s,
                          children: [
                            AppButton(
                              following ? t.following : t.follow,
                              icon: following
                                  ? Icons.check_rounded
                                  : Icons.add_rounded,
                              style: following
                                  ? AppButtonStyle.darkOutlined
                                  : AppButtonStyle.filled,
                              pill: true,
                              dense: true,
                              onPressed: () async {
                                final n = ref.read(followsProvider.notifier);
                                if (following) {
                                  await n.unfollow(masjid.id);
                                } else {
                                  await n.follow(masjid);
                                  if (context.mounted) {
                                    toast(
                                      context,
                                      t.followedToast(masjid.name),
                                    );
                                  }
                                }
                              },
                            ),
                            if (canEdit)
                              AppButton(
                                t.edit,
                                icon: Icons.edit_outlined,
                                style: AppButtonStyle.darkOutlined,
                                dense: true,
                                onPressed: () => push(
                                  context,
                                  EditMasjidInfoScreen(masjid: masjid),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: t.directions,
                    onPressed: () => openDirections(masjid),
                    icon: Icon(
                      Icons.explore_outlined,
                      color: AppColors.onHeader,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.controller, this.t);

  final TabController controller;
  final L10n t;

  @override
  double get minExtent => 44;
  @override
  double get maxExtent => 44;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    color: AppColors.card,
    child: TabBar(
      controller: controller,
      labelColor: AppColors.ink,
      unselectedLabelColor: AppColors.ink,
      labelStyle: AppText.label.copyWith(
        fontFamily: DefaultTextStyle.of(context).style.fontFamily,
      ),
      unselectedLabelStyle: AppText.body.copyWith(
        fontFamily: DefaultTextStyle.of(context).style.fontFamily,
      ),
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.gold, width: 3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
        insets: EdgeInsets.symmetric(horizontal: 8),
      ),
      tabs: [
        Tab(text: t.tabHome),
        Tab(text: t.tabNotice),
        Tab(text: t.tabLive),
        Tab(text: t.tabAbout),
      ],
    ),
  );

  @override
  bool shouldRebuild(_TabBarDelegate old) => old.t != t;
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.masjid});

  final Masjid masjid;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final rejected =
        masjid.status == MasjidStatus.rejected ||
        masjid.status == MasjidStatus.suspended;
    return Container(
      width: double.infinity,
      color: rejected
          ? AppColors.danger.withValues(alpha: 0.1)
          : AppColors.goldLight.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(horizontal: Gap.xl, vertical: Gap.m),
      child: Row(
        children: [
          Icon(
            rejected
                ? Icons.error_outline_rounded
                : Icons.hourglass_top_rounded,
            size: 18,
            color: rejected ? AppColors.danger : AppColors.gold,
          ),
          const SizedBox(width: Gap.s),
          Expanded(
            child: Text(
              rejected
                  ? t.rejectedBanner(masjid.rejectionReason ?? '-')
                  : t.pendingBanner,
              style: AppText.caption,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/page_header.dart';
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
import '../../services/location_service.dart';
import '../../state/channel.dart';
import '../../state/follows.dart';
import '../../state/volunteer.dart';
import '../../state/providers.dart';
import 'edit_masjid_info_screen.dart';
import 'follow_badge.dart';
import 'tabs/about_tab.dart';
import 'tabs/home_tab.dart';
import 'channel/channel_tab.dart';
import 'tabs/notice_tab.dart';
import 'volunteer.dart';

/// Turn-by-turn directions in the phone's own maps app, which follows the
/// phone's GPS. (The Google Maps web page used before opened in Safari on
/// iPhones without Google Maps and started from a rough, IP-based guess.)
/// Walking when the masjid is close, driving otherwise.
Future<void> openDirections(Masjid m, [UserLocation? from]) async {
  final to = '${m.lat},${m.lng}';
  final walk =
      from != null && distanceMeters(from.lat, from.lng, m.lat, m.lng) < 2500;
  if (Platform.isIOS) {
    final google = Uri.parse(
      'comgooglemaps://?daddr=$to&directionsmode=${walk ? 'walking' : 'driving'}',
    );
    if (await canLaunchUrl(google)) {
      await launchUrl(google);
      return;
    }
    await launchUrl(
      Uri.parse('https://maps.apple.com/?daddr=$to&dirflg=${walk ? 'w' : 'd'}'),
      mode: LaunchMode.externalApplication,
    );
    return;
  }
  await launchUrl(
    Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$to'
      '&travelmode=${walk ? 'walking' : 'driving'}',
    ),
    mode: LaunchMode.externalApplication,
  );
}

class MasjidScreen extends ConsumerStatefulWidget {
  const MasjidScreen({super.key, required this.masjidId, this.initial});

  final String masjidId;
  final Masjid? initial;

  @override
  ConsumerState<MasjidScreen> createState() => _MasjidScreenState();
}

class _MasjidScreenState extends ConsumerState<MasjidScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 4, vsync: this)..addListener(_onTab);
  final _scroll = ScrollController();

  /// The channel is a chat: give it the whole screen by scrolling the
  /// masjid info away.
  void _onTab() {
    if (_tabs.index == 2 && !_tabs.indexIsChanging && _scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final async = ref.watch(masjidProvider(widget.masjidId));
    final masjid = async.value ?? widget.initial;
    final user = ref.watch(authProvider).value;

    if (masjid == null) {
      return Scaffold(
        appBar: PatternAppBar(),
        body: async.isLoading
            ? const Loader()
            : EmptyState(message: t.somethingWrong),
      );
    }
    final isOwner = user != null && user.uid == masjid.ownerUid;
    final canEdit = isOwner || (user?.isSuperAdmin ?? false);
    // Owner, admin or a volunteer editor living nearby.
    final canEditTimes = ref.watch(canEditTimesProvider(masjid));

    return Scaffold(
      // The titled header stays; the masjid info scrolls away under it and
      // the tab bar then sticks right below the header.
      body: Column(
        children: [
          PageHeader(
            title: masjid.displayName(f.isBn),
            back: true,
            trailing: _MoreMenu(masjid: masjid),
          ),
          Expanded(
            child: NestedScrollView(
              controller: _scroll,
              headerSliverBuilder: (context, _) => [
                PullToRefresh(onRefresh: () => refreshAll(ref)),
                SliverToBoxAdapter(
                  child: _Info(masjid: masjid, canEdit: canEdit),
                ),
              ],
              body: Column(
                children: [
                  SizedBox(
                    height: 44,
                    child: _TabBarDelegate(_tabs, t).build(context, 0, false),
                  ),
                  if (isOwner && masjid.status != MasjidStatus.approved)
                    _StatusBanner(masjid: masjid),
                  Expanded(
                    child: TabBarView(
                      controller: _tabs,
                      children: [
                        MasjidHomeTab(
                          masjid: masjid,
                          canEdit: canEditTimes,
                          canVolunteer:
                              user != null &&
                              !canEditTimes &&
                              masjid.status == MasjidStatus.approved,
                          canReport: user != null && !isOwner,
                          onOpenChannel: () => _tabs.animateTo(2),
                        ),
                        MasjidNoticeTab(
                          masjid: masjid,
                          canEdit:
                              canEdit && masjid.status == MasjidStatus.approved,
                        ),
                        // Live is hidden for now (live_tab.dart is kept).
                        MasjidChannelTab(masjid: masjid),
                        MasjidAboutTab(
                          masjid: masjid,
                          canEdit: canEditTimes,
                          canManage: canEdit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header "more": share, directions and – for channel members – leave.
class _MoreMenu extends ConsumerWidget {
  const _MoreMenu({required this.masjid});

  final Masjid masjid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    // The owner is always an admin – nothing to leave.
    final member = ref.watch(channelMembershipProvider(masjid.id)).value;
    final user = ref.watch(authProvider).value;
    final editor = ref.watch(isEditorProvider(masjid.id)).value ?? false;
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz_rounded, color: AppColors.onHeader),
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
          openDirections(masjid, ref.read(locationProvider).value);
        } else if (v == 'leave') {
          leaveChannel(context, ref, masjid);
        } else if (v == 'report') {
          reportProblem(context, masjid);
        } else if (v == 'stopEditing') {
          ref.read(backendProvider).leaveEditor(masjid.id);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'share', child: Text(t.share)),
        PopupMenuItem(value: 'dir', child: Text(t.directions)),
        if (member != null)
          PopupMenuItem(value: 'leave', child: Text(t.leaveChannel)),
        if (user != null && user.uid != masjid.ownerUid)
          PopupMenuItem(value: 'report', child: Text(t.reportProblem)),
        if (editor)
          PopupMenuItem(value: 'stopEditing', child: Text(t.stopEditing)),
      ],
    );
  }
}

/// Address, distance, follow / edit – scrolls away under the header.
class _Info extends ConsumerWidget {
  const _Info({required this.masjid, required this.canEdit});

  final Masjid masjid;
  final bool canEdit;

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

    return IslamicPattern(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.xl, 0, Gap.s, Gap.xl),
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
                    masjid.fullAddress,
                    style: AppText.body.copyWith(color: AppColors.onHeader),
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
                              toast(context, t.followedToast(masjid.name));
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
              onPressed: () =>
                  openDirections(masjid, ref.read(locationProvider).value),
              icon: Icon(Icons.explore_outlined, color: AppColors.onHeader),
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
        Tab(text: t.tabChannel),
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

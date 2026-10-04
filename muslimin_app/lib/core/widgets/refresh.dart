import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// iOS-style "rubber band" scrolling on every platform: lists stretch past
/// both the top and the bottom edge and spring back on release.
class BouncyScrollBehavior extends MaterialScrollBehavior {
  const BouncyScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  // The bounce replaces Android's glow/stretch indicator.
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}

/// Pull-to-refresh sliver: pulling down past the top drags the content down
/// with a gold spinner; on release it refreshes and the content springs back
/// up. Only the top (pull-down) edge triggers a refresh – the bottom edge just
/// bounces. Put it first in a [CustomScrollView].
class PullToRefresh extends StatelessWidget {
  const PullToRefresh({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) => CupertinoSliverRefreshControl(
    onRefresh: onRefresh,
    refreshTriggerPullDistance: 90,
    refreshIndicatorExtent: 56,
    builder: (context, mode, pulled, trigger, extent) {
      final p = (pulled / trigger).clamp(0.0, 1.0);
      final spinning =
          mode == RefreshIndicatorMode.refresh ||
          mode == RefreshIndicatorMode.armed;
      return Center(
        child: Opacity(
          opacity: mode == RefreshIndicatorMode.inactive ? 0 : 1,
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.6,
              color: AppColors.gold,
              backgroundColor: AppColors.gold.withValues(alpha: 0.15),
              value: spinning ? null : p,
            ),
          ),
        ),
      );
    },
  );
}

/// A [ListView] replacement with [PullToRefresh] on top.
class RefreshList extends StatelessWidget {
  const RefreshList({
    super.key,
    required this.onRefresh,
    required List<Widget> this.children,
    this.padding = EdgeInsets.zero,
  }) : itemCount = 0,
       itemBuilder = null,
       separatorBuilder = null;

  const RefreshList.separated({
    super.key,
    required this.onRefresh,
    required this.itemCount,
    required IndexedWidgetBuilder this.itemBuilder,
    required IndexedWidgetBuilder this.separatorBuilder,
    this.padding = EdgeInsets.zero,
  }) : children = null;

  final Future<void> Function() onRefresh;
  final List<Widget>? children;
  final int itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      PullToRefresh(onRefresh: onRefresh),
      SliverPadding(
        padding: padding,
        sliver: children != null
            ? SliverList.list(children: children!)
            : SliverList.separated(
                itemCount: itemCount,
                itemBuilder: itemBuilder!,
                separatorBuilder: separatorBuilder!,
              ),
      ),
    ],
  );
}

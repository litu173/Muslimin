import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'entrance.dart';

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
    // A fixed-size spinner that only fades: it never grows with the pull
    // and stays just above the content instead of sliding with the gap.
    builder: (context, mode, pulled, trigger, extent) {
      final opacity = switch (mode) {
        RefreshIndicatorMode.inactive => 0.0,
        RefreshIndicatorMode.drag => ((pulled - 16) / (trigger * 0.6)).clamp(
          0.0,
          1.0,
        ),
        RefreshIndicatorMode.armed || RefreshIndicatorMode.refresh => 1.0,
        RefreshIndicatorMode.done => (pulled / extent).clamp(0.0, 1.0),
      };
      // OverflowBox: the gap starts at 0 px tall; the spinner keeps its
      // size instead of being squeezed while the gap opens.
      return OverflowBox(
        alignment: Alignment.bottomCenter,
        minWidth: 0,
        maxWidth: 40,
        minHeight: 0,
        maxHeight: 40,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Opacity(
            opacity: opacity,
            child: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                strokeCap: StrokeCap.round,
                color: AppColors.gold,
                backgroundColor: AppColors.gold.withValues(alpha: 0.15),
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// A [ListView] replacement with [PullToRefresh] on top; its items come in
/// with the page [Entrance].
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

  /// [children] with the page entrance; spacers don't count as a step.
  List<Widget> _animated() {
    var i = 0;
    return [
      for (final c in children!)
        c is SizedBox && c.child == null ? c : Entrance(index: i++, child: c),
    ];
  }

  @override
  Widget build(BuildContext context) => EntranceScope(
    child: CustomScrollView(
      slivers: [
        PullToRefresh(onRefresh: onRefresh),
        SliverPadding(
          padding: padding,
          sliver: children != null
              ? SliverList.list(children: _animated())
              : SliverList.separated(
                  itemCount: itemCount,
                  itemBuilder: (c, i) =>
                      Entrance(index: i, child: itemBuilder!(c, i)),
                  separatorBuilder: separatorBuilder!,
                ),
        ),
      ],
    ),
  );
}

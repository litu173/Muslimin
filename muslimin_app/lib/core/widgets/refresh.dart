import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/quran/surahs.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../utils/format.dart';
import 'entrance.dart';
import 'frosted_card.dart';

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

/// One short ayah shown while a page refreshes (assets/quran/refresh_ayat.json,
/// built by tool/build_refresh_ayat.py from quran.com).
class RefreshAyah {
  RefreshAyah.fromJson(Map<String, dynamic> j)
    : ref = j['ref'] as String,
      ar = j['ar'] as String,
      tr = (j['tr'] as Map).cast<String, String>();

  /// "94:5-6".
  final String ref;
  final String ar;

  /// Language code -> meaning (no Arabic: the ayah speaks for itself).
  final Map<String, String> tr;

  int get surah => int.parse(ref.split(':').first);

  static Future<List<RefreshAyah>>? _all;
  static List<RefreshAyah>? loaded;

  static Future<List<RefreshAyah>> load() => _all ??= () async {
    final raw = await rootBundle.loadString('assets/quran/refresh_ayat.json');
    return loaded = [
      for (final j in (jsonDecode(raw) as List).cast<Map<String, dynamic>>())
        RefreshAyah.fromJson(j),
    ];
  }();
}

/// Pull-to-refresh sliver: pulling down past the top drags the content down
/// and shows a short ayah from the Quran – a new one on every pull – above a
/// gold spinner. On release the page refreshes, and the ayah stays a few
/// seconds so it can be read, then the content springs back up. Only the top
/// (pull-down) edge triggers a refresh – the bottom edge just bounces. Put it
/// first in a [CustomScrollView].
class PullToRefresh extends StatefulWidget {
  const PullToRefresh({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  /// How long the ayah stays at least, so it can be read.
  static const hold = Duration(seconds: 4);

  @override
  State<PullToRefresh> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends State<PullToRefresh> {
  // Compact, so an ordinary pull reaches it: the bouncing overscroll gets
  // stiffer the further it goes, and a taller gap needs a near full-screen
  // drag.
  static const _card = 112.0;
  static const _extent = _card + 34;
  static final _random = math.Random();

  int? _index;
  RefreshIndicatorMode _last = RefreshIndicatorMode.inactive;

  @override
  void initState() {
    super.initState();
    RefreshAyah.load();
  }

  Future<void> _refresh() => Future.wait([
    widget.onRefresh(),
    Future<void>.delayed(PullToRefresh.hold),
  ]);

  @override
  Widget build(BuildContext context) => CupertinoSliverRefreshControl(
    onRefresh: _refresh,
    refreshTriggerPullDistance: _extent + 8,
    refreshIndicatorExtent: _extent,
    builder: (context, mode, pulled, trigger, extent) {
      // A new ayah each time a pull starts.
      final ayat = RefreshAyah.loaded;
      if (_last == RefreshIndicatorMode.inactive &&
          mode != RefreshIndicatorMode.inactive &&
          ayat != null &&
          ayat.isNotEmpty) {
        var i = _random.nextInt(ayat.length);
        if (i == _index && ayat.length > 1) i = (i + 1) % ayat.length;
        _index = i;
      }
      _last = mode;
      final opacity = switch (mode) {
        RefreshIndicatorMode.inactive => 0.0,
        RefreshIndicatorMode.drag => ((pulled - 16) / (trigger * 0.6)).clamp(
          0.0,
          1.0,
        ),
        RefreshIndicatorMode.armed || RefreshIndicatorMode.refresh => 1.0,
        RefreshIndicatorMode.done => (pulled / extent).clamp(0.0, 1.0),
      };
      final ayah = ayat != null && _index != null ? ayat[_index!] : null;
      // OverflowBox: the gap starts at 0 px tall; the card and spinner keep
      // their size and are uncovered from the bottom as the gap opens.
      // ClipRect: only the open gap shows it – it slides out from under
      // whatever sits above the list (tabs, filters), never over it.
      return ClipRect(
        child: OverflowBox(
          alignment: Alignment.bottomCenter,
          minHeight: 0,
          maxHeight: _extent,
          child: Opacity(
            opacity: opacity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (ayah != null) _AyahCard(ayah: ayah, height: _card),
                  const SizedBox(height: 8),
                  SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      strokeCap: StrokeCap.round,
                      color: AppColors.gold,
                      backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// The ayah on the frosted card of the Home ayah slider: Arabic, its
/// meaning in the app language (none in Arabic) and the surah. Long ayat
/// shrink to fit – nothing is cut off.
class _AyahCard extends StatelessWidget {
  const _AyahCard({required this.ayah, required this.height});

  final RefreshAyah ayah;
  final double height;

  @override
  Widget build(BuildContext context) {
    final f = Fmt.of(context);
    final meaning = f.lang == 'ar' ? '' : ayah.tr[f.lang] ?? ayah.tr['en']!;
    final surah = kSurahs[ayah.surah - 1];
    return SizedBox(
      height: height,
      child: FrostedCard(
        child: LayoutBuilder(
          builder: (context, c) {
            final width = c.maxWidth - 2 * Gap.l;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.l,
                vertical: Gap.s,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ayah.ar,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppText.arabic,
                            fontSize: 20,
                            height: 1.5,
                            color: AppColors.dark
                                ? AppColors.goldLight
                                : AppColors.gold,
                          ),
                        ),
                        if (meaning.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            meaning,
                            textAlign: TextAlign.center,
                            style: AppText.caption.copyWith(
                              color: AppColors.ink,
                              height: 1.3,
                            ),
                          ),
                        ],
                        const SizedBox(height: 2),
                        Text(
                          '${f.surahName(surah)} ${f.digits(ayah.ref)}',
                          style: AppText.micro.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
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

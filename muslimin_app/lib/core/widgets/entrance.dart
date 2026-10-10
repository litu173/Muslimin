import 'package:flutter/material.dart';

/// Tells pages when the user comes back to them (a page on top closed), so
/// their entrance plays again. Registered in MaterialApp.navigatorObservers.
final routeObserver = RouteObserver<ModalRoute<void>>();

/// Calls [onReturn] each time the page holding [context] shows again after
/// a page pushed on top of it is closed.
mixin ReturnAware<T extends StatefulWidget> on State<T> implements RouteAware {
  ModalRoute<void>? _route;

  void onReturn();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final r = ModalRoute.of(context);
    if (r != null && r != _route) {
      if (_route != null) routeObserver.unsubscribe(this);
      _route = r;
      routeObserver.subscribe(this, r);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() => onReturn();
  @override
  void didPush() {}
  @override
  void didPop() {}
  @override
  void didPushNext() {}
}

/// Home's entrance for any page: content slides up and fades in, one piece
/// after another – when the page opens, and again when the user comes back
/// to it. Put [EntranceScope] around the page and [Entrance] around each
/// section.
class EntranceScope extends StatefulWidget {
  const EntranceScope({super.key, required this.child});

  final Widget child;

  @override
  State<EntranceScope> createState() => _EntranceScopeState();
}

class _EntranceScopeState extends State<EntranceScope> with ReturnAware {
  DateTime start = DateTime.now();

  /// Sections without an index take the next one, in build order.
  int next = 0;

  /// Bumped on each return to the page; sections listen and play again.
  final replay = ValueNotifier(0);

  @override
  void onReturn() {
    start = DateTime.now();
    replay.value++;
  }

  @override
  void dispose() {
    replay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Scope(this, child: widget.child);
}

class _Scope extends InheritedWidget {
  const _Scope(this.state, {required super.child});

  final _EntranceScopeState state;

  @override
  bool updateShouldNotify(_Scope old) => false;
}

/// The [index]-th section of a page under an [EntranceScope]. Sections
/// built later (scrolled into view, refreshed) just appear – only the
/// page's first frame animates, and nothing runs once it has settled.
class Entrance extends StatefulWidget {
  const Entrance({super.key, this.index, required this.child});

  /// Defaults to build order within the scope.
  final int? index;
  final Widget child;

  /// Same timing as Home: ~100 ms apart, 440 ms each, 48 px rise.
  static const step = Duration(milliseconds: 99);
  static const length = Duration(milliseconds: 440);
  static const maxIndex = 7;
  static const rise = 48.0;

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: Entrance.length,
    value: 1,
  );
  late final _a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
  _EntranceScopeState? _page;
  int _gen = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_page != null) return;
    final page = _page = context.getInheritedWidgetOfExactType<_Scope>()?.state;
    if (page == null) return;
    page.replay.addListener(_onReplay);
    final index = widget.index ?? page.next++;
    _play(
      Entrance.step * index.clamp(0, Entrance.maxIndex) -
          DateTime.now().difference(page.start),
    );
  }

  /// Back on the page: sections on screen rise again, top to bottom.
  void _onReplay() {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached) return;
    final y = box.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.sizeOf(context).height;
    if (y > h || y + box.size.height < 0) return; // off screen
    final order = (y / 110).clamp(0, Entrance.maxIndex).round();
    _play(Entrance.step * order, force: true);
  }

  void _play(Duration due, {bool force = false}) {
    // Too late: the page has already shown up.
    if (!force && due < -const Duration(milliseconds: 150)) return;
    final gen = ++_gen;
    _c.value = 0;
    if (due <= Duration.zero) {
      _c.forward();
    } else {
      Future.delayed(due, () {
        if (mounted && gen == _gen) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _page?.replay.removeListener(_onReplay);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _a,
    child: widget.child,
    builder: (_, child) => _c.isCompleted
        ? child!
        : Opacity(
            opacity: _a.value,
            child: Transform.translate(
              offset: Offset(0, Entrance.rise * (1 - _a.value)),
              child: child,
            ),
          ),
  );
}

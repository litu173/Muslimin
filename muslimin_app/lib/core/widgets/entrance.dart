import 'package:flutter/material.dart';

/// Home's entrance for any page: content slides up and fades in, one piece
/// after another. Put [EntranceScope] around the page and [Entrance] around
/// each section.
class EntranceScope extends StatefulWidget {
  const EntranceScope({super.key, required this.child});

  final Widget child;

  @override
  State<EntranceScope> createState() => _EntranceScopeState();
}

class _EntranceScopeState extends State<EntranceScope> {
  final start = DateTime.now();

  /// Sections without an index take the next one, in build order.
  int next = 0;

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
  AnimationController? _c;
  late final Animation<double> _a;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final scope = context.getInheritedWidgetOfExactType<_Scope>();
    if (scope == null) return;
    final page = scope.state;
    final index = widget.index ?? page.next++;
    final due =
        Entrance.step * index.clamp(0, Entrance.maxIndex) -
        DateTime.now().difference(page.start);
    // Too late: the page has already shown up.
    if (due < -const Duration(milliseconds: 150)) return;
    final c = _c = AnimationController(vsync: this, duration: Entrance.length);
    _a = CurvedAnimation(parent: c, curve: Curves.easeOutCubic);
    if (due <= Duration.zero) {
      c.forward();
    } else {
      Future.delayed(due, () {
        if (mounted) c.forward();
      });
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_c == null) return widget.child;
    return AnimatedBuilder(
      animation: _a,
      child: widget.child,
      builder: (_, child) => Opacity(
        opacity: _a.value,
        child: Transform.translate(
          offset: Offset(0, Entrance.rise * (1 - _a.value)),
          child: child,
        ),
      ),
    );
  }
}

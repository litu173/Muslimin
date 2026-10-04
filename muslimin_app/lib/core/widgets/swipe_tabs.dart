import 'package:flutter/material.dart';

/// Swipe left / right on [child] to move between [count] tabs, like a
/// TabBarView – but for content that lives inside a vertical scroll view and
/// whose height changes per tab (e.g. the notice list on Home).
///
/// The content follows the finger; a flick or a drag past a third of the width
/// slides it out and the next tab's content slides in from the other side.
/// Changing [index] from outside (tapping a chip) plays the same slide.
class SwipeTabs extends StatefulWidget {
  const SwipeTabs({
    super.key,
    required this.index,
    required this.count,
    required this.onChanged,
    required this.child,
  });

  final int index;
  final int count;
  final ValueChanged<int> onChanged;

  /// Content of the current [index].
  final Widget child;

  @override
  State<SwipeTabs> createState() => _SwipeTabsState();
}

class _SwipeTabsState extends State<SwipeTabs>
    with SingleTickerProviderStateMixin {
  /// Horizontal offset of the content in px.
  late final _dx = AnimationController.unbounded(vsync: this);
  double _width = 1;

  /// True while a swipe-driven change is being applied, so [didUpdateWidget]
  /// does not play the tap animation on top of it.
  bool _swiping = false;

  @override
  void didUpdateWidget(SwipeTabs old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index && !_swiping) {
      // Tapped a chip: slide the new content in from that side.
      final dir = widget.index > old.index ? 1.0 : -1.0;
      _dx.value = dir * _width * 0.35;
      _settle();
    }
  }

  @override
  void dispose() {
    _dx.dispose();
    super.dispose();
  }

  void _settle() => _dx.animateTo(
    0,
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
  );

  void _onUpdate(DragUpdateDetails d) {
    var delta = d.delta.dx;
    final atStart = widget.index == 0 && _dx.value + delta > 0;
    final atEnd = widget.index == widget.count - 1 && _dx.value + delta < 0;
    if (atStart || atEnd) delta *= 0.3; // rubber band at the ends
    _dx.value += delta;
  }

  Future<void> _onEnd(DragEndDetails d) async {
    final v = d.primaryVelocity ?? 0;
    var next = widget.index;
    if (_dx.value < -_width / 3 || v < -500) next++;
    if (_dx.value > _width / 3 || v > 500) next--;
    if (next == widget.index || next < 0 || next >= widget.count) {
      _settle();
      return;
    }
    final dir = next > widget.index ? 1.0 : -1.0;
    // Out…
    await _dx.animateTo(
      -dir * _width,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeIn,
    );
    if (!mounted) return;
    _swiping = true;
    widget.onChanged(next);
    _swiping = false;
    // …and the new tab in from the other side.
    _dx.value = dir * _width * 0.5;
    _settle();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      _width = c.maxWidth;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: _onUpdate,
        onHorizontalDragEnd: _onEnd,
        onHorizontalDragCancel: _settle,
        child: AnimatedBuilder(
          animation: _dx,
          child: widget.child,
          builder: (_, child) => Opacity(
            opacity: (1 - _dx.value.abs() / _width * 0.8).clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(_dx.value, 0),
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

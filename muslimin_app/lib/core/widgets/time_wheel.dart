import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/hm.dart';
import '../../data/models/prayer.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../utils/format.dart';
import 'buttons.dart';

/// The hours (24 h, start inclusive, end exclusive) a time can fall in.
/// With one, the picker shows only hour and minute and works out AM/PM by
/// itself – nobody sets Fajr to 5:30 PM by mistake.
typedef HourWindow = (int, int);

/// When each jamat can be (Bangladesh, all seasons, generous).
HourWindow prayerWindow(Prayer p) => switch (p) {
  Prayer.fajr => (3, 9),
  Prayer.dhuhr || Prayer.jumuah => (11, 16),
  Prayer.asr => (14, 19),
  Prayer.maghrib => (16, 21),
  Prayer.isha => (18, 24),
};

/// Maktab sessions: morning is before noon, evening after.
const HourWindow morningWindow = (4, 12);
const HourWindow eveningWindow = (12, 24);

/// The 24-hour hour for a 12-hour [h12] inside [w] (or the nearer one).
int resolveHour(int h12, HourWindow w) {
  final a = h12 % 12, b = a + 12;
  bool inside(int h) => h >= w.$1 && h < w.$2;
  if (inside(a) && !inside(b)) return a;
  if (inside(b) && !inside(a)) return b;
  final mid = (w.$1 + w.$2) / 2;
  return (a - mid).abs() <= (b - mid).abs() ? a : b;
}

/// Bottom sheet with hour and minute wheels. With [window] the half of the
/// day is automatic; without one an AM/PM wheel is shown too.
Future<HM?> pickTimeWheel(
  BuildContext context, {
  required String title,
  HM? initial,
  HourWindow? window,
}) => showModalBottomSheet<HM>(
  context: context,
  backgroundColor: Colors.transparent,
  constraints: const BoxConstraints(maxWidth: double.infinity),
  builder: (_) => _WheelSheet(
    title: title,
    windows: [window],
    labels: const [null],
    initial: [initial],
  ),
).then((v) => v);

/// From / to in one sheet (maktab sessions).
Future<HMRange?> pickRangeWheel(
  BuildContext context, {
  required String title,
  HMRange? initial,
  HourWindow? window,
}) async {
  final t = L10n.of(context);
  final r = await showModalBottomSheet<List<HM>>(
    context: context,
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints(maxWidth: double.infinity),
    builder: (_) => _WheelSheet(
      title: title,
      windows: [window, window],
      labels: [t.timeFrom, t.timeTo],
      initial: [initial?.start, initial?.end],
      multi: true,
    ),
  );
  return r == null ? null : HMRange(r[0], r[1]);
}

class _WheelSheet extends StatefulWidget {
  const _WheelSheet({
    required this.title,
    required this.windows,
    required this.labels,
    required this.initial,
    this.multi = false,
  });

  final String title;
  final List<HourWindow?> windows;
  final List<String?> labels;
  final List<HM?> initial;
  final bool multi;

  @override
  State<_WheelSheet> createState() => _WheelSheetState();
}

class _WheelSheetState extends State<_WheelSheet> {
  late final List<int> _h12; // 1..12
  late final List<int> _min;
  late final List<bool> _pm; // only used without a window

  @override
  void initState() {
    super.initState();
    _h12 = [];
    _min = [];
    _pm = [];
    for (var i = 0; i < widget.windows.length; i++) {
      final w = widget.windows[i];
      final init =
          widget.initial[i] ??
          (i > 0 && widget.initial[0] != null
              ? HM(
                  (widget.initial[0]!.hour + 1) % 24,
                  widget.initial[0]!.minute,
                )
              : HM(w == null ? 12 : ((w.$1 + w.$2) ~/ 2) % 24, 0));
      final h = init.hour % 12;
      _h12.add(h == 0 ? 12 : h);
      _min.add(init.minute);
      _pm.add(init.hour >= 12);
    }
  }

  HM _value(int i) {
    final w = widget.windows[i];
    final h = w == null
        ? (_h12[i] % 12) + (_pm[i] ? 12 : 0)
        : resolveHour(_h12[i], w);
    return HM(h % 24, _min[i]);
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
      ),
      padding: EdgeInsets.fromLTRB(
        Gap.xl,
        Gap.m,
        Gap.xl,
        Gap.l + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: Gap.l),
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            widget.title,
            style: AppText.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Gap.m),
          Row(
            children: [
              for (var i = 0; i < widget.windows.length; i++) ...[
                if (i > 0) const SizedBox(width: Gap.l),
                Expanded(child: _wheels(i, t, f)),
              ],
            ],
          ),
          const SizedBox(height: Gap.l),
          AppButton(
            t.done,
            expand: true,
            onPressed: () => Navigator.pop(
              context,
              widget.multi
                  ? [for (var i = 0; i < widget.windows.length; i++) _value(i)]
                  : _value(0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wheels(int i, L10n t, Fmt f) {
    final w = widget.windows[i];
    final v = _value(i);
    final half = v.hour >= 12 ? t.pm.toUpperCase() : t.am.toUpperCase();
    final style = AppText.title.copyWith(color: AppColors.ink);
    Widget wheel({
      required int count,
      required int selected,
      required String Function(int) label,
      required ValueChanged<int> onChanged,
      bool loop = true,
    }) => SizedBox(
      height: 180,
      child: CupertinoPicker(
        itemExtent: 44,
        looping: loop,
        scrollController: FixedExtentScrollController(initialItem: selected),
        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: AppColors.gold.withValues(alpha: 0.12),
        ),
        onSelectedItemChanged: (x) => setState(() => onChanged(x)),
        children: [
          for (var x = 0; x < count; x++)
            Center(child: Text(label(x), style: style)),
        ],
      ),
    );

    return Column(
      children: [
        if (widget.labels[i] != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.xs),
            child: Text(
              widget.labels[i]!,
              style: AppText.caption.copyWith(color: AppColors.muted),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: wheel(
                count: 12,
                selected: _h12[i] - 1,
                label: (x) => f.digits(x + 1),
                onChanged: (x) => _h12[i] = x + 1,
              ),
            ),
            Text(':', style: style),
            Expanded(
              child: wheel(
                count: 60,
                selected: _min[i],
                label: (x) => f.digits(x.toString().padLeft(2, '0')),
                onChanged: (x) => _min[i] = x,
              ),
            ),
            if (w == null)
              Expanded(
                child: wheel(
                  count: 2,
                  loop: false,
                  selected: _pm[i] ? 1 : 0,
                  label: (x) =>
                      x == 0 ? t.am.toUpperCase() : t.pm.toUpperCase(),
                  onChanged: (x) => _pm[i] = x == 1,
                ),
              )
            else
              // Set by the prayer / session – shown, not chosen.
              Padding(
                padding: const EdgeInsets.only(left: Gap.s),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                  child: Text(
                    half,
                    style: AppText.label.copyWith(color: AppColors.gold),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

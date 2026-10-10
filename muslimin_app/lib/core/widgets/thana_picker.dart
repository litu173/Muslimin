import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/thana_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/app_spacing.dart';
import 'page_header.dart';

/// Picked in [pickThana] to mean "every area" (when offered).
const allThanas = Thana('', '');

/// The list of every thana / upazila, searchable, the user's own first.
/// Returns the pick, [allThanas] (with [allLabel]) or null (dismissed).
Future<Thana?> pickThana(
  BuildContext context, {
  Thana? mine,
  Thana? current,
  String? allLabel,
}) => showModalBottomSheet<Thana>(
  context: context,
  isScrollControlled: true,
  backgroundColor: AppColors.card,
  builder: (_) => _ThanaSheet(mine: mine, current: current, allLabel: allLabel),
);

/// White pill on the header: "New Market ▾".
class ThanaButton extends StatelessWidget {
  const ThanaButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.sizeOf(context).width * 0.42,
    ),
    child: Material(
      color: AppColors.field,
      shape: StadiumBorder(side: BorderSide(color: AppColors.divider)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 11, 8, 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.place_outlined, size: 18, color: AppColors.gold),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(color: AppColors.ink),
                ),
              ),
              Icon(Icons.arrow_drop_down_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    ),
  );
}

/// All thanas / upazilas, searchable; the user's own first.
class _ThanaSheet extends StatefulWidget {
  const _ThanaSheet({
    required this.mine,
    required this.current,
    required this.allLabel,
  });

  final Thana? mine;
  final Thana? current;

  /// When set, a first row for "every area" (returns [allThanas]).
  final String? allLabel;

  @override
  State<_ThanaSheet> createState() => _ThanaSheetState();
}

class _ThanaSheetState extends State<_ThanaSheet> {
  final _q = TextEditingController();
  List<Thana> _all = const [];

  @override
  void initState() {
    super.initState();
    ThanaService.load().then((s) {
      if (mounted) setState(() => _all = s.all);
    });
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final q = _q.text.trim().toLowerCase();
    final list = q.isEmpty
        ? _all
        : _all
              .where(
                (a) =>
                    a.name.toLowerCase().contains(q) ||
                    a.district.toLowerCase().contains(q),
              )
              .toList();
    final selected = widget.current ?? widget.mine;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (_, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.chooseThana, style: AppText.subtitle),
                Text(
                  t.chooseThanaHint,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: Gap.m),
                AppSearchField(
                  controller: _q,
                  hint: t.searchThana,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: scroll,
              children: [
                if (widget.allLabel != null && q.isEmpty)
                  ListTile(
                    leading: Icon(Icons.public_rounded, color: AppColors.gold),
                    title: Text(widget.allLabel!, style: AppText.label),
                    trailing: widget.current == allThanas
                        ? Icon(Icons.check_rounded, color: AppColors.gold)
                        : null,
                    onTap: () => Navigator.pop(context, allThanas),
                  ),
                if (widget.mine != null && q.isEmpty)
                  ListTile(
                    leading: Icon(
                      Icons.my_location_rounded,
                      color: AppColors.gold,
                    ),
                    title: Text(widget.mine!.name, style: AppText.label),
                    subtitle: Text(
                      t.myThana,
                      style: AppText.micro.copyWith(color: AppColors.muted),
                    ),
                    trailing: selected == widget.mine
                        ? Icon(Icons.check_rounded, color: AppColors.gold)
                        : null,
                    onTap: () => Navigator.pop(context, widget.mine),
                  ),
                for (final a in list)
                  ListTile(
                    dense: true,
                    title: Text(a.name, style: AppText.body),
                    subtitle: Text(
                      a.district,
                      style: AppText.micro.copyWith(color: AppColors.muted),
                    ),
                    trailing: a == selected
                        ? Icon(Icons.check_rounded, color: AppColors.gold)
                        : null,
                    onTap: () => Navigator.pop(context, a),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

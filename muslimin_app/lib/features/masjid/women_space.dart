import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

/// Whether the masjid has a place for women to pray. Everyone sees it once
/// it is set; the owner / admin ([canManage]) answers Yes or No here.
class WomenSpaceCard extends ConsumerStatefulWidget {
  const WomenSpaceCard({
    super.key,
    required this.masjid,
    required this.canManage,
  });

  final Masjid masjid;
  final bool canManage;

  @override
  ConsumerState<WomenSpaceCard> createState() => _WomenSpaceCardState();
}

class _WomenSpaceCardState extends ConsumerState<WomenSpaceCard> {
  bool _saving = false;

  Future<void> _set(bool v) async {
    if (_saving || widget.masjid.womenSpace == v) return;
    setState(() => _saving = true);
    try {
      await ref.read(backendProvider).updateWomenSpace(widget.masjid.id, v);
    } catch (_) {
      if (mounted) toast(context, L10n.of(context).somethingWrong);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final v = widget.masjid.womenSpace;
    final (status, color) = switch (v) {
      true => (t.womenSpaceYes, AppColors.success),
      false => (t.womenSpaceNo, AppColors.muted),
      null => (t.womenSpaceUnset, AppColors.muted),
    };
    return AppCard(
      padding: const EdgeInsets.all(Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              WomenSpaceIcon(available: v == true),
              const SizedBox(width: Gap.m),
              Expanded(child: Text(t.womenSpace, style: AppText.label)),
              Text(
                status,
                style: AppText.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (widget.canManage) ...[
            const SizedBox(height: Gap.m),
            Text(t.womenSpaceAsk, style: AppText.caption),
            const SizedBox(height: Gap.s),
            Row(
              children: [
                for (final (answer, label) in [
                  (true, t.yesLabel),
                  (false, t.noLabel),
                ]) ...[
                  ChoiceChip(
                    label: Text(label),
                    selected: v == answer,
                    onSelected: _saving ? null : (_) => _set(answer),
                    selectedColor: AppColors.gold,
                    labelStyle: AppText.label.copyWith(
                      color: v == answer ? AppColors.onGold : AppColors.ink,
                    ),
                    showCheckmark: false,
                  ),
                  const SizedBox(width: Gap.s),
                ],
                if (_saving)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Round gold badge with a woman figure (the finder and the masjid page).
class WomenSpaceIcon extends StatelessWidget {
  const WomenSpaceIcon({super.key, this.available = true, this.size = 40});

  final bool available;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: available
          ? AppColors.gold.withValues(alpha: 0.16)
          : AppColors.chipIdle,
    ),
    child: Icon(
      Icons.woman_rounded,
      size: size * 0.6,
      color: available ? AppColors.gold : AppColors.muted,
    ),
  );
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

class GoldSheetOption<T> {
  const GoldSheetOption(this.value, this.label);

  final T value;
  final String label;
}

/// The gold bottom sheet from the Figma ("Select Category", "Jamat Reminder").
Future<T?> showGoldSheet<T>(
  BuildContext context, {
  required IconData icon,
  required String title,
  String? subtitle,
  required List<GoldSheetOption<T>> options,
  T? selected,
  String? selectedLabel,
  Widget? footer,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: true,
    builder: (ctx) => Container(
      decoration: BoxDecoration(
        color: AppColors.goldSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
      ),
      padding: EdgeInsets.fromLTRB(
        Gap.xl,
        Gap.xl,
        Gap.xl,
        Gap.xl + MediaQuery.of(ctx).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: Gap.m),
              Text(
                title,
                style: AppText.subtitle.copyWith(color: Colors.white),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: Gap.l),
            Text(subtitle, style: AppText.label.copyWith(color: Colors.white)),
          ],
          const SizedBox(height: Gap.s),
          for (var i = 0; i < options.length; i++) ...[
            InkWell(
              onTap: () => Navigator.pop(ctx, options[i].value),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        options[i].label,
                        style: AppText.label.copyWith(color: Colors.white),
                      ),
                    ),
                    if (options[i].value == selected && selectedLabel != null)
                      Text(
                        selectedLabel,
                        style: AppText.caption.copyWith(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
            if (i < options.length - 1)
              Divider(color: Colors.white.withValues(alpha: 0.3)),
          ],
          ?footer,
        ],
      ),
    ),
  );
}

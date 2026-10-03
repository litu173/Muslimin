import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

enum AppButtonStyle { filled, outlined, light, darkOutlined }

/// The one button of the design system.
///  * filled      – gold background, white label (Next, Create, Post)
///  * outlined    – gold border & label (Skip, Cancel, Load)
///  * light       – cream pill with gold label (View Details on gold card)
///  * darkOutlined– light-gold pill on dark headers (Following, Edit)
class AppButton extends StatelessWidget {
  const AppButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.style = AppButtonStyle.filled,
    this.icon,
    this.loading = false,
    this.expand = false,
    this.pill = false,
    this.dense = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final bool pill;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (style) {
      AppButtonStyle.filled => (AppColors.gold, Colors.white, null),
      AppButtonStyle.outlined => (
        Colors.transparent,
        AppColors.gold,
        AppColors.gold,
      ),
      AppButtonStyle.light => (AppColors.cream, AppColors.gold, null),
      AppButtonStyle.darkOutlined => (
        Colors.transparent,
        AppColors.goldLight,
        AppColors.goldLight,
      ),
    };
    final disabled = onPressed == null || loading;
    final radius = BorderRadius.circular(
      pill || style == AppButtonStyle.darkOutlined ? Radii.pill : Radii.button,
    );
    final textStyle = (dense ? AppText.caption : AppText.label).copyWith(
      color: fg,
      fontWeight: FontWeight.w500,
    );

    Widget content = loading
        ? SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: dense ? 16 : 18, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = Opacity(
      opacity: disabled && !loading ? 0.5 : 1,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: border == null ? BorderSide.none : BorderSide(color: border),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: disabled ? null : onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dense ? 16 : 16,
              vertical: dense ? 7 : 10,
            ),
            child: Center(widthFactor: 1, heightFactor: 1, child: content),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Two buttons side by side at the bottom of form/onboarding cards.
class ButtonPair extends StatelessWidget {
  const ButtonPair({super.key, required this.secondary, required this.primary});

  final Widget secondary;
  final Widget primary;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: secondary),
      const SizedBox(width: Gap.l),
      Expanded(child: primary),
    ],
  );
}

/// Round 36px icon button with cream background (jamat bell, edit chips).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final String? tooltip;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip ?? '',
    child: Material(
      color: active ? AppColors.gold : AppColors.cream,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: 36,
          child: Icon(
            icon,
            size: 20,
            color: active ? Colors.white : AppColors.gold,
          ),
        ),
      ),
    ),
  );
}

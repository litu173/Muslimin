import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Rounded card – the main surface of the app (Figma: #FFFDF5, r20).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.l),
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) => Material(
    color: color ?? AppColors.card,
    borderRadius: BorderRadius.circular(Radii.card),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}

/// The translucent white card that frames onboarding & registration steps.
class SheetCard extends StatelessWidget {
  const SheetCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(Gap.l),
    decoration: BoxDecoration(
      color: AppColors.dark
          ? AppColors.card
          : Colors.white.withValues(alpha: 0.46),
      borderRadius: BorderRadius.circular(Radii.card),
    ),
    child: child,
  );
}

/// Eight-point-star masjid badge (gold by default, teal for alternation).
class MasjidBadge extends StatelessWidget {
  const MasjidBadge({super.key, this.size = 40, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/icons/masjid_badge.svg',
    width: size,
    height: size,
    colorFilter: ColorFilter.mode(color ?? AppColors.gold, BlendMode.srcIn),
  );
}

/// Title + optional caption + trailing action, used above lists.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xl, Gap.m, Gap.m),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.subtitle),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.ink,
              textStyle: AppText.body,
            ),
            child: Text(action!),
          ),
      ],
    ),
  );
}

/// Card row: leading icon, 3 lines of text (title / line / meta), optional trailing.
class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.leading,
    required this.title,
    this.line,
    this.meta,
    this.trailing,
    this.onTap,
    this.lineStyle,
  });

  final Widget leading;
  final String title;
  final String? line;
  final String? meta;
  final Widget? trailing;
  final VoidCallback? onTap;
  final TextStyle? lineStyle;

  @override
  Widget build(BuildContext context) => AppCard(
    onTap: onTap,
    padding: const EdgeInsets.symmetric(horizontal: Gap.l, vertical: Gap.m),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 68),
      child: Row(
        children: [
          SizedBox(width: 40, child: Center(child: leading)),
          const SizedBox(width: Gap.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppText.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (line != null && line!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    line!,
                    style: lineStyle ?? AppText.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (meta != null && meta!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    meta!,
                    style: AppText.caption.copyWith(
                      color: AppColors.ink.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: Gap.s), trailing!],
        ],
      ),
    ),
  );
}

/// Selectable pill chip (notice filters, maktab days).
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.dense = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? AppColors.gold : AppColors.card,
    borderRadius: BorderRadius.circular(Radii.pill),
    child: InkWell(
      borderRadius: BorderRadius.circular(Radii.pill),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dense ? 10 : 12, vertical: 5),
        child: Text(
          label,
          style: AppText.caption.copyWith(
            color: selected ? AppColors.onGold : AppColors.ink,
          ),
        ),
      ),
    ),
  );
}

/// Empty / error placeholder in the same voice as the rest of the UI.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.hint,
    this.icon = Icons.mosque_outlined,
    this.action,
    this.inCard = false,
  });

  final String message;
  final String? hint;
  final IconData icon;
  final Widget? action;

  /// In a feed (Home) the message sits in a full-width card with the page
  /// gutter, like the masjid and notice cards around it.
  final bool inCard;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: inCard ? 52 : 64,
          height: inCard ? 52 : 64,
          decoration: BoxDecoration(
            color: inCard ? AppColors.cream : AppColors.card,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.gold, size: inCard ? 26 : 30),
        ),
        const SizedBox(height: Gap.m),
        Text(message, style: AppText.label, textAlign: TextAlign.center),
        if (hint != null) ...[
          const SizedBox(height: Gap.s),
          Text(
            hint!,
            style: AppText.caption.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
          ),
        ],
        if (action != null) ...[const SizedBox(height: Gap.l), action!],
      ],
    );
    if (inCard) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Gap.page),
        child: SizedBox(
          width: double.infinity,
          child: AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.xl,
              vertical: Gap.xl,
            ),
            child: content,
          ),
        ),
      );
    }
    // Full-screen use: centred both ways in whatever space it gets.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.xxl,
          vertical: Gap.xxl,
        ),
        child: content,
      ),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(32),
    child: Center(child: CircularProgressIndicator()),
  );
}

/// Small status pill (Pending / Approved / Rejected).
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(Radii.pill),
    ),
    child: Text(
      label,
      style: AppText.micro.copyWith(color: color, fontWeight: FontWeight.w600),
    ),
  );
}

/// Page dots (onboarding / verse carousel).
class Dots extends StatelessWidget {
  const Dots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < count; i++)
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: i == index ? 12 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: i == index ? AppColors.gold : Colors.transparent,
            border: Border.all(color: AppColors.gold, width: 1),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
    ],
  );
}

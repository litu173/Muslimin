import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'islamic_pattern.dart';

/// The "spiritual" card surface shared by the ayah slider and the Daily
/// Quran tracker: a warm gold-to-mint gradient (deep green at night), the
/// header pattern, and a frosted-glass wash on top.
class FrostedCard extends StatelessWidget {
  const FrostedCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.dark;
    final radius = BorderRadius.circular(Radii.card);
    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dark
                      ? const [
                          Color(0xFF2A2A12),
                          Color(0xFF13241F),
                          Color(0xFF173A33),
                        ]
                      : const [
                          Color(0xFFFFE7A3),
                          Color(0xFFF7F0D8),
                          Color(0xFFCDEBDF),
                        ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: dark ? 0.9 : 1,
              child: const IslamicPattern(color: Colors.transparent),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.35),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: dark
                        ? const [Color(0x330B1A18), Color(0x660B1A18)]
                        : const [Color(0x59FFFFFF), Color(0x26FFFFFF)],
                  ),
                ),
              ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(onTap: onTap, borderRadius: radius, child: child),
          ),
        ],
      ),
    );
  }
}

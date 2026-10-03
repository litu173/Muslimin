import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// The geometric header pattern from the Figma file (gold lines at 16% on
/// deep green). The SVG is the exact Figma tile repeated – see
/// `tool/build_pattern.py` – so it stays a crisp vector on every screen.
class IslamicPattern extends StatelessWidget {
  const IslamicPattern({super.key, this.child, this.color = AppColors.ink});

  final Widget? child;
  final Color color;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/patterns/header_pattern.svg',
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          ?child,
        ],
      ),
    ),
  );
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// The geometric pattern from the Figma file (gold lines at 16% on deep
/// green). `assets/patterns/header_pattern.svg` is the exact Figma tile
/// repeated 8 x 3 (see `tool/build_pattern.py`); here it is laid out at 1:1
/// Figma scale and repeated as needed, so it covers any width or height and
/// stays a crisp vector.
class IslamicPattern extends StatelessWidget {
  const IslamicPattern({super.key, this.child, this.color = AppColors.ink});

  final Widget? child;
  final Color color;

  static const _w = 575.99;
  static const _h = 296.23;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (_, c) {
                final cols = math.max(1, (c.maxWidth / _w).ceil());
                final rows = math.max(1, (c.maxHeight / _h).ceil());
                return OverflowBox(
                  alignment: Alignment.topLeft,
                  maxWidth: cols * _w,
                  maxHeight: rows * _h,
                  child: Column(
                    children: [
                      for (var r = 0; r < rows; r++)
                        Row(
                          children: [
                            for (var col = 0; col < cols; col++)
                              SvgPicture.asset(
                                'assets/patterns/header_pattern.svg',
                                width: _w,
                                height: _h,
                              ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          ?child,
        ],
      ),
    ),
  );
}

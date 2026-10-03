import 'package:flutter/material.dart';

/// Muslimin colour tokens – taken 1:1 from the Figma file.
abstract final class AppColors {
  /// Deep green used for headers, the dark "All Prayers" screen and all body text.
  static const ink = Color(0xFF002828);

  /// Even deeper green used as the countdown ring track and pattern shade.
  static const inkDeep = Color(0xFF011815);

  /// Primary brand gold: buttons, active tabs, chips, accents.
  static const gold = Color(0xFFBB8907);

  /// Bright gold used on dark surfaces (prayer name, timer, outlined pills).
  static const goldLight = Color(0xFFFFC940);

  /// Page background.
  static const cream = Color(0xFFF3EED5);

  /// Card surface.
  static const card = Color(0xFFFFFDF5);

  /// Input field fill.
  static const field = Color(0xFFFFFFFF);

  /// Pill background used for editable time values.
  static const pill = Color(0xFFF3EED5);

  /// Teal used on the verse banner and the secondary masjid badge.
  static const teal = Color(0xFF74C5B3);
  static const tealDark = Color(0xFF2E6B60);

  static const divider = Color(0x1A002828);
  static const muted = Color(0xB3002828);
  static const success = Color(0xFF2E7D4F);
  static const danger = Color(0xFFB3261E);
  static const white = Color(0xFFFFFFFF);
}

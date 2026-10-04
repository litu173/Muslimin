import 'package:flutter/material.dart';

/// Muslimin colour tokens. Light values come 1:1 from the Figma file; the
/// dark values are a "night masjid" palette: deep green-black surfaces,
/// warm parchment text and a brighter gold that keeps its contrast.
///
/// The tokens are getters over the active palette ([dark]), which the app
/// root sets from the theme setting before every build.
abstract final class AppColors {
  /// Whether the dark palette is active (set by `MusliminApp`).
  static bool dark = false;

  static Color _c(int light, int night) => Color(dark ? night : light);

  /// Body text and icons.
  static Color get ink => _c(0xFF002828, 0xFFEDE6CF);

  /// Even deeper green used as the countdown ring track and pattern shade.
  static Color get inkDeep => _c(0xFF011815, 0xFF040B0A);

  /// Patterned green surfaces (Home cover, masjid header, app bars).
  static Color get header => _c(0xFF002828, 0xFF0C2522);

  /// Text and icons on [header] and other always-dark surfaces.
  static Color get onHeader => const Color(0xFFF3EED5);

  /// Primary brand gold: buttons, active tabs, chips, accents.
  static Color get gold => _c(0xFFBB8907, 0xFFD6A630);

  /// Large gold surfaces (authority banner, gold sheets) – a deeper, richer
  /// gold at night so white text keeps its contrast.
  static Color get goldSurface => _c(0xFFBB8907, 0xFF8E6A12);

  /// Text and icons on [gold] fills (buttons, selected chips).
  static Color get onGold => _c(0xFFFFFFFF, 0xFF1A1407);

  /// Bright gold used on dark surfaces (prayer name, timer, outlined pills).
  static Color get goldLight => const Color(0xFFFFC940);

  /// Page background.
  static Color get cream => _c(0xFFF3EED5, 0xFF07110F);

  /// Card surface.
  static Color get card => _c(0xFFFFFDF5, 0xFF111D1B);

  /// Input field fill.
  static Color get field => _c(0xFFFFFFFF, 0xFF182725);

  /// Pill background used for editable time values.
  static Color get pill => _c(0xFFF3EED5, 0xFF1F302D);

  /// Teal used on the secondary masjid badge.
  static Color get teal => _c(0xFF74C5B3, 0xFF5FB3A1);
  static Color get tealDark => _c(0xFF2E6B60, 0xFF9AD8C9);

  static Color get divider => _c(0x1A002828, 0x24EDE6CF);
  static Color get muted => _c(0xB3002828, 0x99EDE6CF);
  static Color get success => _c(0xFF2E7D4F, 0xFF5CBF86);
  static Color get danger => _c(0xFFB3261E, 0xFFF07467);
  static const white = Color(0xFFFFFFFF);
}

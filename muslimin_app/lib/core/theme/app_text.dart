import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography. Poppins is used for Latin text and Hind Siliguri for Bangla –
/// every style lists both so mixed-language strings (masjid names in English
/// inside Bangla UI) always render correctly. The display face (prayer name
/// and logo) is Rakkas / Galada, an open-licence stand-in for the
/// "Hidayatullah DEMO" face used in Figma.
abstract final class AppText {
  static const latin = 'Poppins';
  static const bangla = 'HindSiliguri';
  static const displayLatin = 'Rakkas';
  static const displayBangla = 'Galada';
  static const arabic = 'Amiri';

  static List<String> fallbackFor(String family) =>
      family == bangla ? const [latin] : const [bangla];

  static TextStyle _base(double size, FontWeight weight, double? height) =>
      TextStyle(
        fontSize: size,
        fontWeight: weight,
        height: height == null ? null : height / size,
        color: AppColors.ink,
        letterSpacing: -0.32 * size / 16,
      );

  /// 20 / Bold – screen titles ("Create Masjid Profile", onboarding titles).
  static final headline = _base(20, FontWeight.w700, 26);

  /// 18 / Bold – masjid name in the dark header.
  static final title = _base(18, FontWeight.w700, 24);

  /// 16 / Medium – card titles, section headers.
  static final subtitle = _base(16, FontWeight.w500, 22);

  /// 14 / Medium – list labels, prayer rows, buttons.
  static final label = _base(14, FontWeight.w500, 20);

  /// 14 / Regular – body copy.
  static final body = _base(14, FontWeight.w400, 20);

  /// 12 / Regular – meta lines (walk time, dates).
  static final caption = _base(12, FontWeight.w400, 18);

  /// 10 / Regular – "Last updated …".
  static final micro = _base(10, FontWeight.w400, 16);
}

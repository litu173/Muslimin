import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography. Poppins is used for Latin text and Hind Siliguri for Bangla –
/// every style lists both so mixed-language strings (masjid names in English
/// inside Bangla UI) always render correctly. The display face (prayer name
/// and logo) is Grenze Gotisch (SIL OFL) / Galada – free, open-licence
/// stand-ins for "Hidayatullah DEMO", whose demo licence is personal-use only.
/// Scale: Figma sizes +~20%, rounded (base body text 16).
abstract final class AppText {
  static const latin = 'Poppins';
  static const bangla = 'HindSiliguri';

  /// Bangla digits (০-৯ and ':') only, cut from Anek Bangla (SIL OFL) by
  /// tool/build_bangla_digits.py. It is listed first for Bangla UI so every
  /// time and number uses it, while letters fall through to Hind Siliguri.
  /// The design asks for Li Ador Noirrit, but Lipighor's free licence forbids
  /// redistributing the font file inside an app; swap it in here (and in
  /// pubspec.yaml) once a licence/permission from Lipighor is in place.
  static const banglaDigits = 'BanglaDigits';
  static const displayLatin = 'GrenzeGotisch';

  /// Grenze Gotisch is a variable font; 800 matches the weight of the Figma face.
  static const displayVariations = [FontVariation('wght', 800)];
  static const displayBangla = 'Galada';

  /// Quran & dua text. Scheherazade New (SIL) supports every mark of the
  /// Uthmani (Madani Mushaf) script, so harakat render exactly as written.
  static const arabic = 'ScheherazadeNew';

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

  /// 24 / Bold – screen titles ("Create Masjid Profile", onboarding titles).
  static TextStyle get headline => _base(24, FontWeight.w700, 31);

  /// 22 / Bold – masjid name in the dark header.
  static TextStyle get title => _base(22, FontWeight.w700, 28);

  /// 19 / Medium – card titles, section headers.
  static TextStyle get subtitle => _base(19, FontWeight.w500, 26);

  /// 16 / Medium – list labels, prayer rows, buttons.
  static TextStyle get label => _base(16, FontWeight.w500, 23);

  /// 16 / Regular – body copy.
  static TextStyle get body => _base(16, FontWeight.w400, 23);

  /// 14 / Regular – meta lines (walk time, dates).
  static TextStyle get caption => _base(14, FontWeight.w400, 20);

  /// 12 / Regular – "Last updated …".
  static TextStyle get micro => _base(12, FontWeight.w400, 18);
}

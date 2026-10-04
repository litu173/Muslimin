import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Thin typed wrapper over SharedPreferences.
class Prefs {
  Prefs(this._p);

  final SharedPreferences _p;

  static Future<Prefs> load() async =>
      Prefs(await SharedPreferences.getInstance());

  bool get onboardingDone => _p.getBool('onboardingDone') ?? false;
  set onboardingDone(bool v) => _p.setBool('onboardingDone', v);

  String? get localeCode => _p.getString('locale');
  set localeCode(String? v) =>
      v == null ? _p.remove('locale') : _p.setString('locale', v);

  /// 'system' | 'light' | 'dark'.
  String get themeMode => _p.getString('themeMode') ?? 'system';
  set themeMode(String v) => _p.setString('themeMode', v);

  bool get authorityBannerHidden =>
      _p.getBool('authorityBannerHidden') ?? false;
  set authorityBannerHidden(bool v) => _p.setBool('authorityBannerHidden', v);

  /// 'hanafi' | 'shafi'
  String get madhab => _p.getString('madhab') ?? 'hanafi';
  set madhab(String v) => _p.setString('madhab', v);

  /// adhan CalculationMethod name, default Karachi (used in Bangladesh).
  String get calcMethod => _p.getString('calcMethod') ?? 'karachi';
  set calcMethod(String v) => _p.setString('calcMethod', v);

  int get hijriOffset =>
      _p.getInt('hijriOffset') ?? -1; // Bangladesh usually sights a day later.
  set hijriOffset(int v) => _p.setInt('hijriOffset', v);

  int get defaultReminder => _p.getInt('defaultReminder') ?? 15;
  set defaultReminder(int v) => _p.setInt('defaultReminder', v);

  /// Followed masjids: id -> {name, reminder (minutes, 0 = off)}.
  Map<String, Map<String, dynamic>> get follows {
    final raw = _p.getString('follows');
    if (raw == null) return {};
    return (jsonDecode(raw) as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)),
    );
  }

  set follows(Map<String, Map<String, dynamic>> v) =>
      _p.setString('follows', jsonEncode(v));

  /// Quran reading journey (Read tab): finished surahs, last position and
  /// best quiz score per phase – stored on the phone.
  Map<String, dynamic> get quranProgress {
    final raw = _p.getString('quranProgress');
    return raw == null ? {} : jsonDecode(raw) as Map<String, dynamic>;
  }

  set quranProgress(Map<String, dynamic> v) =>
      _p.setString('quranProgress', jsonEncode(v));

  /// Cached last location so the home screen renders instantly.
  ({double lat, double lng, String label})? get lastLocation {
    final raw = _p.getString('lastLocation');
    if (raw == null) return null;
    final m = jsonDecode(raw) as Map<String, dynamic>;
    return (
      lat: (m['lat'] as num).toDouble(),
      lng: (m['lng'] as num).toDouble(),
      label: m['label'] as String,
    );
  }

  set lastLocation(({double lat, double lng, String label})? v) => v == null
      ? _p.remove('lastLocation')
      : _p.setString(
          'lastLocation',
          jsonEncode({'lat': v.lat, 'lng': v.lng, 'label': v.label}),
        );
}

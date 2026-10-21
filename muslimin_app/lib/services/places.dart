/// Bangla names of places (districts, thanas, cities, areas, countries),
/// kept by the admins in config/places. Masjid profiles store English
/// names; [of] shows the Bangla one when the app is in Bangla.
abstract final class Places {
  /// English name -> Bangla name.
  static Map<String, String> bn = const {};

  /// The app is in Bangla (set by the Shell).
  static bool bangla = false;

  static String of(String name) {
    if (!bangla || name.isEmpty) return name;
    return bn[name.trim()] ?? name;
  }
}

/// Parts of the app the admin can switch off (admin website → App
/// settings → Features). Everything is on unless switched off.
abstract final class Feature {
  // bottom tabs
  static const tabQuran = 'tabQuran';
  static const tabDua = 'tabDua';
  static const tabNotice = 'tabNotice';
  // Home
  static const homeDailyQuran = 'homeDailyQuran';
  static const homeDailyDhikr = 'homeDailyDhikr';
  static const homeDua = 'homeDua';
  static const homeVerses = 'homeVerses';
  static const homeRegisterBanner = 'homeRegisterBanner';
  static const refreshAyah = 'refreshAyah';
  // masjid page
  static const masjidNotice = 'masjidNotice';
  static const masjidChannel = 'masjidChannel';
  static const masjidAbout = 'masjidAbout';
  static const channelMembers = 'channelMembers';
  static const directions = 'directions';
  static const reportProblem = 'reportProblem';
  static const volunteering = 'volunteering';
  static const timeBoardScan = 'timeBoardScan';
  // More
  static const achievements = 'achievements';
  static const masjidRegistration = 'masjidRegistration';
  static const suggestMasjid = 'suggestMasjid';
}

/// App-wide switches set in the admin website (config/app): a minimum
/// version that must be installed, a banner shown on Home, and features
/// switched off.
class AppConfig {
  const AppConfig({
    this.minVersion = '',
    this.bannerOn = false,
    this.bannerEn = '',
    this.bannerBn = '',
    this.off = const {},
  });

  /// Features switched off ([Feature] keys).
  final Set<String> off;

  bool on(String feature) => !off.contains(feature);

  /// Older installs are asked to update before they continue ('' = none).
  final String minVersion;
  final bool bannerOn;
  final String bannerEn;
  final String bannerBn;

  factory AppConfig.fromMap(Map<String, dynamic>? m) {
    final b = (m?['maintenance'] as Map?)?.cast<String, dynamic>();
    return AppConfig(
      minVersion: (m?['minVersion'] as String?)?.trim() ?? '',
      bannerOn: (b?['on'] as bool?) ?? false,
      bannerEn: (b?['messageEn'] as String?) ?? '',
      bannerBn: (b?['messageBn'] as String?) ?? '',
      off: {
        for (final e in ((m?['features'] as Map?) ?? const {}).entries)
          if (e.value == false) '${e.key}',
      },
    );
  }

  /// The banner in the app's language (English when no Bangla text).
  String banner(bool bangla) =>
      bangla && bannerBn.trim().isNotEmpty ? bannerBn : bannerEn;
}

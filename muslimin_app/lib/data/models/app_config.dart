/// App-wide switches set in the admin website (config/app): a minimum
/// version that must be installed, and a banner shown on Home.
class AppConfig {
  const AppConfig({
    this.minVersion = '',
    this.bannerOn = false,
    this.bannerEn = '',
    this.bannerBn = '',
  });

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
    );
  }

  /// The banner in the app's language (English when no Bangla text).
  String banner(bool bangla) =>
      bangla && bannerBn.trim().isNotEmpty ? bannerBn : bannerEn;
}

import 'dart:convert';

import 'package:http/http.dart' as http;

/// Latest published build on GitHub Releases (same files the website serves).
class UpdateInfo {
  const UpdateInfo({
    required this.tag,
    required this.version,
    required this.apkUrl,
    required this.pageUrl,
  });

  /// e.g. `v1.2.0-beta`
  final String tag;

  /// e.g. `1.2.0`
  final String version;
  final String apkUrl;
  final String pageUrl;

  bool isNewerThan(String installed) => compareVersions(version, installed) > 0;
}

/// Compares dotted numeric versions ("1.10.0" > "1.9.3"). Suffixes like
/// "-beta" are ignored.
int compareVersions(String a, String b) {
  List<int> parse(String v) => v
      .split(RegExp(r'[-+]'))
      .first
      .split('.')
      .map((p) => int.tryParse(p) ?? 0)
      .toList();
  final x = parse(a), y = parse(b);
  for (var i = 0; i < 3; i++) {
    final d = (i < x.length ? x[i] : 0) - (i < y.length ? y[i] : 0);
    if (d != 0) return d.sign;
  }
  return 0;
}

class UpdateService {
  static const repo = 'litu173/Muslimin';
  static const latestApkUrl =
      'https://github.com/$repo/releases/latest/download/Muslimin.apk';
  static const installGuideUrl = 'https://litu173.github.io/Muslimin/#install';

  Future<UpdateInfo> latest() async {
    final res = await http
        .get(
          Uri.parse('https://api.github.com/repos/$repo/releases/latest'),
          headers: {'Accept': 'application/vnd.github+json'},
        )
        .timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) throw Exception('GitHub ${res.statusCode}');
    final j = jsonDecode(res.body) as Map<String, dynamic>;
    final tag = j['tag_name'] as String;
    final assets = (j['assets'] as List).cast<Map<String, dynamic>>();
    final apk = assets
        .where((a) => (a['name'] as String).endsWith('.apk'))
        .firstOrNull;
    return UpdateInfo(
      tag: tag,
      version: tag.replaceFirst(RegExp(r'^v'), ''),
      apkUrl: (apk?['browser_download_url'] as String?) ?? latestApkUrl,
      pageUrl: j['html_url'] as String,
    );
  }
}

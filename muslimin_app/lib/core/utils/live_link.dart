import 'package:url_launcher/url_launcher.dart';

/// Opens a masjid live stream in the YouTube / Facebook app when installed
/// (so the live plays there), falling back to the browser.
///
/// Order: 1) universal/app link that only a native app may handle,
/// 2) the app's own URL scheme, 3) the browser.
Future<void> openLiveStream(String raw) async {
  var url = raw.trim();
  if (!url.startsWith('http')) url = 'https://$url';
  final uri = Uri.parse(url);
  final host = uri.host.toLowerCase();

  // 1. Let YouTube/Facebook claim the https link (Android intent filters,
  //    iOS universal links). Returns false if no non-browser app handles it.
  try {
    if (await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) {
      return;
    }
  } catch (_) {}

  // 2. App-specific schemes.
  final Uri? scheme = switch (host) {
    _ when host.contains('youtube.com') || host.contains('youtu.be') =>
      Uri.parse(
        'youtube://${uri.host}${uri.path}${uri.hasQuery ? '?${uri.query}' : ''}',
      ),
    _
        when host.contains('facebook.com') ||
            host.contains('fb.watch') ||
            host.contains('fb.com') =>
      Uri.parse('fb://facewebmodal/f?href=${Uri.encodeComponent(url)}'),
    _ => null,
  };
  if (scheme != null) {
    try {
      if (await launchUrl(scheme, mode: LaunchMode.externalApplication)) return;
    } catch (_) {}
  }

  // 3. Browser.
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

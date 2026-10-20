import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/models/announcement.dart';
import '../services/update_service.dart';
import 'providers.dart';

/// App news for everyone (update announcements) – also on the
/// Notifications page.
final announcementsProvider = StreamProvider<List<Announcement>>(
  (ref) => ref.watch(backendProvider).announcements(),
);

/// The latest release on GitHub, when it is newer than the installed app
/// (null: up to date, offline, or not known yet). Checked once per run.
final newerReleaseProvider = FutureProvider<UpdateInfo?>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    final latest = await UpdateService().latest();
    return latest.isNewerThan(info.version) ? latest : null;
  } catch (_) {
    return null;
  }
});

/// A newer version is out: a dot on the More tab and on About the App.
final updateAvailableProvider = Provider<bool>(
  (ref) => ref.watch(newerReleaseProvider).value != null,
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/models/announcement.dart';
import '../data/models/app_config.dart';
import '../data/models/inbox_message.dart';
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

/// Messages the admin sent to me (users/{uid}/inbox).
final myInboxProvider = StreamProvider<List<InboxMessage>>((ref) {
  ref.watch(authProvider.select((u) => u.value?.uid));
  return ref.watch(backendProvider).myInbox();
});

/// Switches from the admin website (config/app).
/// Bangla names of places (admin website → Locations), read once.
final placeNamesProvider = FutureProvider<Map<String, String>>(
  (ref) => ref.watch(backendProvider).placeNamesBn(),
);

final appConfigProvider = StreamProvider<AppConfig>(
  (ref) => ref.watch(backendProvider).appConfig(),
);

/// Whether a part of the app is on ([Feature] keys; on until the admin
/// switches it off).
final featureProvider = Provider.family<bool, String>(
  (ref, key) => ref.watch(appConfigProvider).value?.on(key) ?? true,
);

/// The installed version ("1.18.5").
final installedVersionProvider = FutureProvider<String>(
  (ref) async => (await PackageInfo.fromPlatform()).version,
);

/// The admin set a minimum version and this install is older.
final updateRequiredProvider = Provider<bool>((ref) {
  final min = ref.watch(appConfigProvider).value?.minVersion ?? '';
  final mine = ref.watch(installedVersionProvider).value;
  return min.isNotEmpty && mine != null && compareVersions(mine, min) < 0;
});

/// A newer version is out: a dot on the More tab and on About the App.
final updateAvailableProvider = Provider<bool>(
  (ref) => ref.watch(newerReleaseProvider).value != null,
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/format.dart';
import '../data/models/masjid.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
import 'providers.dart';

class FollowInfo {
  const FollowInfo({required this.name, this.reminder = 0});

  final String name;

  /// Minutes before jamat; 0 = reminder off.
  final int reminder;

  Map<String, dynamic> toMap() => {'name': name, 'reminder': reminder};
}

/// Followed masjids live on the device (guests can follow too). When signed
/// in they are also saved to users/{uid}.follows so they sync across devices,
/// and every follow is mirrored to an FCM topic for notice push notifications.
class FollowsNotifier extends Notifier<Map<String, FollowInfo>> {
  @override
  Map<String, FollowInfo> build() {
    // When someone signs in, merge the follows saved in their account with
    // the ones on this device, and push the result back.
    ref.listen(authProvider, (prev, next) {
      final before = prev?.value?.uid;
      final now = next.value?.uid;
      if (now != null && now != before) _pullAndMerge();
    });
    return _decode(ref.read(prefsProvider).follows);
  }

  static Map<String, FollowInfo> _decode(
    Map<String, Map<String, dynamic>> raw,
  ) => raw.map(
    (k, v) => MapEntry(
      k,
      FollowInfo(
        name: v['name'] as String? ?? '',
        reminder: (v['reminder'] as num?)?.toInt() ?? 0,
      ),
    ),
  );

  Map<String, Map<String, dynamic>> get _encoded =>
      state.map((k, v) => MapEntry(k, v.toMap()));

  Future<void> _pullAndMerge() async {
    try {
      final remote = _decode(await ref.read(backendProvider).loadFollows());
      final merged = {...remote, ...state};
      for (final id in merged.keys.where((id) => !state.containsKey(id))) {
        await ref.read(pushProvider).follow(id);
      }
      state = merged;
      _save();
    } catch (_) {
      // Offline – local follows keep working; we sync next time.
    }
  }

  void _save() {
    ref.read(prefsProvider).follows = _encoded;
    if (ref.read(backendProvider).currentUser != null) {
      ref.read(backendProvider).saveFollows(_encoded).ignore();
    }
  }

  bool isFollowing(String id) => state.containsKey(id);

  Future<void> follow(Masjid m, {int reminder = 0}) async {
    state = {...state, m.id: FollowInfo(name: m.name, reminder: reminder)};
    _save();
    await ref.read(pushProvider).follow(m.id);
  }

  Future<void> unfollow(String id) async {
    state = {...state}..remove(id);
    _save();
    await ref.read(pushProvider).unfollow(id);
  }

  Future<void> setReminder(Masjid m, int minutes) async {
    if (!state.containsKey(m.id)) {
      await follow(m, reminder: minutes);
    } else {
      state = {...state, m.id: FollowInfo(name: m.name, reminder: minutes)};
      _save();
    }
    if (minutes > 0) await NotificationService.instance.requestExactAlarms();
  }
}

final followsProvider =
    NotifierProvider<FollowsNotifier, Map<String, FollowInfo>>(
      FollowsNotifier.new,
    );

/// Keeps the scheduled local reminders in sync with followed masjids, their
/// latest jamat times and the UI language. Watched once from the app root.
final reminderSyncProvider = Provider<void>((ref) {
  final follows = ref.watch(followsProvider);
  final locale = ref.watch(settingsProvider).locale;
  final withReminder = follows.entries
      .where((e) => e.value.reminder > 0)
      .toList();

  final map = <Masjid, int>{};
  for (final e in withReminder) {
    final m = ref.watch(masjidProvider(e.key)).value;
    if (m != null) map[m] = e.value.reminder;
  }
  if (map.length < withReminder.length && withReminder.isNotEmpty) {
    return; // still loading
  }

  final t = lookupL10n(locale);
  final f = Fmt(locale, t);
  final signature = [
    locale.languageCode,
    for (final e in map.entries)
      '${e.key.id}:${e.value}:${Masjid.jamatToMap(e.key.jamat)}',
  ].join('|');
  if (signature == _lastSignature) return;
  _lastSignature = signature;

  NotificationService.instance.rescheduleAll(
    map,
    ReminderTexts(
      prayerName: f.prayer,
      body: (prayer, minutes, _) =>
          t.jamatReminderBody(prayer, f.digits(minutes)),
    ),
  );
});

String? _lastSignature;

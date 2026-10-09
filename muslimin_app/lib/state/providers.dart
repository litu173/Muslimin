import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/languages.dart';
import '../data/backend/backend.dart';
import '../data/models/app_user.dart';
import '../data/models/masjid.dart';
import '../data/models/notice.dart';
import '../services/location_service.dart';
import '../services/prayer_time_service.dart';
import '../services/prefs.dart';
import '../services/push_service.dart';

// ---------------------------------------------------------------- singletons
/// Overridden in main() with the real instances.
final backendProvider = Provider<Backend>((_) => throw UnimplementedError());
final prefsProvider = Provider<Prefs>((_) => throw UnimplementedError());
final pushProvider = Provider<PushService>(
  (ref) => PushService(ref.watch(backendProvider)),
);
final locationServiceProvider = Provider((_) => LocationService());

// ------------------------------------------------------------------ settings
class AppSettings {
  const AppSettings({
    required this.locale,
    required this.madhab,
    required this.calcMethod,
    required this.hijriOffset,
    required this.defaultReminder,
    this.themeMode = ThemeMode.system,
  });

  final Locale locale;
  final String madhab;
  final String calcMethod;
  final int hijriOffset;
  final int defaultReminder;
  final ThemeMode themeMode;

  AppSettings copyWith({
    Locale? locale,
    String? madhab,
    String? calcMethod,
    int? hijriOffset,
    int? defaultReminder,
    ThemeMode? themeMode,
  }) => AppSettings(
    locale: locale ?? this.locale,
    madhab: madhab ?? this.madhab,
    calcMethod: calcMethod ?? this.calcMethod,
    hijriOffset: hijriOffset ?? this.hijriOffset,
    defaultReminder: defaultReminder ?? this.defaultReminder,
    themeMode: themeMode ?? this.themeMode,
  );
}

class SettingsNotifier extends Notifier<AppSettings> {
  Prefs get _p => ref.read(prefsProvider);

  @override
  AppSettings build() {
    final p = ref.watch(prefsProvider);
    final device =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return AppSettings(
      // First run: the phone's language if the app has it, else English.
      locale: Locale(
        p.localeCode ??
            (kAppLanguages.any((l) => l.code == device) ? device : 'en'),
      ),
      madhab: p.madhab,
      calcMethod: p.calcMethod,
      hijriOffset: p.hijriOffset,
      defaultReminder: p.defaultReminder,
      themeMode: ThemeMode.values.asNameMap()[p.themeMode] ?? ThemeMode.system,
    );
  }

  void setLocale(Locale l) {
    _p.localeCode = l.languageCode;
    state = state.copyWith(locale: l);
  }

  void setMadhab(String m) {
    _p.madhab = m;
    state = state.copyWith(madhab: m);
  }

  void setCalcMethod(String m) {
    _p.calcMethod = m;
    state = state.copyWith(calcMethod: m);
  }

  void setHijriOffset(int v) {
    _p.hijriOffset = v;
    state = state.copyWith(hijriOffset: v);
  }

  void setThemeMode(ThemeMode m) {
    _p.themeMode = m.name;
    state = state.copyWith(themeMode: m);
  }

  void setDefaultReminder(int v) {
    _p.defaultReminder = v;
    state = state.copyWith(defaultReminder: v);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

// ------------------------------------------------------------------ location
class LocationNotifier extends AsyncNotifier<UserLocation> {
  DateTime? _fetchedAt;

  @override
  Future<UserLocation> build() async {
    // Back in the app after a while: the user may have walked somewhere
    // else, so measure again.
    final lifecycle = AppLifecycleListener(
      onResume: () {
        final at = _fetchedAt;
        if (at == null ||
            DateTime.now().difference(at) > const Duration(minutes: 2)) {
          refresh();
        }
      },
    );
    ref.onDispose(lifecycle.dispose);
    final cached = ref.read(prefsProvider).lastLocation;
    if (cached != null) {
      // Show cached location instantly, refresh in the background.
      Future.microtask(refresh);
      return UserLocation(
        lat: cached.lat,
        lng: cached.lng,
        label: cached.label,
      );
    }
    return _fetch();
  }

  Future<UserLocation> _fetch() async {
    final loc = await ref.read(locationServiceProvider).current();
    _fetchedAt = DateTime.now();
    ref.read(prefsProvider).lastLocation = (
      lat: loc.lat,
      lng: loc.lng,
      label: loc.label,
    );
    return loc;
  }

  Future<void> refresh() async {
    try {
      final loc = await _fetch();
      final prev = state.value;
      // Ignore tiny GPS jitter so streams are not re-subscribed needlessly.
      if (prev == null ||
          (prev.lat - loc.lat).abs() > 0.0005 ||
          (prev.lng - loc.lng).abs() > 0.0005 ||
          prev.label != loc.label ||
          prev.approximate != loc.approximate) {
        state = AsyncData(loc);
      }
    } catch (e, st) {
      if (!state.hasValue) state = AsyncError(e, st);
    }
  }
}

final locationProvider = AsyncNotifierProvider<LocationNotifier, UserLocation>(
  LocationNotifier.new,
);

// --------------------------------------------------------------------- clock
/// Ticks every second – drives the countdown and "Now" markers. Stops while
/// the app is in the background, so it never wakes the phone for nothing.
final clockProvider = StreamProvider<DateTime>((ref) {
  final out = StreamController<DateTime>();
  Timer? timer;
  void start() {
    timer?.cancel();
    out.add(DateTime.now());
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => out.add(DateTime.now()),
    );
  }

  final lifecycle = AppLifecycleListener(
    onResume: start,
    onHide: () => timer?.cancel(),
  );
  start();
  ref.onDispose(() {
    timer?.cancel();
    lifecycle.dispose();
    out.close();
  });
  return out.stream;
});

/// Ticks every minute – for things that don't need per-second updates.
final minuteProvider = Provider<DateTime>((ref) {
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  return DateTime(now.year, now.month, now.day, now.hour, now.minute);
});

// --------------------------------------------------------------- prayer times
final prayerServiceProvider = Provider((ref) {
  final s = ref.watch(settingsProvider);
  return PrayerTimeService(method: s.calcMethod, madhab: s.madhab);
});

final todayTimesProvider = Provider<DayTimes?>((ref) {
  final loc = ref.watch(locationProvider).value;
  if (loc == null) return null;
  final now = ref.watch(minuteProvider);
  return ref.watch(prayerServiceProvider).day(loc.lat, loc.lng, now);
});

final waqtProvider = Provider<WaqtStatus?>((ref) {
  final loc = ref.watch(locationProvider).value;
  if (loc == null) return null;
  final now = ref.watch(minuteProvider);
  return ref.watch(prayerServiceProvider).status(loc.lat, loc.lng, now);
});

// ---------------------------------------------------------------------- auth
final authProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(backendProvider).authState(),
);

final myMasjidsProvider = StreamProvider<List<Masjid>>((ref) {
  final user = ref.watch(authProvider).value;
  if (user == null) return Stream.value(const []);
  return ref.watch(backendProvider).myMasjids(user.uid);
});

// ------------------------------------------------------------------- masjids
const kNearbyRadiusKm = 5.0;

final nearbyMasjidsProvider = StreamProvider<List<Masjid>>((ref) {
  final loc = ref.watch(locationProvider).value;
  if (loc == null) return const Stream.empty();
  return ref
      .watch(backendProvider)
      .nearbyMasjids(loc.lat, loc.lng, kNearbyRadiusKm);
});

/// "View All": every verified masjid, nearest first.
final allMasjidsProvider = StreamProvider<List<Masjid>>((ref) {
  final loc = ref.watch(locationProvider).value;
  if (loc == null) return const Stream.empty();
  return ref.watch(backendProvider).allMasjids(loc.lat, loc.lng);
});

/// Masjids anywhere whose name starts with the text ("View All" search).
final searchMasjidsProvider = FutureProvider.family<List<Masjid>, String>(
  (ref, q) => ref.watch(backendProvider).searchMasjids(q),
);

final masjidProvider = StreamProvider.family<Masjid?, String>(
  (ref, id) => ref.watch(backendProvider).watchMasjid(id),
);

final masjidsByStatusProvider =
    StreamProvider.family<List<Masjid>, MasjidStatus>(
      (ref, s) => ref.watch(backendProvider).masjidsByStatus(s),
    );

// ------------------------------------------------------------------- notices
/// Key is a comma-joined, sorted id list so the family caches correctly.
final noticesProvider = StreamProvider.family<List<Notice>, String>((ref, key) {
  final ids = key.isEmpty ? <String>[] : key.split(',');
  return ref.watch(backendProvider).noticesFor(ids);
});

String noticeKey(Iterable<String> ids) => (ids.toList()..sort()).join(',');

/// Notices from masjids near the user (feeds the home screen).
final nearbyNoticesProvider = Provider<AsyncValue<List<Notice>>>((ref) {
  final masjids = ref.watch(nearbyMasjidsProvider);
  return masjids.when(
    data: (list) =>
        ref.watch(noticesProvider(noticeKey(list.take(30).map((m) => m.id)))),
    loading: () => const AsyncLoading(),
    error: AsyncError.new,
  );
});

/// Pull-to-refresh on any page: re-reads the location and re-subscribes the
/// masjid / notice streams (they keep showing old data while reloading).
Future<void> refreshAll(WidgetRef ref) async {
  ref.invalidate(nearbyMasjidsProvider);
  ref.invalidate(myMasjidsProvider);
  ref.invalidate(masjidProvider);
  ref.invalidate(noticesProvider);
  ref.invalidate(masjidsByStatusProvider);
  await Future.wait([
    ref.read(locationProvider.notifier).refresh(),
    // Keep the spinner up long enough to read as "refreshed".
    Future<void>.delayed(const Duration(milliseconds: 700)),
  ]);
}

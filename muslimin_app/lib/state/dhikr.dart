import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dhikr/dhikrs.dart';
import 'providers.dart';
import 'quran.dart' show Achievement, dayKey;

/// All five portions of a dhikr done (one bit per salah, Fajr = bit 0).
const kAllPortions = (1 << kPortions) - 1;

/// The dhikr day: Isha's dhikr said after midnight still counts for the
/// day before, so the day turns over at 3 AM instead of midnight.
String dhikrDay(DateTime now) => dayKey(now.subtract(const Duration(hours: 3)));

class DhikrProgress {
  const DhikrProgress({this.days = const {}, this.achievedAt = const {}});

  /// Day -> dhikr id -> portions done (bit i = after the i-th salah).
  final Map<String, Map<String, int>> days;

  /// Achievement id -> when it was earned (ISO date).
  final Map<String, String> achievedAt;

  int mask(String day, String id) => days[day]?[id] ?? 0;

  int maskToday(String id) => mask(dhikrDay(DateTime.now()), id);

  /// Portions done on [day], over every dhikr.
  int portionsOn(String day) =>
      kDhikrs.fold(0, (a, d) => a + bits(mask(day, d.id)));

  int get portionsToday => portionsOn(dhikrDay(DateTime.now()));

  /// Portions a whole day has (five per dhikr).
  static int get portionsPerDay => kDhikrs.length * kPortions;

  /// Every dhikr finished on [day].
  bool fullDay(String day) =>
      kDhikrs.every((d) => mask(day, d.id) == kAllPortions);

  bool get doneToday => fullDay(dhikrDay(DateTime.now()));

  /// The i-th salah's portion done for every dhikr on [day].
  bool salahDone(String day, int i) =>
      kDhikrs.every((d) => mask(day, d.id) & (1 << i) != 0);

  /// Times said today, over every dhikr.
  int get countToday {
    final day = dhikrDay(DateTime.now());
    return kDhikrs.fold(0, (a, d) => a + bits(mask(day, d.id)) * d.perSalah);
  }

  /// Times said, ever.
  int get countEver => days.values.fold(
    0,
    (a, m) =>
        a + kDhikrs.fold(0, (b, d) => b + bits(m[d.id] ?? 0) * d.perSalah),
  );

  int get portionsEver => days.keys.fold(0, (a, k) => a + portionsOn(k));

  /// Days with one salah's portion done for every dhikr.
  bool get anySalahComplete => days.keys.any(
    (k) => [for (var i = 0; i < kPortions; i++) i].any((i) => salahDone(k, i)),
  );

  int get fullDays => days.keys.where(fullDay).length;

  /// Full days in a row, ending today (or yesterday, so the streak lasts
  /// until today is over).
  int get streak {
    var d = DateTime.now().subtract(const Duration(hours: 3));
    if (!fullDay(dayKey(d))) d = d.subtract(const Duration(days: 1));
    var n = 0;
    while (fullDay(dayKey(d))) {
      n++;
      d = d.subtract(const Duration(days: 1));
    }
    return n;
  }

  /// Longest run of full days ever.
  int get bestStreak {
    final list = days.keys.where(fullDay).map(DateTime.parse).toList()..sort();
    var best = 0, run = 0;
    DateTime? prev;
    for (final d in list) {
      run = prev != null && d.difference(prev).inDays == 1 ? run + 1 : 1;
      if (run > best) best = run;
      prev = d;
    }
    return best;
  }

  static int bits(int m) {
    var n = 0;
    for (var x = m; x > 0; x >>= 1) {
      n += x & 1;
    }
    return n;
  }

  Map<String, dynamic> toJson() => {'days': days, 'achievedAt': achievedAt};

  factory DhikrProgress.fromJson(Map<String, dynamic> j) => DhikrProgress(
    days: ((j['days'] as Map?) ?? {}).map(
      (k, v) => MapEntry(
        '$k',
        (v as Map).map((id, m) => MapEntry('$id', (m as num).toInt())),
      ),
    ),
    achievedAt: ((j['achievedAt'] as Map?) ?? {}).map(
      (k, v) => MapEntry('$k', '$v'),
    ),
  );
}

class DhikrNotifier extends Notifier<DhikrProgress> {
  @override
  DhikrProgress build() =>
      DhikrProgress.fromJson(ref.watch(prefsProvider).dhikrProgress);

  void _set(String day, Map<String, int> today) {
    var p = DhikrProgress(
      days: {...state.days, day: today},
      achievedAt: state.achievedAt,
    );
    // Stamp any achievement that has just been earned.
    final now = DateTime.now().toIso8601String();
    final earned = {...p.achievedAt};
    for (final a in kDhikrAchievements) {
      if (!earned.containsKey(a.id) && a.progress(p) >= a.target) {
        earned[a.id] = now;
      }
    }
    p = DhikrProgress(days: p.days, achievedAt: earned);
    state = p;
    ref.read(prefsProvider).dhikrProgress = p.toJson();
  }

  Map<String, int> _today(String day) => {...?state.days[day]};

  /// Marks (or unmarks) the portion after the [salah]-th salah (0 = Fajr).
  void toggle(String id, int salah) {
    final day = dhikrDay(DateTime.now());
    final today = _today(day);
    today[id] = (today[id] ?? 0) ^ (1 << salah);
    _set(day, today);
  }

  /// All five portions of one dhikr at once (said in one sitting) – or
  /// none, to undo.
  void setAll(String id, bool done) {
    final day = dhikrDay(DateTime.now());
    _set(day, _today(day)..[id] = done ? kAllPortions : 0);
  }

  /// Every dhikr's portion after the [salah]-th salah, together.
  void setSalah(int salah, bool done) {
    final day = dhikrDay(DateTime.now());
    final today = _today(day);
    for (final d in kDhikrs) {
      final m = today[d.id] ?? 0;
      today[d.id] = done ? m | (1 << salah) : m & ~(1 << salah);
    }
    _set(day, today);
  }
}

final dhikrProgressProvider = NotifierProvider<DhikrNotifier, DhikrProgress>(
  DhikrNotifier.new,
);

/// Dhikr badges, shown with the Quran ones on the Achievements page.
final kDhikrAchievements = <Achievement<DhikrProgress>>[
  Achievement('dhikr_first', 'spa', 1, (p) => p.portionsEver),
  Achievement(
    'dhikr_salah',
    'self_improvement',
    1,
    (p) => p.anySalahComplete ? 1 : 0,
  ),
  Achievement('dhikr_day', 'verified', 1, (p) => p.fullDays),
  Achievement('dhikr_streak7', 'local_florist', 7, (p) => p.bestStreak),
  Achievement('dhikr_streak30', 'diamond', 30, (p) => p.bestStreak),
  Achievement('dhikr_10k', 'all_inclusive', 10000, (p) => p.countEver),
];

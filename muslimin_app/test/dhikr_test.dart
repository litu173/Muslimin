import 'package:flutter_test/flutter_test.dart';
import 'package:muslimin/data/dhikr/dhikrs.dart';
import 'package:muslimin/state/dhikr.dart';
import 'package:muslimin/state/quran.dart' show dayKey;

void main() {
  test('every target splits evenly into five portions', () {
    for (final d in kDhikrs) {
      expect(d.perDay % kPortions, 0, reason: d.id);
    }
  });

  test('dhikr ids are unique; after-salah adhkar come first', () {
    expect(kDhikrs.map((d) => d.id).toSet().length, kDhikrs.length);
    final firstDaily = kDhikrs.indexWhere((d) => !d.afterSalah);
    expect(kDhikrs.skip(firstDaily).every((d) => !d.afterSalah), isTrue);
    expect(kDhikrs.where((d) => d.afterSalah).length, 11);
  });

  test('the dhikr day turns over at 3 AM', () {
    expect(dhikrDay(DateTime(2026, 10, 20, 2, 30)), '2026-10-19');
    expect(dhikrDay(DateTime(2026, 10, 20, 3, 0)), '2026-10-20');
  });

  test('portions, salah marks, full days and streaks', () {
    String day(int ago) => dayKey(
      DateTime.now()
          .subtract(const Duration(hours: 3))
          .subtract(Duration(days: ago)),
    );
    final full = {for (final d in kDhikrs) d.id: kAllPortions};
    // Today: Fajr done for every dhikr, Dhuhr for one.
    final today = {for (final d in kDhikrs) d.id: 1};
    today[kDhikrs.first.id] = 3;
    final p = DhikrProgress(
      days: {day(0): today, day(1): full, day(2): full, day(4): full},
    );

    expect(p.portionsToday, kDhikrs.length + 1);
    expect(p.salahDone(day(0), 0), isTrue);
    expect(p.salahDone(day(0), 1), isFalse);
    expect(p.doneToday, isFalse);
    expect(p.fullDays, 3);
    // Yesterday and the day before; today is not over yet.
    expect(p.streak, 2);
    expect(p.bestStreak, 2);
    expect(p.anySalahComplete, isTrue);
    final perFullDay = kDhikrs.fold(0, (a, d) => a + d.perDay);
    expect(p.countEver, 3 * perFullDay + p.countToday);
  });

  test('achievements unlock from progress', () {
    const empty = DhikrProgress();
    for (final a in kDhikrAchievements) {
      expect(a.progress(empty), 0, reason: a.id);
    }
  });
}

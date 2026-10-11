import 'package:flutter_test/flutter_test.dart';
import 'package:muslimin/core/widgets/time_wheel.dart';
import 'package:muslimin/data/models/prayer.dart';

void main() {
  test('AM/PM follows the prayer', () {
    int h(Prayer p, int h12) => resolveHour(h12, prayerWindow(p));
    expect(h(Prayer.fajr, 5), 5);
    expect(h(Prayer.dhuhr, 1), 13);
    expect(h(Prayer.dhuhr, 12), 12);
    expect(h(Prayer.dhuhr, 11), 11);
    expect(h(Prayer.jumuah, 1), 13);
    expect(h(Prayer.asr, 4), 16);
    expect(h(Prayer.maghrib, 6), 18);
    expect(h(Prayer.maghrib, 5), 17);
    expect(h(Prayer.isha, 8), 20);
    expect(h(Prayer.isha, 7), 19);
  });

  test('maktab sessions', () {
    expect(resolveHour(6, morningWindow), 6);
    expect(resolveHour(11, morningWindow), 11);
    expect(resolveHour(5, eveningWindow), 17);
    expect(resolveHour(12, eveningWindow), 12);
  });
}

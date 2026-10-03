import 'package:adhan/adhan.dart' hide Prayer;

import '../data/models/prayer.dart';

/// One time window, e.g. Duhr 12:18 – 4:17.
class Window {
  const Window(this.start, this.end);

  final DateTime start;
  final DateTime end;

  bool contains(DateTime t) => !t.isBefore(start) && t.isBefore(end);
}

/// Calculated (astronomical) times for one day at one place.
class DayTimes {
  DayTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.nextFajr,
    required this.lastThird,
  });

  final DateTime date;
  final DateTime fajr, sunrise, dhuhr, asr, maghrib, isha, nextFajr, lastThird;

  static const _m = Duration(minutes: 1);

  DateTime startOf(Prayer p) => switch (p) {
    Prayer.fajr => fajr,
    Prayer.dhuhr || Prayer.jumuah => dhuhr,
    Prayer.asr => asr,
    Prayer.maghrib => maghrib,
    Prayer.isha => isha,
  };

  /// Waqt windows as shown on the "All Prayers" screen.
  Map<Prayer, Window> get windows => {
    Prayer.fajr: Window(fajr, sunrise.subtract(_m)),
    Prayer.dhuhr: Window(dhuhr, asr.subtract(_m)),
    Prayer.asr: Window(asr, maghrib.subtract(const Duration(minutes: 4))),
    Prayer.maghrib: Window(maghrib, isha.subtract(_m)),
    Prayer.isha: Window(isha, nextFajr.subtract(_m)),
  };

  /// Makruh (forbidden) windows: sunrise, zawal and sunset.
  Window get forbiddenMorning =>
      Window(sunrise, sunrise.add(const Duration(minutes: 15)));
  Window get forbiddenNoon =>
      Window(dhuhr.subtract(const Duration(minutes: 8)), dhuhr.subtract(_m));
  Window get forbiddenEvening => Window(
    maghrib.subtract(const Duration(minutes: 17)),
    maghrib.subtract(_m),
  );

  Window get tahajjud => Window(
    isha.add(const Duration(minutes: 2)),
    nextFajr.subtract(const Duration(minutes: 7)),
  );
  Window get duha => Window(
    sunrise.add(const Duration(minutes: 16)),
    dhuhr.subtract(const Duration(minutes: 9)),
  );
}

/// What the home header shows: the running waqt and its countdown, or – in a
/// gap such as after sunrise – the next prayer and the time until it starts.
class WaqtStatus {
  const WaqtStatus({
    required this.prayer,
    required this.window,
    required this.isCurrent,
  });

  final Prayer prayer;
  final Window window;
  final bool isCurrent;

  Duration remaining(DateTime now) =>
      (isCurrent ? window.end : window.start).difference(now);

  /// 0..1 for the countdown ring.
  double progress(DateTime now) {
    if (!isCurrent) return 0;
    final total = window.end.difference(window.start).inSeconds;
    if (total <= 0) return 1;
    return (now.difference(window.start).inSeconds / total)
        .clamp(0, 1)
        .toDouble();
  }
}

class PrayerTimeService {
  const PrayerTimeService({this.method = 'karachi', this.madhab = 'hanafi'});

  final String method;
  final String madhab;

  CalculationParameters get _params {
    final m = CalculationMethod.values.firstWhere(
      (e) => e.name == method,
      orElse: () => CalculationMethod.karachi,
    );
    final p = m.getParameters();
    p.madhab = madhab == 'shafi' ? Madhab.shafi : Madhab.hanafi;
    return p;
  }

  PrayerTimes _raw(double lat, double lng, DateTime day) =>
      PrayerTimes(Coordinates(lat, lng), DateComponents.from(day), _params);

  DayTimes day(double lat, double lng, DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final t = _raw(lat, lng, d);
    final next = _raw(lat, lng, d.add(const Duration(days: 1)));
    final sunnah = SunnahTimes(t);
    return DayTimes(
      date: d,
      fajr: t.fajr.toLocal(),
      sunrise: t.sunrise.toLocal(),
      dhuhr: t.dhuhr.toLocal(),
      asr: t.asr.toLocal(),
      maghrib: t.maghrib.toLocal(),
      isha: t.isha.toLocal(),
      nextFajr: next.fajr.toLocal(),
      lastThird: sunnah.lastThirdOfTheNight.toLocal(),
    );
  }

  WaqtStatus status(double lat, double lng, DateTime now) {
    final today = day(lat, lng, now);
    // Before today's Fajr we are still inside yesterday's Isha.
    if (now.isBefore(today.fajr)) {
      final y = day(lat, lng, now.subtract(const Duration(days: 1)));
      return WaqtStatus(
        prayer: Prayer.isha,
        window: y.windows[Prayer.isha]!,
        isCurrent: true,
      );
    }
    for (final e in today.windows.entries) {
      if (e.value.contains(now)) {
        final p = e.key == Prayer.dhuhr && now.weekday == DateTime.friday
            ? Prayer.jumuah
            : e.key;
        return WaqtStatus(prayer: p, window: e.value, isCurrent: true);
      }
    }
    // Gaps (after sunrise, or the few minutes before Maghrib): show the next prayer.
    for (final e in today.windows.entries) {
      if (e.value.start.isAfter(now)) {
        final p = e.key == Prayer.dhuhr && now.weekday == DateTime.friday
            ? Prayer.jumuah
            : e.key;
        return WaqtStatus(prayer: p, window: e.value, isCurrent: false);
      }
    }
    final tomorrow = day(lat, lng, now.add(const Duration(days: 1)));
    return WaqtStatus(
      prayer: Prayer.fajr,
      window: tomorrow.windows[Prayer.fajr]!,
      isCurrent: false,
    );
  }
}

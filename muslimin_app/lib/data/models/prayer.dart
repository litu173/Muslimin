/// The five daily prayers plus Jum'ah. Order matters (used for display).
enum Prayer { fajr, dhuhr, asr, maghrib, isha, jumuah }

extension PrayerX on Prayer {
  bool get isDaily => this != Prayer.jumuah;
  static const daily = [
    Prayer.fajr,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];
}

/// A wall-clock time (hour + minute) such as a jamat time. Stored as "HH:mm".
class HM implements Comparable<HM> {
  const HM(this.hour, this.minute);

  final int hour;
  final int minute;

  static HM? tryParse(Object? raw) {
    if (raw is! String || !raw.contains(':')) return null;
    final parts = raw.split(':');
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
      return null;
    }
    return HM(h, m);
  }

  factory HM.fromDateTime(DateTime d) => HM(d.hour, d.minute);

  int get minutes => hour * 60 + minute;

  DateTime on(DateTime day) =>
      DateTime(day.year, day.month, day.day, hour, minute);

  String toStorage() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(HM other) => minutes.compareTo(other.minutes);

  @override
  bool operator ==(Object other) =>
      other is HM && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => toStorage();
}

/// A start–end range such as a maktab session ("6:20 - 7:20").
class HMRange {
  const HMRange(this.start, this.end);

  final HM start;
  final HM end;

  static HMRange? tryParse(Object? raw) {
    if (raw is! String || !raw.contains('-')) return null;
    final p = raw.split('-');
    final s = HM.tryParse(p[0].trim());
    final e = HM.tryParse(p[1].trim());
    return s == null || e == null ? null : HMRange(s, e);
  }

  String toStorage() => '${start.toStorage()}-${end.toStorage()}';
}

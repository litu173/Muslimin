import 'package:flutter/widgets.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../data/models/hm.dart';
import '../../data/models/notice.dart';
import '../../data/models/prayer.dart';
import '../../l10n/app_localizations.dart';

/// All locale-aware formatting lives here so English and Bangla stay consistent.
class Fmt {
  Fmt(this.locale, this.t);

  factory Fmt.of(BuildContext context) =>
      Fmt(Localizations.localeOf(context), L10n.of(context));

  final Locale locale;
  final L10n t;

  bool get isBn => locale.languageCode == 'bn';

  static const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

  /// Converts ASCII digits to Bangla digits when the UI is in Bangla.
  String digits(Object value) {
    final s = value.toString();
    if (!isBn) return s;
    final b = StringBuffer();
    for (final c in s.codeUnits) {
      b.write(c >= 48 && c <= 57 ? _bnDigits[c - 48] : String.fromCharCode(c));
    }
    return b.toString();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  /// Bangla day-part word, the way times are spoken in Bangladesh.
  String _bnPeriod(int h, int m) {
    final mins = h * 60 + m;
    if (mins < 4 * 60) return 'রাত';
    if (mins < 6 * 60) return 'ভোর';
    if (mins < 12 * 60) return 'সকাল';
    if (mins < 15 * 60) return 'দুপুর';
    if (mins < 17 * 60 + 30) return 'বিকাল';
    if (mins < 19 * 60) return 'সন্ধ্যা';
    return 'রাত';
  }

  /// "5:40" (12h, no suffix) – used in prayer tables like the Figma.
  String hm(HM t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    return digits('$h:${_pad(t.minute)}');
  }

  String time(DateTime d) => hm(HM.fromDateTime(d));

  /// "1:15 pm" / "দুপুর ১:১৫" – used where the period matters.
  String hmPeriod(HM t) {
    if (isBn) return '${_bnPeriod(t.hour, t.minute)} ${hm(t)}';
    return '${hm(t)} ${t.hour < 12 ? 'am' : 'pm'}';
  }

  String timePeriod(DateTime d) => hmPeriod(HM.fromDateTime(d));

  /// "7:26 PM" style for nafl windows.
  String timeUpper(DateTime d) {
    if (isBn) return timePeriod(d);
    return '${time(d)} ${d.hour < 12 ? 'AM' : 'PM'}';
  }

  String range(DateTime a, DateTime b) => '${time(a)} - ${time(b)}';

  String hmRange(HMRange r) => '${hm(r.start)} - ${hm(r.end)}';

  /// "03:50:31"
  String countdown(Duration d) {
    if (d.isNegative) d = Duration.zero;
    return digits(
      '${_pad(d.inHours)}:${_pad(d.inMinutes % 60)}:${_pad(d.inSeconds % 60)}',
    );
  }

  static const _enMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _bnMonths = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];

  /// DateTime.weekday (1=Mon..7=Sun) -> index in the Sat-first lists of the ARB files.
  static int satFirstIndex(int weekday) => (weekday + 1) % 7;
  static int weekdayFromSatFirst(int index) =>
      index == 0 ? 6 : (index == 1 ? 7 : index - 1);

  List<String> get weekdaysShort => t.weekdaysShort.split(',');
  List<String> get weekdaysLong => t.weekdaysLong.split(',');

  String weekdayLong(int weekday) => weekdaysLong[satFirstIndex(weekday)];
  String weekdayShort(int weekday) => weekdaysShort[satFirstIndex(weekday)];

  /// "03/07/2024"
  String date(DateTime d) =>
      digits('${_pad(d.day)}/${_pad(d.month)}/${d.year}');

  /// "03 July, 2024"
  String longDate(DateTime d) =>
      '${digits(_pad(d.day))} ${(isBn ? _bnMonths : _enMonths)[d.month - 1]}, ${digits(d.year)}';

  /// "21 Rajab, Monday, 03 July, 2024"
  String headerDate(DateTime d, int hijriOffset) {
    final h = HijriCalendar.fromDate(d.add(Duration(days: hijriOffset)));
    final month = t.hijriMonths.split(',')[h.hMonth - 1];
    return '${digits(h.hDay)} $month, ${weekdayLong(d.weekday)}, ${longDate(d)}';
  }

  String relativeDays(DateTime when, DateTime now) {
    final a = DateTime(when.year, when.month, when.day);
    final b = DateTime(now.year, now.month, now.day);
    final days = b.difference(a).inDays;
    if (days <= 0) return t.today;
    if (days == 1) return t.yesterday;
    return t.daysAgo(digits(days));
  }

  String prayer(Prayer p) => switch (p) {
    Prayer.fajr => t.fajr,
    Prayer.dhuhr => t.dhuhr,
    Prayer.asr => t.asr,
    Prayer.maghrib => t.maghrib,
    Prayer.isha => t.isha,
    Prayer.jumuah => t.jumuah,
  };

  String category(NoticeCategory c, {bool short = false}) => switch (c) {
    NoticeCategory.janaza => t.catJanaza,
    NoticeCategory.recruitment => t.catRecruitment,
    NoticeCategory.quran => short ? t.catQuranShort : t.catQuran,
    NoticeCategory.mahfil => t.catMahfil,
    NoticeCategory.talim => t.catTalim,
    NoticeCategory.tafsir => t.catTafsir,
    NoticeCategory.general => t.catGeneral,
  };

  /// Second line on a notice card, following the Figma wording per category.
  String noticeMeta(Notice n) {
    final d = n.date;
    final time = HM.tryParse(n.time);
    switch (n.category) {
      case NoticeCategory.recruitment:
        return d == null ? '' : t.deadline(date(d));
      case NoticeCategory.quran:
      case NoticeCategory.talim:
      case NoticeCategory.tafsir:
        return d == null ? '' : t.startingDate(date(d));
      case NoticeCategory.janaza:
      case NoticeCategory.mahfil:
      case NoticeCategory.general:
        final parts = [
          if (time != null) hmPeriod(time),
          if (d != null) date(d),
        ];
        return parts.isEmpty ? '' : t.timeAndDate(parts.join(', '));
    }
  }

  String distance(double meters) =>
      meters < 1000 ? '' : t.kmAway(digits((meters / 1000).toStringAsFixed(1)));
}

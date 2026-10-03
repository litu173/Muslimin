import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/models/hm.dart';
import '../data/models/masjid.dart';
import '../data/models/prayer.dart';

/// Localised strings the scheduler needs (it runs outside the widget tree).
class ReminderTexts {
  const ReminderTexts({required this.prayerName, required this.body});

  final String Function(Prayer) prayerName;

  /// (prayer name, minutes) -> "Duhr jamat in 15 minutes"
  final String Function(String prayer, int minutes, String time) body;
}

/// Local jamat reminders. Uses repeating schedules so reminders keep firing
/// even if the app is not opened for days:
///   * Fajr/Asr/Maghrib/Isha  – daily
///   * Duhr                    – weekly on Sat–Thu
///   * Jum'ah                  – weekly on Friday
/// That is 11 schedules per masjid, so up to 5 masjids fit inside iOS's
/// 64 pending-notification limit.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  static const maxReminderMasjids = 5;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  void Function(String? payload)? onTap;

  static const _jamatChannel = AndroidNotificationDetails(
    'jamat',
    'Jamat reminders',
    channelDescription: 'Reminders before jamat at masjids you follow',
    importance: Importance.high,
    priority: Priority.high,
    color: Color(0xFFBB8907),
  );

  static const noticeChannel = AndroidNotificationDetails(
    'notices',
    'Masjid notices',
    channelDescription: 'Notices from masjids you follow',
    importance: Importance.defaultImportance,
    color: Color(0xFFBB8907),
  );

  Future<void> init() async {
    if (_ready || kIsWeb) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (r) => onTap?.call(r.payload),
    );
    _ready = true;
  }

  Future<String?> launchPayload() async {
    final d = await _plugin.getNotificationAppLaunchDetails();
    return d?.didNotificationLaunchApp == true
        ? d!.notificationResponse?.payload
        : null;
  }

  Future<void> show(
    int id,
    String title,
    String body, {
    String? payload,
  }) async {
    await init();
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: noticeChannel,
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<AndroidScheduleMode> _mode() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return AndroidScheduleMode.exactAllowWhileIdle;
    final exact = await android.canScheduleExactNotifications() ?? false;
    return exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// Asks Android 14+ for the exact-alarm permission so reminders are on time.
  Future<void> requestExactAlarms() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    if (await android.canScheduleExactNotifications() ?? true) return;
    await android.requestExactAlarmsPermission();
  }

  /// Replaces all jamat reminders. [masjids] maps a masjid to minutes-before.
  Future<void> rescheduleAll(
    Map<Masjid, int> masjids,
    ReminderTexts texts,
  ) async {
    if (kIsWeb) return;
    await init();
    await _plugin.cancelAll();
    final mode = await _mode();
    var slot = 0;
    for (final e in masjids.entries.take(maxReminderMasjids)) {
      final m = e.key;
      final before = e.value;
      if (before <= 0) {
        slot++;
        continue;
      }
      var n = 0;
      Future<void> schedule(Prayer p, HM at, {int? weekday}) async {
        final fire = _next(at, before, weekday);
        final id = slot * 20 + n++;
        await _plugin.zonedSchedule(
          id: id,
          title: m.name,
          body: texts.body(
            texts.prayerName(p),
            before,
            '${at.hour}:${at.minute.toString().padLeft(2, '0')}',
          ),
          scheduledDate: fire,
          notificationDetails: const NotificationDetails(
            android: _jamatChannel,
            iOS: DarwinNotificationDetails(
              interruptionLevel: InterruptionLevel.active,
            ),
          ),
          androidScheduleMode: mode,
          matchDateTimeComponents: weekday == null
              ? DateTimeComponents.time
              : DateTimeComponents.dayOfWeekAndTime,
          payload: 'masjid:${m.id}',
        );
      }

      for (final p in [Prayer.fajr, Prayer.asr, Prayer.maghrib, Prayer.isha]) {
        if (m.jamat[p] case final at?) await schedule(p, at);
      }
      if (m.jamat[Prayer.dhuhr] case final at?) {
        for (final wd in [
          DateTime.saturday,
          DateTime.sunday,
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
        ]) {
          await schedule(Prayer.dhuhr, at, weekday: wd);
        }
      }
      final jumuah = m.jamat[Prayer.jumuah] ?? m.jamat[Prayer.dhuhr];
      if (jumuah != null) {
        await schedule(Prayer.jumuah, jumuah, weekday: DateTime.friday);
      }
      slot++;
    }
  }

  tz.TZDateTime _next(HM at, int minutesBefore, int? weekday) {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      at.hour,
      at.minute,
    ).subtract(Duration(minutes: minutesBefore));
    while (t.isBefore(now) || (weekday != null && t.weekday != weekday)) {
      t = t.add(const Duration(days: 1));
    }
    return t;
  }
}

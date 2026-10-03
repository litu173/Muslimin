import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../data/backend/backend.dart';
import 'notification_service.dart';

/// Firebase Cloud Messaging: notices from followed masjids arrive via the
/// topic `masjid_<id>` (sent by the Cloud Function in /firebase/functions).
class PushService {
  PushService(this._backend);

  final Backend _backend;
  bool get _enabled => !_backend.isDemo && !kIsWeb;

  Future<void> init({void Function(String? payload)? onTap}) async {
    if (!_enabled) return;
    final fm = FirebaseMessaging.instance;
    await fm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((msg) {
      final n = msg.notification;
      if (n == null || defaultTargetPlatform == TargetPlatform.iOS) {
        return; // iOS shows it itself.
      }
      NotificationService.instance.show(
        msg.hashCode,
        n.title ?? '',
        n.body ?? '',
        payload: _payload(msg.data),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => onTap?.call(_payload(m.data)),
    );
    final initial = await fm.getInitialMessage();
    if (initial != null) onTap?.call(_payload(initial.data));

    fm.onTokenRefresh.listen(_backend.saveFcmToken);
  }

  String? _payload(Map<String, dynamic> data) =>
      data['masjidId'] == null ? null : 'masjid:${data['masjidId']}';

  Future<void> registerToken() async {
    if (!_enabled) return;
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await _backend.saveFcmToken(token);
  }

  Future<void> follow(String masjidId) async {
    if (_enabled) {
      await FirebaseMessaging.instance.subscribeToTopic('masjid_$masjidId');
    }
  }

  Future<void> unfollow(String masjidId) async {
    if (_enabled) {
      await FirebaseMessaging.instance.unsubscribeFromTopic('masjid_$masjidId');
    }
  }
}

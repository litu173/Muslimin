import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config.dart';
import 'core/nav.dart';
import 'core/theme/app_theme.dart';
import 'features/masjid/masjid_screen.dart';
import 'features/splash/splash_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/notification_service.dart';
import 'state/follows.dart';
import 'state/providers.dart';

class MusliminApp extends ConsumerStatefulWidget {
  const MusliminApp({super.key});

  @override
  ConsumerState<MusliminApp> createState() => _MusliminAppState();
}

class _MusliminAppState extends ConsumerState<MusliminApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.instance.onTap = openNotificationPayload;
    ref.read(pushProvider).init(onTap: openNotificationPayload);
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(settingsProvider.select((s) => s.locale));
    ref.watch(reminderSyncProvider);

    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      locale: locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(locale),
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: child!,
      ),
      home: const SplashScreen(),
    );
  }
}

/// Notification payloads look like `masjid:<id>`.
void openNotificationPayload(String? payload) {
  if (payload == null || !payload.startsWith('masjid:')) return;
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => MasjidScreen(masjidId: payload.substring(7)),
    ),
  );
}

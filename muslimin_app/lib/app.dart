import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config.dart';
import 'core/nav.dart';
import 'core/widgets/entrance.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/refresh.dart';
import 'features/masjid/masjid_screen.dart';
import 'features/more/about_screen.dart';
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
    final mode = ref.watch(settingsProvider.select((s) => s.themeMode));
    ref.watch(reminderSyncProvider);

    // The colour tokens are global, so a theme switch has to rebuild every
    // element (const widgets included) – not only the Theme dependents.
    final dark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    if (dark != AppColors.dark) {
      AppColors.dark = dark;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        void rebuild(Element e) {
          e.markNeedsBuild();
          e.visitChildren(rebuild);
        }

        (context as Element).visitChildren(rebuild);
      });
    }

    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      // Pages replay their entrance when the user comes back to them.
      navigatorObservers: [routeObserver],
      locale: locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.build(locale),
      scrollBehavior: const BouncyScrollBehavior(),
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
            .copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: AppColors.card,
            ),
        child: child!,
      ),
      home: const SplashScreen(),
    );
  }
}

/// A tap that arrived before the app's tabs were showing (the app was
/// opened by the notification): handled by the Shell once it is up, so
/// the splash screen's hand-over doesn't replace the opened page.
String? pendingNotificationPayload;
bool shellReady = false;

/// Notification payloads: `masjid:<id>`, or `about` (an app update –
/// About the App, where the latest APK is downloaded).
void openNotificationPayload(String? payload) {
  if (payload == null) return;
  if (!shellReady) {
    pendingNotificationPayload = payload;
    return;
  }
  final Widget page;
  if (payload == 'about') {
    page = const AboutScreen();
  } else if (payload.startsWith('masjid:')) {
    page = MasjidScreen(masjidId: payload.substring(7));
  } else {
    return;
  }
  navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => page));
}

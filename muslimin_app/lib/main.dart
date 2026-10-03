import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/backend/backend.dart';
import 'data/backend/demo_backend.dart';
import 'data/backend/firebase_backend.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'services/prefs.dart';
import 'state/providers.dart';

/// `--dart-define=DEMO=true` forces the offline demo backend even when
/// Firebase is configured (handy for screenshots & reviews).
const _forceDemo = bool.fromEnvironment('DEMO');

Future<Backend> _initBackend() async {
  if (_forceDemo) return DemoBackend();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FirebaseBackend();
  } catch (e) {
    debugPrint('Firebase not available, running in demo mode: $e');
    return DemoBackend();
  }
}

/// Bundled fonts are SIL Open Font License; their licence texts ship with the
/// app and appear on the "Open-source licences" page (About screen).
void _registerFontLicenses() {
  const fonts = {
    'Grenze Gotisch': 'grenzegotisch',
    'Poppins': 'poppins',
    'Hind Siliguri': 'hindsiliguri',
    'Galada': 'galada',
    'Amiri': 'amiri',
  };
  LicenseRegistry.addLicense(() async* {
    for (final e in fonts.entries) {
      final text = await rootBundle.loadString(
        'assets/licenses/OFL-${e.value}.txt',
      );
      yield LicenseEntryWithLineBreaks(['${e.key} font'], text);
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final results = await Future.wait([Prefs.load(), _initBackend()]);
  await NotificationService.instance.init();

  runApp(
    ProviderScope(
      overrides: [
        prefsProvider.overrideWithValue(results[0] as Prefs),
        backendProvider.overrideWithValue(results[1] as Backend),
      ],
      child: const MusliminApp(),
    ),
  );
}

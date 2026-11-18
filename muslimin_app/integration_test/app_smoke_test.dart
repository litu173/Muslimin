// Walks through the app like a user, on the offline demo data, and fails on
// any error or crash. Run before every release:
//   flutter test integration_test/app_smoke_test.dart --dart-define=DEMO=true -d <device>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:muslimin/features/auth/auth_screens.dart';
import 'package:muslimin/features/home/masjid_card.dart';
import 'package:muslimin/features/home/women_space_screen.dart';
import 'package:muslimin/features/masjid/masjid_screen.dart';
import 'package:muslimin/features/masjid/women_space.dart';
import 'package:muslimin/features/notices/notice_card.dart';
import 'package:muslimin/features/notifications/notifications_screen.dart';
import 'package:muslimin/l10n/app_localizations.dart';
import 'package:muslimin/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // The Home clock ticks every second, so the screen never "settles":
  // pump for a while instead.
  Future<void> wait(WidgetTester tester, [int ms = 1500]) async {
    for (var i = 0; i < ms ~/ 100; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> until(WidgetTester tester, Finder f, {int seconds = 20}) async {
    for (var i = 0; i < seconds * 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (f.evaluate().isNotEmpty) return;
    }
    fail('Not found within ${seconds}s: $f');
  }

  // Scrolls the page's main (vertical) list until [f] is built.
  Future<void> scrollTo(
    WidgetTester tester,
    Finder f, {
    double by = -300,
  }) async {
    final list = find.byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    );
    for (var i = 0; i < 30 && f.evaluate().isEmpty; i++) {
      await tester.drag(list.first, Offset(0, by));
      await wait(tester, 400);
    }
    expect(f, findsWidgets);
    await tester.ensureVisible(f.first);
    await wait(tester, 600);
  }

  // The app draws its own back arrows: go back like the system button.
  Future<void> back(WidgetTester tester) async {
    await Navigator.of(tester.element(find.byType(Scaffold).last)).maybePop();
    await wait(tester);
  }

  testWidgets('user journey', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('onboardingDone', true);
    await prefs.setString('locale', 'bn');
    final t = lookupL10n(const Locale('bn'));

    // Report a notice (Google Play: posts must be reportable).
    Future<void> reportFirstNotice() async {
      final cards = find.byType(NoticeCard);
      debugPrint('notice cards: ${cards.evaluate().length}');
      expect(cards, findsWidgets, reason: 'demo masjid has notices');
      await tester.tap(cards.first);
      await wait(tester, 1200);
      final report = find.text(t.reportPostTitle);
      await tester.ensureVisible(report.first);
      await tester.tap(report.first);
      await until(tester, find.text(t.reasonSpam));
      await tester.tap(find.text(t.reasonSpam));
      await tester.tap(find.text(t.reportSend));
      await until(tester, find.text(t.reportPostThanks));
      debugPrint('report sent OK');
      await wait(tester, 1000);
      await back(tester); // details sheet
    }

    await app.main();

    // ---- sign in: Google only
    await until(tester, find.byType(GoogleSignInButton));
    expect(find.text(t.createAccount), findsNothing);
    await tester.tap(find.byType(GoogleSignInButton).first);
    await until(tester, find.byIcon(Icons.home_rounded), seconds: 30);
    await wait(tester, 3000);

    // ---- every bottom tab
    for (final icon in [
      Icons.menu_book_outlined,
      Icons.volunteer_activism_outlined,
      Icons.campaign_outlined,
      Icons.menu_rounded,
    ]) {
      await tester.tap(find.byIcon(icon));
      await wait(tester, 2500);
      expect(tester.takeException(), isNull, reason: 'tab $icon');
    }
    await tester.tap(find.byIcon(Icons.home_outlined));
    await wait(tester, 2000);

    // ---- notifications
    await tester.tap(find.byIcon(Icons.notifications_none_rounded).first);
    await until(tester, find.byType(NotificationsScreen));
    await wait(tester);
    await back(tester);

    // ---- women's prayer spaces finder
    final womenCard = find.text(t.womenFinderTitle);
    await scrollTo(tester, womenCard);
    await tester.tap(womenCard.first);
    await until(tester, find.byType(WomenSpaceScreen));
    await wait(tester, 2000);
    expect(find.byType(MasjidCard), findsWidgets);

    // ---- a masjid page (from the finder) and all its tabs
    await tester.tap(find.byType(MasjidCard).first);
    await until(tester, find.byType(MasjidScreen));
    await wait(tester, 2000);
    expect(find.byType(WomenSpaceCard), findsOneWidget);
    for (final tab in [t.tabNotice, t.tabChannel, t.tabAbout, t.tabHome]) {
      final f = find.text(tab);
      if (f.evaluate().isEmpty) continue;
      await tester.tap(f.last);
      await wait(tester, 2000);
      expect(tester.takeException(), isNull, reason: 'masjid tab $tab');
      if (tab == t.tabNotice) await reportFirstNotice();
    }
    await back(tester); // masjid
    await back(tester); // finder

    // ---- More → About the App
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await wait(tester, 2000);
    final about = find.text(t.aboutApp);
    await scrollTo(tester, about);
    await tester.tap(about.first);
    await wait(tester, 3000);
    expect(tester.takeException(), isNull);
    await back(tester);
  });
}

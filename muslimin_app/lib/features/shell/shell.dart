import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart'
    show openNotificationPayload, pendingNotificationPayload, shellReady;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/refresh.dart' show RefreshAyah;
import '../../data/models/app_config.dart' show Feature;
import '../../core/theme/app_text.dart';
import '../../l10n/app_localizations.dart';
import '../../services/content_store.dart';
import '../../services/places.dart';
import '../../state/channel.dart';
import '../../state/providers.dart' show backendProvider;
import '../../state/dhikr.dart';
import '../../state/update.dart';
import '../../state/quran.dart';
import '../achievements/achievements.dart';
import '../dua/dua_screen.dart';
import '../home/home_screen.dart';
import '../home/quran_energy_card.dart';
import '../more/more_screen.dart';
import '../notices/notices_screen.dart';
import '../read/read_screen.dart';
import 'update_required.dart';

/// Bottom navigation: Home · Quran · Dua · Notice · More.
class Shell extends ConsumerStatefulWidget {
  const Shell({super.key});

  @override
  ConsumerState<Shell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<Shell> {
  @override
  void initState() {
    super.initState();
    // Opened by tapping a notification: show its page now the tabs are up.
    shellReady = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = pendingNotificationPayload;
      pendingNotificationPayload = null;
      openNotificationPayload(p);
    });
  }

  int get _tab => ref.watch(shellTabProvider);
  void _go(int i) => ref.read(shellTabProvider.notifier).go(i);

  /// Bumped each time a tab is opened, so it is rebuilt fresh and always
  /// starts scrolled to the top.
  final _visits = List.filled(5, 0);

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    // New channel messages → phone notifications while the app runs.
    ref.watch(channelNotifierProvider);
    ref.watch(noticeNotifierProvider);
    ref.listen(shellTabProvider, (prev, next) {
      if (prev != next) setState(() => _visits[next]++);
    });
    // Celebrate each achievement the moment it is earned.
    void celebrate(Map<String, String>? prev, Map<String, String> next) {
      if (prev == null) return;
      for (final id in next.keys.where((k) => !prev.containsKey(k))) {
        showAchievementToast(context, id);
      }
    }

    ref.listen(quranProgressProvider.select((p) => p.achievedAt), celebrate);
    ref.listen(dhikrProgressProvider.select((p) => p.achievedAt), celebrate);
    // Content the admins corrected: download the changed sets.
    ref.listen(appConfigProvider.select((c) => c.value?.contentVersion), (
      _,
      v,
    ) {
      if (v != null && v.isNotEmpty) {
        ContentStore.sync(v, ref.read(backendProvider).content);
      }
    });
    // The admin requires a newer version: nothing else until it's updated.
    if (ref.watch(updateRequiredProvider)) return const UpdateRequiredScreen();
    // Tabs the admin switched off are hidden (App settings → Features).
    final quranOn = ref.watch(featureProvider(Feature.tabQuran));
    final duaOn = ref.watch(featureProvider(Feature.tabDua));
    final noticeOn = ref.watch(featureProvider(Feature.tabNotice));
    RefreshAyah.enabled = ref.watch(featureProvider(Feature.refreshAyah));
    Places.bn = ref.watch(placeNamesProvider).value ?? const {};
    Places.bangla = Localizations.localeOf(context).languageCode == 'bn';
    final hidden = {if (!quranOn) 1, if (!duaOn) 2, if (!noticeOn) 3};
    if (hidden.contains(_tab)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _go(0));
    }
    return Scaffold(
      body: IndexedStack(
        index: hidden.contains(_tab) ? 0 : _tab,
        children: [
          // Hidden tabs stay alive but their animations and timers pause,
          // so only the visible tab uses the CPU / GPU.
          for (final (i, tab) in const [
            HomeScreen(),
            ReadScreen(),
            DuaScreen(),
            NoticesScreen(),
            MoreScreen(),
          ].indexed)
            TickerMode(
              enabled: i == _tab,
              child: KeyedSubtree(key: ValueKey(_visits[i]), child: tab),
            ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: AppColors.dark
                  ? const Color(0x66000000)
                  : const Color(0x0F002828),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                _NavItem(
                  icon: _tab == 0 ? Icons.home_rounded : Icons.home_outlined,
                  label: t.home,
                  selected: _tab == 0,
                  onTap: () => _go(0),
                ),
                if (quranOn)
                  _NavItem(
                    icon: _tab == 1
                        ? Icons.menu_book_rounded
                        : Icons.menu_book_outlined,
                    label: t.tabQuran,
                    selected: _tab == 1,
                    onTap: () => _go(1),
                  ),
                if (duaOn)
                  _NavItem(
                    icon: _tab == 2
                        ? Icons.volunteer_activism_rounded
                        : Icons.volunteer_activism_outlined,
                    label: t.tabDua,
                    selected: _tab == 2,
                    onTap: () => _go(2),
                  ),
                if (noticeOn)
                  _NavItem(
                    icon: _tab == 3
                        ? Icons.campaign_rounded
                        : Icons.campaign_outlined,
                    label: t.tabNotices,
                    selected: _tab == 3,
                    onTap: () => _go(3),
                  ),
                _NavItem(
                  icon: Icons.menu_rounded,
                  label: t.more,
                  selected: _tab == 4,
                  onTap: () => _go(4),
                  // A newer version is out (About the App has it).
                  dot: ref.watch(updateAvailableProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.dot = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// A small red dot on the icon: something new inside.
  final bool dot;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Selected tab in gold, like every other "active" state.
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? AppColors.gold : AppColors.muted,
              ),
              if (dot)
                Positioned(
                  right: -3,
                  top: -2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.card, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: AppText.caption.copyWith(
              color: selected ? AppColors.gold : AppColors.muted,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(label),
          ),
        ],
      ),
    ),
  );
}

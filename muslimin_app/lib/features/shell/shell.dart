import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../l10n/app_localizations.dart';
import '../../state/quran.dart';
import '../achievements/achievements.dart';
import '../dua/dua_screen.dart';
import '../home/home_screen.dart';
import '../home/quran_energy_card.dart';
import '../more/more_screen.dart';
import '../notices/notices_screen.dart';
import '../read/read_screen.dart';

/// Bottom navigation: Home · Quran · Dua · Notice · More.
class Shell extends ConsumerStatefulWidget {
  const Shell({super.key});

  @override
  ConsumerState<Shell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<Shell> {
  int get _tab => ref.watch(shellTabProvider);
  void _go(int i) => ref.read(shellTabProvider.notifier).go(i);

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    // Celebrate each achievement the moment it is earned.
    ref.listen(quranProgressProvider.select((p) => p.achievedAt), (prev, next) {
      if (prev == null) return;
      for (final id in next.keys.where((k) => !prev.containsKey(k))) {
        showAchievementToast(context, id);
      }
    });
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          HomeScreen(),
          ReadScreen(),
          DuaScreen(),
          NoticesScreen(),
          MoreScreen(),
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
                _NavItem(
                  icon: _tab == 1
                      ? Icons.menu_book_rounded
                      : Icons.menu_book_outlined,
                  label: t.tabQuran,
                  selected: _tab == 1,
                  onTap: () => _go(1),
                ),
                _NavItem(
                  icon: _tab == 2
                      ? Icons.volunteer_activism_rounded
                      : Icons.volunteer_activism_outlined,
                  label: t.tabDua,
                  selected: _tab == 2,
                  onTap: () => _go(2),
                ),
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
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Selected tab in gold, like every other "active" state.
          Icon(
            icon,
            size: 22,
            color: selected ? AppColors.gold : AppColors.muted,
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

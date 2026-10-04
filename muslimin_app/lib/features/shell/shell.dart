import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../l10n/app_localizations.dart';
import '../home/home_screen.dart';
import '../more/more_screen.dart';

/// Bottom navigation: Home · More (as in the Figma).
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [HomeScreen(), MoreScreen()],
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
                  onTap: () => setState(() => _tab = 0),
                ),
                _NavItem(
                  icon: Icons.menu_rounded,
                  label: t.more,
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
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

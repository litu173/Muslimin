import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../l10n/app_localizations.dart';
import '../home/home_screen.dart';
import '../more/more_screen.dart';
import '../read/read_screen.dart';
import '../read/read_widgets.dart';

/// Bottom navigation: Home · Read (raised centre circle) · More.
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
        children: const [HomeScreen(), ReadScreen(), MoreScreen()],
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
            height: 60,
            child: Row(
              children: [
                _NavItem(
                  icon: _tab == 0 ? Icons.home_rounded : Icons.home_outlined,
                  label: t.home,
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                _ReadItem(
                  label: t.tabRead,
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
                _NavItem(
                  icon: Icons.menu_rounded,
                  label: t.more,
                  selected: _tab == 2,
                  onTap: () => setState(() => _tab = 2),
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

/// The centre "Read" tab: a big circle raised above the bar, with the
/// eight-point star of the app inside.
class _ReadItem extends StatelessWidget {
  const _ReadItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -26,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: selected
                      ? [AppColors.goldLight, AppColors.gold]
                      : [AppColors.header, AppColors.inkDeep],
                ),
                border: Border.all(color: AppColors.card, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: (selected ? AppColors.gold : AppColors.header)
                        .withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      shape: StarShapeBorder(
                        side: BorderSide(
                          color: (selected ? Colors.white : AppColors.goldLight)
                              .withValues(alpha: 0.55),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.menu_book_rounded,
                    size: 22,
                    color: selected ? Colors.white : AppColors.goldLight,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: AppText.caption.copyWith(
                color: selected ? AppColors.gold : AppColors.muted,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(label),
            ),
          ),
        ],
      ),
    ),
  );
}

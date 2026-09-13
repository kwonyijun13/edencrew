import 'package:edencrew_assignment_starter/presentation/providers/main_tab_provider.dart';
import 'package:edencrew_assignment_starter/theme/app_theme.dart';
import 'package:edencrew_assignment_starter/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Bottom tab bar shared by watchlist and search screens.
class AppBottomNav extends ConsumerWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final dimens = context.dimens;
    final currentTab = ref.watch(mainTabProvider);

    return Container(
      height: dimens.tabBarHeight,
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        border: Border(
          top: BorderSide(color: colors.borderSubtle, width: dimens.borderHairline),
        ),
      ),
      child: Row(
        children: [
          _NavItem(
            icon: Icons.star_border_rounded,
            activeIcon: Icons.star_rounded,
            label: '관심',
            isActive: currentTab == 0,
            onTap: () => ref.read(mainTabProvider.notifier).selectTab(0),
          ),
          _NavItem(
            icon: Icons.search_rounded,
            activeIcon: Icons.search_rounded,
            label: '검색',
            isActive: currentTab == 1,
            onTap: () => ref.read(mainTabProvider.notifier).selectTab(1),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isActive ? colors.navActive : colors.navInactive;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: AppTypography.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
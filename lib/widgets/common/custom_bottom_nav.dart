// lib/widgets/common/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import '../../utils/enums.dart';

class CustomBottomNav extends ConsumerWidget {
  final AppTab currentTab;
  final Function(AppTab) onTabSelected;
  final Map<AppTab, int> badgeCounts;

  const CustomBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    this.badgeCounts = const {},
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: currentTab.index,
      onTap: (index) => onTabSelected(AppTab.values[index]),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: [
        _buildNavItem(
          context,
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
          tab: AppTab.home,
        ),
        _buildNavItem(
          context,
          icon: Icons.explore_outlined,
          activeIcon: Icons.explore,
          label: 'Discover',
          tab: AppTab.discover,
        ),
        _buildNavItem(
          context,
          icon: Icons.chat_bubble_outline,
          activeIcon: Icons.chat,
          label: 'Chat',
          tab: AppTab.chat,
        ),
        _buildNavItem(
          context,
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          tab: AppTab.profile,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required AppTab tab,
  }) {
    final badgeCount = badgeCounts[tab] ?? 0;
    final isActive = currentTab == tab;

    Widget iconWidget = Icon(isActive ? activeIcon : icon, size: 24);

    if (badgeCount > 0) {
      iconWidget = badges.Badge(
        badgeContent: Text(
          badgeCount > 99 ? '99+' : badgeCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        position: badges.BadgePosition.topEnd(top: -8, end: -8),
        child: iconWidget,
      );
    }

    return BottomNavigationBarItem(icon: iconWidget, label: label);
  }
}

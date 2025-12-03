import 'dart:ui';
import 'package:egx/core/Layout/layout_controller.dart';
import 'package:egx/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends GetView<LayoutController> {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              backgroundColor: theme.colorScheme.background,
              elevation: 0,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.candleGreen,
              unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: [
                _navItem(
                  index: 0,
                  controller: controller,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                ),
                _navItem(
                  index: 1,
                  controller: controller,
                  icon: Icons.show_chart_outlined,
                  activeIcon: Icons.show_chart_rounded,
                  label: 'Markets',
                ),
                _navItem(
                  index: 2,
                  controller: controller,
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search_rounded,
                  label: 'Search',
                ),
                _navItem(
                  index: 3,
                  controller: controller,
                  icon: Icons.groups_outlined,
                  activeIcon: Icons.groups_rounded,
                  label: 'Community',
                ),
                _navItem(
                  index: 4,
                  controller: controller,
                  icon: Icons.menu_rounded,
                  activeIcon: Icons.menu_open_rounded,
                  label: 'Menu',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required int index,
    required LayoutController controller,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = controller.currentIndex.value == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.candleGreen.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Icon(isActive ? activeIcon : icon, size: isActive ? 30 : 26),
      ),
      label: label,
    );
  }
}

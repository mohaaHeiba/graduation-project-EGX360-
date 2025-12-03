import 'package:egx/core/Layout/layout_controller.dart';
import 'package:egx/features/community/presentation/pages/community_page.dart';
import 'package:egx/features/markets/chart_page.dart';
import 'package:egx/features/home/home_page.dart';
import 'package:egx/features/search/search_page.dart';
import 'package:egx/features/settings/presentaion/pages/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egx/core/Layout/bottom_nav_bar.dart';

class MainLayout extends GetView<LayoutController> {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomePage(),
      ChartPage(),
      SearchPage(),
      CommunityPage(),
      SettingsView(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}

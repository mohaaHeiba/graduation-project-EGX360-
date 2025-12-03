import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/features/settings/presentaion/controller/settings_controller.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/support/data_sources_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/support/how_to_use_page.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/modern_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportPage extends StatelessWidget {
  HelpSupportPage({super.key});

  final controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppbar(() => Get.back(), 'Help & Support'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Text(
              "Need Help?",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppGaps.h8,
            Text(
              "Find quick answers or reach out for support.",
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
            ),
            AppGaps.h24,

            // ===== FAQs SECTION =====
            ModernSettingsSection(
              title: "FAQs",
              items: [
                SettingItem(
                  title: "How to use EGX360?",
                  subtitle:
                      "Learn how to explore markets and access real-time data.",
                  onTap: () {
                    Get.to(HowToUsePage(), transition: Transition.rightToLeft);
                  },
                ),
                SettingItem(
                  title: "Data Sources",
                  subtitle:
                      "Understand where EGX360 gets its market data from.",
                  onTap: () {
                    Get.to(
                      DataSourcesPage(),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
              ],
            ),

            AppGaps.h24,

            // ===== SUPPORT SECTION =====
            ModernSettingsSection(
              title: "SUPPORT",
              items: [
                SettingItem(
                  title: "Contact & Report Issue",
                  subtitle:
                      "Send us an email if you need help or found a problem.",
                  onTap: controller.openEmail,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

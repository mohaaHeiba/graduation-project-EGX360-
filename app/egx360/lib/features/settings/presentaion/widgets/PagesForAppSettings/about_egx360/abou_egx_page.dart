import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/about_egx360/portfolio_web_view_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/about_egx360/show_license_page.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/modern_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:egx/core/constants/app_gaps.dart';

class AboutEGXPage extends StatelessWidget {
  const AboutEGXPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: customAppbar(Get.back, 'About EGX'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModernSettingsSection(
              title: "ABOUT",
              items: [
                SettingItem(
                  icon: LucideIcons.info,
                  title: "About EGX360",
                  subtitle:
                      "EGX360 is a modern stock market simulator app for the Egyptian Exchange, helping users learn, practice, and explore trading safely with virtual funds.",
                  onTap: () {
                    Get.to(
                      () => const PortfolioWebViewPage(
                        url: 'https://mohamed-heiba-portfolio.vercel.app/',
                      ),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
                SettingItem(
                  icon: LucideIcons.user,
                  title: "About the Developer",
                  subtitle:
                      "Developed by Mohamed Heiba — Software Engineering student specializing in Flutter and AI integrations.",
                  onTap: () {
                    Get.to(
                      () => const PortfolioWebViewPage(
                        url: 'https://mohamed-heiba-portfolio.vercel.app/',
                      ),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
              ],
            ),
            AppGaps.h24,

            ModernSettingsSection(
              title: "APP DETAILS",
              items: [
                SettingItem(
                  icon: LucideIcons.accessibility,
                  title: "App Version",
                  subtitle: "1.0.0 (Beta)",
                ),
                SettingItem(
                  icon: LucideIcons.badgeInfo,
                  title: "Licenses",
                  onTap: () {
                    Get.to(LicensesPage(), transition: Transition.rightToLeft);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

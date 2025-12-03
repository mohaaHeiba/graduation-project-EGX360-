import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/settings/presentaion/controller/settings_controller.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/about_egx360/abou_egx_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/darkMode/dark_mode_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/edit_Profile/edit_profile_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/support/help_support_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/language/language_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/notifications/notifications_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/policy/privacy_policy_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/security/privacy_security_page.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/modern_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSettingsPage extends GetView<SettingsController> {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;

    return Scaffold(
      backgroundColor: theme.background,
      // AppBar
      appBar: customAppbar(controller.backToProfilePage, 'Settings'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
          child: Column(
            children: [
              // ===== Section 1: ACCOUNT =====
              ModernSettingsSection(
                title: "ACCOUNT",
                items: [
                  SettingItem(
                    icon: Icons.person_outline_rounded,
                    title: "Edit Profile",
                    subtitle: "Change your name, avatar, bio",
                    onTap: () => Get.to(
                      EditProfilePage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                  SettingItem(
                    icon: Icons.lock_outline,
                    title: "Privacy & Security",
                    onTap: () => Get.to(
                      PrivacySecurityPage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                  SettingItem(
                    icon: Icons.notifications_none,
                    title: "Notifications",
                    onTap: () => Get.to(
                      NotificationsPage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                ],
              ),
              AppGaps.h24,

              // ===== Section 3: PREFERENCES =====
              ModernSettingsSection(
                title: "PREFERENCES",
                items: [
                  SettingItem(
                    icon: Icons.color_lens_outlined,
                    title: "Dark Mode",
                    onTap: () => Get.to(
                      DarkModePage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                  SettingItem(
                    icon: Icons.language_rounded,
                    title: "Language",
                    subtitle: "English",
                    onTap: () => Get.to(
                      LanguagePage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                ],
              ),
              AppGaps.h24,

              // ===== Section 4: ABOUT & LOGOUT =====
              ModernSettingsSection(
                title: "ABOUT",
                items: [
                  SettingItem(
                    icon: Icons.info_outline,
                    title: "About EGX",
                    subtitle: "Version 1.0.0",
                    onTap: () => Get.to(
                      AboutEGXPage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                  SettingItem(
                    icon: Icons.policy_outlined,
                    title: "Privacy Policy",
                    onTap: () => Get.to(
                      PrivacyPolicyPage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                  SettingItem(
                    icon: Icons.help_outline_rounded,
                    title: "Help & Support",
                    onTap: () => Get.to(
                      HelpSupportPage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                  SettingItem(
                    icon: Icons.logout_rounded,
                    title: "Logout",
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: theme.surface,
                          title: Text(
                            "Confirm Logout",
                            style: theme.textStyles.titleMedium?.copyWith(
                              color: theme.onSurface,
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to logout?",
                            style: theme.textStyles.bodyMedium?.copyWith(
                              color: theme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "Cancel",
                                style: theme.textStyles.bodyMedium?.copyWith(
                                  color: theme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await controller.logout();
                              },
                              child: Text(
                                "Logout",
                                style: theme.textStyles.bodyMedium?.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

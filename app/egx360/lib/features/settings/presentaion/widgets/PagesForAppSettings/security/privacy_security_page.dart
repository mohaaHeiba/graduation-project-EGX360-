import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/settings/presentaion/controller/settings_controller.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/security/active_sessions_page.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/security/change_pass_page.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/modern_settings_section.dart'
    show ModernSettingsSection, SettingItem;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egx/core/custom/custom_appbar.dart';

class PrivacySecurityPage extends GetView<SettingsController> {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: customAppbar(() => Get.back(), 'Privacy & Security'),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          AppGaps.h12,

          /// SECURITY SECTION
          ModernSettingsSection(
            title: "SECURITY",
            items: [
              SettingItem(
                icon: Icons.lock_outline_rounded,
                title: "Change Password",
                subtitle: "Update your account password",
                onTap: () {
                  Get.to(ChangePassPage(), transition: Transition.rightToLeft);
                },
              ),
              SettingItem(
                icon: Icons.devices_other_outlined,
                title: "Active Sessions",
                subtitle: "View where your account is currently logged in",
                onTap: () {
                  Get.to(
                    ActiveSessionsPage(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ],
          ),

          AppGaps.h32,

          /// ACCOUNT ACTIONS SECTION
          ModernSettingsSection(
            title: "ACCOUNT ACTIONS",
            items: [
              SettingItem(
                icon: Icons.delete_outline_rounded,
                title: "Delete Account",
                subtitle: "Permanently remove your data and account",
                iconColor: AppColors.error,
                titleColor: AppColors.error,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: theme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        "Delete Account",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        "Are you sure you want to permanently delete your account? This action cannot be undone.",
                        style: theme.textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            await controller.deleteAccount();
                          },
                          child: Text(
                            "Delete",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimaryLight,
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

          AppGaps.h32,
        ],
      ),
    );
  }
}

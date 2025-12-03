import 'package:egx/core/constants/app_gaps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:egx/features/settings/presentaion/controller/notifications_controller.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/modern_settings_section.dart';
import 'package:egx/core/custom/custom_appbar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppbar(() => Get.back(), 'Notifications'),

      body: Obx(() {
        final systemEnabled = controller.isSystemNotificationsEnabled.value;

        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            ModernSettingsSection(
              title: "GENERAL",
              items: [
                SettingItem(
                  icon: Icons.notifications_active_rounded,
                  title: "Allow Notifications",
                  subtitle: systemEnabled
                      ? "System notifications are ON"
                      : "Tap to enable in settings",
                  iconColor: systemEnabled ? null : theme.disabledColor,
                  trailing: Switch(
                    value: systemEnabled,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (val) =>
                        controller.toggleSystemNotifications(val),
                  ),
                ),
              ],
            ),

            AppGaps.h20,
            IgnorePointer(
              ignoring: !systemEnabled,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: systemEnabled ? 1.0 : 0.5,
                child: Column(
                  children: [
                    ModernSettingsSection(
                      title: "CATEGORIES",
                      items: [
                        SettingItem(
                          icon: Icons.show_chart_rounded,
                          title: "Market Alerts",
                          subtitle: "Price movements, volume spikes",
                          trailing: Switch(
                            value: controller.marketAlerts.value,
                            activeColor: theme.colorScheme.primary,
                            onChanged: (val) => controller.updateSetting(
                              'marketAlerts',
                              val,
                              controller.marketAlerts,
                            ),
                          ),
                        ),
                        SettingItem(
                          icon: Icons.article_outlined,
                          title: "News Updates",
                          subtitle: "Financial and market news",
                          trailing: Switch(
                            value: controller.newsUpdates.value,
                            activeColor: theme.colorScheme.primary,
                            onChanged: (val) => controller.updateSetting(
                              'newsUpdates',
                              val,
                              controller.newsUpdates,
                            ),
                          ),
                        ),
                        SettingItem(
                          icon: Icons.system_update_alt_rounded,
                          title: "App Updates",
                          subtitle: "New features and versions",
                          trailing: Switch(
                            value: controller.appUpdates.value,
                            activeColor: theme.colorScheme.primary,
                            onChanged: (val) => controller.updateSetting(
                              'appUpdates',
                              val,
                              controller.appUpdates,
                            ),
                          ),
                        ),
                      ],
                    ),

                    AppGaps.h20,

                    ModernSettingsSection(
                      title: "SOUNDS & ALERTS",
                      items: [
                        SettingItem(
                          icon: Icons.volume_up_rounded,
                          title: "Notification Sounds",
                          subtitle: "Play sound for new alerts",
                          trailing: Switch(
                            value: controller.soundEnabled.value,
                            activeColor: theme.colorScheme.primary,
                            onChanged: (val) => controller.updateSetting(
                              'soundEnabled',
                              val,
                              controller.soundEnabled,
                            ),
                          ),
                        ),
                      ],
                    ),

                    AppGaps.h32,

                    ElevatedButton.icon(
                      onPressed: () => controller.muteAll(),
                      icon: Icon(
                        Icons.notifications_off_outlined,
                        color: theme.colorScheme.error,
                      ),
                      label: Text(
                        "Mute All App Alerts",
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        side: BorderSide(
                          color: theme.colorScheme.error.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

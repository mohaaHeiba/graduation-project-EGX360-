import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/settings/presentaion/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DarkModePage extends GetView<ThemeController> {
  const DarkModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: customAppbar(Get.back, 'Theme'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 16),
              child: Text(
                'Choose your preferred theme',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            Obx(
              () => Row(
                spacing: 6,
                children: [
                  _buildThemePreviewBox(
                    controller: controller,
                    label: 'Light',
                    imagePath: 'assets/images/lightMode.png',
                    mode: ThemeModeSelection.light,
                    theme: theme,
                  ),
                  AppGaps.w16,
                  _buildThemePreviewBox(
                    controller: controller,
                    label: 'Dark',
                    imagePath: 'assets/images/darkMode.png',
                    mode: ThemeModeSelection.dark,
                    theme: theme,
                  ),
                ],
              ),
            ),
            AppGaps.h32,

            // ===== Use System Theme =====
            Obx(() {
              final bool isSelected =
                  controller.selectedMode.value == ThemeModeSelection.system;
              return InkWell(
                onTap: () => controller.selectMode(ThemeModeSelection.system),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.brightness_auto_rounded,
                          color: theme.primary,
                          size: 22,
                        ),
                      ),
                      AppGaps.w14,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Use System Theme",
                              style: TextStyle(
                                color: isSelected
                                    ? theme.primary
                                    : theme.textTheme.bodyMedium!.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Theme will change depending on phone settings",
                              style: TextStyle(
                                color: isSelected
                                    ? theme.primary
                                    : theme.textTheme.bodySmall!.color,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: theme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreviewBox({
    required controller,
    required String label,
    required String imagePath,
    required ThemeModeSelection mode,
    required BuildContext theme,
  }) {
    final bool isSelected = controller.selectedMode.value == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectMode(mode),
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? theme.primary : Colors.grey[800]!,
                  width: isSelected ? 3 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            AppGaps.h12,
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? theme.primary
                    : theme.textTheme.bodySmall!.color,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

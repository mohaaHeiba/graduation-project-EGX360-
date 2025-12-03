import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/features/settings/presentaion/controller/settings_controller.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/modern_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egx/core/custom/custom_appbar.dart';

class LanguagePage extends GetView<SettingsController> {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppbar(() => Get.back(), "Language"),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(18),
        children: [
          Obx(
            () => ModernSettingsSection(
              title: "Select your preferred language",
              items: [
                SettingItem(
                  icon: Icons.language,
                  title: "English",
                  subtitle: "Set app language to English",
                  trailing: _buildRadio("en", controller, theme),
                  onTap: () => controller.onLangSelected("en"),
                ),
                SettingItem(
                  icon: Icons.language,
                  title: "العربية",
                  subtitle: "اضبط لغة التطبيق إلى العربية",
                  trailing: _buildRadio("ar", controller, theme),
                  onTap: () => controller.onLangSelected("ar"),
                ),
              ],
            ),
          ),

          AppGaps.h20,

          /// Apply Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              // 👇 1. استدعاء دالة الحفظ والتطبيق
              controller.applyLanguage();

              // 👇 2. إظهار رسالة النجاح
              Get.snackbar(
                "Language Changed",
                controller.selectedLang.value == "ar"
                    ? "تم تغيير اللغة إلى العربية"
                    : "App language set to English",
                backgroundColor:
                    theme.snackBarTheme.backgroundColor ?? Colors.black87,
                colorText:
                    theme.snackBarTheme.contentTextStyle?.color ?? Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: Icon(
              Icons.done_all_rounded,
              color: theme.colorScheme.onPrimary,
            ),
            label: Text(
              "Apply Language",
              style:
                  theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // helper for radio icon
  Widget _buildRadio(String code, controller, ThemeData theme) {
    final isSelected = controller.selectedLang.value == code;
    return Icon(
      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
      color: isSelected ? theme.colorScheme.primary : theme.disabledColor,
    );
  }
}

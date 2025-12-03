import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/settings/presentaion/controller/settings_controller.dart';
import 'package:flutter/foundation.dart' show LicenseParagraph;
import 'package:flutter/material.dart';
import 'package:egx/core/custom/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart' show LucideIcons;

class LicensesPage extends GetView<SettingsController> {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: customAppbar(() => Get.back(), 'Licenses'),
      body: FutureBuilder<LicenseData>(
        future: controller.loadLicenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: theme.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading licenses: ${snapshot.error}",
                style: TextStyle(color: AppColors.error),
              ),
            );
          }

          final data = snapshot.data!;
          final packages = data.packages.keys.toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Icon(LucideIcons.barChart, size: 50, color: theme.primary),
              AppGaps.h12,
              Text(
                "EGX360",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge!.color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppGaps.h4,
              Text(
                "Version 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.textTheme.bodyMedium!.color),
              ),
              AppGaps.h16,
              Text(
                "© 2025 EGX360. All rights reserved.\nBuilt with Flutter & Firebase.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium!.color,
                  fontSize: 13,
                ),
              ),
              AppGaps.h32,
              Text(
                "Open Source Licenses",
                style: TextStyle(
                  color: theme.textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              AppGaps.h12,

              // ===== Packages list =====
              Container(
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: packages.asMap().entries.map((entry) {
                    final pkg = entry.value;
                    final isLast = entry.key == packages.length - 1;

                    return InkWell(
                      borderRadius: isLast
                          ? const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            )
                          : BorderRadius.zero,
                      onTap: () {
                        Get.to(
                          () => LicenseDetailsPage(
                            package: pkg,
                            paragraphs: data.packages[pkg]!,
                          ),
                          transition: Transition.fadeIn,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: !isLast
                              ? Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[850]!,
                                    width: 0.7,
                                  ),
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                pkg,
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge!.color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: theme.textTheme.bodySmall!.color
                                  ?.withOpacity(0.5),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LicenseDetailsPage extends StatelessWidget {
  final String package;
  final List<LicenseParagraph> paragraphs;

  const LicenseDetailsPage({
    super.key,
    required this.package,
    required this.paragraphs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppbar(() => Get.back(), package),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: paragraphs.map((p) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              p.text,
              style: TextStyle(
                color: theme.textTheme.bodyMedium!.color,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class LicenseData {
  final Map<String, List<LicenseParagraph>> packages;
  LicenseData(this.packages);
}

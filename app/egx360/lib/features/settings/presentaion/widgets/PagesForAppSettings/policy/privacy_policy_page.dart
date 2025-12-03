import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/build_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppbar(Get.back, 'Privacy Policy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last Updated: October 26, 2025",
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 20),
            Text(
              "Privacy Policy",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "At EGX App, we value your privacy and are committed to protecting your personal information. "
              "This Privacy Policy explains how we collect, use, and protect your data when you use our services.",
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            buildSection(
              "1. Information We Collect",
              "We may collect information such as your name, email address, portfolio preferences, "
                  "and usage activity within the app to enhance your experience.",
              theme: theme,
            ),
            buildSection(
              "2. How We Use Your Information",
              "Your data helps us provide personalized content, improve app performance, "
                  "and ensure security of your account.",
              theme: theme,
            ),
            buildSection(
              "3. Data Protection",
              "We use secure encryption and authentication methods to protect your data. "
                  "Your information is not shared with third parties without your consent.",
              theme: theme,
            ),
            buildSection(
              "4. Third-Party Services",
              "We may integrate with trusted services like Firebase or analytics tools "
                  "for performance tracking and crash reporting.",
              theme: theme,
            ),
            buildSection(
              "5. Your Rights",
              "You have the right to access, modify, or delete your data. "
                  "You can request this via the app settings or contact support.",
              theme: theme,
            ),
            buildSection(
              "6. Updates to This Policy",
              "We may update this Privacy Policy from time to time. "
                  "All changes will be reflected here with a new 'Last Updated' date.",
              theme: theme,
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "© 2025 EGX App. All rights reserved.",
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

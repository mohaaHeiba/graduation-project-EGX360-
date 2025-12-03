import 'package:egx/core/custom/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/build_section.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColorPrimary = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final textColorSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final hintColor = theme.textTheme.bodySmall?.color ?? Colors.grey.shade400;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: customAppbar(() => Get.back(), 'How to use EGX360'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Learn how to explore EGX360 features effectively.",
              style: TextStyle(color: hintColor, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Text(
              "How to Use EGX360",
              style: TextStyle(
                color: textColorPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "EGX360 is designed to give you real-time market data and analytics. "
              "Follow these steps to maximize your experience:",
              style: TextStyle(color: textColorSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            buildSection(
              "1. Explore Markets",
              "Navigate through indices, sectors, and stocks using the bottom menu and search bar.",
              theme: theme,
            ),
            buildSection(
              "2. Real-Time Data",
              "Access live market prices, volume, and historical trends for informed decision-making.",
              theme: theme,
            ),
            buildSection(
              "3. Portfolio Management",
              "Track your investments, create watchlists, and get alerts on price movements.",
              theme: theme,
            ),
            buildSection(
              "4. Analysis Tools",
              "Use charts, indicators, and AI insights to analyze market patterns.",
              theme: theme,
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "© 2025 EGX App. All rights reserved.",
                style: TextStyle(color: hintColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/features/settings/presentaion/widgets/app_settings_widgets/build_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataSourcesPage extends StatelessWidget {
  const DataSourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppbar(() => Get.back(), 'Data Sources'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Understand where EGX360 gets its market data.",
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 20),
            Text(
              "Data Sources",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "EGX360 aggregates data from reliable and trusted sources to provide accurate market insights.",
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),

            // ===== Sections =====
            buildSection(
              "1. TradingView (TDV)",
              "We fetch real-time stock quotes, indices, and trading volumes from TradingView via TDV and store them securely in our cloud for fast access.",
              theme: theme,
            ),
            buildSection(
              "2. Gold Local Prices",
              "We scrape local gold prices from trusted sources to provide accurate and up-to-date pricing for investors.",
              theme: theme,
            ),
            buildSection(
              "3. Historical Market Data",
              "Access past stock and index data for analysis, charting, and backtesting.",
              theme: theme,
            ),
            buildSection(
              "4. Financial News",
              "Aggregated news from verified financial and economic outlets to keep you updated with market events.",
              theme: theme,
            ),
            buildSection(
              "5. Third-Party APIs",
              "Integrations with trusted APIs provide analytics, charts, and additional market information.",
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

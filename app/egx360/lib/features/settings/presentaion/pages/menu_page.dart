import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/settings/presentaion/controller/settings_controller.dart';
import 'package:egx/features/settings/presentaion/widgets/ProfileWidgets/build_profile_card.dart';
import 'package:egx/features/settings/presentaion/widgets/ProfileWidgets/build_simulation_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuPage extends GetView<SettingsController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;
    final gradients = context.gradients;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: theme.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 80,

        // 🔹 Left Button (Notifications)
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 0.0),
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Navigate to notifications
              },
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),

        // 🔹 Title
        title: ShaderMask(
          shaderCallback: (bounds) => gradients.logo.createShader(bounds),
          child: Text(
            "EGX360",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
              fontSize: 34,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,

        // 🔹 Right Button (Settings)
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 18.0),
              decoration: BoxDecoration(
                color: theme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: controller.goToSettingsPage,
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),

      // 🔹 Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final user = controller.currentUser.value;
              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return ProfileCard(currentUser: user);
            }),
            AppGaps.h12,
            buildSimulationCard(context),
          ],
        ),
      ),
    );
  }
}

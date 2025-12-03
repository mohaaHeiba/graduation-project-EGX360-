import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/custom/background/custom_background.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/welcome/presentaion/controller/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egx/core/constants/app_colors.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;
    final gradients = context.gradients;
    final s = context.s;

    // Get themed gradients

    return Scaffold(
      body: Stack(
        children: [
          // Custom Background
          customBackground(context),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                AppGaps.h40,
                AppGaps.h20,

                // Logo and Title Section
                FadeTransition(
                  opacity: controller.fadeAnimation,
                  child: SlideTransition(
                    position: controller.slideAnimation,
                    child: Column(
                      children: [
                        // App Name with Gradient & Glow
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              gradients.logo.createShader(bounds),
                          child: Text(
                            s.appTitle,
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 3,
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

                        AppGaps.h4,

                        // Tagline
                        Text(
                          "Egyptian Stock Exchange",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary.withOpacity(0.9),
                            letterSpacing: 2.5,
                          ),
                        ),
                      ],
                    ),
                    // child: Image.asset('assets/images/logo.png'),
                  ),
                ),

                const Spacer(),

                // Buttons Section
                FadeTransition(
                  opacity: controller.fadeAnimation,
                  child: Column(
                    children: [
                      //Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.goAuth();
                          },
                          child: Text(
                            s.get_started,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                      ),

                      AppGaps.h24,

                      // Terms & Privacy
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          s.policy_agreement,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.onBackground.withOpacity(0.5),
                            height: 1.5,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                AppGaps.h40,
                AppGaps.h8,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';

import 'package:egx/core/custom/background/custom_background.dart';
import 'package:egx/features/auth/presentaion/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationPage extends GetView<AuthController> {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Get.arguments;
    final appTheme = context;
    final s = context.s;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: customBackground(context)),
          Center(
            child: controller.isVerified.value
                ? Icon(Icons.check_circle, color: appTheme.primary, size: 80)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: appTheme.primary),
                      AppGaps.h24,
                      Text(
                        s.email_verification_sent(email),
                        textAlign: TextAlign.center,
                        style: appTheme.textTheme.bodyLarge?.copyWith(
                          color: appTheme.onBackground,
                        ),
                      ),
                      AppGaps.h12,
                      Text(
                        s.email_verification_message,
                        textAlign: TextAlign.center,
                        style: appTheme.textTheme.bodyMedium?.copyWith(
                          color: appTheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

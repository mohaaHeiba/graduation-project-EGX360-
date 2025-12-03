import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';

import 'package:egx/core/custom/text_form_fileds_widget.dart';
import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/utils/validator.dart';
import 'package:egx/features/auth/presentaion/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context;
    final s = context.s;
    final validator = Validator();

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.lock_reset_rounded,
                color: appTheme.primary,
                size: AppGaps.screenWidth(context) * 0.18,
              ),
              AppGaps.h24,
              Text(
                s.forgot_password,
                textAlign: TextAlign.center,
                style: appTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: appTheme.onBackground,
                ),
              ),
              AppGaps.h12,
              Text(
                s.forgot_description,
                textAlign: TextAlign.center,
                style: appTheme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.onSurface.withOpacity(0.8),
                ),
              ),
              AppGaps.h40,

              /// 🔹 Email Field
              textFieldWidget(
                controller: controller.emailController,
                hint: s.email_label,
                icon: Icons.email_outlined,
                inputType: TextInputType.emailAddress,
                validator: (value) =>
                    validator.validateEmail(value ?? '', context),
              ),
              AppGaps.h24,

              /// 🔹 Send Reset Link
              Obx(
                () => SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                    ),
                    onPressed: controller.isLoding.value
                        ? null
                        : () async {
                            if (controller.formKey.currentState!.validate()) {
                              controller.isLoding.value = true;
                              await controller.resetPassword();
                              controller.isLoding.value = false;
                            }
                          },
                    child: controller.isLoding.value
                        ? CircularProgressIndicator(color: appTheme.onPrimary)
                        : Text(
                            s.forgot_send_link,
                            style: appTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.background,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ),
              AppGaps.h24,

              /// 🔹 Back to Login
              Center(
                child: GestureDetector(
                  onTap: controller.backfromForgotPass,
                  child: RichText(
                    text: TextSpan(
                      text: s.forgot_remember,
                      style: appTheme.textTheme.bodyMedium?.copyWith(
                        color: appTheme.onSurface.withOpacity(0.7),
                      ),
                      children: [
                        TextSpan(
                          text: s.register_login,
                          style: appTheme.textTheme.bodyMedium?.copyWith(
                            color: appTheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

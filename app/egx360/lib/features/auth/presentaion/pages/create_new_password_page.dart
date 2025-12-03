import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/core/custom/text_form_fileds_widget.dart';
import 'package:egx/core/utils/validator.dart';
import 'package:egx/features/auth/presentaion/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';

class CreateNewPasswordPage extends GetView<AuthController> {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context;
    final s = context.s;
    final validator = Validator();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 Header Icon
          Icon(
            Icons.lock_reset_rounded,
            color: appTheme.primary,
            size: AppGaps.screenWidth(context) * 0.18,
          ),
          AppGaps.h24,

          // 🔹 Title
          Text(
            s.create_password_title,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppGaps.h12,

          // 🔹 Description
          Text(
            s.create_password_description,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.bodyMedium?.copyWith(
              color: appTheme.textTheme.bodyMedium?.color?.withOpacity(0.8),
            ),
          ),
          AppGaps.h40,

          // 🔹 New Password
          textFieldPasswordWidget(
            controller: controller.passController,
            hint: s.create_password_new,
            icon: Icons.lock_outline,
            isObsure: controller.isPasswordObscure,
            validator: (value) =>
                validator.validatePassword(value ?? '', context),
          ),
          AppGaps.h18,

          // 🔹 Confirm New Password
          textFieldPasswordWidget(
            controller: controller.confirmPassController,
            hint: s.confirmPassword,
            icon: Icons.lock_outline,
            isObsure: controller.isConfirmPasswordObscure,
            validator: (value) => validator.validateConfirmPassword(
              controller.passController.text,
              controller.confirmPassController.text,
              context,
            ),
          ),
          AppGaps.h24,

          // 🔹 Submit button
          SizedBox(
            height: 54,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoding.value
                    ? null
                    : () async {
                        if (controller.formKey.currentState!.validate()) {
                          final newPassword = controller.passController.text
                              .trim();
                          await controller.updatePassword(newPassword);
                        }
                      },
                child: controller.isLoding.value
                    ? CircularProgressIndicator(color: appTheme.onPrimary)
                    : Text(
                        s.create_password_update_button,
                        style: appTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.background,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ),
          AppGaps.h32,

          // 🔹 Back to Login
          Center(
            child: GestureDetector(
              onTap: controller.goToLogin,
              child: RichText(
                text: TextSpan(
                  text: s.create_password_remember,
                  style: appTheme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.textTheme.bodyMedium?.color?.withOpacity(
                      0.7,
                    ),
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
    );
  }
}

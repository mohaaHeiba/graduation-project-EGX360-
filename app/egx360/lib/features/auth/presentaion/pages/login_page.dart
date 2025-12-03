import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/constants/app_images.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/core/custom/text_form_fileds_widget.dart';
import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/utils/validator.dart';
import 'package:egx/features/auth/presentaion/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

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
          // 🔹 Logo / Header
          Icon(
            Icons.lock_outline_rounded,
            color: appTheme.primary,
            size: AppGaps.screenWidth(context) * 0.18,
          ),
          AppGaps.h24,

          Text(
            s.welcome_title,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.headlineSmall?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: appTheme.onBackground,
            ),
          ),
          AppGaps.h12,

          Text(
            s.welcome_subtitle,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: appTheme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          AppGaps.h40,

          // 🔹 Email field
          textFieldWidget(
            controller: controller.emailController,
            hint: s.email_label,
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            validator: (value) => validator.validateEmail(value ?? '', context),
          ),
          AppGaps.h18,

          // 🔹 Password field
          textFieldPasswordWidget(
            controller: controller.passController,
            hint: s.password_label,
            icon: Icons.lock_outline,
            isObsure: controller.isPasswordObscure,
            validator: (value) =>
                validator.validatePassword(value ?? '', context),
          ),

          // 🔹 Forgot Password? link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.goToForgotPass,
              child: Text(
                s.forgot_password,
                style: appTheme.textTheme.bodySmall?.copyWith(
                  color: appTheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: appTheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          AppGaps.h12,

          // 🔹 Log In button
          SizedBox(
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
              ),
              onPressed: () async {
                if (controller.formKey.currentState!.validate()) {
                  controller.isLoding.value = !controller.isLoding.value;
                  await controller.signIn(
                    email: controller.emailController.text,
                    password: controller.passController.text,
                  );
                  controller.isLoding.value = !controller.isLoding.value;
                }
              },
              child: Center(
                child: Obx(
                  () => controller.isLoding.value
                      ? CircularProgressIndicator(color: appTheme.onPrimary)
                      : Text(
                          s.auth_sign_in,
                          style: appTheme.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.background,
                          ),
                        ),
                ),
              ),
            ),
          ),
          AppGaps.h32,

          // 🔹 Divider
          Row(
            children: [
              Expanded(child: Divider(color: appTheme.surface, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  s.continue_with,
                  style: appTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: appTheme.textTheme.bodySmall?.color?.withOpacity(
                      0.8,
                    ),
                  ),
                ),
              ),
              Expanded(child: Divider(color: appTheme.surface, thickness: 1)),
            ],
          ),
          AppGaps.h24,

          // 🔹 Google Sign-In Button
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: controller.googleSignIn,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: appTheme.onSurface.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: appTheme.onSurface.withOpacity(0.08),
              ),
              icon: Image.asset(AppImages.logoGoogle, height: 24, width: 24),
              label: Text(
                s.sign_google,
                style: appTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),

          AppGaps.h24,

          // 🔹 Sign Up Link
          Center(
            child: GestureDetector(
              onTap: controller.goToRegister,
              child: RichText(
                text: TextSpan(
                  text: "${s.create_account}? ",
                  style: appTheme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.textTheme.bodyMedium?.color?.withOpacity(
                      0.85,
                    ),
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: s.auth_sign_up,
                      style: TextStyle(
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

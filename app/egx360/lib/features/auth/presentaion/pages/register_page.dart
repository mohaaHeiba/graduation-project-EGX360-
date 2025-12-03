import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/core/custom/text_form_fileds_widget.dart';
import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/utils/validator.dart';
import 'package:egx/features/auth/presentaion/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

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
            Icons.person_add_alt_1_rounded,
            color: appTheme.primary.withOpacity(0.9),
            size: AppGaps.screenWidth(context) * 0.18,
          ),
          AppGaps.h24,

          // 🔹 Title
          Text(
            s.auth_sign_up,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: appTheme.onBackground,
            ),
          ),
          AppGaps.h12,

          // 🔹 Description
          Text(
            s.register_description,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.bodyMedium?.copyWith(
              color: appTheme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          AppGaps.h40,

          // 🔹 Full Name
          textFieldWidget(
            controller: controller.nameController,
            hint: s.name_label,
            icon: Icons.person_outline,
            validator: (value) => validator.validateName(value ?? '', context),
          ),
          AppGaps.h18,

          // 🔹 Email
          textFieldWidget(
            controller: controller.emailController,
            hint: s.email_label,
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            validator: (value) => validator.validateEmail(value ?? '', context),
          ),
          AppGaps.h18,

          // 🔹 Password
          textFieldPasswordWidget(
            controller: controller.passController,
            hint: s.password_label,
            icon: Icons.lock_outline,
            isObsure: controller.isPasswordObscure,
            validator: (value) =>
                validator.validatePassword(value ?? '', context),
          ),
          AppGaps.h18,

          // 🔹 Confirm Password
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

          // 🔹 Sign Up button
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () async {
                if (controller.formKey.currentState!.validate()) {
                  controller.isLoding.value = !controller.isLoding.value;

                  await controller.signUp(
                    controller.nameController.text,
                    controller.emailController.text,
                    controller.passController.text,
                  );
                  controller.isLoding.value = !controller.isLoding.value;
                }
              },
              child: Ink(
                child: Center(
                  child: Obx(
                    () => controller.isLoding.value
                        ? CircularProgressIndicator(color: appTheme.onPrimary)
                        : Text(
                            s.auth_sign_up,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.background,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          AppGaps.h32,

          // 🔹 Already have an account
          Center(
            child: GestureDetector(
              onTap: controller.goToLogin,
              child: RichText(
                text: TextSpan(
                  text: s.register_have_account,
                  style: appTheme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.textTheme.bodyMedium?.color?.withOpacity(
                      0.85,
                    ),
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: s.register_login,
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

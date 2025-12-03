import 'package:egx/core/custom/background/custom_background.dart';
import 'package:egx/features/auth/presentaion/controller/auth_controller.dart';
import 'package:egx/features/auth/presentaion/pages/create_new_password_page.dart';
import 'package:egx/features/auth/presentaion/pages/forgot_password_page.dart';
import 'package:egx/features/auth/presentaion/pages/login_page.dart';
import 'package:egx/features/auth/presentaion/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom / 1.4;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: controller.formKey,
        child: Stack(
          children: [
            customBackground(context),

            AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: keyboardSpace),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pagecontroller,
                onPageChanged: controller.onPageChanged,
                children: const [
                  LoginPage(),
                  RegisterPage(),
                  ForgotPasswordPage(),
                  CreateNewPasswordPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:egx/core/custom/custom_snackbar.dart';
import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/routes/app_pages.dart';
import 'package:egx/core/errors/app_exception.dart';
import 'package:egx/core/services/network_service.dart';

import 'package:egx/features/auth/domain/repository/auth_repository.dart';
import 'package:egx/features/auth/presentaion/pages/email_verification_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final supabase = Supabase.instance.client;

  //
  //------------------ Page View & Navigation ------------------
  //
  final PageController pagecontroller = PageController(initialPage: 0);
  final currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> goToRegister() async {
    pagecontroller.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    await clearControllers();
  }

  Future<void> goToLogin() async {
    pagecontroller.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    await clearControllers();
  }

  Future<void> goToForgotPass() async {
    currentPage.value = 0;
    await Future.delayed(const Duration(milliseconds: 100));
    pagecontroller.jumpToPage(2);
    await clearControllers();
  }

  Future<void> backfromForgotPass() async {
    await Future.delayed(const Duration(milliseconds: 100));
    pagecontroller.jumpToPage(0);
    await clearControllers();
  }

  Future<void> goToNewPass() async {
    await Future.delayed(const Duration(milliseconds: 100));
    pagecontroller.jumpToPage(3);
    await clearControllers();
  }

  Future<void> backToLogin() async {
    await Future.delayed(const Duration(milliseconds: 100));
    pagecontroller.jumpToPage(0);
    await clearControllers();
  }

  //
  //------------------ Form Variables ------------------
  //
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  // Settings Controllers
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  final isPasswordObscure = true.obs;
  final isConfirmPasswordObscure = true.obs;
  final isLoding = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //
  //------------------ Email Verification Logic (Fixed) ------------------
  //
  final isVerified = false.obs;

  //
  //------------------ Auth Functions ------------------
  //

  Future<void> signUp(String name, String email, String password) async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkAppException('No internet connection.');
      }

      isLoding.value = true;

      await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
      );

      customSnackbar(
        title: 'Account Created Successfully!',
        message: 'A verification link has been sent to your email.',
        color: AppColors.success,
      );

      // startVerificationTimer();

      Get.off(
        () => EmailVerificationPage(),
        arguments: email,
        transition: Transition.fadeIn,
      );
    } on NetworkAppException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection.',
        color: AppColors.error,
      );
    } on UserAlreadyExistsException {
      customSnackbar(
        title: 'Email Already Registered',
        message: 'This email is already in use.',
        color: AppColors.warning,
      );
    } on AuthAppException catch (e) {
      customSnackbar(
        title: 'Signup Error',
        message: e.message,
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong.',
        color: AppColors.error,
      );
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkAppException('No internet connection.');
      }

      isLoding.value = true;

      await _authRepository.signIn(email: email, password: password);

      customSnackbar(
        title: 'Welcome Back',
        message: 'You’ve signed in successfully!',
        color: AppColors.success,
      );

      // Navigation handled by onInit listener usually, but can be forced here
    } on MissingDataException {
      customSnackbar(
        title: 'Invalid Credentials',
        message: 'Incorrect email or password.',
        color: AppColors.warning,
      );
    } on NetworkAppException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection.',
        color: AppColors.error,
      );
    } on AuthAppException catch (e) {
      customSnackbar(
        title: 'Sign-in Error',
        message: e.message,
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong.',
        color: AppColors.error,
      );
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> googleSignIn() async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkAppException('No internet connection.');
      }

      isLoding.value = true;

      await _authRepository.googleSignIn();

      customSnackbar(
        title: 'Welcome!',
        message: 'Signed in successfully with Google.',
        color: AppColors.success,
      );
    } on NetworkAppException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection.',
        color: AppColors.error,
      );
    } on GoogleSignInCancelledException {
      // customSnackbar(
      //   title: 'Cancelled',
      //   message: 'Google sign-in was cancelled by you.',
      //   color: AppColors.warning,
      // );
    } on AuthAppException catch (e) {
      customSnackbar(
        title: 'Sign-in Error',
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong.',
        color: AppColors.error,
      );
    } finally {
      isLoding.value = false;
    }
  }

  //
  //------------------ Password Reset & Settings ------------------
  //

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkAppException('No internet connection.');
      }

      isLoding.value = true;

      await _authRepository.resetPassword(email);

      customSnackbar(
        title: 'Email Sent',
        message: 'A password reset link has been sent to your email.',
        color: AppColors.success,
      );
      emailController.clear();
    } on UserNotFoundException {
      customSnackbar(
        title: 'User Not Found',
        message: 'No account found with this email.',
        color: AppColors.error,
      );
    } on NetworkAppException {
      customSnackbar(
        title: 'No Internet',
        message: 'Please check your connection.',
        color: AppColors.warning,
      );
    } on AuthAppException catch (e) {
      customSnackbar(
        title: 'Error',
        message: e.message,
        color: AppColors.error,
      );
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      isLoding.value = true;
      await _authRepository.updatePassword(newPassword);

      customSnackbar(
        title: 'Password Updated',
        message: 'Your password has been changed successfully.',
        color: AppColors.success,
      );

      backToLogin();
    } on AuthAppException catch (e) {
      customSnackbar(
        title: 'Error',
        message: e.message,
        color: AppColors.error,
      );
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> changePassword() async {
    try {
      final email =
          supabase.auth.currentUser?.email ?? emailController.text.trim();

      await _authRepository.changePassword(
        email: email,
        oldPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      customSnackbar(
        title: 'Password Updated',
        message: 'Your password has been changed successfully.',
        color: AppColors.success,
      );

      oldPasswordController.clear();
      newPasswordController.clear();
    } on AuthInvalidCredentialsException {
      customSnackbar(
        title: 'Invalid Password',
        message: 'The current password you entered is incorrect.',
        color: AppColors.warning,
      );
    } on NetworkAppException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection.',
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Failed to change password.',
        color: AppColors.error,
      );
    }
  }

  Future<void> logout() async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkAppException('No internet connection.');
      }

      await _authRepository.logout();
      GetStorage().write('loginBefore', false);
      Get.offAllNamed(AppPages.welcomePage);

      customSnackbar(
        title: 'Logged Out',
        message: 'You have been logged out successfully.',
        color: AppColors.success,
      );
    } on NetworkAppException catch (e) {
      customSnackbar(
        title: 'No Connection',
        message: e.message,
        color: AppColors.warning,
      );
    } on AuthAppException catch (e) {
      customSnackbar(
        title: 'Logout Failed',
        message: e.message,
        color: AppColors.error,
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const UserNotFoundException('No user is currently logged in.');
      }

      await _authRepository.deleteAccount(userId);
      GetStorage().write('loginBefore', false);
      Get.offAllNamed(AppPages.welcomePage);

      customSnackbar(
        title: 'Account Deleted',
        message: 'Your account has been permanently removed.',
        color: AppColors.success,
      );
    } on NetworkAppException catch (e) {
      customSnackbar(
        title: 'No Connection',
        message: e.message,
        color: AppColors.warning,
      );
    } on AuthAppException catch (e) {
      customSnackbar(
        title: 'Deletion Failed',
        message: e.message,
        color: AppColors.error,
      );
    }
  }

  //
  //------------------ Lifecycle & Init ------------------
  //

  @override
  void onInit() {
    super.onInit();

    // Listener for Auth State Changes (Supabase Magic)
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final user = data.session?.user;

      if (event == AuthChangeEvent.passwordRecovery) {
        goToNewPass();
        return;
      }

      if (event == AuthChangeEvent.signedIn && user != null) {
        if (user.emailConfirmedAt != null) {
          GetStorage().write('loginBefore', true);
          Get.offAllNamed(AppPages.layoutPage);
        }
      }
    });
  }

  Future<void> clearControllers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    nameController.clear();
    emailController.clear();
    passController.clear();
    confirmPassController.clear();
    isPasswordObscure.value = true;
    isConfirmPasswordObscure.value = true;
  }

  @override
  void onClose() {
    // _timer?.cancel();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}

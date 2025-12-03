import 'dart:io';

import 'package:egx/core/custom/custom_snackbar.dart';
import 'package:egx/core/data/init_local_data.dart';
import 'package:egx/core/errors/app_exception.dart';
import 'package:egx/core/routes/app_pages.dart';
import 'package:egx/core/services/network_service.dart';
import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/services/media_service.dart';

import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/features/auth/data/model/auth_model.dart';
import 'package:egx/features/auth/domain/repository/auth_repository.dart';
import 'package:egx/features/settings/presentaion/widgets/PagesForAppSettings/about_egx360/show_license_page.dart';
import 'package:egx/features/settings/presentaion/controller/theme_controller.dart';
import 'package:flutter/foundation.dart' show LicenseParagraph, LicenseRegistry;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum ThemeModeSelection { light, dark, system }

class SettingsController extends GetxController {
  final AuthRepository _authRepository;
  final MediaService _mediaService;

  SettingsController({
    required AuthRepository authRepository,
    required MediaService mediaService,
  }) : _authRepository = authRepository,
       _mediaService = mediaService;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final supabase = Supabase.instance.client;

  final Rx<AuthEntity?> currentUser = Rx<AuthEntity?>(null);

  final PageController pagecontroller = PageController(initialPage: 0);
  final RxInt currentPage = 0.obs;

  void onPageChange(int index) => currentPage.value = index;

  Future<void> goToSettingsPage() async => pagecontroller.animateToPage(
    1,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  Future<void> backToProfilePage() async => pagecontroller.animateToPage(
    0,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final emailController = TextEditingController();

  void getDataUser() {
    if (currentUser.value == null) return;
    nameController.text = currentUser.value!.name;
    bioController.text = currentUser.value?.bio ?? '';
    emailController.text = currentUser.value!.email;
  }

  Future<void> updateDataUser() async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkAppException('No internet connection.');
      }

      final updateUser = AuthModel(
        id: currentUser.value!.id,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim(),
        avatarUrl: currentUser.value?.avatarUrl,
        lastActiveAtDate: DateTime.now(),
        createdAtDate: currentUser.value!.createdAt != null
            ? DateTime.tryParse(currentUser.value!.createdAt!)
            : DateTime.now(),
        updatedAtDate: DateTime.now(),
      );

      await _authRepository.updateUserData(updateUser);

      currentUser.value = updateUser;

      customSnackbar(
        title: 'Success',
        message: 'Your profile has been updated successfully!',
        color: AppColors.success,
      );
    } on NetworkAppException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection.',
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong.',
        color: AppColors.error,
      );
    }
  }

  Future<void> pickImage() async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkAppException('No internet connection.');
      }

      final XFile? image = await _mediaService.pickFromGalleryAsWebP();

      if (image == null) {
        return;
      }

      String avatarUrl;
      try {
        final fileName = 'avatars/${currentUser.value!.id}_Profile.webp';
        await supabase.storage
            .from('avatars')
            .upload(
              fileName,
              File(image.path),
              fileOptions: const FileOptions(upsert: true),
            );

        avatarUrl = supabase.storage.from('avatars').getPublicUrl(fileName);
        avatarUrl = '$avatarUrl?ts=${DateTime.now().millisecondsSinceEpoch}';
      } on StorageException catch (e) {
        throw Exception('Failed to upload image: ${e.message}');
      }

      final userEntity = currentUser.value!;
      final tempUser = AuthModel(
        id: userEntity.id,
        name: userEntity.name,
        email: userEntity.email,
        avatarUrl: avatarUrl,
        bio: userEntity.bio,
        lastActiveAtDate: DateTime.now(),
        createdAtDate: userEntity.createdAt != null
            ? DateTime.tryParse(userEntity.createdAt!)
            : DateTime.now(),
        updatedAtDate: DateTime.now(),
      );

      currentUser.value = tempUser;

      await _authRepository.updateUserData(tempUser);

      customSnackbar(
        title: 'Success',
        message: 'Profile picture updated successfully!',
        color: AppColors.success,
      );
    } on NetworkAppException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection.',
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: 'Error',
        message: 'Failed to update image.',
        color: AppColors.error,
      );
    }
  }

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

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
    } catch (e) {
      customSnackbar(
        title: 'Error',
        message: 'Logout failed.',
        color: AppColors.error,
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (currentUser.value == null) {
        throw const UserNotFoundException('No user is currently logged in.');
      }

      await _authRepository.deleteAccount(currentUser.value!.id);

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
    } catch (e) {
      customSnackbar(
        title: 'Error',
        message: 'Account deletion failed.',
        color: AppColors.error,
      );
    }
  }

  Future<void> openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@egx360.com',
      query: 'subject=EGX360 Support Request',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      customSnackbar(
        title: 'Error',
        message: 'Unable to open email app.',
        color: AppColors.error,
      );
    }
  }

  final RxString selectedLang = 'en'.obs;

  void onLangSelected(String code) {
    selectedLang.value = code;
  }

  void applyLanguage() {
    final themeController = Get.find<ThemeController>();
    if (selectedLang.value == 'ar') {
      themeController.selectLanguage(LanguageSelection.arabic);
    } else {
      themeController.selectLanguage(LanguageSelection.english);
    }
  }

  String getLangName(String code) {
    return switch (code) {
      'ar' => 'Arabic',
      _ => 'English',
    };
  }

  Future<LicenseData> loadLicenses() async {
    final packages = <String, List<LicenseParagraph>>{};
    await Future.delayed(const Duration(seconds: 1));
    await for (final license in LicenseRegistry.licenses) {
      for (final package in license.packages) {
        packages.putIfAbsent(package, () => []);
        packages[package]!.addAll(license.paragraphs.toList());
      }
    }
    return LicenseData(packages);
  }

  @override
  void onInit() {
    super.onInit();

    final initData = Get.find<InitLocalData>();

    currentUser.value = initData.currentUser.value;
    getDataUser();

    ever(initData.currentUser, (user) {
      currentUser.value = user;
      getDataUser();
    });

    try {
      final themeController = Get.find<ThemeController>();
      if (themeController.selectedLanguage.value == LanguageSelection.arabic) {
        selectedLang.value = 'ar';
      } else {
        selectedLang.value = 'en';
      }
    } catch (_) {}
  }
}

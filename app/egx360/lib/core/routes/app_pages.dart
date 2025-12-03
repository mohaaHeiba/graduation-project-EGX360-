import 'package:egx/core/Layout/main_layout.dart';
import 'package:egx/core/bindings/auth_bindings.dart';
import 'package:egx/core/bindings/community_bindings.dart';
import 'package:egx/core/bindings/layout_bindings.dart';
import 'package:egx/core/bindings/post_details_binding.dart';
import 'package:egx/core/bindings/profile_bindings.dart';
import 'package:egx/core/bindings/settings_bindings.dart';
import 'package:egx/core/bindings/welcome_bindings.dart';
import 'package:egx/features/auth/presentaion/pages/auth_page.dart';
import 'package:egx/features/auth/presentaion/pages/create_new_password_page.dart';
import 'package:egx/features/auth/presentaion/pages/forgot_password_page.dart';
import 'package:egx/features/community/presentation/pages/community_page.dart';
import 'package:egx/features/post_details/presentation/page/post_details_page.dart';
import 'package:egx/features/profile/presentations/page/profile_page.dart';
import 'package:egx/features/profile/presentations/page/user_profile_page.dart';
import 'package:egx/features/profile/presentations/page/followers_following_page.dart';
import 'package:egx/features/welcome/presentaion/page/welcome_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppPages {
  static const welcomePage = '/welcome';
  static const authPage = '/auth';
  static const homePage = '/home';
  static const forgotPassPage = '/forgotPass';
  static const createNewPassPage = '/newPass';

  static const layoutPage = '/loyoutPage';

  static const profilePage = '/profile';
  static const userProfilePage = '/user_profile'; // New route
  static const followersFollowingPage = '/followers_following';
  static const communityPage = '/community';
  static const showDetailsPage = '/showDetailsPage';

  static List<GetPage> routes = [
    // welcome
    GetPage(
      name: welcomePage,
      page: () => const WelcomePage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 700),
      binding: WelcomeBindings(),
    ),
    // Auth
    GetPage(
      name: authPage,
      page: () => AuthPage(),
      transition: Transition.fadeIn,
      binding: AuthBindings(),
    ),
    GetPage(
      name: forgotPassPage,
      page: () => ForgotPasswordPage(),
      transition: Transition.fadeIn,
      binding: AuthBindings(),
    ),
    GetPage(
      name: createNewPassPage,
      page: () => CreateNewPasswordPage(),
      transition: Transition.fadeIn,
      binding: AuthBindings(),
    ),
    // layout
    GetPage(
      name: layoutPage,
      page: () => MainLayout(),
      transition: Transition.fadeIn,
      bindings: [LayoutBindings(), SettingsBinding(), CommunityBindings()],
    ),
    // show post
    GetPage(
      name: showDetailsPage,
      page: () => PostDetailsPage(),
      transition: Transition.fadeIn,
      binding: PostDetailsBinding(),
    ),

    //////////////////////////////
    GetPage(
      name: profilePage,
      page: () => const ProfilePage(),
      binding: ProfileBindings(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    ),
    GetPage(
      name: userProfilePage,
      page: () => const UserProfilePage(),
      binding: ProfileBindings(), // Reuse ProfileBindings
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: followersFollowingPage,
      page: () => const FollowersFollowingPage(),
      binding: ProfileBindings(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: communityPage,
      page: () => const CommunityPage(),
      binding: CommunityBindings(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}

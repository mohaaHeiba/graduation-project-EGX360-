import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/features/profile/presentations/controller/view_profile_controller.dart';
import 'package:egx/features/profile/presentations/widgets/profile_page.dart/build_action_buttons.dart';
import 'package:egx/features/profile/presentations/widgets/profile_page.dart/build_bio_section.dart';
import 'package:egx/features/profile/presentations/widgets/profile_page.dart/build_header.dart';
import 'package:egx/features/profile/presentations/widgets/profile_page.dart/build_posts_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePage extends GetView<ViewProfileController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthEntity? argUser = Get.arguments as AuthEntity?;

    if (argUser == null) {
      return const Scaffold(body: Center(child: Text("User not found")));
    }

    // Initialize data for the viewed user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadViewedUser(argUser.id);
    });

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: customAppbar(Get.back, "Profile"),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadViewedUser(argUser.id);
        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pass the argument user initially, but widget should observe controller.userProfile
                        buildHeader(controller, argUser, context),
                        AppGaps.h4,
                        buildBioSection(controller, argUser, context),
                        AppGaps.h16,
                        buildActionButtons(controller, argUser, context),
                        AppGaps.h12,
                        Divider(color: Colors.grey.withOpacity(0.2)),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (BuildContext context) {
              return buildPostsList(
                controller,
                context,
                posts: controller.userPosts,
                isViewedPost: true,
              );
            },
          ),
        ),
      ),
    );
  }
}

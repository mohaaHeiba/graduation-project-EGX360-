import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/features/profile/presentations/controller/profile_controller.dart';
import 'package:egx/features/profile/presentations/page/create_post_sheet.dart';
import 'package:egx/features/profile/presentations/widgets/profile_page.dart/build_action_buttons.dart';
import 'package:egx/features/profile/presentations/widgets/profile_page.dart/build_bio_section.dart';
import 'package:egx/features/profile/presentations/widgets/profile_page.dart/build_header.dart';
import 'package:egx/features/profile/presentations/widgets/profile_page.dart/build_posts_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthEntity? argUser = Get.arguments as AuthEntity?;

    final AuthEntity? displayUser = argUser ?? controller.userProfile.value;

    final theme = context;

    if (displayUser == null) {
      return Scaffold(
        backgroundColor: theme.background,
        appBar: customAppbar(Get.back, "Profile"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.background,
      appBar: customAppbar(Get.back, "Profile"),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const CreatePostPage(), arguments: displayUser),
        backgroundColor: theme.primary,
        mini: true,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: RefreshIndicator(
        onRefresh: () => controller.loadFullData(),
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
                        buildHeader(controller, displayUser, context),
                        AppGaps.h4,
                        buildBioSection(controller, displayUser, context),
                        AppGaps.h16,
                        buildActionButtons(controller, displayUser, context),
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
              );
            },
          ),
        ),
      ),
    );
  }
}

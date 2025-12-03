import 'package:cached_network_image/cached_network_image.dart';
import 'package:egx/core/routes/app_pages.dart';
import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/features/profile/presentations/controller/follow_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListItem extends StatelessWidget {
  final AuthEntity user;
  final FollowListController controller;

  const UserListItem({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isMe = user.id == controller.currentUserId;

    return ListTile(
      onTap: () {
        if (isMe) {
          // Navigate to own profile (ProfilePage)
          // But usually we are already in ProfilePage or can just go back
          // Or navigate to main profile tab
          // For now, let's navigate to UserProfilePage but it handles "isMe" logic too
          Get.toNamed(AppPages.userProfilePage, arguments: user);
        } else {
          Get.toNamed(AppPages.userProfilePage, arguments: user);
        }
      },
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: CachedNetworkImageProvider(user.avatarUrl ?? ''),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: user.bio != null && user.bio!.isNotEmpty
          ? Text(
              user.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            )
          : null,
      trailing: isMe
          ? null
          : Obx(() {
              final isFollowing = controller.isFollowingMap[user.id] ?? false;
              final isToggling = controller.isTogglingMap[user.id] ?? false;

              return SizedBox(
                height: 32,
                width: 100,
                child: ElevatedButton(
                  onPressed: isToggling
                      ? null
                      : () => controller.toggleFollow(user.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing
                        ? Colors.grey[300]
                        : Theme.of(context).primaryColor,
                    foregroundColor: isFollowing ? Colors.black : Colors.white,
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isToggling
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          isFollowing ? "Following" : "Follow",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            }),
    );
  }
}

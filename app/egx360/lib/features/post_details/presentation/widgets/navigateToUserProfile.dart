import 'package:flutter/material.dart';

// void navigateToUserProfile(post) {
//   final userEntity = AuthEntity(
//     id: post.userId,
//     name: post.userName ?? "User",
//     email: '',
//     avatarUrl: post.userAvatar,
//   );
//   Get.toNamed(AppPages.profilePage, arguments: userEntity);
// }

class ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback? onTap;
  final bool isActive;

  const ActionButton({
    super.key,
    required this.icon,
    required this.count,
    required this.color,
    this.onTap,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Your imports
import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/core/routes/app_pages.dart';
import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/features/profile/domain/entity/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final int index;
  final dynamic controller;

  const PostCard({
    super.key,
    required this.post,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => controller.navigateToPostDetails(post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.onSurface.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: User Info (Left) + Sentiment (Right)
            _buildHeader(context, theme),

            // 2. Image with OVERLAY Tags (The Stack)
            if (post.imageUrl != null) _buildImageWithTagsOverlay(theme),

            // 3. Content Text
            if (post.content != null && post.content!.isNotEmpty)
              _buildContentText(theme),

            // Divider
            if (post.imageUrl != null ||
                (post.content != null && post.content!.isNotEmpty))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: Colors.grey.withOpacity(0.1)),
              ),

            // 4. Footer Actions
            _buildActionFooter(theme),
          ],
        ),
      ),
    );
  }

  // --- Components ---

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar & Name
          Expanded(
            child: InkWell(
              onTap: () => _navigateToUserProfile(),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.primaryColor.withOpacity(0.1),
                      image:
                          (post.userAvatar != null &&
                              post.userAvatar!.isNotEmpty)
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                post.userAvatar!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (post.userAvatar == null || post.userAvatar!.isEmpty)
                        ? Center(
                            child: Text(
                              post.userName?.substring(0, 1).toUpperCase() ??
                                  "U",
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.userName ?? "User",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        Text(
                          _formatDate(post.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sentiment Badge (Top Right)
          if (post.sentiment != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: post.sentiment == 'bullish'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: post.sentiment == 'bullish'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    post.sentiment == 'bullish'
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 14,
                    color: post.sentiment == 'bullish'
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    post.sentiment == 'bullish' ? "Bullish" : "Bearish",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: post.sentiment == 'bullish'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // THIS IS THE KEY PART YOU WANTED
  Widget _buildImageWithTagsOverlay(ThemeData theme) {
    return Stack(
      children: [
        // 1. The Image
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250, minHeight: 200),
          child: SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: post.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 250,
                color: Colors.grey[100],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[100],
                child: const Icon(
                  Icons.broken_image_rounded,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),

        // 2. The Tags Overlay (Positioned on top of image)
        if (post.cashtags != null && post.cashtags!.isNotEmpty)
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: post.cashtags!.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    // Semi-transparent black background for contrast
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // White text for overlay
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildContentText(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. If Headline exists -> Show Headline ONLY
          if (post.headline.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                post.headline,
                style: TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),

          // 2. If Headline is EMPTY -> Show Body/Content
          if (post.headline.isEmpty)
            Text(
              post.body.isNotEmpty ? post.body : post.content!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1.5,
                fontSize: 15,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionFooter(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          _InteractionBtn(
            icon: post.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            label: "${post.likesCount}",
            color: post.isLiked ? Colors.red : Colors.grey.shade700,
            onTap: () => controller.toggleLike(index),
          ),
          _InteractionBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: "${post.commentsCount}",
            color: Colors.blueAccent,
            onTap: () => controller.navigateToPostDetails(post),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => controller.toggleBookmark(index),
            icon: Icon(
              post.isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              size: 20,
              color: post.isBookmarked
                  ? theme.primaryColor
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToUserProfile() {
    final userEntity = AuthEntity(
      id: post.userId,
      name: post.userName ?? "User",
      email: '',
      avatarUrl: post.userAvatar,
    );
    Get.toNamed(AppPages.userProfilePage, arguments: userEntity);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) return "${date.day}/${date.month}/${date.year}";
    if (difference.inDays > 0) return "${difference.inDays}d ago";
    if (difference.inHours > 0) return "${difference.inHours}h ago";
    if (difference.inMinutes > 0) return "${difference.inMinutes}m ago";
    return "Just now";
  }
}

class _InteractionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _InteractionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            AppGaps.w8,
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/core/custom/custom_appbar.dart';
import 'package:egx/core/data/init_local_data.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/features/post_details/presentation/controller/post_details_controller.dart';
import 'package:egx/features/post_details/presentation/page/comment_thread_page.dart';
import 'package:egx/features/post_details/presentation/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egx/core/routes/app_pages.dart';
import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailsPage extends GetView<PostDetailsController> {
  const PostDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppbar(Get.back, "Post Details"),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // A. Post Header Section
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    child: Obx(() {
                      final post = controller.post.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ============================
                          // User Info Header + Sentiment
                          // ============================
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. User Info (Left Side)
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      final userEntity = AuthEntity(
                                        id: post.userId,
                                        name: post.userName ?? "User",
                                        email: '',
                                        avatarUrl: post.userAvatar,
                                      );
                                      Get.toNamed(
                                        AppPages.userProfilePage,
                                        arguments: userEntity,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Row(
                                      children: [
                                        // Avatar
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color:
                                                (post.userAvatar == null ||
                                                    post.userAvatar!.isEmpty)
                                                ? context.primary.withOpacity(
                                                    0.15,
                                                  )
                                                : Colors.transparent,
                                            image:
                                                (post.userAvatar != null &&
                                                    post.userAvatar!.isNotEmpty)
                                                ? DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          post.userAvatar!,
                                                        ),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                          ),
                                          child:
                                              (post.userAvatar == null ||
                                                  post.userAvatar!.isEmpty)
                                              ? Center(
                                                  child: Text(
                                                    post.userName
                                                            ?.substring(0, 1)
                                                            .toUpperCase() ??
                                                        "U",
                                                    style: TextStyle(
                                                      color: context.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        // Name & Time
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.userName ?? "User",
                                                style: theme
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                timeago.format(post.createdAt),
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 2. Sentiment Badge (Right Side)
                                if (post.sentiment != null)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: post.sentiment == 'bullish'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: post.sentiment == 'bullish'
                                            ? Colors.green.withOpacity(0.5)
                                            : Colors.red.withOpacity(0.5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          post.sentiment == 'bullish'
                                              ? Icons.trending_up
                                              : Icons.trending_down,
                                          size: 16,
                                          color: post.sentiment == 'bullish'
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          post.sentiment == 'bullish'
                                              ? "Bullish"
                                              : "Bearish",
                                          style: TextStyle(
                                            fontSize: 12,
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
                          ),

                          // Image & Content
                          if (post.imageUrl != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: post.imageUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        height: 200,
                                        color: Colors.grey[200],
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  // Cashtags Overlay
                                  if (post.cashtags != null &&
                                      post.cashtags!.isNotEmpty)
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
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                          if (post.content != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (post.headline.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        post.headline,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                      ),
                                    ),
                                  Text(
                                    post.headline.isNotEmpty
                                        ? post.body
                                        : post.content!,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      height: 1.6,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Actions
                          Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ActionButton(
                                  icon: post.isLiked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  count: post.likesCount,
                                  color: post.isLiked
                                      ? Colors.red
                                      : Colors.grey[600]!,
                                  onTap: controller.toggleLike,
                                ),
                                ActionButton(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  count: post.commentsCount,
                                  color: const Color(0xFF3B82F6),
                                  isActive: false,
                                ),
                                IconButton(
                                  onPressed: controller.toggleBookmark,
                                  icon: Icon(
                                    post.isBookmarked
                                        ? Icons.bookmark_rounded
                                        : Icons.bookmark_border_rounded,
                                    color: post.isBookmarked
                                        ? AppColors.candleGreen
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),

                // B. Comments Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Comments",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${controller.comments.length}",
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // C. Comments List (ROOTS ONLY)
                Obx(() {
                  if (controller.isLoadingComments.value) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }

                  // استخدام الـ rootComments فقط
                  final commentsList = controller.rootComments;

                  if (commentsList.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 48,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No comments yet",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final comment = commentsList[index];

                      return Column(
                        children: [
                          CommentItem(
                            comment: comment,
                            isReplyingTo:
                                controller.replyingTo.value?.id == comment.id,
                            repliesCount: controller.getReplyCount(comment.id),

                            onViewReplies: () {
                              Get.to(
                                () => CommentThreadPage(rootComment: comment),
                              );
                            },

                            onVote: (voteType) {
                              final originalIndex = controller.comments
                                  .indexWhere((c) => c.id == comment.id);
                              if (originalIndex != -1) {
                                controller.toggleCommentVote(
                                  originalIndex,
                                  voteType,
                                );
                              }
                            },
                            onReply: () => controller.setReplyTo(comment),
                          ),
                          if (index < commentsList.length - 1)
                            Divider(
                              height: 1,
                              indent: 70,
                              endIndent: 20,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                        ],
                      );
                    }, childCount: commentsList.length),
                  );
                }),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // --- 2. Bottom Input Field ---
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Replying Indicator
                Obx(() {
                  if (controller.replyingTo.value == null) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(color: colorScheme.primary, width: 4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.reply, size: 16, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: "Replying to ",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      controller.replyingTo.value?.userName ??
                                      'User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: controller.cancelReply,
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // Input Field Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            (Get.find<InitLocalData>()
                                    .currentUser
                                    .value
                                    ?.avatarUrl ==
                                null)
                            ? colorScheme.primary.withOpacity(0.15)
                            : Colors.transparent,
                        image:
                            (Get.find<InitLocalData>()
                                    .currentUser
                                    .value
                                    ?.avatarUrl !=
                                null)
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                  Get.find<InitLocalData>()
                                      .currentUser
                                      .value!
                                      .avatarUrl!,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child:
                          (Get.find<InitLocalData>()
                                  .currentUser
                                  .value
                                  ?.avatarUrl ==
                              null)
                          ? const Center(
                              child: Icon(
                                Icons.person,
                                size: 22,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 100),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.4),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Obx(
                          () => TextField(
                            controller: controller.commentController,
                            decoration: InputDecoration(
                              hintText: controller.replyingTo.value != null
                                  ? "Reply to ${controller.replyingTo.value?.userName ?? 'user'}..."
                                  : "Share your thoughts...",
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                            minLines: 1,
                            maxLines: 4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => controller.isSendingComment.value
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: controller.addComment,
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 6),
          Text(
            "$count",
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

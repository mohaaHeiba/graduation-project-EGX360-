import 'package:cached_network_image/cached_network_image.dart';
import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:egx/core/routes/app_pages.dart';
import 'package:egx/features/profile/domain/entity/post_entity.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildPostsList(
  dynamic controller,
  BuildContext context, {
  required RxList<PostEntity> posts,
  bool isViewedPost = false,
}) {
  final theme = context;

  return Obx(() {
    // 1. حالة التحميل
    if (controller.isPostsLoading.value) {
      return const CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    if (posts.isEmpty) {
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 60,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  AppGaps.h12,
                  const Text(
                    "No posts shared yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final post = posts[index];

              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppPages.showDetailsPage, arguments: post);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: context.surface.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Image ---
                      if (post.imageUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 250,
                              minHeight: 200,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: post.imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 250,
                                  color: Colors.grey[100],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
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
                        ),

                      // --- Tags (Sentiment & Cashtags) ---
                      if (post.sentiment != null ||
                          (post.cashtags != null && post.cashtags!.isNotEmpty))
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (post.sentiment != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: post.sentiment == 'bullish'
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: post.sentiment == 'bullish'
                                          ? Colors.green
                                          : Colors.red,
                                      width: 1,
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
                                        post.sentiment == 'bullish'
                                            ? "Bullish"
                                            : "Bearish",
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
                              if (post.cashtags != null)
                                ...post.cashtags!.map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: theme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      // --- Content ---
                      if (post.content != null && post.content!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (post.headline.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    post.headline,
                                    style: TextStyle(
                                      height: 1.3,
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                      color: theme.onSurface,
                                    ),
                                  ),
                                ),

                              if (post.headline.isEmpty)
                                Text(
                                  post.body.isNotEmpty
                                      ? post.body
                                      : post.content!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                    color: theme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      if (post.imageUrl != null || post.content!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(color: Colors.grey.withOpacity(0.1)),
                        ),

                      // --- Buttons ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            _buildInteractionBtn(
                              icon: post.isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              label: "${post.likesCount}",
                              color: post.isLiked
                                  ? Colors.red
                                  : Colors.grey.shade700,
                              onTap: () => controller.toggleLike(index),
                            ),
                            _buildInteractionBtn(
                              icon: Icons.chat_bubble_outline_rounded,
                              label: "${post.commentsCount}",
                              color: Colors.blueAccent,
                              onTap: () {},
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => controller.toggleBookmark(index),
                              icon: Icon(
                                Icons.share_rounded,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: posts.length),
          ),
        ),
      ],
    );
  });
}

Widget _buildInteractionBtn({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
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

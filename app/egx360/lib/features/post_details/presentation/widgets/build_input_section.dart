import 'package:cached_network_image/cached_network_image.dart';
import 'package:egx/core/data/init_local_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildInputSection(
  final controller,
  BuildContext context,
  ThemeData theme,
  ColorScheme colorScheme,
) {
  return Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      children: [
                        TextSpan(
                          text: controller.replyingTo.value?.userName ?? 'User',
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
                  child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }),

        // Input Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar الحقيقي
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    (Get.find<InitLocalData>().currentUser.value?.avatarUrl ==
                        null)
                    ? colorScheme.primary.withOpacity(0.15)
                    : Colors.transparent,
                image:
                    (Get.find<InitLocalData>().currentUser.value?.avatarUrl !=
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
                  (Get.find<InitLocalData>().currentUser.value?.avatarUrl ==
                      null)
                  ? const Center(
                      child: Icon(Icons.person, size: 22, color: Colors.grey),
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 100),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                    0.4,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller.commentController,
                  decoration: const InputDecoration(
                    hintText: "Write a reply...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // زر الإرسال مع Loading
            Obx(
              () => controller.isSendingComment.value
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
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
  );
}

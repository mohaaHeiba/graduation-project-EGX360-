import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPostCard extends StatelessWidget {
  const ShimmerPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper to keep code clean
    Widget shimmerBox({double? width, double? height, double radius = 4}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Or context.surface
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================
            // Header (Avatar + Name + Tags)
            // ============================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  shimmerBox(width: 40, height: 40, radius: 12),
                  const SizedBox(width: 12),
                  // Name and Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerBox(width: 120, height: 14),
                        const SizedBox(height: 6),
                        shimmerBox(width: 80, height: 10),
                      ],
                    ),
                  ),
                  // Right side Sentiment Tag placeholder
                  shimmerBox(width: 60, height: 24, radius: 6),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ============================
            // Image Placeholder
            // ============================
            Container(width: double.infinity, height: 200, color: Colors.white),

            // ============================
            // Content Text
            // ============================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(width: double.infinity, height: 14),
                  const SizedBox(height: 8),
                  shimmerBox(width: double.infinity, height: 14),
                  const SizedBox(height: 8),
                  shimmerBox(width: 200, height: 14),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.white),
            ),

            // ============================
            // Footer (Actions)
            // ============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  // Like Button Placeholder
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        shimmerBox(width: 22, height: 22, radius: 4),
                        const SizedBox(width: 8),
                        shimmerBox(width: 20, height: 12),
                      ],
                    ),
                  ),
                  // Comment Button Placeholder
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        shimmerBox(width: 22, height: 22, radius: 4),
                        const SizedBox(width: 8),
                        shimmerBox(width: 20, height: 12),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Bookmark Icon
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: shimmerBox(width: 20, height: 20, radius: 4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

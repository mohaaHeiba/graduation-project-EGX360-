import 'package:cached_network_image/cached_network_image.dart';
import 'package:egx/features/community/presentation/controller/community_controller.dart';
import 'package:egx/features/community/presentation/widgets/posts_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityPage extends GetView<CommunityController> {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: controller.refreshPosts,
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              backgroundColor: theme.scaffoldBackgroundColor,
              surfaceTintColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Obx(() {
                  final selected = controller.selectedStock.value;
                  if (selected == null) {
                    return Text(
                      "Community",
                      style: TextStyle(
                        color: colorScheme.onBackground,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    );
                  }
                  return Row(
                    children: [
                      if (selected.logoUrl != null)
                        Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                selected.logoUrl!,
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      Text(
                        selected.symbol,
                        style: TextStyle(
                          color: colorScheme.onBackground,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: Container(
              //       padding: const EdgeInsets.all(8),
              //       decoration: BoxDecoration(
              //         color: colorScheme.primary.withOpacity(0.1),
              //         shape: BoxShape.circle,
              //       ),
              //       child: Icon(
              //         Icons.search_rounded,
              //         color: colorScheme.primary,
              //         size: 24,
              //       ),
              //     ),
              //   ),
              //   const SizedBox(width: 16),
              // ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Obx(() {
                    print(
                      "CommunityPage Header Obx rebuilding. Selected: ${controller.selectedStock.value?.symbol}",
                    );
                    if (controller.stocks.isEmpty) {
                      // Show loading or empty state?
                      // For now, maybe just show "All"
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.stocks.length + 1, // +1 for "All"
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        // "All" Chip
                        if (index == 0) {
                          final isSelected =
                              controller.selectedStock.value == null;
                          return _buildFilterChip(
                            context: context,
                            label: "All",
                            isSelected: isSelected,
                            onTap: () => controller.fetchAll(null),
                          );
                        }

                        final stock = controller.stocks[index - 1];
                        // Compare by symbol to ensure selection persists across object instances
                        final isSelected =
                            controller.selectedStock.value?.symbol ==
                            stock.symbol;
                        return _buildFilterChip(
                          context: context,
                          label: stock.symbol,
                          isSelected: isSelected,
                          logoUrl: stock.logoUrl,
                          onTap: () => controller.toggleStockFilter(stock),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
            PostsListWidget(controller: controller),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isPaginationLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
            // Add some bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    String? logoUrl,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (logoUrl != null) ...[
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(logoUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

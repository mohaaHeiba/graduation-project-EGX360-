import 'package:egx/features/profile/presentations/controller/follow_list_controller.dart';
import 'package:egx/features/profile/presentations/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowersFollowingPage extends StatefulWidget {
  const FollowersFollowingPage({super.key});

  @override
  State<FollowersFollowingPage> createState() => _FollowersFollowingPageState();
}

class _FollowersFollowingPageState extends State<FollowersFollowingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FollowListController controller = Get.find<FollowListController>();
  late String userId;
  late String userName;
  late int initialIndex;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    userId = args['userId'];
    userName = args['userName'];
    initialIndex = args['initialIndex'] ?? 0;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );

    // Fetch data
    controller.fetchFollowers(userId);
    controller.fetchFollowing(userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName, style: const TextStyle(fontSize: 16)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Followers"),
            Tab(text: "Following"),
          ],
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFollowersList(), _buildFollowingList()],
      ),
    );
  }

  Widget _buildFollowersList() {
    return Obx(() {
      if (controller.isLoadingFollowers.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.followers.isEmpty) {
        return const Center(child: Text("No followers yet"));
      }

      return ListView.builder(
        itemCount: controller.followers.length,
        itemBuilder: (context, index) {
          final user = controller.followers[index];
          return UserListItem(user: user, controller: controller);
        },
      );
    });
  }

  Widget _buildFollowingList() {
    return Obx(() {
      if (controller.isLoadingFollowing.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.following.isEmpty) {
        return const Center(child: Text("Not following anyone yet"));
      }

      return ListView.builder(
        itemCount: controller.following.length,
        itemBuilder: (context, index) {
          final user = controller.following[index];
          return UserListItem(user: user, controller: controller);
        },
      );
    });
  }
}

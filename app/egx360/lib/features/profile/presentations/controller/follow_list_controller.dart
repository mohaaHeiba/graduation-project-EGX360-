import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/features/profile/domain/usecase/get_followers_usecase.dart';
import 'package:egx/features/profile/domain/usecase/get_following_usecase.dart';
import 'package:egx/features/profile/domain/usecase/interaction_usecases.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FollowListController extends GetxController {
  final GetFollowersUseCase getFollowersUseCase;
  final GetFollowingUseCase getFollowingUseCase;
  final ToggleFollowUseCase toggleFollowUseCase;
  final CheckFollowStatusUseCase checkFollowStatusUseCase;

  FollowListController({
    required this.getFollowersUseCase,
    required this.getFollowingUseCase,
    required this.toggleFollowUseCase,
    required this.checkFollowStatusUseCase,
  });

  final RxList<AuthEntity> followers = <AuthEntity>[].obs;
  final RxList<AuthEntity> following = <AuthEntity>[].obs;
  final RxBool isLoadingFollowers = false.obs;
  final RxBool isLoadingFollowing = false.obs;
  final RxMap<String, bool> isFollowingMap = <String, bool>{}.obs;
  final RxMap<String, bool> isTogglingMap = <String, bool>{}.obs;

  final String currentUserId =
      Supabase.instance.client.auth.currentUser?.id ?? '';

  Future<void> fetchFollowers(String userId) async {
    try {
      isLoadingFollowers.value = true;
      final result = await getFollowersUseCase(userId);
      followers.assignAll(result);
      await _checkFollowStatuses(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch followers");
    } finally {
      isLoadingFollowers.value = false;
    }
  }

  Future<void> fetchFollowing(String userId) async {
    try {
      isLoadingFollowing.value = true;
      final result = await getFollowingUseCase(userId);
      following.assignAll(result);
      await _checkFollowStatuses(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch following");
    } finally {
      isLoadingFollowing.value = false;
    }
  }

  Future<void> _checkFollowStatuses(List<AuthEntity> users) async {
    if (users.isEmpty) return;

    try {
      // Fetch all IDs that the current user follows
      // We can reuse getFollowingUseCase for the current user
      final myFollowingList = await getFollowingUseCase(currentUserId);
      final myFollowingIds = myFollowingList.map((e) => e.id).toSet();

      for (var user in users) {
        if (user.id == currentUserId) continue;
        isFollowingMap[user.id] = myFollowingIds.contains(user.id);
      }
    } catch (e) {
      // Fallback to individual checks if batch fails (unlikely)
      print("Batch check failed: $e");
    }
  }

  Future<void> toggleFollow(String targetUserId) async {
    if (isTogglingMap[targetUserId] == true) return;

    try {
      isTogglingMap[targetUserId] = true;
      await toggleFollowUseCase(currentUserId, targetUserId);

      // Update local state
      if (isFollowingMap.containsKey(targetUserId)) {
        isFollowingMap[targetUserId] = !isFollowingMap[targetUserId]!;
      } else {
        isFollowingMap[targetUserId] = true;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update follow status");
    } finally {
      isTogglingMap[targetUserId] = false;
    }
  }
}

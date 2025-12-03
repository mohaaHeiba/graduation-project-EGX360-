import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/features/profile/domain/entity/post_entity.dart';
import 'package:egx/features/profile/domain/entity/profile_stats.dart';
import 'package:egx/features/profile/domain/usecase/get_profile_stats_usecase.dart';
import 'package:egx/features/profile/domain/usecase/get_user_profile_usecase.dart';
import 'package:egx/features/profile/domain/usecase/get_viewed_user_posts_usecase.dart';
import 'package:egx/features/profile/domain/usecase/interaction_usecases.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewProfileController extends GetxController {
  // Dependencies
  final GetUserProfileUseCase getUserProfileUseCase = Get.find();
  final GetViewedUserPostsUseCase getViewedUserPostsUseCase = Get.find();
  final GetProfileStatsUseCase getProfileStatsUseCase = Get.find();
  final CheckFollowStatusUseCase checkFollowStatusUseCase = Get.find();
  final ToggleFollowUseCase toggleFollowUseCase = Get.find();
  final TogglePostVoteUseCase togglePostVoteUseCase = Get.find();
  final ToggleBookmarkUseCase toggleBookmarkUseCase = Get.find();

  // State
  Rx<AuthEntity?> userProfile = Rx<AuthEntity?>(null);
  Rx<ProfileStats?> userStats = Rx<ProfileStats?>(null);
  RxList<PostEntity> userPosts = <PostEntity>[].obs;

  var isLoading = false.obs;
  var isPostsLoading = false.obs;

  // Follow Status
  var isFollowing = false.obs;
  var isCheckingFollow = false.obs;

  String get currentUserId => Supabase.instance.client.auth.currentUser!.id;

  // --- Actions ---

  Future<void> loadViewedUser(String userId) async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchUserProfile(userId),
        fetchUserStats(userId),
        fetchUserPosts(userId),
        checkFollowStatus(userId),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserProfile(String userId) async {
    try {
      final result = await getUserProfileUseCase(userId);
      userProfile.value = result;
    } catch (e) {
      print("❌ Error fetching user profile: $e");
    }
  }

  Future<void> fetchUserStats(String userId) async {
    try {
      final result = await getProfileStatsUseCase(userId);
      userStats.value = result;
    } catch (e) {
      print("❌ Error fetching user stats: $e");
    }
  }

  Future<void> fetchUserPosts(String userId) async {
    try {
      isPostsLoading.value = true;
      // Always use the remote-only use case
      final result = await getViewedUserPostsUseCase(userId);
      print(
        "✅ ViewProfileController: Fetched ${result.length} posts for $userId",
      );
      userPosts.assignAll(result);
    } catch (e) {
      print("❌ Error fetching user posts: $e");
    } finally {
      isPostsLoading.value = false;
    }
  }

  Future<void> checkFollowStatus(String userId) async {
    if (userId == currentUserId) {
      isFollowing.value = false;
      return;
    }

    try {
      isCheckingFollow.value = true;
      final result = await checkFollowStatusUseCase.call(currentUserId, userId);
      isFollowing.value = result;
    } catch (e) {
      print("❌ Error checking follow status: $e");
    } finally {
      isCheckingFollow.value = false;
    }
  }

  Future<void> toggleFollow(String userId) async {
    if (userId == currentUserId) return;

    final oldStatus = isFollowing.value;
    isFollowing.value = !oldStatus; // Optimistic update

    try {
      await toggleFollowUseCase.call(currentUserId, userId);
      await fetchUserStats(userId); // Refresh stats
    } catch (e) {
      isFollowing.value = oldStatus; // Rollback
      Get.snackbar("Error", "Failed to update follow status");
    }
  }

  Future<void> toggleLike(int index) async {
    final post = userPosts[index];
    final oldPost = post;

    final newLikedStatus = !post.isLiked;
    final int newLikesCount = newLikedStatus
        ? post.likesCount + 1
        : (post.likesCount > 0 ? post.likesCount - 1 : 0);

    userPosts[index] = post.copyWith(
      isLiked: newLikedStatus,
      likesCount: newLikesCount,
    );
    userPosts.refresh();

    try {
      await togglePostVoteUseCase.call(currentUserId, post.id, 1);
    } catch (e) {
      userPosts[index] = oldPost;
      userPosts.refresh();
      Get.snackbar("Error", "Failed to like post");
    }
  }

  Future<void> toggleBookmark(int index) async {
    final post = userPosts[index];
    final oldPost = post;

    userPosts[index] = post.copyWith(isBookmarked: !post.isBookmarked);
    userPosts.refresh();

    try {
      await toggleBookmarkUseCase.call(currentUserId, post.id);
    } catch (e) {
      userPosts[index] = oldPost;
      userPosts.refresh();
      Get.snackbar("Error", "Failed to bookmark post");
    }
  }
}

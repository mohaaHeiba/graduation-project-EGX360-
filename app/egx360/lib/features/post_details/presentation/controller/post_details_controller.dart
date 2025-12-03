import 'dart:async';
import 'package:egx/features/post_details/domain/entity/comment_entity.dart';
import 'package:egx/features/profile/domain/entity/post_entity.dart';
import 'package:egx/features/profile/domain/usecase/interaction_usecases.dart';
import 'package:egx/features/community/presentation/controller/community_controller.dart';
import 'package:egx/features/profile/presentations/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostDetailsController extends GetxController {
  final GetCommentsUseCase getCommentsUseCase = Get.find();
  final AddCommentUseCase addCommentUseCase = Get.find();
  final TogglePostVoteUseCase togglePostVoteUseCase = Get.find();
  final ToggleBookmarkUseCase toggleBookmarkUseCase = Get.find();
  final ToggleCommentVoteUseCase toggleCommentVoteUseCase = Get.find();

  // --- State ---
  late Rx<PostEntity> post;

  var comments = <CommentEntity>[].obs;
  var isLoadingComments = true.obs;
  var isSendingComment = false.obs;

  var replyingTo = Rxn<CommentEntity>();
  final commentController = TextEditingController();

  Timer? _voteDebounceTimer;
  PostEntity? _originalPostState;

  String get currentUserId => Supabase.instance.client.auth.currentUser!.id;

  @override
  void onInit() {
    super.onInit();
    final PostEntity argPost = Get.arguments as PostEntity;
    post = argPost.obs;
    fetchComments();
  }

  @override
  void onClose() {
    _voteDebounceTimer?.cancel();
    commentController.dispose();
    super.onClose();
  }

  List<CommentEntity> get rootComments {
    final roots = comments.where((c) => c.parentId == null).toList();
    roots.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return roots;
  }

  List<CommentEntity> getThreadFor(int rootId) {
    final allReplies = comments.where((c) => c.parentId != null).toList();

    List<CommentEntity> getDescendants(int parentId) {
      final directChildren = allReplies
          .where((c) => c.parentId == parentId)
          .toList();
      directChildren.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      final result = <CommentEntity>[];
      for (var child in directChildren) {
        result.add(child);
        result.addAll(getDescendants(child.id));
      }
      return result;
    }

    return getDescendants(rootId);
  }

  int getReplyCount(int rootId) {
    int count = 0;
    final directChildren = comments.where((c) => c.parentId == rootId).toList();

    count += directChildren.length;

    for (var child in directChildren) {
      count += getReplyCount(child.id);
    }

    return count;
  }

  // --- 2. Actions (Fetch, Add, Vote) ---

  Future<void> fetchComments() async {
    try {
      isLoadingComments.value = true;
      final result = await getCommentsUseCase.call(post.value.id);
      comments.assignAll(result);
    } catch (e) {
      print("Error fetching comments: $e");
    } finally {
      isLoadingComments.value = false;
    }
  }

  void setReplyTo(CommentEntity comment) {
    if (replyingTo.value?.id == comment.id) {
      cancelReply();
      return;
    }
    replyingTo.value = comment;
  }

  void cancelReply() {
    replyingTo.value = null;
  }

  Future<void> addComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) return;

    try {
      isSendingComment.value = true;

      await addCommentUseCase.call(
        userId: currentUserId,
        postId: post.value.id,
        content: content,
        parentId: replyingTo.value?.id,
      );

      commentController.clear();
      cancelReply();
      await fetchComments();

      final newPost = post.value.copyWith(
        commentsCount: post.value.commentsCount + 1,
      );
      post.value = newPost;
      _syncWithProfile(newPost);
      _syncWithCommunity(newPost);
    } catch (e) {
      Get.snackbar("Error", "Failed to add comment");
    } finally {
      isSendingComment.value = false;
    }
  }

  // --- 3. Like / Vote Logic ---

  Future<void> toggleLike() async {
    // 1. Cancel existing timer
    if (_voteDebounceTimer?.isActive ?? false) {
      _voteDebounceTimer!.cancel();
    } else {
      // First tap in a sequence: save original state
      _originalPostState = post.value;
    }

    // 2. Optimistic Update
    final oldPost = post.value;
    final bool newLikedStatus = !oldPost.isLiked;
    final int newLikesCount = newLikedStatus
        ? oldPost.likesCount + 1
        : (oldPost.likesCount > 0 ? oldPost.likesCount - 1 : 0);

    final newPost = oldPost.copyWith(
      isLiked: newLikedStatus,
      likesCount: newLikesCount,
    );

    post.value = newPost;
    _syncWithProfile(newPost);
    _syncWithCommunity(newPost);

    // 3. Start Debounce Timer
    _voteDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        // If new status is Liked, voteType is 1. If Unliked, voteType is null (remove vote).
        final int? voteType = newPost.isLiked ? 1 : null;
        await togglePostVoteUseCase.call(currentUserId, newPost.id, voteType);
        _originalPostState = null; // Success, clear backup
      } catch (e) {
        // Revert to original state on error
        if (_originalPostState != null) {
          post.value = _originalPostState!;
          _syncWithProfile(_originalPostState!);
          _syncWithCommunity(_originalPostState!);
          _originalPostState = null;
        }
        Get.snackbar("Error", "Could not like post");
      }
    });
  }

  Future<void> toggleBookmark() async {
    final oldPost = post.value;
    final newPost = oldPost.copyWith(isBookmarked: !oldPost.isBookmarked);

    post.value = newPost;
    _syncWithProfile(newPost);
    _syncWithCommunity(newPost);

    try {
      await toggleBookmarkUseCase.call(currentUserId, post.value.id);
    } catch (e) {
      post.value = oldPost;
      _syncWithProfile(oldPost);
      _syncWithCommunity(oldPost);
      Get.snackbar("Error", "Could not save post");
    }
  }

  Future<void> toggleCommentVote(int index, int voteType) async {
    final comment = comments[index];
    final oldVote = comment.userVoteType;
    final int? newVote = (oldVote == voteType) ? null : voteType;

    int newLikes = comment.likesCount;
    int newDislikes = comment.dislikesCount;

    if (oldVote == 1) {
      newLikes = (newLikes > 0 ? newLikes - 1 : 0);
    } else if (oldVote == -1)
      // ignore: curly_braces_in_flow_control_structures
      newDislikes = (newDislikes > 0 ? newDislikes - 1 : 0);

    if (newVote == 1) {
      newLikes++;
    } else if (newVote == -1)
      // ignore: curly_braces_in_flow_control_structures
      newDislikes++;

    final newComment = comment.copyWith(
      userVoteType: newVote,
      likesCount: newLikes,
      dislikesCount: newDislikes,
      resetUserVoteType: newVote == null,
    );

    comments[index] = newComment;
    comments.refresh();

    try {
      await toggleCommentVoteUseCase.call(currentUserId, comment.id, newVote);
    } catch (e) {
      comments[index] = comment;
      comments.refresh();
      Get.snackbar("Error", "Failed to vote");
    }
  }

  void _syncWithProfile(PostEntity updatedPost) {
    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      final index = profileCtrl.userPosts.indexWhere(
        (p) => p.id == updatedPost.id,
      );
      if (index != -1) {
        profileCtrl.userPosts[index] = updatedPost;
        profileCtrl.userPosts.refresh();
      }
    }
  }

  void _syncWithCommunity(PostEntity updatedPost) {
    try {
      if (Get.isRegistered<CommunityController>()) {
        final communityCtrl = Get.find<CommunityController>();
        final index = communityCtrl.posts.indexWhere(
          (p) => p.id == updatedPost.id,
        );
        if (index != -1) {
          communityCtrl.posts[index] = updatedPost;
          communityCtrl.posts.refresh();
        }
      }
    } catch (e) {
      // Ignore if not found or type error
    }
  }
}

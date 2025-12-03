import 'dart:io';
import 'package:egx/core/errors/app_exception.dart';
import 'package:egx/features/auth/data/model/auth_model.dart';
import 'package:egx/features/post_details/data/model/comment_model.dart';
import 'package:egx/features/profile/data/model/post_model.dart';
import 'package:egx/features/profile/domain/entity/profile_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<void> createPost({
    required String userId,
    String? content,
    File? imageFile,
    String? sentiment,
    List<String>? cashtags,
  });
  Future<List<PostModel>> getUserPosts(String userId);
  Future<ProfileStats> getStats(String userId);

  Future<void> togglePostVote({
    required String userId,
    required int postId,
    required int? voteType,
  });

  Future<List<CommentModel>> getPostComments(int postId);

  Future<void> addComment({
    required String userId,
    required int postId,
    required String content,
    int? parentId,
  });

  Future<void> toggleCommentVote({
    required String userId,
    required int commentId,
    required int? voteType,
  });

  Future<void> toggleFollow({
    required String followerId,
    required String followingId,
  });
  Future<void> toggleBookmark({required String userId, required int postId});

  Future<bool> checkFollowStatus({
    required String followerId,
    required String followingId,
  });

  Future<void> toggleWatchlist({
    required String userId,
    required String stockSymbol,
  });

  Future<List<String>> getUserWatchlist(String userId);

  Future<AuthModel> getUserProfile(String userId);

  Future<List<AuthModel>> getFollowers(String userId);
  Future<List<AuthModel>> getFollowing(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _supabaseClient;
  ProfileRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<AuthModel> getUserProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return AuthModel.fromMap(response);
    } catch (e) {
      throw DatabaseAppException('Failed to fetch user profile');
    }
  }

  @override
  Future<void> createPost({
    required String userId,
    String? content,
    File? imageFile,
    String? sentiment,
    List<String>? cashtags,
  }) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        final fileExt = imageFile.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        await _supabaseClient.storage.from('posts').upload(fileName, imageFile);
        imageUrl = _supabaseClient.storage.from('posts').getPublicUrl(fileName);
      }

      await _supabaseClient.from('posts').insert({
        'user_id': userId,
        'content': content,
        'image_url': imageUrl,
        'sentiment': sentiment,
        'cashtags': cashtags,
      });
    } catch (e) {
      if (e is PostgrestException) {
        print("Code: ${e.code}");
        print("Message: ${e.message}");
        print("Details: ${e.details}");
      }
      throw DatabaseAppException('Real Error: $e');
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final response = await _supabaseClient.rpc(
        'get_posts_with_status',
        params: {
          'viewer_id': _supabaseClient.auth.currentUser!.id,
          'target_user_id': userId,
          'limit_val': 100, // Temporary: fetch 100 posts for profile
          'offset_val': 0,
          'category_filter': null,
        },
      );

      return (response as List).map((e) => PostModel.fromMap(e)).toList();
    } catch (e) {
      print("RPC Error: $e");
      throw DatabaseAppException('Failed to fetch posts');
    }
  }

  @override
  Future<ProfileStats> getStats(String userId) async {
    try {
      final results = await Future.wait([
        _supabaseClient
            .from('posts')
            .count(CountOption.exact)
            .eq('user_id', userId),
        _supabaseClient
            .from('follows')
            .count(CountOption.exact)
            .eq('following_id', userId),
        _supabaseClient
            .from('follows')
            .count(CountOption.exact)
            .eq('follower_id', userId),
      ]);

      return ProfileStats(
        postsCount: results[0],
        followersCount: results[1],
        followingCount: results[2],
      );
    } catch (e) {
      throw DatabaseAppException('Failed to fetch stats');
    }
  }

  @override
  Future<void> togglePostVote({
    required String userId,
    required int postId,
    required int? voteType,
  }) async {
    try {
      // Always delete existing vote first
      await _supabaseClient
          .from('post_votes')
          .delete()
          .eq('user_id', userId)
          .eq('post_id', postId);

      if (voteType != null) {
        // Insert new vote
        await _supabaseClient.from('post_votes').insert({
          'user_id': userId,
          'post_id': postId,
          'vote_type': voteType,
        });
      }
    } catch (e) {
      throw DatabaseAppException('Failed to vote on post');
    }
  }

  @override
  Future<List<CommentModel>> getPostComments(int postId) async {
    try {
      final response = await _supabaseClient.rpc(
        'get_comments_with_status',
        params: {
          'viewer_id': _supabaseClient.auth.currentUser!.id,
          'target_post_id': postId,
        },
      );

      return (response as List).map((e) => CommentModel.fromMap(e)).toList();
    } catch (e) {
      print("Comments RPC Error: $e");
      throw DatabaseAppException('Failed to fetch comments');
    }
  }

  @override
  Future<void> addComment({
    required String userId,
    required int postId,
    required String content,
    int? parentId,
  }) async {
    try {
      await _supabaseClient.from('comments').insert({
        'user_id': userId,
        'post_id': postId,
        'content': content,
        'parent_id': parentId,
      });
    } catch (e) {
      throw DatabaseAppException('Failed to add comment');
    }
  }

  @override
  Future<void> toggleCommentVote({
    required String userId,
    required int commentId,
    required int? voteType,
  }) async {
    try {
      // Always delete existing vote first
      await _supabaseClient
          .from('comment_votes')
          .delete()
          .eq('user_id', userId)
          .eq('comment_id', commentId);

      if (voteType != null) {
        // Insert new vote
        await _supabaseClient.from('comment_votes').insert({
          'user_id': userId,
          'comment_id': commentId,
          'vote_type': voteType,
        });
      }
    } catch (e) {
      throw DatabaseAppException('Failed to vote on comment');
    }
  }

  @override
  Future<void> toggleFollow({
    required String followerId,
    required String followingId,
  }) async {
    try {
      final existingFollow = await _supabaseClient
          .from('follows')
          .select()
          .eq('follower_id', followerId)
          .eq('following_id', followingId)
          .maybeSingle();

      if (existingFollow != null) {
        await _supabaseClient
            .from('follows')
            .delete()
            .eq('follower_id', followerId)
            .eq('following_id', followingId);
      } else {
        await _supabaseClient.from('follows').insert({
          'follower_id': followerId,
          'following_id': followingId,
        });
      }
    } catch (e) {
      throw DatabaseAppException('Failed to follow user');
    }
  }

  @override
  Future<void> toggleBookmark({
    required String userId,
    required int postId,
  }) async {
    try {
      final existing = await _supabaseClient
          .from('bookmarks')
          .select()
          .eq('user_id', userId)
          .eq('post_id', postId)
          .maybeSingle();

      if (existing != null) {
        await _supabaseClient
            .from('bookmarks')
            .delete()
            .eq('user_id', userId)
            .eq('post_id', postId);
      } else {
        await _supabaseClient.from('bookmarks').insert({
          'user_id': userId,
          'post_id': postId,
        });
      }
    } catch (e) {
      throw DatabaseAppException('Failed to toggle bookmark');
    }
  }

  @override
  Future<bool> checkFollowStatus({
    required String followerId,
    required String followingId,
  }) async {
    try {
      final result = await _supabaseClient
          .from('follows')
          .select()
          .eq('follower_id', followerId)
          .eq('following_id', followingId)
          .maybeSingle();

      return result != null;
    } catch (e) {
      throw DatabaseAppException('Failed to check follow status');
    }
  }

  @override
  Future<void> toggleWatchlist({
    required String userId,
    required String stockSymbol,
  }) async {
    try {
      final existing = await _supabaseClient
          .from('user_watchlist')
          .select()
          .eq('user_id', userId)
          .eq('stock_symbol', stockSymbol)
          .maybeSingle();

      if (existing != null) {
        await _supabaseClient
            .from('user_watchlist')
            .delete()
            .eq('user_id', userId)
            .eq('stock_symbol', stockSymbol);
      } else {
        await _supabaseClient.from('user_watchlist').insert({
          'user_id': userId,
          'stock_symbol': stockSymbol,
        });
      }
    } catch (e) {
      throw DatabaseAppException('Failed to toggle watchlist');
    }
  }

  @override
  Future<List<String>> getUserWatchlist(String userId) async {
    try {
      final response = await _supabaseClient
          .from('user_watchlist')
          .select('stock_symbol')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => e['stock_symbol'] as String)
          .toList();
    } catch (e) {
      throw DatabaseAppException('Failed to fetch watchlist');
    }
  }

  @override
  Future<List<AuthModel>> getFollowers(String userId) async {
    try {
      // 1. Get follower IDs
      final followsResponse = await _supabaseClient
          .from('follows')
          .select('follower_id')
          .eq('following_id', userId);

      final followerIds = (followsResponse as List)
          .map((e) => e['follower_id'] as String)
          .toList();

      if (followerIds.isEmpty) return [];

      // 2. Get profiles
      final profilesResponse = await _supabaseClient
          .from('profiles')
          .select()
          .filter('id', 'in', followerIds);

      return (profilesResponse as List)
          .map((e) => AuthModel.fromMap(e))
          .toList();
    } catch (e) {
      print("GetFollowers Error: $e");
      throw DatabaseAppException('Failed to fetch followers');
    }
  }

  @override
  Future<List<AuthModel>> getFollowing(String userId) async {
    try {
      // 1. Get following IDs
      final followsResponse = await _supabaseClient
          .from('follows')
          .select('following_id')
          .eq('follower_id', userId);

      final followingIds = (followsResponse as List)
          .map((e) => e['following_id'] as String)
          .toList();

      if (followingIds.isEmpty) return [];

      // 2. Get profiles
      final profilesResponse = await _supabaseClient
          .from('profiles')
          .select()
          .filter('id', 'in', followingIds);

      return (profilesResponse as List)
          .map((e) => AuthModel.fromMap(e))
          .toList();
    } catch (e) {
      print("GetFollowing Error: $e");
      throw DatabaseAppException('Failed to fetch following');
    }
  }
}

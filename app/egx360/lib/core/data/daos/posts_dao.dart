import 'package:floor/floor.dart';
import 'package:egx/core/data/entities/post_local_model.dart';

@dao
abstract class PostsDao {
  @Query(
    'SELECT * FROM cached_posts WHERE userId = :userId ORDER BY createdAt DESC',
  )
  Future<List<PostLocalModel>> getUserPosts(String userId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPosts(List<PostLocalModel> posts);

  @Query('DELETE FROM cached_posts WHERE userId = :userId')
  Future<void> clearUserPosts(String userId);

  @transaction
  Future<void> updateUserPostsCache(
    String userId,
    List<PostLocalModel> posts,
  ) async {
    await clearUserPosts(userId);
    await insertPosts(posts);
  }
}

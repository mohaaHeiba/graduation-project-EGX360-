import 'package:floor/floor.dart';
import 'package:egx/features/profile/domain/entity/post_entity.dart';

@Entity(tableName: 'cached_posts')
class PostLocalModel {
  @PrimaryKey()
  final int id;

  final String userId;

  final String? content;
  final String? imageUrl;
  final DateTime createdAt;

  // Offline Data
  final String? userName;
  final String? userAvatar;

  final String? sentiment;
  final String? cashtags;

  // Stats
  final int likesCount;
  final int dislikesCount;
  final int commentsCount;

  // 🔥 User Interactions (اللايك والحفظ)
  final bool isLiked;
  final bool isBookmarked; // 👈 دي الإضافة الجديدة

  PostLocalModel({
    required this.id,
    required this.userId,
    this.content,
    this.imageUrl,
    required this.createdAt,
    this.userName,
    this.userAvatar,
    required this.likesCount,
    required this.dislikesCount,
    required this.commentsCount,
    this.sentiment,
    this.cashtags,
    required this.isLiked,
    required this.isBookmarked, // 👈 مطلوبة هنا
  });

  factory PostLocalModel.fromEntity(PostEntity entity) {
    return PostLocalModel(
      id: entity.id,
      userId: entity.userId,
      content: entity.content,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
      userName: entity.userName,
      userAvatar: entity.userAvatar,
      likesCount: entity.likesCount,
      dislikesCount: entity.dislikesCount,
      commentsCount: entity.commentsCount,
      sentiment: entity.sentiment,
      cashtags: entity.cashtags?.join(','),

      isLiked: entity.isLiked,
      isBookmarked: entity.isBookmarked, // 👈 حفظ الحالة
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      userId: userId,
      content: content,
      imageUrl: imageUrl,
      createdAt: createdAt,
      userName: userName,
      userAvatar: userAvatar,
      likesCount: likesCount,
      dislikesCount: dislikesCount,
      commentsCount: commentsCount,
      sentiment: sentiment,
      cashtags: cashtags?.split(','),

      isLiked: isLiked,
      isBookmarked: isBookmarked, // 👈 استرجاع الحالة
    );
  }
}

import 'package:floor/floor.dart';

@Entity(tableName: 'profiles')
class AuthEntity {
  @PrimaryKey()
  final String id;

  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;

  final String? lastActiveAt;
  final String? createdAt;
  final String? updatedAt;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
  });
}

import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class AuthDao {
  @Query('SELECT * FROM profiles LIMIT 1')
  Future<AuthEntity?> getAuthData();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> inserAuthData(AuthEntity authentity);

  @Query('DELETE FROM profiles')
  Future<void> deleteAuthData();
}

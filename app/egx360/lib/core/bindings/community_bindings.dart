import 'package:egx/core/data/database.dart';
import 'package:egx/features/community/data/datasources/community_remote_data_source.dart';
import 'package:egx/features/community/data/repositories/community_repository_impl.dart';
import 'package:egx/features/community/domain/repositories/community_repository.dart';
import 'package:egx/features/community/domain/usecase/get_all_posts_usecase.dart';
import 'package:egx/features/community/domain/usecase/get_stocks_usecase.dart';
import 'package:egx/features/community/presentation/controller/community_controller.dart';
import 'package:egx/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:egx/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:egx/features/profile/domain/repositories/profile_repository.dart';
import 'package:egx/features/profile/domain/usecase/interaction_usecases.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityBindings extends Bindings {
  @override
  void dependencies() {
    // Community Data Source
    Get.lazyPut<CommunityRemoteDataSource>(
      () => CommunityRemoteDataSourceImpl(Supabase.instance.client),
    );

    // Community Repository
    Get.lazyPut<CommunityRepository>(
      () => CommunityRepositoryImpl(
        remoteDataSource: Get.find<CommunityRemoteDataSource>(),
      ),
    );

    // Profile Data Source (for interaction use cases)
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(Supabase.instance.client),
    );

    // Profile Repository (for interaction use cases)
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: Get.find<ProfileRemoteDataSource>(),
        localData: Get.find<LocalData>(),
      ),
    );

    // Community Use Cases
    Get.lazyPut(() => GetAllPostsUseCase(Get.find<CommunityRepository>()));
    Get.lazyPut(() => CommunityController());

    // Interaction Use Cases (for like/bookmark)
    Get.lazyPut(() => TogglePostVoteUseCase(Get.find<ProfileRepository>()));
    Get.lazyPut(() => ToggleBookmarkUseCase(Get.find<ProfileRepository>()));
    Get.put(GetStocksUseCase(Get.find<CommunityRepository>()));
    // Controller
  }
}

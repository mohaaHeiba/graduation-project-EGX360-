import 'package:egx/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:egx/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:egx/features/auth/data/repository/auth_repository_impl.dart';
import 'package:egx/features/settings/presentaion/controller/settings_controller.dart';
import 'package:get/get.dart';

import 'package:egx/features/auth/domain/repository/auth_repository.dart';
import 'package:egx/core/services/media_service.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MediaService>(() => MediaService());

    Get.lazyPut<RemoteAuthDatasource>(
      () => RemoteAuthDatasourceImpl(),
      fenix: true,
    );
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
      fenix: true,
    );
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
      permanent: true,
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        authRepository: Get.find<AuthRepository>(),

        mediaService: Get.find<MediaService>(),
      ),
    );
  }
}

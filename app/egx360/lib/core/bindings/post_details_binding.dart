import 'package:egx/features/post_details/presentation/controller/post_details_controller.dart';
import 'package:egx/features/profile/domain/repositories/profile_repository.dart';
import 'package:egx/features/profile/domain/usecase/interaction_usecases.dart';
import 'package:get/get.dart';

class PostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final repo = Get.find<ProfileRepository>();

    Get.lazyPut(() => GetCommentsUseCase(repo));
    Get.lazyPut(() => AddCommentUseCase(repo));
    Get.lazyPut(() => TogglePostVoteUseCase(repo));
    Get.lazyPut(() => ToggleBookmarkUseCase(repo));
    Get.lazyPut(() => ToggleCommentVoteUseCase(repo));

    Get.lazyPut(() => PostDetailsController());
  }
}

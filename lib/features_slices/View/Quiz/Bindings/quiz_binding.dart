import 'package:get/get.dart';
import '../../../../Data/Repositories/quiz_repository.dart';
import '../../../../Data/Sources/asset_data_source.dart';
import '../Controller/quiz_controller.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AssetDataSource>()) {
      Get.lazyPut<AssetDataSource>(() => AssetDataSource());
    }
    if (!Get.isRegistered<QuizRepository>()) {
      Get.lazyPut<QuizRepository>(
        () => QuizRepository(Get.find<AssetDataSource>()),
      );
    }
    Get.lazyPut<QuizController>(
      () => QuizController(Get.find<QuizRepository>()),
    );
  }
}

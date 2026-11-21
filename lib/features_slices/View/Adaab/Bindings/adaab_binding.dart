import 'package:get/get.dart';
import 'package:islam786/Data/Repositories/adaab_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import '../Controller/adaab_controller.dart';

class AdaabBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AssetDataSource>()) {
      Get.lazyPut<AssetDataSource>(AssetDataSource.new);
    }
    if (!Get.isRegistered<AdaabRepository>()) {
      Get.lazyPut<AdaabRepository>(
        () => AdaabRepository(Get.find<AssetDataSource>()),
      );
    }
    if (!Get.isRegistered<AdaabController>()) {
      Get.lazyPut<AdaabController>(
        () => AdaabController(Get.find<AdaabRepository>()),
      );
    }
  }
}

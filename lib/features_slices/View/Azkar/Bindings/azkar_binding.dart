import 'package:get/get.dart';
import 'package:islam786/Data/Repositories/azkar_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import '../Controller/azkar_controller.dart';

class AzkarBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AssetDataSource>()) {
      Get.lazyPut<AssetDataSource>(AssetDataSource.new);
    }
    if (!Get.isRegistered<AzkarRepository>()) {
      Get.lazyPut<AzkarRepository>(
        () => AzkarRepository(Get.find<AssetDataSource>()),
      );
    }
    if (!Get.isRegistered<AzkarController>()) {
      Get.lazyPut<AzkarController>(
        () => AzkarController(Get.find<AzkarRepository>()),
      );
    }
  }
}

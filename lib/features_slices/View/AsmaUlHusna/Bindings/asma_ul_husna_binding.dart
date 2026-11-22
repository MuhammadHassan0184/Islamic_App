import 'package:get/get.dart';
import 'package:islam786/Data/Repositories/asma_ul_husna_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import '../Controller/asma_ul_husna_controller.dart';

class AsmaUlHusnaBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AssetDataSource>()) {
      Get.lazyPut<AssetDataSource>(AssetDataSource.new);
    }
    if (!Get.isRegistered<AsmaUlHusnaRepository>()) {
      Get.lazyPut<AsmaUlHusnaRepository>(
        () => AsmaUlHusnaRepository(Get.find<AssetDataSource>()),
      );
    }
    if (!Get.isRegistered<AsmaUlHusnaController>()) {
      Get.lazyPut<AsmaUlHusnaController>(
        () => AsmaUlHusnaController(Get.find<AsmaUlHusnaRepository>()),
      );
    }
  }
}

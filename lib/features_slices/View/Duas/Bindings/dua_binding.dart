import 'package:get/get.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/Data/Repositories/dua_repository.dart';

import '../Controller/dua_controller.dart';

class DuaBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AssetDataSource>()) {
      Get.lazyPut<AssetDataSource>(AssetDataSource.new);
    }
    if (!Get.isRegistered<DuaRepository>()) {
      Get.lazyPut<DuaRepository>(
        () => DuaRepository(Get.find<AssetDataSource>()),
      );
    }
    if (!Get.isRegistered<DuaController>()) {
      Get.lazyPut<DuaController>(
        () => DuaController(Get.find<DuaRepository>()),
      );
    }
  }
}


import 'package:get/get.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/Data/Repositories/dua_repository.dart';

import '../Controller/dua_controller.dart';

class DuaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetDataSource>(
      () => AssetDataSource(),
    );

    Get.lazyPut<DuaRepository>(
      () => DuaRepository(
        Get.find<AssetDataSource>(),
      ),
    );

    Get.lazyPut<DuaController>(
      () => DuaController(
        Get.find<DuaRepository>(),
      ),
    );
  }
}

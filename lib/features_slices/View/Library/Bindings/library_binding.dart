import 'package:get/get.dart';
import 'package:islam786/Data/Repositories/library_content_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import '../Controller/library_controller.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AssetDataSource>()) {
      Get.lazyPut<AssetDataSource>(AssetDataSource.new);
    }
    if (!Get.isRegistered<LibraryContentRepository>()) {
      Get.lazyPut<LibraryContentRepository>(
        () => LibraryContentRepository(Get.find<AssetDataSource>()),
      );
    }
    if (!Get.isRegistered<LibraryController>()) {
      Get.lazyPut<LibraryController>(
        () => LibraryController(Get.find<LibraryContentRepository>()),
      );
    }
  }
}

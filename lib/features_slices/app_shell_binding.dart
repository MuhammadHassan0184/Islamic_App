import 'package:get/get.dart';
import 'package:islam786/features_slices/View/Azkar/Bindings/azkar_binding.dart';
import 'package:islam786/features_slices/View/Duas/Bindings/dua_binding.dart';
import 'app_shell_controller.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    DuaBinding().dependencies();
    AzkarBinding().dependencies();
    if (!Get.isRegistered<AppShellController>()) {
      Get.lazyPut<AppShellController>(AppShellController.new);
    }
  }
}

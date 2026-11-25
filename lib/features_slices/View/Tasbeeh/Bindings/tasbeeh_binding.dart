import 'package:get/get.dart';
import '../Controller/tasbeeh_controller.dart';

class TasbeehBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TasbeehController>()) {
      Get.lazyPut<TasbeehController>(TasbeehController.new);
    }
  }
}

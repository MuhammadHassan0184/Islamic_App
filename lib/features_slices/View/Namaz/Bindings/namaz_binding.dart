import 'package:get/get.dart';
import '../Controller/namaz_controller.dart';

class NamazBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NamazController>()) {
      Get.put<NamazController>(NamazController());
    }
  }
}

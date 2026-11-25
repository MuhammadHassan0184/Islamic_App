import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:islam786/Services/app_permission_service.dart';

class AppShellController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void onReady() {
    super.onReady();
    if (!Get.testMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = Get.context;
        if (context != null && context.mounted) {
          AppPermissionService.checkAndPromptFirstTime(context);
        }
      });
    }
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final RxString searchQuery = ''.obs;
  final RxBool isSearchOpen = false.obs;
  final TextEditingController searchTextController = TextEditingController();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openSearch() {
    isSearchOpen.value = true;
  }

  void closeSearch() {
    isSearchOpen.value = false;
    searchQuery.value = '';
    searchTextController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  void continueReading() {
    openFeature('Quran reading');
  }

  void openFeature(String feature) {
    final route = switch (feature) {
      'Azkar' => AppRoutes.azkar,
      'Adaab' => AppRoutes.adaab,
      'Asma-ul-Husna' => AppRoutes.asmaUlHusna,
      'Islamic Library' => AppRoutes.library,
      'Tasbeeh' => AppRoutes.tasbeeh,
      _ => null,
    };

    if (route == null) {
      AppSnackbar.info('$feature screen is not connected yet.');
      return;
    }

    Get.toNamed(route);
  }
}

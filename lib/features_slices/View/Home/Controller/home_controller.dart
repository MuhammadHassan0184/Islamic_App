import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final RxString searchQuery = ''.obs;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openSearch() {
    Get.dialog(
      AlertDialog(
        title: const Text('Search'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => searchQuery.value = value,
          decoration: const InputDecoration(
            hintText: 'Search Quran, Duas, and more...',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchQuery.value = '';
              Get.back();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
      _ => null,
    };

    if (route == null) {
      AppSnackbar.info('$feature screen is not connected yet.');
      return;
    }

    Get.toNamed(route);
  }
}

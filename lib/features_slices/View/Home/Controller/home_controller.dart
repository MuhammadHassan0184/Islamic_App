import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Data/Models/quiz_model.dart';
import 'package:islam786/Data/Repositories/quiz_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:islam786/features_slices/View/Quran/quran_reading_progress.dart';
import 'package:islam786/features_slices/app_shell_controller.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final RxString searchQuery = ''.obs;
  final RxBool isSearchOpen = false.obs;
  final TextEditingController searchTextController = TextEditingController();

  final RxList<QuizModel> quizHighlights = <QuizModel>[].obs;
  final RxBool isQuizLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    QuranReadingProgress.load();
    loadQuizHighlights();
  }

  Future<void> loadQuizHighlights() async {
    isQuizLoading.value = true;
    try {
      final repo = QuizRepository(AssetDataSource());
      final items = await repo.getQuizList();
      quizHighlights.assignAll(items);
    } catch (_) {
      // Graceful fallback
    } finally {
      isQuizLoading.value = false;
    }
  }

  void openQuiz({String? category}) {
    if (category != null) {
      Get.toNamed(AppRoutes.quiz, arguments: {'category': category});
    } else {
      Get.toNamed(AppRoutes.quiz);
    }
  }

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
    Get.find<AppShellController>().selectTab(2);
  }

  void openFeature(String feature) {
    final route = switch (feature) {
      'Azkar' => AppRoutes.azkar,
      'Adaab' => AppRoutes.adaab,
      'Asma-ul-Husna' => AppRoutes.asmaUlHusna,
      'Islamic Library' => AppRoutes.library,
      'Tasbeeh' => AppRoutes.tasbeeh,
      'Islamic Quiz' => AppRoutes.quiz,
      _ => null,
    };

    if (route == null) {
      AppSnackbar.info('$feature screen is not connected yet.');
      return;
    }

    Get.toNamed(route);
  }
}

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Models/adaab_model.dart';
import 'package:islam786/Data/Repositories/adaab_repository.dart';

class AdaabController extends GetxController {
  AdaabController(this.repository);

  final AdaabRepository repository;
  final RxList<AdaabModel> adaab = <AdaabModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  List<String> get categories {
    final values =
        adaab
            .map((item) => item.category)
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return values;
  }

  List<AdaabModel> get filteredAdaab {
    final query = searchQuery.value.trim().toLowerCase();
    return adaab.where((item) {
      final matchesCategory =
          selectedCategory.value.isEmpty ||
          item.category == selectedCategory.value;
      final matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.urdu.toLowerCase().contains(query) ||
          item.english.toLowerCase().contains(query) ||
          item.arabic.contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadAdaab();
  }

  Future<void> loadAdaab() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      adaab.assignAll(await repository.getAdaab());
    } catch (error, stackTrace) {
      debugPrint('Unable to load Adaab: $error');
      debugPrintStack(stackTrace: stackTrace);
      errorMessage.value = 'Unable to load Adaab. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}

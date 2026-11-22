import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Models/asma_ul_husna_model.dart';
import 'package:islam786/Data/Repositories/asma_ul_husna_repository.dart';

class AsmaUlHusnaController extends GetxController {
  AsmaUlHusnaController(this.repository);

  final AsmaUlHusnaRepository repository;
  final RxList<AsmaUlHusnaModel> names = <AsmaUlHusnaModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  List<String> get categories {
    final values =
        names
            .map((item) => item.category)
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return values;
  }

  List<AsmaUlHusnaModel> get filteredNames {
    final query = searchQuery.value.trim().toLowerCase();
    return names.where((item) {
      final matchesCategory =
          selectedCategory.value.isEmpty ||
          item.category == selectedCategory.value;
      final matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.transliteration.toLowerCase().contains(query) ||
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
    loadNames();
  }

  Future<void> loadNames() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      names.assignAll(await repository.getNames());
    } catch (error, stackTrace) {
      debugPrint('Unable to load Asma-ul-Husna: $error');
      debugPrintStack(stackTrace: stackTrace);
      errorMessage.value = 'Unable to load Asma-ul-Husna. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}

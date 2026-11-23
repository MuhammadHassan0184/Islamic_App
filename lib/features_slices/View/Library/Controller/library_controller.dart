import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Models/library_collection_model.dart';
import 'package:islam786/Data/Models/library_content_model.dart';
import 'package:islam786/Data/Repositories/library_content_repository.dart';

class LibraryController extends GetxController {
  LibraryController(this.repository);

  final LibraryContentRepository repository;
  final RxMap<String, List<LibraryContentModel>> contents =
      <String, List<LibraryContentModel>>{}.obs;
  final RxString collectionSearchQuery = ''.obs;
  final RxString itemSearchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  List<LibraryCollectionModel> get filteredCollections {
    final query = collectionSearchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return LibraryCollectionModel.available;

    return LibraryCollectionModel.available.where((collection) {
      return collection.title.toLowerCase().contains(query) ||
          collection.description.toLowerCase().contains(query);
    }).toList();
  }

  List<LibraryContentModel> itemsFor(LibraryCollectionModel collection) {
    final items = contents[collection.fileName] ?? const [];
    final query = itemSearchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return items;

    return items.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.arabic.toLowerCase().contains(query) ||
          item.urdu.toLowerCase().contains(query) ||
          item.english.toLowerCase().contains(query) ||
          item.reference.toLowerCase().contains(query) ||
          item.extraFields.values.any(
            (value) => value.toString().toLowerCase().contains(query),
          ) ||
          item.steps.any(
            (step) =>
                step.title.toLowerCase().contains(query) ||
                step.detail.toLowerCase().contains(query),
          );
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadCollections();
  }

  Future<void> loadCollections() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final loaded = await Future.wait(
        LibraryCollectionModel.available.map(
          (collection) async => MapEntry(
            collection.fileName,
            await repository.getItems(collection),
          ),
        ),
      );
      contents.assignAll(Map.fromEntries(loaded));
    } catch (error, stackTrace) {
      debugPrint('Unable to load Islamic Library data: $error');
      debugPrintStack(stackTrace: stackTrace);
      errorMessage.value = 'Unable to load library data. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}

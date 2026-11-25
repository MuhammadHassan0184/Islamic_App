import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';

import 'package:islam786/Data/Models/dua_model.dart';
import 'package:islam786/Data/Repositories/dua_repository.dart';

class DuaCategory {
  final String title;
  final int count;
  final String? image;
  final int colorValue;
  final String id;

  const DuaCategory({
    required this.id,
    required this.title,
    required this.count,
    required this.colorValue,
    this.image,
  });
}

class DuaController extends GetxController {
  final DuaRepository repository;

  DuaController(this.repository);

  final RxInt selectedTab = 0.obs;
  final RxBool isTodayDuaFavorite = false.obs;
  final RxList<DuaModel> duas = <DuaModel>[].obs;
  final RxList<DuaCategory> categories = <DuaCategory>[].obs;
  final RxList<DuaModel> favoriteDuas = <DuaModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  static const _favoritesKey = 'favorite_dua_ids';
  final Set<String> _favoriteIds = {};

  DuaModel? get todayDua => duas.isEmpty ? null : duas.first;

  List<DuaModel> get searchResults {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return duas.toList();

    return duas.where((dua) {
      return dua.title.toLowerCase().contains(query) ||
          dua.category.toLowerCase().contains(query) ||
          dua.urdu.toLowerCase().contains(query) ||
          dua.english.toLowerCase().contains(query) ||
          dua.arabic.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadDuas();
  }

  // Load Duas from JSON
  Future<void> loadDuas() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getDuas();
      duas.assignAll(result);
      _buildCategories();
      try {
        await _loadFavorites();
        _syncFavoriteState();
      } catch (error, stackTrace) {
        debugPrint('Unable to load saved Dua favorites: $error');
        debugPrintStack(stackTrace: stackTrace);
        AppSnackbar.info(
          'Duas loaded, but saved favorites could not be restored.',
        );
      }
    } catch (e) {
      debugPrint('Unable to load Duas: $e');
      errorMessage.value = 'Unable to load Duas: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds
      ..clear()
      ..addAll(prefs.getStringList(_favoritesKey) ?? const <String>[]);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
  }

  void _buildCategories() {
    const images = <String, String>{
      'morning': 'assets/Eveningbg.jpg',
      'guidance': 'assets/Dua_bg1.jpg',
      'sleep': 'assets/Sleep.jpg',
      'daily': 'assets/daily_life.jpg',
      'distress': 'assets/Safety.jpg',
      'family': 'assets/Dua_bg2.jpg',
      'forgiveness': 'assets/forgiveness.jpg',
      'protection': 'assets/Safety.jpg',
      'travel': 'assets/Travel.jpg',
      'worship': 'assets/prayer.jpg',
      'prayer': 'assets/prayer.jpg',
      'food_drink': 'assets/Dua_bg3.jpg',
    };

    const fallbackImages = <String>[
      'assets/Dua_bg1.jpg',
      'assets/Dua_bg2.jpg',
      'assets/Dua_bg3.jpg',
      'assets/daily_life.jpg',
      'assets/prayer.jpg',
      'assets/forgiveness.jpg',
      'assets/Safety.jpg',
      'assets/Sleep.jpg',
      'assets/Travel.jpg',
      'assets/Eveningbg.jpg',
    ];

    const colors = <String, int>{
      'morning': 0xFF858666,
      'guidance': 0xFF515C61,
      'sleep': 0xFF426D86,
      'daily': 0xFF527C72,
      'distress': 0xFF71868B,
      'family': 0xFF515C61,
      'forgiveness': 0xFF777C9C,
      'protection': 0xFF81749C,
      'travel': 0xFF987B63,
      'worship': 0xFF668B76,
      'prayer': 0xFF668B76,
    };

    final grouped = <String, List<DuaModel>>{};
    for (final dua in duas) {
      grouped.putIfAbsent(dua.category, () => <DuaModel>[]).add(dua);
    }

    final entries = grouped.entries.toList();
    categories.assignAll(
      entries.asMap().entries.map((indexedEntry) {
        final index = indexedEntry.key;
        final entry = indexedEntry.value;
        final catKey = entry.key.toLowerCase().trim();
        final img =
            images[catKey] ?? fallbackImages[index % fallbackImages.length];

        return DuaCategory(
          id: entry.key,
          title: _categoryTitle(entry.key),
          count: entry.value.length,
          image: img,
          colorValue: colors[catKey] ?? 0xFF527C72,
        );
      }).toList(),
    );
  }

  String _categoryTitle(String category) {
    if (category.isEmpty) return 'Daily Duas';
    return category
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  void _syncFavoriteState() {
    favoriteDuas.assignAll(
      duas.where((dua) => _favoriteIds.contains(dua.id)).toList(),
    );
    final today = todayDua;
    isTodayDuaFavorite.value = today != null && _favoriteIds.contains(today.id);
  }

  // Get Duas by JSON category
  List<DuaModel> getDuasByCategory(String category) {
    return duas.where((dua) => dua.category == category).toList();
  }

  // Find a Dua using its unique ID
  DuaModel? getDuaById(String id) {
    try {
      return duas.firstWhere((dua) => dua.id == id);
    } catch (_) {
      return null;
    }
  }

  // Get all available JSON categories
  List<String> get duaCategories {
    return duas
        .map((dua) => dua.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  Future<void> toggleFavorite(DuaModel dua) async {
    if (_favoriteIds.contains(dua.id)) {
      _favoriteIds.remove(dua.id);
      AppSnackbar.info('Dua removed from favorites');
    } else {
      _favoriteIds.add(dua.id);
      AppSnackbar.success('Dua added to favorites');
    }

    await _saveFavorites();
    _syncFavoriteState();
  }

  void toggleTodayFavorite() {
    final dua = todayDua;
    if (dua != null) {
      toggleFavorite(dua);
    }
  }

  void openCategory(DuaCategory category) {
    Get.toNamed(
      AppRoutes.duaCategory,
      arguments: {'id': category.id, 'title': category.title},
    );
  }
}

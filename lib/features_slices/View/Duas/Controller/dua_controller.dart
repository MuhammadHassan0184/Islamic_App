
import 'package:get/get.dart';
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

  // Existing UI state
  final RxInt selectedTab = 0.obs;
  final RxBool isTodayDuaFavorite = false.obs;

  // JSON data state
  final RxList<DuaModel> duas = <DuaModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final String todayDua =
      'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أُشْرِكَ بِكَ '
      'وَأَنَا أَعْلَمُ، وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ';

  // Existing categories - UI remains unchanged
  final List<DuaCategory> categories = const [
    DuaCategory(
      id: 'morning_evening',
      title: 'Morning & Evening',
      count: 6,
      image: 'assets/Eveningbg.jpg',
      colorValue: 0xFF858666,
    ),
    DuaCategory(
      id: 'home_family',
      title: 'Home & Family',
      count: 14,
      image: 'assets/Dua_bg1.jpg',
      colorValue: 0xFF515C61,
    ),
    DuaCategory(
      id: 'food_drink',
      title: 'Food & Drink',
      count: 7,
      image: 'assets/Dua_bg3.jpg',
      colorValue: 0xFF426D86,
    ),
    DuaCategory(
      id: 'joy_distress',
      title: 'Joy & Distress',
      count: 12,
      image: 'assets/Dua_bg2.jpg',
      colorValue: 0xFF71868B,
    ),
    DuaCategory(
      id: 'worship',
      title: 'Worship & Prayer',
      count: 18,
      image: 'assets/prayer.jpg',
      colorValue: 0xFF668B76,
    ),
    DuaCategory(
      id: 'protection',
      title: 'Protection & Safety',
      count: 9,
      image: 'assets/Safety.jpg',
      colorValue: 0xFF81749C,
    ),
    DuaCategory(
      id: 'travel',
      title: 'Travel & Journey',
      count: 8,
      image: 'assets/Travel.jpg',
      colorValue: 0xFF987B63,
    ),
    DuaCategory(
      id: 'daily_life',
      title: 'Daily Life',
      count: 11,
      image: 'assets/daily_life.jpg',
      colorValue: 0xFF527C72,
    ),
    DuaCategory(
      id: 'forgiveness',
      title: 'Forgiveness & Repentance',
      count: 10,
      image: 'assets/forgiveness.jpg',
      colorValue: 0xFF777C9C,
    ),
  ];

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
    } catch (e) {
      errorMessage.value = 'Unable to load Duas. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Get Duas by JSON category
  List<DuaModel> getDuasByCategory(String category) {
    return duas
        .where((dua) => dua.category == category)
        .toList();
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

  void toggleTodayFavorite() {
    isTodayDuaFavorite.toggle();

    if (isTodayDuaFavorite.value) {
      AppSnackbar.success('Dua added to favorites');
    } else {
      AppSnackbar.info('Dua removed from favorites');
    }
  }

  void openCategory(DuaCategory category) {
    AppSnackbar.info(
      '${category.title} - ${category.count} Duas',
    );
  }
}

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranReadingProgress {
  QuranReadingProgress._();

  static const _urlKey = 'quran_last_read_url';
  static const _titleKey = 'quran_last_read_title';
  static const _scrollKey = 'quran_last_read_scroll';

  static final RxString lastReadUrl = ''.obs;
  static final RxString lastReadTitle = 'الْفَاتِحَة'.obs;
  static final RxDouble lastReadScrollOffset = 0.0.obs;
  static Future<void>? _loadFuture;

  static Future<void> load() {
    return _loadFuture ??= _loadSavedProgress();
  }

  static Future<void> _loadSavedProgress() async {
    final preferences = await SharedPreferences.getInstance();
    lastReadUrl.value = preferences.getString(_urlKey) ?? '';
    lastReadTitle.value = preferences.getString(_titleKey) ?? 'الْفَاتِحَة';
    lastReadScrollOffset.value = preferences.getDouble(_scrollKey) ?? 0;
  }

  static Future<void> save({required String url, String? title}) async {
    await load();
    final preferences = await SharedPreferences.getInstance();
    if (lastReadUrl.value != url) {
      lastReadScrollOffset.value = 0;
      await preferences.setDouble(_scrollKey, 0);
    }
    lastReadUrl.value = url;
    if (title != null && title.trim().isNotEmpty) {
      lastReadTitle.value = title.trim();
    }
    await preferences.setString(_urlKey, url);
    await preferences.setString(_titleKey, lastReadTitle.value);
  }

  static Future<void> saveScrollOffset(double offset) async {
    await load();
    lastReadScrollOffset.value = offset < 0 ? 0 : offset;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(_scrollKey, lastReadScrollOffset.value);
  }
}

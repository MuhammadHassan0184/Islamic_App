import 'package:get/get.dart';
import 'package:islam786/features_slices/View/Azkar/Bindings/azkar_binding.dart';
import 'package:islam786/features_slices/View/Azkar/azkar_screen.dart';
import 'package:islam786/features_slices/View/Duas/Bindings/dua_binding.dart';
import 'package:islam786/features_slices/View/Duas/dua_category_screen.dart';
import 'package:islam786/features_slices/View/Duas/dua_detail_screen.dart';
import 'package:islam786/features_slices/View/Duas/duas_screen.dart';
import 'package:islam786/features_slices/app_shell_binding.dart';
import 'package:islam786/features_slices/name_app.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/home';
  static const azkar = '/azkar';
  static const duas = '/duas';
  static const duaCategory = '/dua-category';
  static const duaDetail = '/dua-detail';

  static final List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => const NameAppView(),
      binding: AppShellBinding(),
    ),
    GetPage(
      name: azkar,
      page: () => const AzkarScreen(),
      binding: AzkarBinding(),
    ),
    GetPage(name: duas, page: () => const DuaScreen(), binding: DuaBinding()),
    GetPage(
      name: duaCategory,
      page: () => const DuaCategoryScreen(),
      binding: DuaBinding(),
    ),
    GetPage(
      name: duaDetail,
      page: () => const DuaDetailScreen(),
      binding: DuaBinding(),
    ),
  ];
}

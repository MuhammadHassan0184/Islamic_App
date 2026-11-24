import 'package:get/get.dart';
import 'package:islam786/features_slices/View/Adaab/Bindings/adaab_binding.dart';
import 'package:islam786/features_slices/View/Adaab/adaab_detail_screen.dart';
import 'package:islam786/features_slices/View/Adaab/adaab_screen.dart';
import 'package:islam786/features_slices/View/AsmaUlHusna/Bindings/asma_ul_husna_binding.dart';
import 'package:islam786/features_slices/View/AsmaUlHusna/asma_ul_husna_detail_screen.dart';
import 'package:islam786/features_slices/View/AsmaUlHusna/asma_ul_husna_screen.dart';
import 'package:islam786/features_slices/View/Azkar/Bindings/azkar_binding.dart';
import 'package:islam786/features_slices/View/Azkar/azkar_screen.dart';
import 'package:islam786/features_slices/View/Duas/Bindings/dua_binding.dart';
import 'package:islam786/features_slices/View/Duas/dua_category_screen.dart';
import 'package:islam786/features_slices/View/Duas/dua_detail_screen.dart';
import 'package:islam786/features_slices/View/Duas/duas_screen.dart';
import 'package:islam786/features_slices/View/Library/Bindings/library_binding.dart';
import 'package:islam786/features_slices/View/Library/library_collection_screen.dart';
import 'package:islam786/features_slices/View/Library/library_detail_screen.dart';
import 'package:islam786/features_slices/View/Library/library_screen.dart';
import 'package:islam786/features_slices/View/Namaz/Bindings/namaz_binding.dart';
import 'package:islam786/features_slices/View/Namaz/namaz_screen.dart';
import 'package:islam786/features_slices/app_shell_binding.dart';
import 'package:islam786/features_slices/name_app.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/home';
  static const azkar = '/azkar';
  static const namaz = '/namaz';
  static const duas = '/duas';
  static const duaCategory = '/dua-category';
  static const duaDetail = '/dua-detail';
  static const adaab = '/adaab';
  static const adaabDetail = '/adaab-detail';
  static const asmaUlHusna = '/asma-ul-husna';
  static const asmaUlHusnaDetail = '/asma-ul-husna-detail';
  static const library = '/library';
  static const libraryCollection = '/library/collection';
  static const libraryDetail = '/library/detail';

  static final List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => const NameAppView(),
      binding: AppShellBinding(),
    ),
    GetPage(
      name: namaz,
      page: () => const NamazScreen(),
      binding: NamazBinding(),
    ),
    GetPage(
      name: azkar,
      page: () => const AzkarScreen(),
      binding: AzkarBinding(),
    ),
    GetPage(name: duas, page: () => const DuaScreen(), binding: DuaBinding()),
    GetPage(
      name: adaab,
      page: () => const AdaabScreen(),
      binding: AdaabBinding(),
    ),
    GetPage(
      name: adaabDetail,
      page: () => const AdaabDetailScreen(),
      binding: AdaabBinding(),
    ),
    GetPage(
      name: asmaUlHusna,
      page: () => const AsmaUlHusnaScreen(),
      binding: AsmaUlHusnaBinding(),
    ),
    GetPage(
      name: asmaUlHusnaDetail,
      page: () => const AsmaUlHusnaDetailScreen(),
      binding: AsmaUlHusnaBinding(),
    ),
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
    GetPage(
      name: library,
      page: () => const LibraryScreen(),
      binding: LibraryBinding(),
    ),
    GetPage(
      name: libraryCollection,
      page: () => const LibraryCollectionScreen(),
      binding: LibraryBinding(),
    ),
    GetPage(name: libraryDetail, page: () => const LibraryDetailScreen()),
  ];
}

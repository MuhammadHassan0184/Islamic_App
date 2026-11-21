import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Models/adaab_model.dart';
import 'package:islam786/Data/Repositories/adaab_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/features_slices/View/Adaab/Controller/adaab_controller.dart';
import 'package:islam786/features_slices/View/Adaab/adaab_detail_screen.dart';
import 'package:islam786/features_slices/View/Adaab/adaab_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Adaab loads JSON articles and filters by category and search',
    () async {
      final controller = AdaabController(AdaabRepository(AssetDataSource()));

      await controller.loadAdaab();

      expect(controller.adaab, hasLength(3));
      expect(controller.adaab.first.steps, hasLength(3));
      expect(controller.adaab.first.reference, isNotEmpty);

      controller.selectCategory('parents');
      expect(controller.filteredAdaab, hasLength(1));
      expect(
        controller.filteredAdaab.single.title,
        'Walidain Ke Huqooq Aur Adab',
      );

      controller.selectCategory('');
      controller.searchQuery.value = 'neighbors';
      expect(controller.filteredAdaab, hasLength(1));
      expect(controller.filteredAdaab.single.category, 'neighbors');
    },
  );

  testWidgets('Adaab list opens the detail with translations and steps', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = AdaabController(AdaabRepository(AssetDataSource()));
    await controller.loadAdaab();
    Get.put<AdaabController>(controller);
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const AdaabScreen(),
        getPages: [
          GetPage(name: '/adaab-detail', page: () => const AdaabDetailScreen()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Khane Ke Adab'), findsOneWidget);
    await tester.tap(find.text('Khane Ke Adab'));
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/adaab-detail');
    expect(Get.arguments, isA<AdaabModel>());
    expect((Get.arguments as AdaabModel).steps, isNotEmpty);
    expect(find.text('Practice step by step'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Hath Dhona Aur Bismillah'), findsOneWidget);
    expect(
      find.textContaining('Sahih al-Bukhari & Sahih Muslim'),
      findsOneWidget,
    );
  });
}

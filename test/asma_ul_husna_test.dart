import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Models/asma_ul_husna_model.dart';
import 'package:islam786/Data/Repositories/asma_ul_husna_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/features_slices/View/AsmaUlHusna/Controller/asma_ul_husna_controller.dart';
import 'package:islam786/features_slices/View/AsmaUlHusna/asma_ul_husna_detail_screen.dart';
import 'package:islam786/features_slices/View/AsmaUlHusna/asma_ul_husna_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Asma-ul-Husna loads its JSON fields and filters', () async {
    final controller = AsmaUlHusnaController(
      AsmaUlHusnaRepository(AssetDataSource()),
    );

    await controller.loadNames();

    expect(controller.names, hasLength(3));
    expect(controller.names.first.number, 1);
    expect(controller.names.first.transliteration, 'Ar-Rahman');
    expect(controller.names.first.steps, hasLength(2));

    controller.selectCategory('sovereignty');
    expect(controller.filteredNames, hasLength(1));
    expect(controller.filteredNames.single.title, 'Al-Malik');

    controller.selectCategory('');
    controller.searchQuery.value = 'rahim';
    expect(controller.filteredNames, hasLength(1));
    expect(controller.filteredNames.single.title, 'Ar-Rahim');
  });

  testWidgets('Asma-ul-Husna screen opens the detail view', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = AsmaUlHusnaController(
      AsmaUlHusnaRepository(AssetDataSource()),
    );
    await controller.loadNames();
    Get.put<AsmaUlHusnaController>(controller);
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const AsmaUlHusnaScreen(),
        getPages: [
          GetPage(
            name: '/asma-ul-husna-detail',
            page: () => const AsmaUlHusnaDetailScreen(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ar-Rahman'), findsWidgets);
    await tester.tap(find.text('Ar-Rahman').first);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/asma-ul-husna-detail');
    expect(Get.arguments, isA<AsmaUlHusnaModel>());
    expect(find.text('Meaning and practice'), findsOneWidget);
    expect(find.text('Reference: Surah Al-Fatihah 1:3'), findsOneWidget);
  });
}

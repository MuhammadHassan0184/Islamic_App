import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Repositories/dua_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/features_slices/View/Duas/Controller/dua_controller.dart';
import 'package:islam786/features_slices/View/Duas/dua_category_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('category screen accepts a DuaModel route argument', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = DuaController(DuaRepository(AssetDataSource()));
    await controller.loadDuas();
    Get.put<DuaController>(controller);
    addTearDown(Get.reset);

    final dua = controller.duas.first;
    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/dua-category', arguments: dua),
                child: const Text('Open category'),
              ),
            ),
          ),
        ),
        getPages: [
          GetPage(name: '/dua-category', page: () => const DuaCategoryScreen()),
        ],
      ),
    );

    await tester.tap(find.text('Open category'));
    await tester.pumpAndSettle();

    expect(find.text('Morning'), findsOneWidget);
    expect(find.text(dua.urdu), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

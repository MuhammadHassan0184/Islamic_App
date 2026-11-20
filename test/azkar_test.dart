import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Repositories/azkar_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/features_slices/View/Azkar/Controller/azkar_controller.dart';
import 'package:islam786/features_slices/View/Azkar/azkar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Azkar loads its own schema and persists counter progress', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = AzkarRepository(AssetDataSource());
    final controller = AzkarController(repository);

    await controller.loadAzkar();

    expect(controller.azkar, hasLength(3));
    final zikr = controller.azkar.first;
    expect(zikr.title, 'SubhanAllah');
    expect(zikr.arabic, isNotEmpty);
    expect(zikr.defaultTarget, 33);
    expect(zikr.steps, hasLength(2));

    await controller.setTarget(zikr, 3);
    await controller.increment(zikr);
    expect(controller.countFor(zikr), 1);

    await controller.resetCount(zikr);
    final reloadedController = AzkarController(repository);
    await reloadedController.loadAzkar();
    expect(reloadedController.targetFor(zikr), 3);
    expect(reloadedController.countFor(zikr), 0);
  });

  testWidgets('Azkar screen opens the counter and applies a custom target', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AzkarController(AzkarRepository(AssetDataSource()));
    await controller.loadAzkar();
    Get.put<AzkarController>(controller);
    addTearDown(Get.reset);

    await tester.pumpWidget(const GetMaterialApp(home: AzkarScreen()));
    await tester.pumpAndSettle();
    expect(find.text('SubhanAllah'), findsOneWidget);

    await tester.tap(find.text('Count').first);
    await tester.pumpAndSettle();
    expect(find.text('Target: 33'), findsOneWidget);

    await tester.tap(find.text('Target: 33'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '2');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Target: 2'), findsOneWidget);

    final counterButton = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.label == 'Increment SubhanAllah counter',
    );
    await tester.tap(counterButton);
    await tester.pumpAndSettle();
    expect(controller.countFor(controller.azkar.first), 1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Models/dua_model.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/features_slices/View/Home/Controller/home_controller.dart';
import 'package:islam786/features_slices/View/Home/Widgets/home_header.dart';
import 'package:islam786/features_slices/View/Home/Widgets/last_read_banner.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AssetDataSource loads the bundled daily Duas JSON', () async {
    final records = await AssetDataSource().loadJsonList('daily_duas.json');

    expect(records, isNotEmpty);
    expect(records.first['id'], isNotEmpty);
  });

  test('DuaModel parses Arabic, translations, reference, and steps', () {
    final dua = DuaModel.fromJson({
      'id': 'dua_test',
      'category': 'morning',
      'title': 'Test Dua',
      'arabic': 'اللهم',
      'urdu': 'اے اللہ',
      'english': 'O Allah',
      'reference': 'Test Reference',
      'steps': [
        {'step_no': 1, 'title': 'Step', 'detail': 'Read sincerely'},
      ],
    });

    expect(dua.id, 'dua_test');
    expect(dua.category, 'morning');
    expect(dua.arabic, 'اللهم');
    expect(dua.urdu, 'اے اللہ');
    expect(dua.reference, 'Test Reference');
    expect(dua.steps, hasLength(1));
    expect(dua.steps.first.detail, 'Read sincerely');
  });

  testWidgets('Last Read banner remains bounded on narrow screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = HomeController();
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topCenter,
              child: LastReadBanner(controller: controller),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Last Read'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Home search opens inline and closes without a dialog', (
    tester,
  ) async {
    final controller = HomeController();
    addTearDown(controller.onClose);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HomeHeader(controller: controller),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(find.byType(TextField), 'Quran');
    expect(controller.searchQuery.value, 'Quran');

    await tester.tap(find.byTooltip('Close search'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNothing);
    expect(controller.searchQuery.value, isEmpty);
    expect(find.text('Hafiz'), findsOneWidget);
  });
}

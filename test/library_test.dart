import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Models/library_collection_model.dart';
import 'package:islam786/Data/Repositories/library_content_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/features_slices/View/Library/Controller/library_controller.dart';
import 'package:islam786/features_slices/View/Library/library_collection_screen.dart';
import 'package:islam786/features_slices/View/Library/library_detail_screen.dart';
import 'package:islam786/features_slices/View/Library/library_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'loads all additional JSON collections and searchable item details',
    () async {
      final controller = LibraryController(
        LibraryContentRepository(AssetDataSource()),
      );

      await controller.loadCollections();

      expect(controller.errorMessage.value, isEmpty);
      expect(
        controller.contents,
        hasLength(LibraryCollectionModel.available.length),
      );

      final kalmay = LibraryCollectionModel.available.firstWhere(
        (collection) => collection.fileName == 'kalmay.json',
      );
      final items = controller.contents[kalmay.fileName]!;
      expect(items, hasLength(3));
      expect(items.first.extraFields['transliteration'], isNotEmpty);
      expect(items.first.steps, isNotEmpty);

      controller.itemSearchQuery.value = 'Pehla Kalma Tayyab';
      expect(controller.itemsFor(kalmay), hasLength(1));
      expect(controller.itemsFor(kalmay).single.title, items.first.title);

      controller.collectionSearchQuery.value = 'baby';
      expect(controller.filteredCollections, hasLength(1));
      expect(controller.filteredCollections.single.title, 'Baby Names');
    },
  );

  testWidgets('library collection opens an item detail screen', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = LibraryController(
      LibraryContentRepository(AssetDataSource()),
    );
    await controller.loadCollections();
    Get.put<LibraryController>(controller);
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const LibraryScreen(),
        getPages: [
          GetPage(
            name: '/library/collection',
            page: () => const LibraryCollectionScreen(),
          ),
          GetPage(
            name: '/library/detail',
            page: () => const LibraryDetailScreen(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Baby Names'));
    await tester.pumpAndSettle();
    expect(find.text('Ayesha'), findsOneWidget);

    await tester.tap(find.text('Ayesha'));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/library/detail');
    expect(find.text('Meaning'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
  });

  testWidgets('collection screen handles missing route arguments safely', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/library/collection'),
              child: const Text('Open collection'),
            ),
          ),
        ),
        getPages: [
          GetPage(
            name: '/library/collection',
            page: () => const LibraryCollectionScreen(),
          ),
          GetPage(
            name: '/library',
            page: () => const Scaffold(body: Text('Islamic Library home')),
          ),
        ],
      ),
    );

    await tester.tap(find.text('Open collection'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('This collection could not be opened.'), findsOneWidget);

    await tester.tap(find.text('Open Islamic Library'));
    await tester.pumpAndSettle();
    expect(find.text('Islamic Library home'), findsOneWidget);
  });
}
